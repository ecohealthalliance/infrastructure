echo "Print out variables for testing"
env
source /docker.env
echo "------------------------------"
env
/usr/local/bin/ansible-playbook --connection=local /ansible/site.yml --extra-vars "mongo_url=$MONGO_URL SPARQLDB_URL=$SPARQLDB_URL" $OTHER_ANSIBLE_PARAMS
