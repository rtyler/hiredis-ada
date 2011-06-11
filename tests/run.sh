#!/bin/sh

source "tests/functions.sh"

greenout "Preparing to start integration tests"

locate_redis

## Start running through all our test cases
for d in $(find tests/cases -type d); do
    if [ "$d" = "tests/cases" ]; then
        continue
    fi
    greenout "Starting test case: \"${d}\""

    test -e "${d}/test.sh"

    if [ $? -ne 0 ]; then
        redout "Could not find the test script in ${d}"
        exit 1
    fi
done
