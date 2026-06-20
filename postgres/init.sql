-- Inicialización de Esquema de Base de Datos Estricto
CREATE TABLE IF NOT EXISTS user_accounts (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Índices B-Tree para optimización de consultas en alta concurrencia
CREATE INDEX IF NOT EXISTS idx_users_username ON user_accounts(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON user_accounts(email);

-- Insertar semilla de datos iniciales (Seed Data)
INSERT INTO user_accounts (username, email, password_hash) VALUES 
('sys_admin', 'admin@telemetry.infra', '$2b$12$K7v1S9Zf6u5R4e3w2q1u0O7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2'),
('telemetry_worker', 'worker@telemetry.infra', '$2b$12$X9y8z7w6v5u4t3s2r1q0O7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2')
ON CONFLICT DO NOTHING;
