
echo "*****get initial flight/legs counts*****"
/usr/bin/mongo flirt-reporting.eha.io/grits-net-meteor --eval 'db.flights.count()'
/usr/bin/mongo flirt-reporting.eha.io/grits-net-meteor --eval 'db.legs.count()'


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

echo "*****Update ftp credentials*****"
sed -i 's/url-innovata.com/suwweb03.innovata-llc.com/' grits_ftp_config.py
sed -i 's/username/ECOHEALTH/' grits_ftp_config.py
sed -i 's/password/HD38jFXc/' grits_ftp_config.py

echo "*****Consume/import flight data*****"
python grits_flight_pull.py
python grits_consume.py --type DiioAirport -m flirt-reporting.eha.io -d grits-net-meteor tests/data/MiExpressAllAirportCodes.tsv
python grits_consume.py --type FlightGlobal -m flirt-reporting.eha.io -d grits-net-meteor data/EcoHealth_*.csv  &&\
rm -fr data

echo "*****Make sure indexes are good*****"
python grits_ensure_index.py -d grits-net-meteor -m flirt-reporting.eha.io -f

echo "*****Import heat map data*****"
aws s3 sync s3://flight-network-heat-map/ ./
mongorestore -h flirt-reporting.eha.io -d grits-net-meteor -c heatmap ./dump/grits/heatmap.bson

echo "*****Create legs collection*****"
java -jar /flirt-legs.jar --mongohost="flirt-reporting.eha.io" mongoport="27017"

echo "*****Start the app*****"
service supervisor start