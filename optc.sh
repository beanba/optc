#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG=$1
ID=$2
SUBDIR=$3

# pull GNPCACHE, mv *.png to SUBDIR
adb pull /data/data/com.linecorp.LGOPTW/files/Cache/GNPCACHE
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
