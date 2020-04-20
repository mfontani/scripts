#!/bin/bash

LICENSE=$( sed 's/^/# /;s/^# $/#/' LICENSE )

for f in ./*; do
    [[ "$f" == ./LICENSE ]] && continue
    [[ "$f" == ./README.md ]] && continue
    [[ "$f" == ./Makefile ]] && continue
    if grep -q '^[#][ ]Copyright' "$f"; then
        continue
    fi
    head=$(head -n 1 "$f")
    tail=$(tail -n +2 "$f")
    printf "%s\n%s\n%s\n" "$head" "$LICENSE" "$tail" | tee "$f" >/dev/null
done
