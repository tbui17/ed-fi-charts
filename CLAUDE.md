# Ed-Fi ODS Sandbox Exploration

## Purpose
Hands-on exploration of the Ed-Fi Operational Data Store to build real familiarity with the Ed-Fi data standard, API, and data model. This supports a job application for a Data Warehouse Support Engineer role at the NM Public Education Department (PED #21499).

## Context
- The target role centers on Ed-Fi ODS support, data collection from ~150 school districts, and CEDS-compliant data warehousing
- The candidate has strong SQL, REST API, data pipeline, and data validation experience but zero prior Ed-Fi exposure
- Goal: enough hands-on experience to truthfully add Ed-Fi to the resume and defend it in an interview

## Current Progress
- Ed-Fi ODS sandbox running via Docker (PostgreSQL backend)
- API authentication working (OAuth2 client credentials, token caching)
- Typed API client generated from Ed-Fi Swagger spec (`ed-fi-api.ts`, 2MB+)
- Working TypeScript code querying students, schools, and associations via Ed-Fi API
- Deep research completed: Ed-Fi architecture, NM PED context, CPSI tooling, NOVA/STARS transition
- Interview talking points drafted with experience-bridging table

## Remaining Work
1. Database exploration: connect to ODS PostgreSQL, explore schema, write SQL queries
2. ODS→CEDS synthesis: map Ed-Fi normalized schema to warehouse/reporting needs
3. Fill out `notes/resume-update.md` with truthful claims based on actual work done
4. Consider: build a small Ed-Fi→CEDS translation pipeline as a resume-worthy project

## Stack
- Runtime: Bun/TypeScript
- API client: axios + generated typed client from Swagger spec
- Utilities: remeda
- Docker Desktop (Ed-Fi ODS containers)
- PostgreSQL (ODS backend)

## Key Files
- `index.ts` — Ed-Fi API exploration script (students, schools, associations)
- `ed-fi-api.ts` — Generated typed API client from Swagger spec
- `notes/ed-fi-architecture.md` — Ed-Fi concepts, data model, ODS vs warehouse
- `notes/nm-ped-edfi-research.md` — NM PED systems, vendors, challenges, initiatives
- `notes/interview-talking-points.md` — Ranked talking points + experience bridge table
- `notes/exploration-tasks.md` — Checklist of exploration tasks
- `HANDOFF.md` — Original handoff context from job-search repo

## Rules
- Never fabricate Ed-Fi experience claims beyond what was actually done
- Style guide from job-search repo applies to any resume language drafted here
