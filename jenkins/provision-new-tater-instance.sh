#This script is meant to run inside of a jenkins job
#This script also assumes that the infrastructure repo is checked out
#Another assumption is that we are executing this script from the top level of the infrastructure repo

#Make sure we have pyhaproxy ready to go
[ -d "pyhaproxy" ] || git clone https://github.com/frosario/pyhaproxy.git
export PYTHONPATH="$(pwd)/pyhaproxy"


#Update haproxy.cfg
$WORKSPACE/docker/images/app-router/update_config.py \
  -n $instance_name \
  -c $WORKSPACE/docker/images/app-router/haproxy.cfg \
  -p $instance_port


#Create a docker-compose file for new instance
./docker/containers/generate-new-tater-container.sh --name $instance_name --port $instance_port


#Commit update to revision control
git add -A
git commit -m "New tater instance: $instance_name   $BUILD_URL"
#HEAD_ON_BRANCH=$(echo $GIT_BRANCH|awk -F"/" '{print $1 " HEAD:"$2}')
#git push $HEAD_ON_BRANCH

