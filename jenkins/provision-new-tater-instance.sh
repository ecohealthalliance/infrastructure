#This script is meant to run inside of a jenkins job
#This script also assumes that the infrastructure repo is checked out
#Another assumption is that we are executing this script from the top level of the infrastructure repo

#Make sure we have pyhaproxy ready to go
[ -d "pyhaproxy" ] || git clone https://github.com/frosario/pyhaproxy.git
export PYTHONPATH="$(pwd)/pyhaproxy"


#Update haproxy.cfg
./docker/images/app-router/update_config.py \
  -n $instance_name \
  -c ./docker/images/app-router/haproxy.cfg \
  -p $instance_port


#Create a docker-compose file for new instance
./docker/containers/generate-new-tater-container.sh --name $instance_name --port $instance_port


#Commit update to revision control
git add -A
git commit -m "New tater instance: $instance_name   $BUILD_URL"
HEAD_ON_BRANCH=$(echo $GIT_BRANCH|awk -F"/" '{print $1 " HEAD:"$2}')
git push $HEAD_ON_BRANCH


#Spin up new docker container
/usr/bin/scp -i /keys/infrastructure.pem ./docker/containers/tater/$instance_name  ubuntu@po.tater.io:/tmp/ && \
/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@po.tater.io "sudo docker-compose -f /tmp/$instance_name up -d"


#Build up a few convenience aliases
config_file="/etc/haproxy/haproxy.cfg"
timestamp=$(date +%Y%m%d-%H:%M)
config_fail="(echo 'Something is wrong with the haproxy.cfg file' && exit 1)"
verify_config="/usr/sbin/haproxy -c -f $config_file || $config_fail"
backup_config="($verify_config && cp $config_file $config_file-$timestamp) || $config_fail"


#Update loadbalancers
/usr/bin/ssh -p 2222 root@po.tater.io "$backup_config" && \
/usr/bin/ssh -p 2222 root@tots01.tater.io "$backup_config" && \

/usr/bin/scp -i ~/.ssh/id_rsa -P 2222 docker/images/app-router/haproxy.cfg root@po.tater.io:$config_file && \
/usr/bin/scp -i ~/.ssh/id_rsa -P 2222 docker/images/app-router/haproxy.cfg root@tots01.tater.io:$config_file && \

/usr/bin/ssh -p 2222 root@po.tater.io "$verify_config" && \
/usr/bin/ssh -p 2222 root@tots01.tater.io "$verify_config" && \
/usr/bin/ssh -p 2222 root@po.tater.io "supervisorctl restart haproxyd" && \
/usr/bin/ssh -p 2222 root@tots01.tater.io "supervisorctl restart haproxyd"




#TODO:
#Route53 API call
