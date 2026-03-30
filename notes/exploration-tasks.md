# Ed-Fi Sandbox Exploration Tasks

## Setup

* \[x] **Set up environment and start sandbox**
Copy .env.example to .env, run generate-cert.sh (with MSYS\_NO\_PATHCONV=1), docker compose up the sandbox. Verify services at https://localhost/.

  * Straightforward, no comment.

## API Exploration (Ed-Fi Concepts)

* \[x] **Explore API authentication flow**
Use Sandbox Admin to create an API key/secret. Walk through the OAuth2 client credentials flow — get a token, use it in a request. Understand how districts authenticate to push data.

  * Went through OAuth flow, got access token with sample admin credentials. No comment.
* \[x] **Explore the Association pattern via API**
Hit /ed-fi/students, /ed-fi/schools, /ed-fi/studentSchoolAssociations. See how associations link entities with their own attributes (entry date, grade level). Try /ed-fi/staffEducationOrganizationAssignmentAssociations too. Note the natural key structure in responses.

  * Entities are linked via XYAssociations. If you wanted to know what additional info you could get on an entity, you'd find all the association tables that link it to some other table. Then you'd get info from that other table.
* \[x] **Explore the Descriptor system via API**
Hit descriptor endpoints (e.g., /ed-fi/gradeLevelDescriptors, /ed-fi/entryTypeDescriptors). Examine the URI namespace pattern. See how descriptors are referenced in other resources. Understand how NM would add state-specific values.

  * Descriptors contain metadata and you can get an ID linked to that descriptor in a main Descriptor table.
* \[x] **Test the upsert-by-default behavior**
POST a new student or association, then POST again with the same natural keys but changed attributes. Confirm the second POST returns 200 (update) not 409 (conflict). This is a key Ed-Fi API design choice.

  * Straightforward. No comment.

## Database Exploration (Same Concepts, SQL Lens)

* \[x] **Explore the ODS database schema**
Connect to PostgreSQL (docker exec or expose port via override). List tables in the edfi schema. Examine how associations, descriptors, and natural keys are implemented at the database level. Look at constraints and how they enforce data quality.

  * Other than typical PK / FK constraints, we see natural key constraints like `CONSTRAINT descriptor\_ak UNIQUE (namespace, codevalue)` which uses namespace plus the code value for uniqueness. Associatiosn and descriptors otherwise look similar to what we see from the API.
* \[x] **Write SQL queries against key Ed-Fi tables**
Save queries to notes/queries/: (1) Join students to enrollments via StudentSchoolAssociation, (2) Aggregate student counts by school and LEA, (3) Explore descriptors and how they're joined, (4) Staff assignments. Focus on understanding the Ed-Fi schema, not SQL technique.

  * See notes file

## Synthesis (Most Interview-Relevant)

* \[x] **Map ODS schema to warehouse needs**
Look at the ODS normalized structure and think about what the ETL to a CEDS warehouse would involve. What denormalization is needed? What descriptor translations? This is the core of the PED role. Write observations to notes/.

  * We can discuss this in terms of students and schools.
  *
  * Normally this might require a large number of joins between student, school, studentschoolassociation, educationorganization (twice) to get all the relevant details.
  *
  * This would be changed into people, role, and organization. We would need to map students to people, then the school and educationorganization into an organization. studentschoolassociation would be a role.
  * Afterwards, we might create star schema tables around aggregates - student enrollments for example. The fact table would contain student enrollments, and accompanying dim tables would contain student details and school details.
  *
  * Example warehouse enrollment fact table:
    * `enrollment_fact` with keys into: `dim_student` (flattened demographics), `dim_school` (name, type, district — flattened from school + educationorganization x2), `dim_grade_level` (edfi code, ceds code, grade number, grade band), `dim_date`, `dim_entry_type`, `dim_exit_type`, plus measures like FTE and is_primary_school.
    * The dimension tables are where Ed-Fi descriptor → CEDS code translation lives. The grade_level_dimension table we built is literally a piece of this warehouse.
  *
  * Three hard parts of ODS → CEDS:
    1. **Denormalization** — collapsing the education org inheritance hierarchy, flattening associations into single rows
    2. **Descriptor mapping** — every Ed-Fi descriptor URI needs a CEDS equivalent. State-specific descriptors (e.g., `uri://nm-ped.org/...`) may not have a direct CEDS mapping and need governance decisions.
    3. **Incremental loads** — using the `changeversion` column on ODS tables to pull only what changed since the last ETL run, rather than full table scans.
* \[x] **Fill out resume-update.md**
After completing exploration, fill in notes/resume-update.md with: what you did, skills line addition, summary language, bullet candidates, and interview talking points based on actual hands-on experience.

