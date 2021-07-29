#!/bin/bash
# mulitple commands warrant a file instead of just one command in the Dockerfile
set -e

# . $VIRT_ENV/bin/activate
export GPG_TTY=$(tty)

exec "$@"
