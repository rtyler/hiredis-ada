#!/bin/sh -e

source "tests/functions.sh"

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=`dirname "$SCRIPT"`

cd $SCRIPTPATH

start_redis

runcommand ./basic_set simplekey simplevalue

runcommand ruby check.rb simplekey simplevalue
