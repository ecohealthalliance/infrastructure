#Make sure we have pyhaproxy ready to go
[ -d "pyhaproxy" ] || git clone https://github.com/frosario/pyhaproxy.git
export PYTHONPATH="$(pwd)/pyhaproxy"


#Update haproxy.cfg
$WORKSPACE/docker/images/app-router/update_config.py \
  -n $instance_name \
  -c $WORKSPACE/docker/images/app-router/haproxy.cfg \
  -p $instance_port


#Commit update to revision control
git add -A
git commit -m "New tater instance: $instance_name   $BUILD_URL"
git push


