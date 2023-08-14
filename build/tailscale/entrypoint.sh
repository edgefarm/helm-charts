#!/bin/sh
TAILSCALED_CMD_ARGS=""
if [ -n "$TS_TUN_NAME" ]; then
    TAILSCALED_CMD_ARGS="$TAILSCALE_CMDD_ARGS --tun=$TS_TUN_NAME"
fi

echo "Running tailscaled command:"
echo tailscaled $TAILSCALED_CMD_ARGS
tailscaled $TAILSCALED_CMD_ARGS &

sleep 5
TAILSCALE_CMD_ARGS=""

if [ -n "$TS_AUTH_KEY" ]; then
    TAILSCALE_CMD_ARGS="$TAILSCALE_CMD_ARGS --auth-key=$TS_AUTH_KEY"
fi

if [ -n "$TS_LOGIN_SERVER" ]; then
    TAILSCALE_CMD_ARGS="$TAILSCALE_CMD_ARGS --login-server=$TS_LOGIN_SERVER"
fi

if [ -n "$TS_ACCEPT_DNS" ]; then
    TAILSCALE_CMD_ARGS="$TAILSCALE_CMD_ARGS --accept-dns=$TS_ACCEPT_DNS"
fi

if [ -n "$TS_ADDITIONAL_ARGS" ]; then
    TAILSCALE_CMD_ARGS="$TAILSCALE_CMD_ARGS $TS_ADDITIONAL_ARGS"
fi

echo "Running tailscale up command:"
echo tailscale up $TAILSCALE_CMD_ARGS
tailscale up $TAILSCALE_CMD_ARGS

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
