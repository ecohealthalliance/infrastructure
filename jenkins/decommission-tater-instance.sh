#This script is meant to run inside of a jenkins job
#This script also assumes that the infrastructure repo is checked out
#Another assumption is that we are executing this script from the top level of the infrastructure repo

#Make sure we have pyhaproxy ready to go
[ -d "pyhaproxy" ] || git clone https://github.com/frosario/pyhaproxy.git
export PYTHONPATH="$(pwd)/pyhaproxy"


