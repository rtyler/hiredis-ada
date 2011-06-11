#!/bin/sh

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
