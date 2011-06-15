#!/bin/sh

REDIS_PIDFILE="$PWD/redis.pid"

#########################
##  PRINTING FUNCTIONS
redout() {
    echo "$(tput bold)$(tput setaf 1)*** $@ ***$(tput sgr0)"
}

greenout() {
    echo "$(tput bold)$(tput setaf 2)>> $@$(tput sgr0)"
}

yellowout() {
    echo "$(tput bold)$(tput setaf 3)*** $@ ***$(tput sgr0)"
}

blueout() {
    echo "$(tput bold)$(tput setaf 4)*** $@ ***$(tput sgr0)"
}
#########################


#########################
## SCAFFOLDING FUNCTIONS
locate_redis() {
    REDIS=$(which redis-server)

    if [ $? -ne 0 ]; then
        redout "Could not find \`redis-server\` in your \$PATH"
        exit 1
    else
        greenout "Using \`redis-server\` located in: ${REDIS}"
    fi

    export REDIS=$REDIS
}

kill_redis() {
  RUNNING=1
  REDIS_PID=$(cat $REDIS_PIDFILE)

  greenout "Killing redis-server on pid: ${REDIS_PID}"
  kill ${REDIS_PID}
  while [ $RUNNING -ne 0 ]; do
    ps -eo pid | grep "^${REDIS_PID}$$" > /dev/null
    if [ $? -ne 0 ]; then
      RUNNING=0
    fi
    sleep 0.1
  done
}

start_redis() {
  trap kill_redis INT QUIT TERM EXIT
  redis-server - <<EOF
  loglevel debug
  daemonize yes
  pidfile ${REDIS_PIDFILE}
EOF
  greenout "redis-server started with pid: $(cat $REDIS_PIDFILE)"
}




#########################
## TESTING HELPERS
not_implemented() {
    echo
    yellowout "NOT IMPLEMENTED"
    echo
    exit 2
}

skip_test() {
    echo
    blueout "SKIPPING"
    echo
    exit 3
}

runcommand() {
  "$@"

  if [ $? -ne 0 ]; then
    redout "Failed while running: \`$@\`"
    exit 1
  fi
}

#########################
