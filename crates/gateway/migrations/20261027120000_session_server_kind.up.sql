ALTER TABLE mcp_transport_sessions
    ADD COLUMN server_kind TEXT NOT NULL DEFAULT 'nats'
    CHECK (server_kind = 'nats');
