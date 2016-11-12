#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG=$1
ID=$2
SUBDIR=$3

if [ -n "$c1" ]; then
  adb shell ls /data/data/$PKG/files/Cache/GNPCACHE/*/*c1.png | tr '\r' ' ' | xargs -J % adb pull % $BASEDIR'/png/'$SUBDIR'/'
  exit 0
fi

if [ -n "$t1" ]; then
  adb shell ls /data/data/$PKG/files/Cache/GNPCACHE/*/*t1.png | tr '\r' ' ' | xargs -J % adb pull % $BASEDIR'/png/'$SUBDIR'/'
  exit 0
fi

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
