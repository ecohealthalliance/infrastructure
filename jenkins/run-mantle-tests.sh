#!/bin/bash

kill `lsof -t -i:3000`
export NVM_DIR="/var/lib/jenkins/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use v5.2.0

meteor & 
tail -f testoutput.txt &

CUCUMBER_TAIL=1 ~/node_modules/.bin/chimp --ddp=http://localhost:3000 --path=tests/cucumber/features/ --coffee=true --chai=true --sync=false > testoutput.txt

kill `lsof -t -i:3000`
if grep -q "failed steps" testoutput.txt
then
  echo "Tests Failed"
  exit 1
fi
echo "Tests Passed"
exit 0
