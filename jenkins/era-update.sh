# This is the default run.sh..
# Should only be executed on first run.
# If you have a prepopulated DB, just execute the container with the last line

echo "*****Take care of grits-net-consume dependencies*****"
# cd /Users/Shared/Jenkins/grits-net-consume

# echo "change directories"
cd /grits-net-consume
# echo "virtualenv"
virtualenv /grits-net-consume-env
# echo "source"
source /grits-net-consume-env/bin/activate
# echo "install"
pip install -r requirements.txt

echo "*****Download flight data*****"
python grits_flight_pull.py -m era.eha.io -d grits-net-meteor
# if no file was downloaded then exit the script without running updates
if ! ls data/*.csv 1> /dev/null 2>&1; then
  exit 0
fi
echo "*****Consume/import flight data*****"
python grits_consume.py --type DiioAirport -m era.eha.io -d grits-net-meteor tests/data/MiExpressAllAirportCodes.tsv
python grits_consume.py --type FlightGlobal -m era.eha.io -d grits-net-meteor data/EcoHealth_*.csv  &&\
rm -fr data

echo "*****Make sure indexes are good*****"
python grits_ensure_index.py -d grits-net-meteor -m era.eha.io -f

echo "*****Import heat map data*****"
aws s3 sync s3://flight-network-heat-map/ ./
mongorestore -h era.eha.io -d grits-net-meteor -c heatmap ./dump/grits/heatmap.bson

echo "*****Create legs collection*****"
java -jar /flirt-legs.jar --mongohost="era.eha.io" mongoport="27017"

echo "*****Update flight counts*****"
python grits_update_counts.py -m era.eha.io -d grits-net-meteor 

echo "*****Start the app*****"
service supervisor start
