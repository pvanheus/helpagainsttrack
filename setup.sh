#!/bin/bash

# THIS SCRIPT IS FOR SETTING UP A NEW HOST

#function join { local IFS="$1"; shift; echo "$*"; }
REQUIREMENTS=(tor git wget torsocks traceroute python-pip gcc python-dev libgeoip-dev geoip-database libfontconfig1)
MUSTINST=0
for req in ${REQUIREMENTS[*]} ; do
  status=$(dpkg-query -l $req | tail -1 | cut -c 1,2)
  if [ "$status" != "ii" ] ; then 
    MUSTINST=1
  fi
done

if [ $MUSTINST = 1 ] ; then
  sudo apt-get update
  sudo apt-get install -y ${REQUIREMENTS[*]}
fi

# TODO: consider using virtualenv
sudo pip install GeoIP tldextract termcolor

if [ ! -d helpagainsttrack ] ; then
    git clone https://github.com/vecna/helpagainsttrack.git
else
    ( cd helpagainsttrack ; git pull )
fi

(
    cd helpagainsttrack
    if [ -x ./fetch_phantomjs.sh ] ; then
        ./fetch_phantomjs.sh
    else
        # no fetch_phantomjs.sh in repo, insert its code here
        ARCH=$(uname -m)

        PHANTOMJS_VER=1.9.2
        PHANTOMJS=phantomjs-$PHANTOMJS_VER-linux-$ARCH
        PHANTOMJS_BIN=phantom-$PHANTOMJS_VER
        PHANTOMJS_DIST=$PHANTOMJS.tar.bz2
        PHANTOMJS_URL=https://phantomjs.googlecode.com/files/$PHANTOMJS_DIST

        wget -c $PHANTOMJS_URL
        if [ ! -d $PHANTOMJS ] ; then
            tar xf $PHANTOMJS_DIST
            ln -s $PHANTOMJS/bin/phantomjs $PHANTOMJS_BIN
        fi
     fi
)
echo "helpagainsttrack installed and updated"
