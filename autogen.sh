#!/bin/sh

while getopts "h" flag; do
  case "$flag" in
    h) echo "Usage: $(basename $0) NAME VERSION HASH";;
  esac
done

NAME=${@:$OPTIND:1}
VERSION=${@:$OPTIND+1:1}
ID_HASH=${@:$OPTIND+2:1}

AUTORECONF=`which autoreconf`
COMMONDIR=/opt/usr/apps/common-apps

if [ ! -d $COMMONDIR ]; then
  echo "*** No common dir found, please install common-apps ***"
  exit 1
fi

if [ -z $AUTORECONF ]; then
  echo "*** No autoreconf found, please install autoconf ***"
  exit 1
fi

mkdir -p m4
cp -r $COMMONDIR src/DNA_common
EOF=EOF_$RANDOM
echo "$(cat <<$EOF
# AX_IMPORT
# ---------
# Import package information from an outside source.
AC_DEFUN([AX_IMPORT],
[m4_define([AX_PACKAGE_NAME], [${NAME^}])
m4_define([AX_PACKAGE_VERSION], [$VERSION])
m4_define([AX_PACKAGE_HASH], [$ID_HASH])
])
$EOF
)" > m4/package.m4

$AUTORECONF -i
