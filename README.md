# Ed-Fi ODS Data Warehouse Prototype

A CEDS-aligned star schema warehouse and demographics web application built on top of the Ed-Fi ODS v7 sandbox. Demonstrates the ODS-to-CEDS translation layer: extracting student, school, and enrollment data from the Ed-Fi operational data store and transforming it into analytical warehouse tables.

## What This Demonstrates

- **Star schema design** - enrollment fact table with student, school, grade, and date dimensions, plus bridge tables for multi-valued demographics (race, disability, language, tribal affiliation)
- **ODS-to-CEDS transformation** - SQL queries that navigate Ed-Fi entity relationships (associations, descriptors) and map them to CEDS-aligned warehouse structure
- **Analytical reporting** - demographic views with window functions computing per-school percentages across seven categories
- **End-to-end deployment** - Docker Compose, Terraform IaC, GitHub Actions CI/CD, Caddy auto-TLS

## Schema

```
warehouse.enrollment_fact    -- Fact table: one row per student-school enrollment
  |-- warehouse.dim_student  -- Student demographics and addresses
  |-- warehouse.dim_school   -- School, district, charter status, Title I
  |
  |-- warehouse.bridge_student_race       -- Multi-valued: student races
  |-- warehouse.bridge_student_language   -- Multi-valued: student languages
  |-- warehouse.bridge_student_disability -- Multi-valued: student disabilities
  |-- warehouse.bridge_student_tribal     -- Multi-valued: tribal affiliations
```

## SQL

| File | Purpose |
|------|---------|
| `sql/ddl.sql` | Warehouse schema creation (star schema + bridge tables) |
| `sql/seed.sql` | ODS-to-warehouse ETL: extracts from Ed-Fi ODS tables, maps descriptors to CEDS codes |
| `sql/view_demographics.sql` | Demographic reporting view with window functions for per-school percentages |

## Stack

- **App**: Next.js 16, React 19, Chart.js, Kysely (type-safe SQL), TypeScript
- **Runtime**: Bun
- **Database**: Ed-Fi ODS PostgreSQL (sandbox image from `edfialliance/ods-api-db-ods-sandbox`)
- **Infra**: Terraform (Hetzner VPS + Cloudflare DNS), Caddy (reverse proxy + auto-TLS)
- **CI/CD**: GitHub Actions -> GHCR; Watchtower auto-pulls on the server

## Quick Start

```bash
# Start the ODS database locally
docker compose up -d

# Run the Next.js dev server
bun dev
```

Dashboard connects to `localhost:5403` in dev. The Ed-Fi sandbox image takes ~60s to initialize on first boot.

## Deployment

Production uses a separate compose file with five services:

| Service | Purpose |
|---------|---------|
| `db-ods` | Ed-Fi ODS PostgreSQL sandbox |
| `db-init` | Applies DDL, seed, and views on startup |
| `dashboard` | Next.js demographics application |
| `caddy` | Reverse proxy with auto-TLS |
| `watchtower` | Auto-pulls new dashboard images from GHCR |

Infrastructure is provisioned via Terraform from `infra/`. See `infra/terraform.tfvars.example` for required variables.

## Context

Built as a prototype of the ODS-to-CEDS warehouse translation layer for education data systems. The star schema, bridge table pattern, and CEDS grade code mapping reflect real warehouse design decisions.
