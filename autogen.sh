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

cp -r $COMMONDIR src/DNA_common
cp package.pc.in $NAME.pc.in

EOF=EOF_$RANDOM
eval echo "\"$(cat <<$EOF
$(<configure.ac.in)
$EOF
)\"" > configure.ac

$AUTORECONF -i
