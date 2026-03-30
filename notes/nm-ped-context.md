# NM PED Ed-Fi Context

## Current State

- NM PED is a verified Ed-Fi implementation site (ODS/API Suite 3 v5.3 and v7.0, via Edufied MSP)
- Data collected from **~200 districts and charter schools**
- Data: student demographics/enrollment, staff, attendance, assessments, special education, financial data, graduation readiness, early childhood

## Key Systems

- **STARS** (legacy) — batch-based, 4 snapshots/year, being phased out
- **NOVA** — operational replacement with automated data validation checks
- **RESPEC-EASOL Ed-Fi Real-Time Data System** — connecting all districts to Ed-Fi, building real-time dashboards
- **CPSI Data Management System** (awarded 2019):
  - xDStore (ODS)
  - xDValidator (data validation)
  - xDUID (unique student IDs)
  - xDStore CEDS/Generate (federal reporting)

## Ed-Fi to CEDS Pipeline

CPSI's xDStore CEDS/Generate provides a REST-based ODS for CEDS/Generate compliance. A CEDS-aligned data warehouse integrates with the **RISE NM P-20W SLDS**, connecting 4 agencies:
- Early Childhood (ECECD)
- K-12 (PED)
- Higher Ed (HED)
- Workforce (DWS)

## Known Challenges

- Decades of piecemeal, non-communicating legacy systems
- No formal data governance council (districts want one legislatively created)
- SIS fragmentation (7+ disparate systems); small vendors struggle with Ed-Fi compliance
- Data quality issues that propagate across interconnected systems
- Transition from batch (4x/year) to real-time collection is ongoing

## Statewide SIS

**Synergy (Edupoint)** selected as the first statewide SIS in February 2026, rolling out summer 2026. This is a massive change — will reduce SIS fragmentation and simplify Ed-Fi compliance.

## Relevance to PED #21499

The Data Warehouse Support Engineer role sits in the IT Bureau managing NOVA and STARS. Likely involves:
- Supporting the Ed-Fi ODS (Suite 3)
- CEDS data warehouse (CPSI tools)
- Data validation across ~200 districts
- STARS-to-NOVA transition
- PostgreSQL/SQL Server databases
- Upcoming Synergy SIS rollout
