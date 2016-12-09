#!/usr/bin/env bash

for i in $(seq $1 $2); do
  full=$(curl -s 'http://onepiece-treasurecruise.com/c-'$i'/' | grep 'monster_name' | awk -F'>' '{print $2}' | awk -F'<' '{print $1}')
  fullus=$(curl -s 'http://onepiece-treasurecruise.com/en/c-'$i'/' | grep 'monster_name' | awk -F'>' '{print $2}' | awk -F'<' '{print $1}')

  echo "$i: jp: $full"
  echo "$i: us: $fullus"
done

exit 0
