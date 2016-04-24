#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG='com.namcobandaigames.spmoja010'
ID=$1
DEVICE=$2

$BASEDIR/optc.sh "$PKG" "$ID" "$DEVICE" 'jp'

exit 0
