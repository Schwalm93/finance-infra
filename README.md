# homelab-infra

Deployment repository for GoFinance in a home network.

This stack is designed for Portainer Stack deployment (GitOps-like):
- app code lives in `app-backend` and `app-frontend`
- this repo only deploys versioned container images

## Files
- `docker-compose.yml`: deploy stack with Traefik, Postgres, backend, frontend, optional pgweb
- `.env.example`: required environment variables
- `db/`: Postgres image build context with schema bootstrap SQL

## Prerequisites
- Docker host in your LAN
- Portainer connected to this git repo
- Reachable container registry (for example `registry.example.lan`)

## Setup
1. Copy `.env.example` to `.env`.
2. Set `BACKEND_IMAGE` and `FRONTEND_IMAGE` to existing tags from your Forgejo pipelines.
3. Adjust database and ports if needed.
4. Deploy the stack via Portainer (`docker-compose.yml` + `.env`).

## Local Validation
From this folder:

```bash
docker-compose --env-file .env.example -f docker-compose.yml config
```

## Notes
- Routing is host-agnostic (`PathPrefix`) so access via `http://<server-ip>` works in LAN.
- Database schema is initialized from `db/init.sql` via `/docker-entrypoint-initdb.d` when the Postgres volume is empty.
- If you change `db/init.sql` after first startup, recreate the DB volume to apply bootstrap changes.
- `pgweb` is optional and only starts with profile `tools`:

```bash
docker-compose --profile tools up -d
```

- Traefik dashboard is intentionally insecure by default for homelab usage.
  Set `TRAEFIK_DASHBOARD_INSECURE=false` for stricter setups.
