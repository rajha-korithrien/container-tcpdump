#!/bin/sh
set -e

# if the first argument isn't executable, then we default to running tcpdump
if ! type -- "$1" &> /dev/null; then
	set -- tcpdump "$@"
fi

exec "$@"