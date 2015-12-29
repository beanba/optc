#!/usr/bin/env bash

BASEDIR=$(dirname $0)
PKG='com.linecorp.LGOPTW'
DEVICE=$1

$BASEDIR/optc.sh $PKG $DEVICE

exit 0
