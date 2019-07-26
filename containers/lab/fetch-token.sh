#!/usr/bin/env bash
function set_vault_credentials {
  VAULT_ADDR="https://vault.pulsifer.dev:8200"

  JWT=$(curl -H "Metadata-Flavor: Google"\
  -G \
  --data-urlencode "audience=$VAULT_ADDR/vault/web"\
  --data-urlencode "format=full" \
  "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity")

  check_errors=$(curl \
    --request POST \
    --data "{\"role\": \"web\", \"jwt\": \"$JWT\"}" \
    "${VAULT_ADDR}/v1/auth/gcp/login" | jq -r ".errors")

  if [ "\$check_errors" == "null" ]
  then
    VAULT_TOKEN=$(curl \
    --request POST \
    --data "{\"role\": \"web\", \"jwt\": \"$JWT\"}" \
    "${vault_addr}/v1/auth/gcp/login" | jq -r ".auth.client_token")
  else
    echo "Error from vault: $check_errors"
    exit 1
  fi

  export VAULT_ADDR
  export VAULT_TOKEN
}

set_vault_credentials
