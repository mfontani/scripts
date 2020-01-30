#!/bin/bash
# Copyright 2018-2020 Marco Fontani <MFONTANI@cpan.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# README: jq
#
# A wrapper around the "real" `jq`, to allow it to work with compressed files.
# Requires the "real" `jq` to be installed in `/usr/bin/jq`.
# Only works if the _file_ to be worked on is the _last_ parameter of the `jq`
# invocation.
#
# Usage:
# - `jq . foo.json`
# - `jq . foo.json.gz`
# - `jq . foo.json.zst`

# override only jq [OPTS] '...' FILE, where FILE exists and is a known
# compressed file type
JQ=/usr/bin/jq

# The LAST parameter is the file.
file="${!#}"
if test -f "$file"; then
    decompressor=
    filetype=$(file "$file")
    if [[ "$filetype" =~ gzip\ compressed\ data ]]; then
        decompressor='gzip -dc'
    elif [[ "$filetype" =~ bzip2\ compressed\ data ]]; then
        decompressor='bzip2 -dc'
    elif [[ "$filetype" =~ Zstandard\ compressed\ data ]]; then
        decompressor='zstd -q -d -c'
    fi
    if [[ -n "$decompressor" ]]; then
        set -- "${@:1:$#-1}"
        $decompressor "$file" | "$JQ" "$@"
        exit $?
    fi
fi

"$JQ" "$@"
