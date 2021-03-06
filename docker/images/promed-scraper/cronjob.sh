set -o allexport
source /docker.env
set +o allexport
echo "Print out variables for testing"
env
ansible-playbook --connection=local /promed_mail_scraper/ansible/site.yml --extra-vars "mongo_url=$MONGO_URL SPARQLDB_URL=$SPARQLDB_URL" --tags=promed,download-classifier,s3backup --skip-tags=preloadable
