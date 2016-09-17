#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG=$1
ID=$2
SUBDIR=$3

if [ -z "$ID" ]; then
  adb shell 'ls -d /data/data/'$PKG'/files/Cache/GNPCACHE/**/* | grep -E "/.*\.png$"' > tmp.txt
else
  adb shell 'ls -d /data/data/'$PKG'/files/Cache/GNPCACHE/**/* | grep -E "/.*'$ID'.*\.png$"' > tmp.txt
fi

while read -r line
do
  s="$(echo -e "${line}" | tr -d '[[:space:]]')"
  echo $s

  while true; do
    if [ -z "$DEVICE" ]; then
      adb pull $s $BASEDIR'/png/'$SUBDIR'/'
    else
      adb -s $DEVICE pull $s $BASEDIR'/png/'$SUBDIR'/'
    fi
    err=$?
    if [ "0" == "${err}" ]; then
      break
    else
      echo "retry: $s"
      sleep 1
      adb devices
    fi
  done

done < tmp.txt

rm -f tmp.txt

# ls $BASEDIR'/png/'
# find $BASEDIR'/png/' -name "*.png" | wc -l

./index.py "$SUBDIR"
jade --out . --obj index.json --pretty index.jade
jade --out . --obj index.json --pretty index-jp.jade
jade --out . --obj index.json --pretty index-tw.jade
jade --out . --obj index.json --pretty index-us.jade

exit 0
