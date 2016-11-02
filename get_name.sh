#!/usr/bin/env bash

for i in $(seq $1 $2); do
  name=$(curl -s 'http://onepiece-treasurecruise.com/c-'$i'/' | grep 'monster_name' | awk -F'>' '{print $2}' | awk -F'<' '{print $1}')
  echo $i" 'name-jp':'"$name"',"
done

exit 0
