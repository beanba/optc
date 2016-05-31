#!/usr/bin/env bash

for f in $(find png/ -name character*t1* | awk -F/ '{print $4}' | sort | uniq | grep -Eo "_\d+_" | awk -F_ '{print $2}'); do
	f=$((10#$f))
	if [ $f -gt 2000 ]; then
		continue;
	fi
	dummy=$(grep "'id':"$f"" "index.py")
	if [ "$?" != 0 ]; then
		find png/ -name *$f*
	fi
done

exit 0
