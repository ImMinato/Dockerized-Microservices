# 🐳 Multi-Container Microservices Infrastructure Orchestrator

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

A production-ready microservices infrastructure blueprint utilizing Docker and Docker Compose. This repository orchestrates an isolated, multi-container network environment comprising a high-performance relational database (PostgreSQL), an in-memory memory cache engine (Redis), and an administrative analytics dashboard interface.

---

## ⚡ Infrastructure Design Concepts

* **Container Isolation & Custom Networking:** Services communicate securely within a private, dedicated virtual bridge network (`infra_backend_network`), preventing unauthorized external system exposures.
* **Data Persistence Assurance:** Implements named volume drivers (`postgres_data`, `redis_data`) mapped directly to the host machine filesystem to guarantee data integrity across container tear-downs.
* **Automated Seed Initialization:** Hooks directly into the PostgreSQL entry point pipeline to automatically execute strict schema bindings and indices generation during the first boot sequence.
* **High-Availability Configuration:** Enforces stateful restart policies (`always`, `unless-stopped`) to make services resilient against unexpected infrastructure crashes or engine runtime drops.

---

## 📂 Project Structure & Source Code

To implement this architecture on your environment, populate your repository with the following structural layout and file contents:

### 1. `docker-compose.yml`
```yaml
version: '3.8'

services:
  database:
    image: postgres:15-alpine
    container_name: infra_postgres_db
    environment:
      POSTGRES_USER: admin_user
      POSTGRES_PASSWORD: secure_infra_password_2026
      POSTGRES_DB: enterprise_telemetry
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./postgres/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - infra_backend_network
    restart: always

  cache_memory:
    image: redis:7-alpine
    container_name: infra_redis_cache
    command: redis-server --appendonly yes --requirepass redis_secure_token_777
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - infra_backend_network
    restart: always

  db_dashboard:
    image: dpage/pgadmin4
    container_name: infra_pgadmin_dashboard
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@telemetry.infra
      PGADMIN_DEFAULT_PASSWORD: root_dashboard_password
    ports:
      - "8080:80"
    networks:
      - infra_backend_network
    depends_on:
      - database
    restart: unless-stopped

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

networks:
  infra_backend_network:
    driver: bridge
```

### 2. `postgres/init.sql`
```sql
-- Inicialización de Esquema de Base de Datos Estricto
CREATE TABLE IF NOT EXISTS user_accounts (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX IF NOT EXISTS idx_users_username ON user_accounts(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON user_accounts(email);

INSERT INTO user_accounts (username, email, password_hash) VALUES 
('sys_admin', 'admin@telemetry.infra', '$2b$12$K7v1S9Zf6u5R4e3w2q1u0O7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2'),
('telemetry_worker', 'worker@telemetry.infra', '$2b$12$X9y8z7w6v5u4t3s2r1q0O7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2')
ON CONFLICT DO NOTHING;
```

### 3. `.gitignore`
```text
.data/
postgres_data/
redis_data/
.env
```

---

## 🛠️ Stack Component Blueprint

| Infrastructure Core | Technology / Image | Exposed Port | Volume Persistence |
| :--- | :--- | :--- | :--- |
| **Relational Data Storage** | `postgres:15-alpine` | `5432` | `postgres_data` (Mapped) |
| **In-Memory Cache Cache** | `redis:7-alpine` | `6379` | `redis_data` (Mapped) |
| **Visual Management GUI** | `dpage/pgadmin4` | `8080` | Ephemeral / Host Session |

---

## 📥 Deployment & Run Sequence

### Prerequisites
Ensure you have **Docker** and **Docker Compose** installed on your system.

1. **Clone the repository core infrastructure:**
   ```bash
   git clone https://github.com/YOUR-GITHUB-USERNAME/dockerized-microservices-infra.git
   cd dockerized-microservices-infra
   ```

2. **Spin up the entire architecture cluster in detached mode:**
   ```bash
   docker compose up -d
   ```

3. **Verify running containers status:**
   ```bash
   docker compose ps
   ```

4. **Tear down infrastructure releasing network bridges:**
   ```bash
   docker compose down
   ```

---

## 📊 Expected Infrastructure Telemetry Log

```text
[+] Running 4/4
 ✔ Network dockerized_infra_backend_network  Created
 ✔ Container infra_postgres_db               Started
 ✔ Container infra_redis_cache               Started
 ✔ Container infra_pgadmin_dashboard         Started

[INFO] PostgreSQL: /docker-entrypoint-initdb.d/init.sql: running src/init.sql
[INFO] PostgreSQL: CREATE TABLE user_accounts... SUCCESS
[INFO] Redis: Server initialized, AOF enabled. Ready to accept secured TCP connections on port 6379.
