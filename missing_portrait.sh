#!/usr/bin/env bash

a=$(find -E png/$1 -regex ".*character_[0|1][0-9]{3}_t1\.png" | sed 's/_t1/_c1/')
b=$(find -E png/$1 -regex ".*character_[5|6][0-9]{3}_t1\.png" | sed 's/_5/_0/' | sed 's/_6/_1/' | sed 's/_t1/_c1/')

for f in $(echo $a $b | xargs -n1 | sort | uniq); do
  if [ ! -f $f ]; then
  	thumbnail=$(echo $f | sed 's/_c1/_t1/')
    if [ -f $thumbnail ]; then
      echo $thumbnail
    else
      skill=$(echo $f | sed 's/_0/_5/' | sed 's/_1/_6/' | sed 's/_c1/_t1/')
      echo $skill
    fi
  fi
done