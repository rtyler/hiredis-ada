#!/bin/sh

OBJDIR="${PWD}/obj/tests"

source "tests/functions.sh"

for f in $(find tests -iname "*.adb"); do
    FILE=$(echo $f | cut -d / -f 4);
    DIR=$(echo $f | cut -d / -f -3);

    (cd $DIR && gnatmake -gnat05 -L${OBJDIR}/../../build -aI${OBJDIR}/../../src -D $OBJDIR $FILE -largs -lredisada)

    if [ $? -ne 0 ]; then
        echo
        redout "FAILED TO BUILD ${FILE}"
        echo
        exit 1
    fi
done
