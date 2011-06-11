#!/bin/sh

redout() {
    echo "$(tput bold)$(tput setaf 1)*** $@ ***$(tput sgr0)"
}

greenout() {
    echo "$(tput bold)$(tput setaf 2)>> $@$(tput sgr0)"
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
