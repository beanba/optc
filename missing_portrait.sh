#!/usr/bin/env bash

a=$(find -E png/$1 -regex ".*character_[0|1][0-9]{3}_t1\.png" | sed 's/_t1/_c1/')
b=$(find -E png/$1 -regex ".*character_[5|6][0-9]{3}_t1\.png" | sed 's/_5/_0/' | sed 's/_6/_1/' | sed 's/_t1/_c1/')

for f in $(echo $a $b | xargs -n1 | sort | uniq); do
  if [ ! -f $f ]; then
  	thumbnail=$(echo $f | sed 's/_c1/_t1/')
    if [ -f $thumbnail ]; then
      id=$(echo $f | awk -F'/' '{print $3}' |  awk -F'_' '{print $2}' | sed -E 's/^0+//')
      no=$(grep -A7 "\"id\": $id," index.json  | grep '"no":' | awk '{print $2}' | awk -F',' '{print $1}')
      echo $thumbnail $no
    else
      skill=$(echo $f | sed 's/_0/_5/' | sed 's/_1/_6/' | sed 's/_c1/_t1/')
      id=$(echo $f | awk -F'/' '{print $3}' |  awk -F'_' '{print $2}' | sed -E 's/^0+//')
      no=$(grep -A7 "\"id\": $id," index.json  | grep '"no":' | awk '{print $2}' | awk -F',' '{print $1}')
      echo $skill $no
    fi
  fi
done
