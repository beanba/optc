#!/usr/bin/env bash

BASEDIR=$(dirname $0)

files=$(ls $BASEDIR/png/character*_t.png | xargs)
montage -background '#000000' -geometry +1+1 ${files} png/ymontage.png

args=""
for i in $(seq 1 401)
do
	n=`printf %04d $i`
	name="png/character_${n}_t.png"
	if [ -f "${name}" ]; then
		args="${args} png/character_${n}_t.png"
	else
		args="${args} png/character_9999_t.png"
	fi
done

for i in $(seq 5002 5321)
do
	name="png/character_${i}_t.png"
	if [ -f "${name}" ]; then
		args="${args} png/character_${i}_t.png"
	else
		args="${args} png/character_9999_t.png"
	fi
done

montage -background '#000000' -geometry +1+1 ${args} png/zmontage.png

exit 0
