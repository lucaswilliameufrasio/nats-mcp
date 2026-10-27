#!/bin/sh
set -eu

export VAULT_TOKEN="$VAULT_ROOT_TOKEN"

until vault status >/dev/null 2>&1; do
  sleep 1
done

if ! vault secrets list -format=json | grep -Fq '"integration-secrets/"'; then
  vault secrets enable -version=2 -path=integration-secrets kv >/dev/null
fi
vault policy write nats-mcp-admin /config/policies/admin.hcl >/dev/null
vault policy write nats-mcp-runtime /config/policies/runtime.hcl >/dev/null
if ! VAULT_TOKEN="$VAULT_ADMIN_TOKEN" vault token lookup >/dev/null 2>&1; then
  vault token create -id="$VAULT_ADMIN_TOKEN" -policy=nats-mcp-admin -orphan >/dev/null
fi
if ! VAULT_TOKEN="$VAULT_RUNTIME_TOKEN" vault token lookup >/dev/null 2>&1; then
  vault token create -id="$VAULT_RUNTIME_TOKEN" -policy=nats-mcp-runtime -orphan >/dev/null
fi
