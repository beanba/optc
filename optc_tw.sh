#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG='com.linecorp.LGOPTW'
ID=$1
DEVICE=$2

$BASEDIR/optc.sh "$PKG" "$ID" "$DEVICE" ''

exit 0
