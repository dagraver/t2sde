#!/bin/bash
#
# Written by Benjamin Schieder <blindcoder@scavenger.homeip.net>
#
# Use:
# newpackage.sh [-main] <rep>/<pkg> http://www.example.com/down/pkg.tar.bz2
#
# will create <pkg>.desc and <pkg>.conf. .desc will contain the [D] and [COPY]
# already filled in. The other tags are mentioned with TODO.
#
# .conf will contain an empty <pkg>_main() { } and custmain="<pkg>_main"
# if -main is specified.
#
# --- ROCK-COPYRIGHT-NOTE-BEGIN ---
# 
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# Please add additional copyright information _after_ the line containing
# the ROCK-COPYRIGHT-NOTE-END tag. Otherwise it might get removed by
# the ./scripts/Create-CopyPatch script. Do not edit this copyright text!
# 
# ROCK Linux: rock-src/misc/archive/newpackage.sh
# ROCK Linux is Copyright (C) 1998 - 2003 Clifford Wolf
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version. A copy of the GNU General Public
# License can be found at Documentation/COPYING.
# 
# Many people helped and are helping developing ROCK Linux. Please
# have a look at http://www.rocklinux.org/ and the Documentation/TEAM
# file for details.
# 
# --- ROCK-COPYRIGHT-NOTE-END ---
#

if [ "$1" == "-main" ] ; then
	create_main=1
	shift
fi

if [ $# -lt 2 ] ; then
	cat <<-EEE
Usage:
$0 <option> package/repository/packagename Download_1 < Download_2, Download_n >

Where <option> may be:
	-main		Create a package.conf file with main-function

	EEE
	exit 1
fi


dir=${1#package/} ; shift
package=${dir##*/}
if [ "$package" = "$dir" ]; then
	echo "failed"
	echo -e "\t$dir must be <rep>/<pkg>!\n"
	exit
fi

rep="$( echo package/*/$package | cut -d'/' -f 2 )"
if [ "$rep" != "*" ]; then
	echo "failed"
	echo -e "\tpackage $package belongs to $rep!\n"
	exit
fi

rep=${dir/\/$package/}
maintainer="$( grep -h -m 1 "\[M\]" package/$rep/*/*.desc | head -n 1 | cut -d' ' -f2- )"

echo -n "Creating package/$dir ... "
if [ -e package/$dir ] ; then
	echo "failed"
	echo -e "\tpackage/$dir already exists!\n"
	exit
fi
if mkdir -p package/$dir ; then
	echo "ok"
else
	echo "failed"
	exit
fi

cd package/$dir
rc="ROCK-COPYRIGHT"

echo -n "Creating $package.desc ... "
cat >>$package.desc <<EEE

[COPY] --- ${rc}-NOTE-BEGIN ---
[COPY] 
[COPY] This copyright note is auto-generated by ./scripts/Create-CopyPatch.
[COPY] Please add additional copyright information _after_ the line containing
[COPY] the ROCK-COPYRIGHT-NOTE-END tag. Otherwise it might get removed by
[COPY] the ./scripts/Create-CopyPatch script. Do not edit this copyright text!
[COPY] 
[COPY] ROCK Linux: rock-src/package/$dir/$package.desc
[COPY] ROCK Linux is Copyright (C) 1998 - `date +%Y` Clifford Wolf
[COPY] 
[COPY] This program is free software; you can redistribute it and/or modify
[COPY] it under the terms of the GNU General Public License as published by
[COPY] the Free Software Foundation; either version 2 of the License, or
[COPY] (at your option) any later version. A copy of the GNU General Public
[COPY] License can be found at Documentation/COPYING.
[COPY] 
[COPY] Many people helped and are helping developing ROCK Linux. Please
[COPY] have a look at http://www.rocklinux.org/ and the Documentation/TEAM
[COPY] file for details.
[COPY] 
[COPY] --- ${rc}-NOTE-END ---

[I] TODO: Short Information

[T] TODO: Long Expanation
[T] TODO: Long Expanation
[T] TODO: Long Expanation
[T] TODO: Long Expanation
[T] TODO: Long Expanation

[U] TODO: URL

[A] TODO: Author
[M] ${maintainer:-TODO: Maintainer}

[C] TODO: Category

[L] TODO: License
[S] TODO: Status
[V] TODO: Version
[P] X -----5---9 800.000

EEE

while [ "$1" ]; do
	dl=$1; shift
	file=`echo $dl | sed 's,^.*/,,g'`
	server=${dl%$file}
	echo [D] 0 $file $server >> $package.desc
done
echo >> $package.desc

echo "ok"
echo -n "Creating $package.conf ... "

if [ "$create_main" == "1" ] ; then
	cat >>$package.conf <<-EEE

# --- ${rc}-NOTE-BEGIN ---
# 
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# Please add additional copyright information _after_ the line containing
# the ROCK-COPYRIGHT-NOTE-END tag. Otherwise it might get removed by
# the ./scripts/Create-CopyPatch script. Do not edit this copyright text!
# 
# ROCK Linux: rock-src/package/$dir/$package.conf
# ROCK Linux is Copyright (C) 1998 - `date +%Y` Clifford Wolf
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version. A copy of the GNU General Public
# License can be found at Documentation/COPYING.
# 
# Many people helped and are helping developing ROCK Linux. Please
# have a look at http://www.rocklinux.org/ and the Documentation/TEAM
# file for details.
# 
# --- ${rc}-NOTE-END ---

	EEE
	cat >>$package.conf <<-EEE
${package}_main() { #TODO
}

custmain="${package}_main"
	EEE
fi

echo "ok"
echo "Remember to fill in the TODO's:"
cd -
grep TODO package/$dir/$package.*
echo
