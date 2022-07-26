# scripts

A collection of scripts I've written over the years.

Hope you find them useful.

This repository used to only live in my personal gitea instance at
https://git.marcofontani.it/mfontani/scripts but I've recently started
mirroring it to GitHub, in the hope it can be found by a larger audience.

## atqq

Displays the "at" queue, similarly to "atq"
... but also showing which command is scheduled for execution.

Usage:

- `atqq`

## colorize

colorize regex with given color.

Usage:

- `colorize REGEX ANSI_COLOR`
- `lscpu | colorize MHz 32`

## colorz

Displays:
- all 256 ANSI colors your terminal hopefully supports
- the "base" foreground and background colors
- a truecolor "rainbow", useful to see if your terminal supports it.

Provide one color number to see it used in the background color.

Usage:

- `colorz`
- `colorz 22`
- `colorz 22 23`

## contrast

Shows WCAG contrast for the FOREGROUND on BACKGROUND hex colors.

Usage:

- `contrast ff0000 000000`
- `contrast ff0000 000000 -l`
- `for f in ff0000 aa0000; for b in 000000 333333; do contrast "$f" "$b" -l; done`

## evenodd

Colorizes STDIN lines (even and odd), with a given optional color for the
background color to be used.

Usage:

- `foo | evenodd`
- `foo | evenodd 42`

## filter-file-exists

A pipe filter which only outputs files which are found on the filesystem.

Usage:

- `prove -j4 $(git fcm | filter-file-exists | grep '[.]t$')`

## ggrep

Does a `git grep` on the current repository, but instructing `git grep` to
_exclude_ all files/patterns referenced in the local `ggrep.exclude` list of
exclude options, added i.e. via a `.git/config` stanza like:

    [ggrep]
    exclude = ':!/foo/'
    exclude = ':!*.jpg'

Usage:
- `ggrep foo`

## git amend-addtime

Amend the HEAD commit's timestamp to a later, or ealier, timestamp.

Usage:
- `git amend-addtime 86400`
- `git amend-addtime -3600`

## git grepblame

Perform a `git grep` for a pattern, and then run a `git blame` on the matched
files and lines.
Useful to find out who & when "dealt with" a specific chunk of code/pattern.
See also: https://blog.darkpan.com/posts/git-grepblame/

Usage:
- `git grepblame foobar`

## gz-to-zst

Convert given `*.gz` files into `*.zst` files (at `-9`), and show statistics
for space saved by the conversion

Usage:
- `gz-to-zst foo.gz`
- `gz-to-zst *.gz`

## h

Run a command on all lines but the first one (the "h"-eader). Useful to i.e.
run a `grep` on all lines _but_ the first.
Optionally provide a number of lines to keep instead, via `-N`.

Usage:
- `h grep foobar file.csv`
- `h -3 grep foobar file.csv`

## highlight

Perform a "color `grep`" on a given pattern. Useful to ensure the whole
command/data is displayed, _but_ the given pattern is highlighted, unlike
standard `grep`.
Ancestor of `colorize`.

Usage:
- `ls | highlight foo`
- `lscpu | highlight MHz`

## jq

A wrapper around the "real" `jq`, to allow it to work with compressed files.
Requires the "real" `jq` to be installed in `/usr/bin/jq`.
Only works if the _file_ to be worked on is the _last_ parameter of the `jq`
invocation.

Usage:
- `jq . foo.json`
- `jq . foo.json.gz`
- `jq . foo.json.zst`

## lsw

Shows where a (given) command is located, and which (debian) package, if any,
it belongs to.

Usage:
- `lsw ls`

## muffle-env

Replaces _all_ environment variable _values_ with their _name_, in the format
`{{NAME}}`, i.e. for env var `FOO=BAR` it'd show `blah {{FOO}} baz` for the
given string `blah BAR baz`.
If parameters are given, it only performs the replacement for environment
variable _names_ which match any of the regexes given as parameters.
Note this may end up substituting parts of values of other environment
variables which wouldn't otherwise be matched.

Useful to ensure a log file or log output doesn't end up containing any
sensitive secret which is present in the environment.
Just add it at the end of a pipe.

Usage:

- `env | muffle-env`
- `git push origin master:master 2>&1 | muffle-env '^SSH_'`

## ping-site

Given a URL to "ping" every second, it makes a request to that URL every
second for a maximum of five minutes, after which it gives up.
Uses `notify-send` to notify you whether the site is now up, or whether the 5
minutes' timeout has passed, and the site is still down.
Requires `perl` to be installed, as well as `Mojolicious` (on Debian,
`sudo apt install -y -q libmojolicious-perl`), as well as `notify-send` (and
likely a running daemon like `dunst`) to be able to send you notifications.

Usage:

- `ping-site https://www.theregister.com/`
use 5.020_001;
use warnings;
use Mojo::UserAgent qw<>;

## stddev

Calculate the mean of the set, the standard deviation, and output some useful
percentile values from the set, too.
Needs a list of numerical (integers or floating point, but beware those)
numbers, given as either parameters or as input.
The "number" part of the input ought to be either at the start, or at the
end, of the parameter - or be wholly "the" parameter.

Usage:
- `stddev $(seq 1 1000)`
- `for i in $(seq 1 10); do echo "$i"; done | stddev`
- `for i in $(seq 1 10); do echo "x $i"; done | stddev`
- `for i in $(seq 1 10); do echo "$i x"; done | stddev`

## time-rollup

Execute a command a number of times, then spit out the min, max, and a couple
pNN percentages for its execution.  Defaults to executing it 10 times; can
take an optional numerical first parameter which overrides this.
Requires `/usr/bin/time` to be installed, as well as `perl`.

Usage:
- `time-rollup sleep 1`
- `time-rollup 5 sleep 1`

## xargso

An easy-to-use replacement for "xargs -o" for xargs which don't have it, and
need the well-known "shell hack" to perform the same operation.

    -o, --open-tty
      Reopen stdin as /dev/tty in the child process before executing the command.  This is useful if you want xargs to run an interactive application.

If you need to pass options to xargs, provide them _first_, and separate them
from the rest via `--`. Only options until the _first_ `--` delimiter are
passed to xargs; the rest are for the command to run

Usage:

- `ls | xargso vim -o` (don't do this! use null terminators!)
- `printf 'foo\0bar\0baz' | xargso -0 -- echo`


# License

Copyright 2018-2022 Marco Fontani <MFONTANI@cpan.org>

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
