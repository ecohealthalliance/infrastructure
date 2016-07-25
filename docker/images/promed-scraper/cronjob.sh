echo "Print out variables for testing"
env
source /docker.env
echo "------------------------------"
env
# TODO: setup aws credentials in dockerfile?
/usr/local/bin/ansible-playbook --connection=local /ansible/site.yml --extra-vars "mongo_url=$MONGO_URL SPARQLDB_URL=$SPARQLDB_URL"
