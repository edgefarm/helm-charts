#!/bin/bash
set -e
VAULT_NATS_SECRETS_PLUGIN_VERSION=$(yq '.vault.image' charts/vault/values.yaml | awk -F ':' '{print $2}')
CHECKSUM_FILE_ADDRESS=https://github.com/edgefarm/vault-plugin-secrets-nats/releases/download/v${VAULT_NATS_SECRETS_PLUGIN_VERSION}/vault-plugin-secrets-nats.sha256
TEMP_DIR=$(mktemp -d)
ROOT_DIR=$(pwd)
cd $TEMP_DIR
curl -sL ${CHECKSUM_FILE_ADDRESS} -o ${TEMP_DIR}/vault-plugin-secrets-nats.sha256
CONTENT=$(cat ${TEMP_DIR}/vault-plugin-secrets-nats.sha256)
export CHECKSUM=${CONTENT% *}
echo Updating checksum for plugin version v${VAULT_NATS_SECRETS_PLUGIN_VERSION} to ${CHECKSUM} in charts/vault/values.yaml
yq -i '(.vault.externalConfig.plugins[] | select(.plugin_name == "vault-plugin-secrets-nats") | .sha256) |= env(CHECKSUM)' $ROOT_DIR/charts/vault/values.yaml
rm -r ${TEMP_DIR}