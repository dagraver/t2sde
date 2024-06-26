#!/bin/sh
#
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# T2 SDE: package/*/t2-debug/test_bindups.sh
# Copyright (C) 2004 - 2023 The T2 SDE Project
# Copyright (C) 1998 - 2003 ROCK Linux Project
# 
# This Copyright note is generated by scripts/Create-CopyPatch,
# more information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2.
# --- T2-COPYRIGHT-NOTE-END ---
#
# List all binary names which are used more than once in various bin dirs.
#
# Output format:
# Bin-Name <Tab> Dir1 <Tab> Dir2
# ...

find {,/usr,/usr/local}/{,s}bin -type f -printf '%f %H\n' |
sort | awk 'BEGIN { OFS="\t"; last=""; lastdir=""; }
$1==last { print $1, lastdir, $2; } { lastdir=$2; last=$1; }'

exit 0
