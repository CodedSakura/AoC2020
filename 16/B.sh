#!/bin/bash

elementIn() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

mapfile -t data <input.txt
state=0
arr=()
declare -A fields
validTickets=()
for i in "${data[@]}"; do
  case $state in
  0)
    if [[ "$i" =~ ^(.*):\ ([0-9]+)-([0-9]+)\ or\ ([0-9]+)-([0-9]+)$ ]]; then
      new=()
      while IFS='' read -r line; do new+=("$line"); done < <(seq "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}")
      while IFS='' read -r line; do new+=("$line"); done < <(seq "${BASH_REMATCH[4]}" "${BASH_REMATCH[5]}")
      fields+=(["${BASH_REMATCH[1]}"]="${new[@]}")
      mapfile -t arrU < <(printf "%s\n" "${new[@]}" "${arr[@]}" | sort -n -u)
      arr=("${arrU[@]}")
    fi
    ;;
  1)
    if [[ "$i" =~ ^([0-9]+,?)+$ ]]; then
      validTickets+=("$i")
    fi
    ;;
  2)
    IFS=',' read -ra val <<<"$i"
    valid=true
    for j in "${val[@]}"; do
      if ! elementIn "$j" "${arr[@]}"; then
        valid=false
        break
      fi
    done
    if [ $valid = true ]; then
      validTickets+=("$i")
    fi
    ;;
  esac
  if [ "$i" == "your ticket:" ]; then state=1; fi
  if [ "$i" == "nearby tickets:" ]; then state=2; fi
done

declare -A fieldPos
count="${#fields[@]}"
((count-=1))
for x in "${!fields[@]}"; do
  fieldPos+=(["$x"]="$(seq 0 "$count" | tr '\n' ' ')")
done

for i in "${validTickets[@]}"; do
  IFS=',' read -ra val <<<"$i"
  for j in "${!val[@]}"; do
    for k in "${!fields[@]}"; do
      if [[ "${fieldPos[$k]}" !=  *"$j "* ]]; then
        continue
      fi
      read -ra tmp <<<"${fields[$k]}"
      if ! elementIn "${val[$j]}" "${tmp[@]}"; then
        fieldPos[$k]="${fieldPos[$k]/$j }"
      fi
    done
  done
done

left=("${!fieldPos[@]}")
while [[ "${#left[@]}" != 0 ]]; do
  for i in "${left[@]}"; do
    read -ra tmp <<<"${fieldPos[$i]}"
    if [[ "${#tmp[@]}" == 1 ]]; then
      newLeft=()
      for k in "${left[@]}"; do [[ "$k" != "$i" ]] && newLeft+=("$k"); done
      left=("${newLeft[@]}")

      delete="${tmp[0]} "
      for j in "${left[@]}"; do
        fieldPos[$j]="${fieldPos[$j]/$delete}"
      done
    fi
  done
done

prod=1
IFS=',' read -ra myFields <<<"${validTickets[0]}"
for x in "${!fieldPos[@]}"; do
  if [[ "$x" = "departure"* ]]; then
    v="${myFields["${fieldPos[$x]}"]}"
    ((prod*=v));
  fi
done

echo "$prod"
