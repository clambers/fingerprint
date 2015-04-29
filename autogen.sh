#!/bin/sh

NAME=${1:-unknown}
VERSION=${2:-0.0}
ID_HASH=${3:-0000000000}

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

cp -r $COMMONDIR src/DNA_common
cp package.pc.in $NAME.pc.in

EOF=EOF_$RANDOM
eval echo "\"$(cat <<$EOF
$(<configure.ac.in)
$EOF
)\"" > configure.ac

$AUTORECONF -i
