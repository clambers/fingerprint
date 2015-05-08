#!/bin/sh

NAME=$1
INPUT=${2:-/dev/stdin}
OUTPUT=${3:-/dev/stdout}

if [ "$INPUT" = "-" ]; then
  INPUT=/dev/stdin
fi

if [ "$OUTPUT" = "-" ]; then
  OUTPUT=/dev/stdout
fi

if [ ! -r "$INPUT" ]; then
  echo "Usage: $(basename $0) name [js api file] [output c header file]"
  exit 1
fi

exec > $OUTPUT

echo "static const char *kSource_fingerprint_api = "
tr -d '\r' < "$INPUT" | sed 's:["\\]:\\&:g;s:.*:    "&\\n":'
echo ";"
