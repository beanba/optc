#!/usr/bin/env bash

id=$(grep -B7 "no\": $2," index.json | grep '"id":' | awk '{print $2}' | awk -F',' '{print $1}')
sid=$(grep -A7 "no\": $2," index.json | grep '"sid":' | awk '{print $2}' | awk -F',' '{print $1}')

padid=`printf %04d $id`
padsid=`printf %04d $sid`

find png/$1 -name "*character_"$padid"_*" | xargs ls -l
find png/$1 -name "*_"$padsid"*" | grep skill | xargs ls -l
