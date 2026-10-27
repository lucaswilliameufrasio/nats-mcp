# Connections and grants

- **Reach:** sign in locally as an administrator, then open `/nats`.
- **Drive:** create a disposable local NATS connection and grant a test principal a narrow subject scope and the minimum access level.
- **Proof:** saved target and grant are visible; confirm them through the isolated local API and run a broker operation within the granted scope. Verify an out-of-scope operation is denied when the local test harness supports it.
- **Preconditions:** isolated NATS MCP stack, disposable NATS broker, Vault bootstrap, and test identities.
- **Gotcha:** never use production broker credentials; backend acceptance is not established by the form's success message alone.
