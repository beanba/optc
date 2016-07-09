#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG='com.linecorp.LGOPTW'
ID=$1

$BASEDIR/optc.sh "$PKG" "$ID" 'tw'

exit 0
