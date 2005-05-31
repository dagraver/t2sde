#!/bin/bash
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: misc/archive/Update.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

pkg="$1" ; shift
ver="$1" ; shift

if [ -z "$ver" ]; then
	ver=${pkg/*-/}
	pkg=${pkg%-$ver}
fi

if [ -z "$pkg" -o -z "$ver" ]; then
	echo "Usage: $0 pkg ver"
	echo "   or: $0 pkg-ver"
	exit
fi

rm -f $$.diff
pkg=`echo $pkg | tr [A-Z] [a-z]`

if [ -d package/*/$pkg ]; then
	./scripts/Create-PkgUpdPatch $pkg $ver | tee $$.diff
	patch -p1 < $$.diff
	rm -f $$.diff

	./scripts/Download $pkg
	./scripts/Create-CkSumPatch $pkg | patch -p0
else
	echo "ERROR: package $pkg doesn't exist"
	pkg=`echo "$pkg" | tr '\-_.' '***'`
	echo `echo package/*/*$pkg*/ | tr ' ' '\n' | grep -v '*' | cut -d'/' -f3`
fi

