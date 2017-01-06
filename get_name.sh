#!/usr/bin/env bash

start=$1
if [ -n "$2" ]; then
  end=$2
else
  end=$1
fi

for i in $(seq $start $end); do
  full=$(curl -s 'http://onepiece-treasurecruise.com/c-'$i'/' | grep 'monster_name' | awk -F'>' '{print $2}' | awk -F'<' '{print $1}')
  fulltw=$(curl -s 'http://line-optc.com/tw/c-'$i'/' | grep -A1 'class="single">' | grep h1 | awk -F'>' '{print $2}' | awk -F'<' '{print $1}')
  fullus=$(curl -s 'http://onepiece-treasurecruise.com/en/c-'$i'/' | grep 'monster_name' | awk -F'>' '{print $2}' | awk -F'<' '{print $1}')

  echo "$i: jp: $full"
  echo "$i: tw: $fulltw"
  echo "$i: us: $fullus"
done

exit 0
