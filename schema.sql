CREATE TABLE IF NOT EXISTS flows(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid TEXT NOT NULL UNIQUE,
    source TEXT NOT NULL,
    dest TEXT NOT NULL,
    l4_protocol TEXT NOT NULL,
    protocol TEXT NOT NULL,
    request_raw JSONB NOT NULL,
    response_raw JSONB NOT NULL,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS proto_defs(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    proto_file TEXT NOT NULL,
    created_at TEXT NOT NULL
);
