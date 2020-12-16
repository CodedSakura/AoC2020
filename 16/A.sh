#!/bin/bash

elementIn() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

data=$(cat input.txt)
state=0
arr=()
sum=0
for i in $data; do
  case $state in
  0)
    if [[ "$i" =~ ([0-9]+)-([0-9]+) ]]; then
      arr+=($(seq "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"))
      arr=($(echo "${arr[@]}" | tr ' ' '\n' | sort -n -u))
    fi
    ;;
  1) ;;
  2)
    IFS=',' read -ra val <<<"$i"
    for j in "${val[@]}"; do
      if ! elementIn "$j" "${arr[@]}"; then
        ((sum+=j))
      fi
    done
    ;;
  esac
  if [ "$i" == "ticket:" ]; then state=1; fi
  if [ "$i" == "tickets:" ]; then state=2; fi
done
echo "$sum"
