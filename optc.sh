#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG=$1
ID=$2
SUBDIR=$3

# pull GNPCACHE, mv *.png to SUBDIR
rm -rf GNPCACHE
adb pull /data/data/$PKG/files/Cache/GNPCACHE
if [ $? != 0 ]; then
  adb kill-server
  adb start-server
  adb devices
  exit 1
fi
mv $(find GNPCACHE -name *.png | xargs) $BASEDIR'/png/'$SUBDIR'/'
rm -rf GNPCACHE

# generate json
./index.py "$SUBDIR"

# export html
jade --out . --obj index.json --pretty index.jade
jade --out . --obj index.json --pretty index-jp.jade
jade --out . --obj index.json --pretty index-tw.jade
jade --out . --obj index.json --pretty index-us.jade

exit 0
