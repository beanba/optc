#!/usr/bin/env bash

for i in $(seq $1 $2); do
  full=$(curl -s 'http://onepiece-treasurecruise.com/c-'$i'/' | grep 'monster_name' | awk -F'>' '{print $2}' | awk -F'<' '{print $1}')
  name=$(echo $full | awk -F' ' '{print $1}')
  title=$(echo $full | awk -F' ' '{print $2}')
  if [ -z "$3" ]; then
    echo $i" 'name-jp':'"$full"',"
  else
    echo $i" 'name-jp':'"$name"',"" 'title-jp':'"$title"',"
  fi
done

exit 0
