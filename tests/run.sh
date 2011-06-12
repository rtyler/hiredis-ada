#!/bin/sh

source "tests/functions.sh"

greenout "Preparing to start integration tests"

locate_redis

echo "---------------------------------------"

SKIPFILE="testresults.$$.skip.log"
FAILFILE="testresults.$$.fail.log"
PASSFILE="testresults.$$.pass.log"

## Start running through all our test cases
for d in $(find tests/cases -type d); do
    if [ "$d" = "tests/cases" ]; then
        continue
    fi
    greenout "Starting test case: \"${d}\""

    SCRIPT="${d}/test.sh"

    test -e $SCRIPT

    if [ $? -ne 0 ]; then
        redout "Could not find the test script \"${SCRIPT}\""
        exit 1
    fi

    sh $SCRIPT

    case $? in
        2 | 3)
            echo $SCRIPT >> $SKIPFILE
            ;;
            0)
            echo $SCRIPT >> $PASSFILE
            ;;
            *)
            # Anything that isn't zero, 2 or 3, probably is fail
            echo $SCRIPT >> $FAILFILE
            ;;
    esac
done

greenout "Completed running tests"

echo "---------------------------------------"
echo

RC=0
test -e $FAILFILE

if [ $? -eq 0 ]; then
    redout "There were test failures!"
    cat $FAILFILE
    RC=1
fi

if [ -e $SKIPFILE ]; then
    yellowout "Skipped tests:"
    cat $SKIPFILE
    yellowout "------"
fi


if [ -e $PASSFILE ]; then
    greenout "Passed tests:"
    cat $PASSFILE
    greenout "------"
fi

rm -f testresults.*

exit $RC
