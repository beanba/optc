#!/usr/bin/env bash

for f in $(find -E png/$1  -regex ".*character_[0-1][0-9]{3}_t1\.png"); do
	dummy=$(grep "$f" index.json)
	if [ "$?" != 0 ]; then
		echo "$f"
	fi
done

exit 0
