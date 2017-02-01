#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG=$1
ID=$2
SUBDIR=$3

if [ -n "$c1" ]; then
  adb shell ls /data/data/$PKG/files/Cache/GNPCACHE/*/*c1.png | tr '\r' ' ' | xargs -J % adb pull % $BASEDIR'/png/'$SUBDIR'/'
  exit 0
fi

if [ -n "$c2" ]; then
  adb shell ls /data/data/$PKG/files/Cache/GNPCACHE/*/*c2.png | tr '\r' ' ' | xargs -J % adb pull % $BASEDIR'/png/'$SUBDIR'/'
  exit 0
fi

if [ -n "$t1" ]; then
  adb shell ls /data/data/$PKG/files/Cache/GNPCACHE/*/*t1.png | tr '\r' ' ' | xargs -J % adb pull % $BASEDIR'/png/'$SUBDIR'/'
  exit 0
fi

adb shell ls /data/data/$PKG/files/Cache/GNPCACHE/*/*.png | tr '\r' ' ' | xargs -J % adb pull % $BASEDIR'/png/'$SUBDIR'/'
if [ "$?" != 0 ]; then
	exit 1
fi

# generate json, parse pug to html
date
DEBUG=miss OPTC_FORCE=true OPTC_LANG=$SUBDIR node index.js
date

exit 0
