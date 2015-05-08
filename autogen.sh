#!/bin/sh

NAME=fingerprint
VERSION=0.0.1
HASH=BMQA0bTQCY

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
# AX_IMPORT_PACKAGE_INFO
# ----------------------
# Import package information from an outside source.
AC_DEFUN([AX_IMPORT],
[m4_define([AX_PACKAGE_NAME], [${NAME^}])
m4_define([AX_PACKAGE_VERSION], [$VERSION])
m4_define([AX_PACKAGE_HASH], [$HASH])
])
$EOF
)" > m4/package.m4

EOF=EOF_$RANDOM
eval echo "\"$(cat <<$EOF
$(<packaging/fingerprint.spec.in)
$EOF
)\""

$AUTORECONF -if
