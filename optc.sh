#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG=$1
ID=$2
DEVICE=$3
SUBDIR=$4

if [ -z "$ID" ]; then
	if [ -z "$DEVICE" ]; then
		adb shell 'ls -d /data/data/'$PKG'/files/Cache/GNPCACHE/**/* | grep -E "/character_.*\.png|/motion_.*\.png|/skill_name_.*\.png"' > tmp.txt
	else
		adb -s $DEVICE shell 'ls -d /data/data/'$PKG'/files/Cache/GNPCACHE/**/* | grep -E "/character_.*\.png|/motion_.*\.png|/skill_name_.*\.png"' > tmp.txt
	fi
else
	if [ -z "$DEVICE" ]; then
		adb shell 'ls -d /data/data/'$PKG'/files/Cache/GNPCACHE/**/* | grep -E "/character_.*'$ID'.*\.png|/motion_.*'$ID'.*\.png|/skill_name_.*'$ID'.*\.png"' > tmp.txt
	else
		adb -s $DEVICE shell 'ls -d /data/data/'$PKG'/files/Cache/GNPCACHE/**/* | grep -E "/character_.*'$ID'.*\.png|/motion_.*'$ID'.*\.png|/skill_name_.*'$ID'.*\.png"' > tmp.txt
	fi
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

./index.py
jade --out . --obj index.json --pretty index.jade

exit 0
