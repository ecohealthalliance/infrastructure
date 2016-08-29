# ssh into flirt machine
# go into docker instance for web

# cd /grits

# open run.shell

# Execute all lines for the following blocks:

print "get initial flight/legs counts"

# This is the default run.sh..
# Should only be executed on first run.
# If you have a prepopulated DB, just execute the container with the last line

print "Take care of grits-net-consume dependencies"
# cd /grits-net-consume
# virtualenv /grits-net-consume-env &&\
# source /grits-net-consume-env/bin/activate &&\
# pip install -r requirements.txt

print "Update ftp credentials"
# sed -i 's/url-innovata.com/suwweb03.innovata-llc.com/' grits_ftp_config.py
# sed -i 's/username/ECOHEALTH/' grits_ftp_config.py
# sed -i 's/password/HD38jFXc/' grits_ftp_config.py

print "Consume/import flight data"
# python grits_flight_pull.py
# python grits_consume.py --type DiioAirport -m 10.0.0.175 -d grits-net-meteor tests/data/MiExpressAllAirportCodes.tsv
# python grits_consume.py --type FlightGlobal -m 10.0.0.134 -d grits-net-meteor data/EcoHealth_*.csv  &&\
# rm -fr data

print "Make sure indexes are good"
# python grits_ensure_index.py -d grits-net-meteor -m 10.0.0.134

print "Import heat map data"
# aws s3 sync s3://flight-network-heat-map/ ./
# mongorestore -h 10.0.0.134 -d grits-net-meteor -c heatmap ./dump/grits/heatmap.bson

print "Create legs collection"
# java -jar /flirt-legs.jar --mongohost="10.0.0.134" mongoport="27017"

print "Start the app"
# service supervisor start