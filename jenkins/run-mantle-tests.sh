#!/bin/bash

killall -9 node
export NVM_DIR="/var/lib/jenkins/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use v5.2.0
meteor & 
CUCUMBER_TAIL=1 ~/node_modules/.bin/chimp --ddp=http://localhost:3000 --path=tests/cucumber/features/ --coffee=true --chai=true --sync=false
killall -9 node
