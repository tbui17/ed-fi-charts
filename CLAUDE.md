# Ed-Fi Demographics Dashboard

## Architecture

Next.js dashboard backed by an Ed-Fi ODS PostgreSQL database. Queries Ed-Fi sandbox data to render student demographic charts per school.

### Stack
- **App**: Next.js 16, React 19, Chart.js, Kysely (query builder), TypeScript
- **Runtime**: Bun (build + server)
- **Database**: Ed-Fi ODS PostgreSQL (sandbox image from `edfialliance/ods-api-db-ods-sandbox`)
- **Infra**: Terraform (Hetzner VPS + Cloudflare DNS), Caddy (reverse proxy + auto-TLS)
- **CI/CD**: GitHub Actions builds and pushes to GHCR; Watchtower auto-pulls on the server

### Key Directories
- `app/` — Next.js app router (pages, components, db layer)
- `sql/` — DDL, seed data, and views applied by `db-init` container at deploy time
- `infra/` — Terraform configs (server, DNS, variables, outputs)
- `infra/scripts/` — Server bootstrap script (Docker install, GHCR login, compose up)

### Compose Files
- `docker-compose.yml` — Dev: runs only `db-ods` on `localhost:5403`
- `docker-compose.prod.yml` — Prod: `db-ods`, `db-init`, `dashboard`, `caddy`, `watchtower`

### Deployment Flow
1. Push to `main` triggers GitHub Actions workflow (path-filtered to app code changes)
2. Workflow builds Docker image and pushes to `ghcr.io/tbui17/ed-fi-charts:latest`
3. Watchtower on the server polls GHCR every 5 minutes and pulls new images
4. Caddy handles TLS via Let's Encrypt ACME

### Infrastructure Provisioning
- `terraform apply` from `infra/` provisions: Hetzner VPS, Cloudflare A record, SSH key, firewall
- Server bootstraps via provisioners: uploads compose + SQL + Caddyfile, writes `.env`, runs `setup.sh`
- Secrets live in `infra/secrets.auto.tfvars` (gitignored). See `infra/terraform.tfvars.example` for schema.
- State is local (no remote backend)

## Development

```bash
# Start the ODS database locally
docker compose up -d

# Run the Next.js dev server
bun dev
```

Dashboard connects to `localhost:5403` in dev. The Ed-Fi sandbox image takes ~60s to initialize template databases on first boot.
