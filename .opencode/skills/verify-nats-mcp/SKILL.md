---
name: verify-nats-mcp
description: Verify the standalone NATS MCP admin UI and documented operator journeys.
---

# Verify NATS MCP

## Launch

Primary surface: SvelteKit admin UI in `apps/admin`. From that directory run:

```sh
pnpm dev --port 5179
```

The UI proxies API, MCP, and OAuth discovery routes to `127.0.0.1:8080`. An authenticated operator journey needs the documented standalone NATS stack, the SQL development Authentik network, and disposable NATS/test data (see the root README). Do not load or print `.env` values. Without that stack, verify only the local logged-out UI. Stop only this run's dev server with Ctrl-C.

## Preflight

1. In `apps/admin`, run `pnpm check` and `pnpm build`.
2. Check port ownership with `ss -ltnp 'sport = :5179'`; choose a different free loopback port if occupied and do not stop an unknown process.
3. Start Vite, wait for its ready message, and confirm `http://127.0.0.1:5179/` and `/favicon.svg` both return HTTP 200.
4. Treat gateway/OIDC/NATS health as a separate prerequisite; a ready UI server does not establish backend readiness.

## Drive and evidence

Use Firefox at the local URL and accessible roles, names, and labels. Capture screenshots and relevant console/network errors in `artifacts/verification/`; preserve evidence after teardown. Do not activate SSO in routine UI checks: that navigates to an external identity provider. Follow [`features/README.md`](features/README.md); an unauthenticated screenshot proves only the sign-in boundary. For full operator journeys, verify visible state and the isolated local API/broker outcome.

## Isolation, cleanup, and failures

Use a free loopback port and disposable local broker/test identities. Never use production credentials, kill processes by name, or remove resources not created for this run. Missing API, Authentik, Vault, or NATS setup is a blocker, not a passing journey. Preserve artifacts and update the feature map when route behavior changes.
