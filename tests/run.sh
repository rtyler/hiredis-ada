#!/bin/sh

# Set this so our test scripts can properly pick up our shared lib
export LD_LIBRARY_PATH=`pwd`/build:$LD_LIBRARY_PATH

source "tests/functions.sh"

greenout "Preparing to start integration tests"

locate_redis

echo "---------------------------------------"

SKIPFILE="testresults.$$.skip.log"
FAILFILE="testresults.$$.fail.log"
PASSFILE="testresults.$$.pass.log"

## Start running through all our test cases
for d in $(find tests/cases -type d | sort); do
    if [ "$d" = "tests/cases" ]; then
        continue
    fi

    testname=$(echo $d | cut -d / -f 3)
    execname=$(echo $d | cut -d - -f 2- | sed 's/-/_/')
    greenout "Starting test case: \"${testname}\""

    cat > tmptest.sh <<EOF
#!/bin/sh
source "tests/functions.sh"
cd ${d}
start_redis
if [ -f "pre.rb" ]; then
    runcommand ruby pre.rb
fi
runcommand ./${execname}
runcommand ruby check.rb
EOF

    sh tmptest.sh

    case $? in
        2 | 3)
            echo $testname>> $SKIPFILE
            ;;
            0)
            echo $testname >> $PASSFILE
            ;;
            *)
            # Anything that isn't zero, 2 or 3, probably is fail
            echo $testname >> $FAILFILE
            ;;
    esac
done

rm -f tmptest.sh

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
