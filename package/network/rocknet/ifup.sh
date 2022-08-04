#!/bin/bash
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# T2 SDE: package/*/rocknet/ifup.sh
# Copyright (C) 2004 - 2022 The T2 SDE Project
# 
# This Copyright note is generated by scripts/Create-CopyPatch,
# more information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2.
# --- T2-COPYRIGHT-NOTE-END ---

rocknet_tmp_base="/var/run/rocknet"
[ -d $rocknet_tmp_base ] || mkdir -p $rocknet_tmp_base

var_contains() {
  local tmp
  eval "tmp=\"\$$1\""

  [ "${tmp/$3$2/}" != "$tmp" ]
}

usage() {
	echo "Usage: $0 interface [ profile ] [ -force ]"
	exit 1
}

force=0

if="$1" ; shift ; [ "$if" ] || usage
profile=""
action="${0/#*\/if}"

while [ "$1" ] ; do
	case $1 in
		-force) force=1 ;;
		*) [ "$profile" = "" ] && profile="$1" || usage ;;
	esac
	shift
done

[ "$profile" ] || profile="`cat /etc/conf/network-profile 2> /dev/null`"
profile=${profile:-default}

# sanity checks (...)

if [ $force -eq 0 ]; then
  active_interfaces="`cat $rocknet_tmp_base/active-interfaces 2>/dev/null`"

  if test $action = "up" && var_contains active_interfaces ',' "$if($profile)"
    then
	echo "Interface $if($profile) is already listed active, it is probably a good idea to"
	echo "take it down before activating it. Use -force to suppress this warning."
	exit 2
  fi

  if test $action = "down" && ! var_contains active_interfaces ',' "$if($profile)"
    then
        echo "Interface $if($profile) is not listed active, it is probably a good idea to"
        echo "activate it before deactivating it. Use -force to suppress this warning."
        exit 2
  fi
fi

/sbin/rocknet "$profile" "$if" "$action"
echo "$profile" > /etc/conf/network-profile
