#!/bin/bash

rm -f README.md
(
    [[ -f .README.head.md ]] && (
        cat .README.head.md
        echo ''
    )
    for f in ./*; do
        [[ "$f" == ./README.md ]] && continue
        perl -lne'
            if (/^[#][ ]README:/../^$/) {
                s/^[#][ ]README:[ ]/# ## /;
                s/^[#][ ]//;
                s/^[#]$//;
                print;
            }
        ' "$f"
    done
    [[ -f .README.tail.md ]] && (
        cat .README.tail.md
        echo ''
    )
    [[ -f LICENSE ]] && (
        echo ''
        echo '# License'
        echo ''
        cat LICENSE
    )
) > README.md
