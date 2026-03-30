# New Mexico PED Ed-Fi Research

*Research date: 2026-03-27*

## 1. Does NM PED Currently Use Ed-Fi? What Version?

**Yes.** Ed-Fi has been established as the NM PED data standard. Key facts:

- RESPEC-EASOL was contracted to develop the **Ed-Fi Real-Time Data Project** and establish Ed-Fi as the NM PED data standard
- Every SIS must comply with the Ed-Fi data standard to interface with the statewide ODS
- NM PED is listed as an **implementation verification site** for **Edufied** (Ed-Fi Managed Service Provider)
- Verified Ed-Fi versions: **Ed-Fi ODS/API Suite 3 v5.3** and **v7.0**
- CPSI (another vendor) has worked with Ed-Fi since 2012; their first state Ed-Fi ODS project design was recognized by the Ed-Fi Alliance as a reference implementation
- The Ed-Fi ODS uses either **Microsoft SQL Server or PostgreSQL** as the database platform, with the API written in C#

## 2. What Data Do They Collect from Districts via Ed-Fi?

NM PED collects data from **nearly 200 school districts and charter schools**. Data domains include:

- **Student demographics and enrollment** (student tracking, longitudinal data)
- **Staff data** (educator information)
- **Attendance** (trends and early warning indicators)
- **Assessment data** (from multiple assessment vendors)
- **Special education** data
- **Financial/budget** data
- **Graduation readiness** patterns
- **Early childhood** data (via ECIDS - Early Childhood Integrated Data System)

Data collection historically happened via **4 snapshots per year** through the STARS system. The new NOVA system and Ed-Fi integration aim for **real-time or near-real-time** data collection.

## 3. Public Documentation About Their Ed-Fi Implementation

### Key Systems (Historical to Current)

**STARS (Student Teacher Accountability Reporting System)** - Legacy system
- Traditional batch-based data collection
- 4 snapshots per year
- Being replaced/supplemented

**Project Nova** - Current operational system
- Launched to replace/modernize STARS
- Collects data directly from each LEA's Student Information System
- Includes automated data checks that flag issues before data is sent from LEA to SEA
- Additional validation checks after data arrives at SEA
- Resources: https://web.ped.nm.gov/bureaus/information-technology/nova/

**RESPEC-EASOL Ed-Fi Real-Time Data System**
- Contracted to connect all districts and charters to Ed-Fi at NM PED
- Converting and integrating legacy systems into the NM EASOL/Ed-Fi ecosystem
- Creating real-time data dashboards for local administrators and educators
- Building interagency data links (early childhood to K-12 to educator preparation)
- Source: https://www.respec.com/project/ed-fi-real-time-data-system/

**CPSI Data Management System** (awarded November 2019)
- Eight specialized tools:
  - **xDStore**: Data collection and operational data store
  - **xDStore CEDS/Generate**: REST-based ODS for CEDS/Generate compliance
  - **xDValidator**: Data validation and error reporting
  - **xDUID**: Unique identifier generation and management (assigns/validates IDs within 5 minutes)
  - **xDComposer**: Data mapping and format conversion
  - **xdAD**: Identity and Active Directory administration
  - **OneUser SSO**: Single sign-on with privacy controls
  - **xDZIS/xDBroker**: Data routing and APIs
- Source: https://blog.cpsiltd.com/cpsi-is-awarded-the-contract-for-new-mexicos-new-public-education-data-management-system/

### SLDS Grant (2023)
- Federal grant title: "Leveraging a State-of-the-Art Statewide Longitudinal Data System to Improve Education and Workforce Outcomes in New Mexico"
- Source: https://nces.ed.gov/programs/slds/pdf/2023NMabstract.pdf

## 4. How They Handle the Ed-Fi to CEDS Pipeline

- CPSI's **xDStore CEDS/Generate** provides a REST-based ODS specifically for CEDS/Generate compliance
- A **CEDS-aligned data warehouse** is being created to collect, integrate, and prepare data for reporting and analysis
- CPSI's approach integrates **SIF, CEDS, and Ed-Fi** standards into a single operational data store
- The CEDS data warehouse links to legacy and auxiliary systems
- Facilitates interoperability with **RISE NM P-20W SLDS** (the multi-agency longitudinal system)
- P-20W integrates data from 4 state agencies:
  - Early Childhood Education and Care Department (ECECD)
  - Public Education Department (PED)
  - Higher Education Department (HED)
  - Department of Workforce Solutions (DWS)

## 5. Known Challenges and Initiatives

