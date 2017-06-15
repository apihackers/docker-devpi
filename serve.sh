#!/usr/bin/env bash
set -e

[[ -f $DEVPI_SERVERDIR/.serverversion ]] || initialize=yes

# Properly shutdown devpi server
shutdown() {
    devpi-server --stop  # Kill server
    kill -SIGTERM $TAIL_PID  # Kill log tailing
}

trap shutdown SIGTERM SIGINT

if [[ $initialize = yes ]]; then
  devpi-server --init
fi
# Need $DEVPI_SERVERDIR
devpi-server --start --host 0.0.0.0 --port $DEVPI_PORT --theme $DEVPI_THEME

DEVPI_LOGS=$DEVPI_SERVERDIR/.xproc/devpi-server/xprocess.log

devpi use http://localhost:$DEVPI_PORT
if [[ $initialize = yes ]]; then
  # Set root password
  devpi login root --password=''
  devpi user -m root password="${DEVPI_PASSWORD}"
  # devpi index -y -c public pypi_whitelist='*'
fi
# Authenticate for later commands
devpi login root --password="${DEVPI_PASSWORD}"

tail -f $DEVPI_LOGS &
TAIL_PID=$!

# Wait until tail is killed
wait $TAIL_PID

# Set proper exit code
wait $DEVPI_PID
EXIT_STATUS=$?
