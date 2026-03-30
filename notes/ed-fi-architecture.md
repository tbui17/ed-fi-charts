# Ed-Fi Architecture & Design Philosophy

## The Ed-Fi Ecosystem

Ed-Fi is not just a database schema — it's a full ecosystem: a data standard (the Unifying Data Model), a REST API specification, and reference implementations (ODS, API, admin tools). Most education data standards before Ed-Fi were flat-file batch submissions. Ed-Fi's big differentiator is that it's API-first and real-time.

## The Data Flow (NM PED Context)

```
~200 NM Districts (each running a SIS like Synergy/PowerSchool)
    ↓ Ed-Fi API (real-time, REST)
NM PED's Ed-Fi ODS (operational staging layer)
    ↓ ETL/translation
CEDS-compliant Data Warehouse (federal reporting)
    ↓
RISE NM P-20W SLDS (cross-agency: Early Childhood, K-12, Higher Ed, Workforce)
```

## The Unifying Data Model (UDM)

Enterprise data model of commonly exchanged K-12 education data, expressed as UML class diagrams. 17+ domains:

1. Alternative and Supplemental Services
2. Assessment
3. Bell Schedule
4. Discipline
5. Education Organization (hierarchy: SEAs, LEAs, schools)
6. Educator Preparation
7. Enrollment
8. Finance
9. Graduation
10. Intervention
11. School Calendar
12. Staff
13. Student Academic Record
14. Student Attendance
15. Student Cohort
16. Student Identification and Demographics
17. Survey
18. Teaching and Learning

Three building blocks: **Entities** (Student, School), **Attributes** (birth date, score), **Associations** (relationship entities with their own attributes).

The model is student-centric — captures granular, discrete data about individual students rather than aggregated statistics.

## The Association Pattern

Ed-Fi doesn't put a `school_id` FK on a Student table. Instead, there's a separate `StudentSchoolAssociation` entity with its own attributes (entry date, grade level, entry type, exit date).

Why:
- **Relationships carry data.** An enrollment has dates, grade levels, exit reasons.
- **Many-to-many.** A student can be in multiple schools (dual enrollment, transfers).
- **Temporal modeling.** Separate entity with date fields tracks full history.
- **Natural keys.** Association key = natural keys of both entities + discriminating attributes.

Naming: `[Entity1][Entity2]Association` — with semantic discriminators when multiple relationship types exist (e.g., Staff Employment vs. Assignment).

## Natural Keys (Not Surrogate Keys)

Ed-Fi uses natural keys (business-meaningful attributes) as the primary identity mechanism. A Course Offering is identified by Local Course Code + School + Session, not an arbitrary integer ID. This has real implications for query complexity and is one reason the DMS replacement is being built.

## The Descriptor System

Descriptors are Ed-Fi's extensible enumeration system — namespaced enums.

Format: `uri://[namespace]/[DescriptorName]#[value]`
- Ed-Fi default: `uri://ed-fi.org/AcademicSubjectDescriptor#Mathematics`
- State custom: `uri://nm-ped.org/AcademicSubjectDescriptor#Bilingual Education`
- District custom: `uri://grandbendsd.edu/AcademicSubjectDescriptor#Linear Algebra II`

The namespace identifies who governs the value. States take a tiered approach:
- Use existing state code values when possible
- Create new values in a state-controlled namespace
- The `ed-fi.org` defaults exist as a fallback but are discouraged for operational use

Descriptors are REST resources with full CRUD. Best practice: all clients get read access; POST access tightly controlled.

## Extensions

How states add data elements beyond the core model. Three types:
1. New entities
2. Extensions to existing entities (adding attributes)
3. Subclassing existing entities

In the API, extensions appear in an `_ext` object:
```json
{
  "studentUniqueId": "123",
  "firstName": "Jane",
  "_ext": {
    "nm_ped": {
      "bilingualProgram": "Dual Language",
      "tribalAffiliation": "Navajo Nation"
    }
  }
}
```

Across states, the median is 16 extensions with ~37% of the API surface being non-core. Texas is extreme (20 new entities, 491 attributes).

The **MetaEd IDE** is a free Alliance tool for authoring extensions using a domain-specific language.

## Ed-Fi API Design

- **Upsert by default.** POST with matching natural keys does UPDATE, not 409 Conflict. Simplifies client code — senders don't check existence first.
- **Model-driven API surface.** Each UDM entity/association = REST resource. URL: `/ed-fi/{resourceName}`.
- **OAuth 2.0 client credentials** for authentication.
- **Query via GET** with `?propertyName=value` filtering, paging, ordering. ETags for optimistic concurrency.
- **Extensions in `_ext` object** — cleanly separates core from custom data.

## ODS vs. Data Warehouse

**ODS (Operational Data Store):**
- Collection point for near-real-time data from districts
- Receives data via Ed-Fi API
- Runs Level 2 (business rule) data validation
- Provides immediate error feedback to source systems
- Normalized, not optimized for analytics
- "The ODS is only an appliance of the API"

**Data Warehouse / SLDS:**
- Purpose-built for analytics, reporting, longitudinal analysis
- Populated from ODS but organized differently (star schemas, denormalized)
- Generates datamarts for state/federal reporting (EDFacts)

**Anti-pattern:** Building dashboards directly on the ODS.

## Ed-Fi vs. CEDS

- **Ed-Fi** = collection standard (how data comes in from districts). Operational. K-12 focused. Comes with technology suite.
- **CEDS** = reporting standard (how data goes out to federal agencies). Reference standard. P-20W scope. Defines terms but no implementation tech.

"CEDS answers 'what should we call things?' Ed-Fi answers 'how do we actually move the data and store it?'"

With every major Ed-Fi release, the Alliance reviews CEDS for alignment.

## Ed-Fi Alliance Governance

- **Michael & Susan Dell Foundation initiative** — not a vendor, not government
- Advisory Council (SEAs/LEAs), Governance Advisory Team, expert panel, community workgroups
- All changes documented in Ed-Fi Tracker, public RFCs before finalization
- Over 250 software vendors, 32 SEAs, nearly 12,000 school districts
- Open-source, free membership and licensing

## The DMS Is Coming

The Ed-Fi Alliance is building a **Data Management Service (DMS)** to replace the ODS/API by school year 2029-2030. Introduces streaming events (Kafka), addresses wide composite key pain points. Current ODS/API supported through 2028-2029.