### Challenges
- **Piecemeal legacy systems**: Decades of isolated systems that do not communicate with one another and lack a single data standard
- **Data governance gap**: No formal data governance council exists; districts recommended the Legislature create one
- **SIS fragmentation**: Previously 7+ disparate SIS systems across districts; small SIS vendors may struggle to maintain Ed-Fi compliance
- **Administrative burden**: Districts have faced high data collection burden; PED is working to streamline to only necessary data
- **Data quality**: Incorrect data in Ed-Fi ODS can proliferate across all interconnected systems
- **Snapshot-based limitations**: Legacy STARS system only collected data 4x/year; transition to real-time is ongoing

### Current Initiatives
- **Synergy statewide SIS rollout** (announced Feb 2026): First statewide SIS, rolling out summer 2026 with initial cohort, phased expansion after
- **NOVA system**: Operational replacement for STARS with better validation
- **Ed-Fi real-time data**: Moving from batch snapshots to real-time data collection
- **P-20W SLDS**: Cross-agency longitudinal data system (early childhood through workforce)
- **ECIDS**: Early Childhood Integrated Data System (eScholar selected as vendor)

## 6. Common Student Information Systems in NM Districts

- **Synergy (Edupoint)**: Selected as the **statewide SIS** in February 2026; will eventually serve all participating LEAs. Initial rollout summer 2026. Features include attendance tracking, early warning indicators, graduation readiness, special education support, analytics.
- **PowerSchool**: Used by some districts and charter schools (e.g., Pecos Cyber Academy). Has NM-specific compliance documentation.
- **Various smaller SIS vendors**: Some districts use smaller vendors, but they are required to maintain Ed-Fi compliance or districts must switch to a compliant vendor.

## Key Personnel

- **Johnathon Garcia**: Senior Data Warehouse Support Engineer at NM PED (the role the candidate is applying for has a similar title)

## Relevance to PED #21499 (Data Warehouse Support Engineer)

The job posting is within the **IT Bureau** that manages NOVA and legacy STARS systems. Based on research, the role likely involves:
- Supporting the Ed-Fi ODS (Suite 3, versions 5.3/7.0)
- Working with the CEDS data warehouse and CPSI tools (xDStore, xDValidator, etc.)
- Data validation and quality assurance across ~200 districts
- Supporting the transition from STARS to NOVA/Ed-Fi real-time data
- Working with PostgreSQL or SQL Server databases
- Potentially supporting the Synergy SIS rollout and Ed-Fi compliance
- Supporting federal reporting via CEDS/Generate

## Sources

- [RESPEC Ed-Fi Real Time Data System](https://www.respec.com/project/ed-fi-real-time-data-system/)
- [CPSI NM PED Contract](https://blog.cpsiltd.com/cpsi-is-awarded-the-contract-for-new-mexicos-new-public-education-data-management-system/)
- [CPSI Ed-Fi ODS Data Model](https://blog.cpsiltd.com/the-new-edfi-ods-data-model-and-cpsi/)
- [NM PED NOVA System](https://web.ped.nm.gov/bureaus/information-technology/nova/)
- [NM PED STARS Overview](https://web.ped.nm.gov/bureaus/information-technology/stars/)
- [NM PED IT Staff](https://web.ped.nm.gov/bureaus/information-technology/information-technology-staff/)
- [LESC Brief: Update on STARS and Project Nova (June 2023)](https://www.nmlegis.gov/handouts/ALESC%20062823%20Item%205%205.1%20-%20LESC%20Brief;%20Update%20on%20STARS%20and%20Project%20Nova.pdf)
- [Synergy Statewide SIS Announcement](https://www.send2press.com/wire/new-mexico-public-education-department-selects-synergy-education-platform-by-edupoint-as-statewide-student-information-system/)
- [Edufied Ed-Fi Partner (NM PED verification)](https://www.ed-fi.org/technology-partners/edufied/)
- [NM PED Admin Burdens Report](https://www.governor.state.nm.us/wp-content/uploads/2022/09/NMPED-Admin-Burdens-Report.pdf)
- [LearningMate: NM Longitudinal Data System](https://learningmate.com/new-mexico-establishes-data-system/)
- [SLDS 2023 Grant Abstract](https://nces.ed.gov/programs/slds/pdf/2023NMabstract.pdf)
- [NM PED Data Transparency Platforms](https://web.ped.nm.gov/wp-content/uploads/2025/01/6-PED-Data-Transparancy-Platforms.pdf)
