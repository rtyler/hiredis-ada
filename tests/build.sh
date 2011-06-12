#!/bin/sh

OBJDIR="${PWD}/obj/tests"

for f in $(find tests -iname "*.adb"); do
    FILE=$(echo $f | cut -d / -f 4);
    DIR=$(echo $f | cut -d / -f -3);

    (cd $DIR && gnatmake -D $OBJDIR $FILE)
done
