# Resume Update — Post Ed-Fi Sprint

## What I Did
- Stood up Ed-Fi ODS v7 sandbox via Docker (PostgreSQL backend)
- Implemented OAuth2 client credentials auth flow with token caching
- Generated typed TypeScript API client from Ed-Fi Swagger spec (2MB+ type definitions)
- Built scripts querying Ed-Fi API: students, schools, staff, enrollment associations
- Explored Ed-Fi concepts hands-on: association pattern, descriptor system, upsert-by-default, natural keys, extensions
- Researched NM PED's specific Ed-Fi implementation: NOVA, STARS legacy, CPSI tooling, Synergy SIS rollout, P-20W SLDS

**DB exploration (completed):**
- [x] SQL queries against ODS PostgreSQL (student-enrollment joins, LEA aggregations, descriptor lookups)
- [x] ODS→CEDS mapping observations
- Wrote multi-join queries across student, school, studentschoolassociation, educationorganization (table inheritance), and descriptor tables
- Built a grade_level_dimension table mapping Ed-Fi descriptors to sortable grade numbers and grade bands — prototype of a warehouse dimension table
- Explored DDLs, constraints, FK enforcement on descriptors, change tracking triggers (changeversion for incremental ETL)
- Mapped ODS → CEDS warehouse structure: denormalization, descriptor-to-CEDS code translation, star schema with enrollment fact table and student/school/grade dimensions

## Skills Line Addition
Add "Ed-Fi ODS" to Data & Integration line:
```
"ANSI SQL, Ed-Fi ODS, data consolidation, REST API development, data validation, ETL pipelines, schema design, ..."
```

## Summary Language
Option A (weave into existing):
> ...across *MS SQL Server*, *Ed-Fi ODS*, PostgreSQL, and Neo4j.

Option B (replace Neo4j, more focused):
> ...across *MS SQL Server*, PostgreSQL, and *Ed-Fi ODS*.

Recommendation: Option B if space is tight. Neo4j is less relevant to this role than Ed-Fi.

## Bullet Candidates

**If this stays exploration-only (no project):**
Not bullet-worthy on its own. Skills line + summary mention is sufficient. The interview talking points carry the weight.

**If expanded into a project (Ed-Fi → CEDS pipeline):**
> Built *Ed-Fi ODS* data extraction pipeline using typed TypeScript client against *REST API*, querying student, school, and enrollment data across *Ed-Fi* association model

> Explored *Ed-Fi ODS* schema and API, implementing OAuth2 auth flow and typed client generation from OpenAPI spec for student/school/enrollment data queries

Pick one. Second is more honest about scope if it's exploration + scripting rather than a full pipeline.

## Interview Talking Points
See `interview-talking-points.md` — already drafted with ranked points and experience bridge table.

Key additions from hands-on work:
- "I stood up the Ed-Fi ODS sandbox and wrote TypeScript scripts against the API — the association pattern and descriptor system make a lot of sense for how district data needs to be normalized"
- "I looked at NM PED's specific implementation — you're on Suite 3, transitioning from STARS to NOVA, with CPSI handling the CEDS warehouse layer"
- "The upsert-by-default pattern is clever — districts don't need to check existence before pushing data, which simplifies the ~200 district integration"
