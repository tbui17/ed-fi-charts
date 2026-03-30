# Interview Talking Points (Ranked by Impact)

1. **"Ed-Fi bridges collection and CEDS bridges reporting — the role sits at the translation layer"**
   Shows you understand the architecture end-to-end.

2. **"Associations are first-class entities because in education, relationships carry data"**
   Shows you get the design philosophy, not just the schema.

3. **"Descriptors use namespaced URIs so NM can extend the vocabulary without breaking the standard"**
   Shows you understand how states customize Ed-Fi.

4. **"The ODS is operational, not analytical — analytics belong in the downstream warehouse"**
   Shows architectural maturity and awareness of a common anti-pattern.

5. **"The DMS migration is coming by 2029-2030, replacing the current ODS/API"**
   Shows you've done homework on the roadmap. If hired, you'd likely be involved.

6. **"NM is transitioning from STARS batch collection to real-time via Ed-Fi and Project Nova"**
   Shows you understand their specific context and current challenges.

7. **"Synergy was just selected as the statewide SIS — rolling out summer 2026"**
   Shows you're current on NM education IT. This directly affects the role.

## Bridging Your Experience to Ed-Fi

| Your Experience | Ed-Fi Parallel |
|---|---|
| Multi-source data consolidation (5+ sources, 40K records) | PED collects from ~200 districts via Ed-Fi API |
| Schema validation engine | Ed-Fi descriptors + xDValidator for data quality |
| PostgreSQL views with CTEs and window functions | ODS queries, warehouse reporting |
| REST API development | Ed-Fi is API-first; upsert-by-default pattern |
| Federal compliance at Leidos/CMS | FERPA, CEDS federal reporting |
| MS SQL Server + Entity Framework | ODS supports both PostgreSQL and SQL Server |

## Questions to Ask Them

- "Are you currently on Suite 3 v5.3 or v7.0, and is there a migration timeline for the DMS?"
- "How many NM-specific extensions are in your Ed-Fi implementation?"
- "What does the STARS-to-NOVA transition timeline look like — are all districts on NOVA yet?"
- "How is the Synergy rollout affecting your data collection pipeline?"
- "What's your current stack for the CEDS warehouse — is it the CPSI xDStore tooling?"
