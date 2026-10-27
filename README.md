# NATS MCP

Standalone NATS/JetStream MCP service. It owns its HTTP process, admin API, admin UI,
control database migrations, target catalog, grants, and audit events; it is not built
or deployed with `sql-mcp-gateway`.

Production OIDC and Vault are external dependencies configured for this service. Local
Compose reuses the SQL MCP Gateway's Authentik provider and attaches the API to its
Docker network. This MCP still owns its Vault, control database, grants, and audit events.
The public MCP endpoint is `${MCP_PUBLIC_URL}/nats/mcp`.

## Local development

Copy `.env.example` to `.env` using a secret-safe local workflow, then configure the
OIDC provider, dedicated control database, and Vault tokens. The service applies its
embedded migrations at startup.

```sh
cargo run -p nats-mcp
```

## Docker Compose

The default Compose service is this project's isolated PostgreSQL control database;
it does not expose a database port on the host. To run the complete local stack,
generate a private `.env` with `python3 deploy/init-local-env.py`, start the SQL MCP
Gateway's local development stack with `make dev-up` there, then run
`docker --context rootless compose --profile application up -d --build`.
The SQL stack must be running first so its Authentik network and
providers are available. The UI/API are at `http://localhost:18180`; sign in with the
SQL MCP Gateway's `dev-admin` account. Authentik is at `http://127.0.0.1:9000`, and the
MCP endpoint is `/nats/mcp`. The Vault development server is loopback-only
and in-memory; its secrets and policies are lost when its container restarts or is
recreated. After a Vault restart, rerun
`docker --context rootless compose --profile application run --rm --no-deps vault-bootstrap`
to restore the local mount and scoped tokens. These local development instances are
not production configurations.

In another terminal:

```sh
cd apps/admin && pnpm install --frozen-lockfile && pnpm dev
```

The admin UI is served at `http://127.0.0.1:5173`. NATS credentials are validated
before storage in Vault and are never returned by the API. Grants default to no access;
write operations require an explicit write grant and authorized subject scope.

The Rust package currently carries shared protocol/authentication support code copied
from the SQL gateway; only NATS routes are mounted in this service. SQL tools and SQL
target administration are not exposed here.

For the ignored live broker smoke tests, provide `NATS_MCP_TEST_PORT` and
`NATS_MCP_TEST_PASSWORD` through a secret-safe shell environment while a disposable
token-authenticated NATS server with JetStream is running on loopback, then run
`cargo test -p nats-mcp live_nats -- --ignored`. These tests do not use the SQL
gateway's integration stack.
