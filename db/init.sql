CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(20) NOT NULL
);

INSERT INTO users (name, email, password) VALUES ('Chris', 'test@email.com', '12345');

CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    purpose VARCHAR(255),
    status VARCHAR(50) NOT NULL,
    category VARCHAR(30),
    hash TEXT NOT NULL UNIQUE
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    color VARCHAR(7) NOT NULL
);

INSERT INTO categories (name, color) VALUES ('Lebensmittel', '#22c55e');
INSERT INTO categories (name, color) VALUES ('Lieferdienst', '#f97316');
INSERT INTO categories (name, color) VALUES ('Shopping', '#3b82f6');
INSERT INTO categories (name, color) VALUES ('Restaurant', '#ec4899');
INSERT INTO categories (name, color) VALUES ('Tanken', '#f59e0b');
INSERT INTO categories (name, color) VALUES ('Gesundheit', '#0ea5e9');
INSERT INTO categories (name, color) VALUES ('Unternehmungen', '#a855f7');
INSERT INTO categories (name, color) VALUES ('Sonstiges', '#64748b');

CREATE TABLE calendar_events (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    notes TEXT NOT NULL DEFAULT '',
    event_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    color VARCHAR(7) NOT NULL,
    all_day BOOLEAN NOT NULL DEFAULT FALSE,
    recurrence VARCHAR(16) NOT NULL DEFAULT 'none',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
