# Ed-Fi Sandbox Sprint — Handoff

## Why This Exists

You are applying for **Data Warehouse Support Engineer** at the **NM Public Education Department** (PED #21499). The role revolves around Ed-Fi ODS support, and the JD mentions Ed-Fi 6+ times. Four domain expert agents (hiring manager, recruiter, social psychologist, I/O psychologist) unanimously identified the Ed-Fi gap as the #1 risk factor. The hiring manager's top recommendation: "Spend a weekend with the Ed-Fi sandbox. Even 'completed hands-on exploration of Ed-Fi ODS' could tip the scale."

### The Role in Brief
- Maintain/modernize student and teacher data warehouse (mission-critical)
- Support Ed-Fi Operational Data Store (open standard for K-12 education data)
- Re-engineer data collection, validation, and reporting from ~150 school districts (LEAs)
- Implement Ed-Fi APIs for data collection, define data elements and extensions
- Implement data validation engine
- Transfer and translate data into CEDS-compliant warehouse
- Ideal candidate: 1-2 yrs Ed-Fi, 4+ yrs MSSQL, 2+ yrs SSRS

### Your Existing Strengths (already on resume)
- Multi-source data consolidation pipeline (5+ sources, 40K+ records, schema validation)
- PostgreSQL views with CTEs and window functions
- REST API development for data collection
- Data validation engine with schema enforcement
- Federal agency operations at Leidos/CMS (10K+ users, compliance environment)
- MS SQL Server, Entity Framework, ITIL certified

### The Gap
Zero Ed-Fi experience. This sprint closes that gap truthfully.

---

## Setup Instructions

### Prerequisites
- Docker Desktop installed and running
- Git Bash or WSL (you're on Windows 11)
- A SQL client (DBeaver, pgAdmin, or `psql` via Docker exec)

### 1. Clone Ed-Fi ODS Docker

```bash
cd C:/Users/PCS/Documents/repos/ed-fi
git clone https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker.git ods-docker
cd ods-docker
```

### 2. Configure Environment

```bash
cp .env.example .env
```

Default `.env` values work for sandbox exploration:
- `TAG=7` (Ed-Fi ODS v7.x)
- `ADMIN_USER=admin@example.com`
- `ADMIN_PASSWORD=Admin1`
- `POSTGRES_USER=postgres`
- `POSTGRES_PASSWORD=P@ssw0rd`
- `LOGS_FOLDER=c:/tmp/logs`

### 3. Generate SSL Certificate

```bash
export MSYS_NO_PATHCONV=1
./generate-cert.sh
```

### 4. Start Sandbox

```bash
docker compose -f ./Compose/pgsql/compose-sandbox-env.yml --env-file ./.env up -d
```

### 5. Verify

- Swagger UI: `https://localhost/`
- Sandbox Admin: `https://localhost/admin`
- ODS API: `https://localhost/api`
- Admin API: `https://localhost/adminapi`

Accept the self-signed certificate warning in your browser.

---

## Exploration Checklist

Work through these in order. Save notes and SQL files in `../notes/`.

### Phase 1: API Exploration (30-60 min)
- [ ] Open Swagger UI, browse available resource endpoints
- [ ] Understand the resource categories: students, schools, staff, enrollments, grades, assessments
- [ ] Use Sandbox Admin to create an API key/secret pair
- [ ] Make GET requests to `/ed-fi/students`, `/ed-fi/schools`, `/ed-fi/studentSchoolAssociations`
- [ ] Try POST to create a student record (sandbox has sample data)
- [ ] Understand API authentication flow (OAuth2 client credentials)
- [ ] Note: Ed-Fi uses "associations" (e.g., studentSchoolAssociation) rather than foreign keys at the API level

### Phase 2: Database Exploration (60-90 min)
- [ ] Connect to the ODS PostgreSQL database
  ```bash
  # Find the postgres container name
  docker ps
  # Connect
  docker exec -it <postgres_container> psql -U postgres -d EdFi_Ods
  ```
  Or use DBeaver: `localhost:5432`, database `EdFi_Ods`, user `postgres`, password `P@ssw0rd`
- [ ] Explore the schema: `\dt edfi.*` to list tables in the edfi schema
- [ ] Key tables to examine:
  - `edfi.Student` — student demographic data
  - `edfi.School` — school entities
  - `edfi.LocalEducationAgency` — districts (the ~150 LEAs in PED's case)
  - `edfi.StudentSchoolAssociation` — enrollment records
  - `edfi.Staff`, `edfi.StaffEducationOrganizationAssignmentAssociation` — teacher data
  - `edfi.Descriptor` — Ed-Fi's extensible enumeration system
- [ ] Write SQL queries (save to `notes/queries/`):
  - Join students to their school enrollments
  - Aggregate student counts by school and district (LEA)
  - Explore descriptors: how grade levels, entry types, etc. are coded
  - Join staff to their education organization assignments
  - Look at how data validation works at the database level (constraints, check expressions)

### Phase 3: Architecture Understanding (30-45 min)
- [ ] Read about the Ed-Fi data flow:
  - Student Information Systems (SIS) at each district → Ed-Fi API → ODS database
  - ODS is the staging/operational layer; analytics/reporting happens downstream
  - CEDS is a separate standard; data must be translated from Ed-Fi ODS → CEDS warehouse
- [ ] Understand Ed-Fi concepts:
  - **Descriptors**: Ed-Fi's equivalent of lookup tables / enumerations (extensible per state)
  - **Extensions**: How states (like NM) add custom fields to the standard
  - **API Profiles**: Restricting which fields different API consumers can read/write
  - **Composites**: Read-only denormalized views for common query patterns
- [ ] Map to PED role: "The PED collects data from ~150 districts via Ed-Fi API, stores in ODS, then transfers and translates into a CEDS-compliant warehouse. You would maintain this pipeline."

### Phase 4: PED-Specific Context (20-30 min)
- [ ] New Mexico is an Ed-Fi state — they use Ed-Fi for state longitudinal data
- [ ] CEDS (Common Education Data Standards) is the federal reporting standard
- [ ] The role bridges Ed-Fi (collection) → CEDS (reporting/compliance)
- [ ] FERPA governs student data privacy — relevant to security requirements in the JD
- [ ] Ed-Fi Alliance governance: community-driven, open source, states + vendors + districts

---

## Key Documentation Links

- Ed-Fi Tech Docs: https://techdocs.ed-fi.org/
- Ed-Fi Data Standard: https://techdocs.ed-fi.org/reference/data-exchange/data-standard/
- Ed-Fi ODS/API: https://techdocs.ed-fi.org/reference/ods-api/
- Ed-Fi Docker Deployment: https://docs.ed-fi.org/reference/docker/
- CEDS Overview: https://ceds.ed.gov/
- Ed-Fi GitHub: https://github.com/Ed-Fi-Alliance-OSS

---

## After the Sprint: Resume Update

Once you've completed the exploration, draft resume language in `notes/resume-update.md`. Guidelines:

**What you can truthfully claim:**
- Hands-on exploration of Ed-Fi ODS including API endpoints, data model, and database schema
- SQL queries against Ed-Fi ODS (student, school, enrollment, staff data)
- Understanding of Ed-Fi data flow: SIS → API → ODS → downstream warehouse
- Familiarity with Ed-Fi concepts: descriptors, extensions, associations, API profiles

**Where to add on resume:**
- Skills "Data & Integration" line: add "Ed-Fi ODS"
- Summary: weave in "Ed-Fi" alongside existing data standard language
- Possible new bullet or enhancement to existing project bullets

**What NOT to claim:**
- Production Ed-Fi experience
- Ed-Fi implementation or deployment experience
- Any specific years of Ed-Fi experience
- CEDS implementation (unless you also explore CEDS tooling)

**Style guide reminder:** Don't rename things to match the JD. Don't fabricate intent. Be specific about YOUR work. Metrics always earn their space.

---

## Teardown

When done:

```bash
cd C:/Users/PCS/Documents/repos/ed-fi/ods-docker
docker compose -f ./Compose/pgsql/compose-sandbox-env.yml --env-file ./.env down -v
```

The `-v` flag removes persistent volumes (database data). Omit it if you want to come back later.
