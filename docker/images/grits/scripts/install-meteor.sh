#!/bin/bash
# This script is based on the meteor-launchpad docker image:
# https://github.com/jshimko/meteor-launchpad/blob/master/scripts/install-meteor.sh
set -e

# download installer script
curl -v https://install.meteor.com -o /tmp/install_meteor.sh

# replace tar command with bsdtar in the install script (bsdtar -xf "$TARBALL_FILE" -C "$INSTALL_TMPDIR")
# https://github.com/jshimko/meteor-launchpad/issues/39
sed -i.bak "s/tar -xzf.*/bsdtar -xf \"\$TARBALL_FILE\" -C \"\$INSTALL_TMPDIR\"/g" /tmp/install_meteor.sh

# install
printf "\n[-] Installing Meteor...\n\n"
sh /tmp/install_meteor.sh
