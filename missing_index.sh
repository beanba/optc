#!/usr/bin/env bash

for f in $(find png/$1/ -name character*t1* | awk -F/ '{print $4}' | sort | uniq | grep -Eo "_\d+_" | awk -F_ '{print $2}'); do
	f=$((10#$f))
	if [ $f -gt 2000 ]; then
		continue;
	fi
	dummy=$(grep "'id':"$f"" "index.py" | grep "$1")
	if [ "$?" != 0 ]; then
		find "png/$1" -name *$f*
	fi
done

exit 0
