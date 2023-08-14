FROM ghcr.io/tailscale/tailscale:v1.44.0

# Declare environment variables
ENV TS_TUN_NAME=
ENV TS_AUTH_KEY=
ENV TS_LOGIN_SERVER=
ENV TS_ADDITIONAL_ARGS=
ENV TS_ACCEPT_DNS=

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

