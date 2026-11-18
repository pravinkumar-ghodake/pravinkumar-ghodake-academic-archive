# Manifest — Academic & Intellectual Knowledge Base

**Project:** Pravinkumar Ramchandra Ghodake — Academic & Intellectual Knowledge Base

**Canonical database:** `profile.sqlite`

**Database format:** SQLite

**Canonical database schema:** Version 1.1

**Manifest last updated:** 2026-11-18

---

## 1. Purpose

This manifest documents the files, datasets, source records, provenance and integration status of the consolidated academic and intellectual knowledge base.

The project maintains one canonical database on GitHub.

Information from multiple independently maintained datasets and source collections is progressively incorporated into this database.

Original database files are retained by the profile owner as local backups. Imported source records and their provenance are maintained inside the canonical database.

Repository documentation, including the README and research keyword index, describes the scope, organization and maintenance of the knowledge base. These documentation files do not automatically constitute additional imported database datasets.

This manifest is updated whenever a source is added, an import is completed, or a significant database structure or documentation change is made.

---

## 2. Current repository files

| File or directory | Purpose | Current status |
|---|---|---|
| `README.md` | Project overview, identity, research and intellectual scope, and data stewardship | Present; updated |
| `ORCID_KEYWORDS.md` | Categorized research keyword and academic indexing document | Present; documentation resource |
| `profile.sqlite` | Consolidated canonical database | Present; Version 1.1 |
| `schema.sql` | Schema definition for creating a new database | Version 1.1; fresh-database creation tested |
| `migrations/001_schema_v1_0_to_v1_1.sql` | Migration from schema version 1.0 to 1.1 | Present; tested on a separate copy and applied to the canonical database |
| `SCHEMA_V1_1_MIGRATION_PLAN.md` | Migration scope, decisions and validation plan | Present; updated |
| `DATA_DICTIONARY.md` | Database tables, fields and relationships | Present; describes the Version 1.1 schema |
| `DATABASE_BUILD_REPORT.md` | Database build, migration checks, counts and limitations | Present; records migration, fresh-schema and publication checks |
| `MANIFEST.md` | Repository file inventory, source register and integration status | Present; current revision |
| `PROFILE_KNOWLEDGE_BRIEF.md` | Human-readable profile | Planned |
| `reconciliation/` | Reconciliation history and documented decisions | Present; ongoing |
| `exports/` | Generated CSV and JSON representations | Optional future addition |

The repository file inventory describes documentation and database artifacts separately from the source datasets registered inside SQLite.

---

## 3. Canonical database inventory

The canonical Version 1.1 database contains the following records.

| Database component | Current count |
|---|---:|
| Canonical records | 431 |
| Canonical links | 419 |
| Original source records | 435 |
| Provenance relationships | 433 |
| Research themes | 10 |
| Profile subject records | 1 |
| Registered source datasets | 4 |
| Import batches | 4 |
| Registered claims | 1 |

The 420 original link entries from the master directory and supplemental list resolve to 419 canonical link records.

Original source entries are retained through the source-record and provenance structure.

These counts are database record counts. They do not represent the final complete academic and intellectual profile, publication counts, unique research-work counts, DOI counts or counts of independently authored academic contributions.

Documentation changes to `README.md`, `ORCID_KEYWORDS.md`, `MANIFEST.md`, `DATA_DICTIONARY.md` and `DATABASE_BUILD_REPORT.md` do not independently change these database counts.

### 3.1 Link consolidation

The master link directory contains 400 original link entries.

A supplemental source contributed another 20 entries, resulting in 420 original link entries.

After URL normalization and canonical deduplication, these entries resolve to 419 canonical link records.

The original source entries and their provenance relationships are retained. Deduplicating a canonical URL does not mean that an original source entry has been silently discarded.

### 3.2 Version 1.1 schema structure

The canonical Version 1.1 database contains:

| Object type | Count |
|---|---:|
| Tables | 42 |
| Triggers | 41 |
| Views | 11 |

The index definitions were compared with the fresh-schema definition. The final comparison found no index-definition differences after `idx_verification_scope` was added to `schema.sql`.

### 3.3 Historical Version 1.0 baseline

The recorded Version 1.0 baseline inspection reported:

| Baseline item | Recorded value |
|---|---|
| Database file | `profile.sqlite` |
| File size | 1,351,680 bytes |
| Schema version | 1.0 |
| Tables | 25 |
| Views | 4 |
| Indexes | 30 |
| SQLite integrity check | `ok` |
| Foreign-key violations | 0 |
| SQLite version reported during that inspection | 3.46.1 |
| Baseline SHA-256 | `16d00294c2ed71963399a2dafdd1e8256f0d8bfbf45580ed7b8f42ed73904cde` |

The baseline database was retained as a local backup. Its hash was checked before migration testing and matched the recorded value.

---

## 4. Registered source datasets

The following four source datasets are registered in the `sources` table of `profile.sqlite`.

### 4.1 SRC-MASTER-400 — Master link directory

| Field | Value |
|---|---|
| Source identifier | `SRC-MASTER-400` |
| Source name | User-pasted master link directory |
| Source type | User supplied |
| Original source name | `300 PLUS LINKS OF ME HAHA` |
| Stored representation | `master-link-directory-transcribed.md` |
| Acquisition date | 2026-11-16 |
| Original entries | 400 |
| Import batch | `BATCH-MASTER-400` |
| Import status | Completed |

The directory contains 400 link entries organised into 11 original sections.

Its stored transcription preserves the supplied section organisation and URL entries.

### 4.2 SRC-SUPPLEMENT-20 — Additional GitHub and project links

| Field | Value |
|---|---|
| Source identifier | `SRC-SUPPLEMENT-20` |
| Source name | Additional GitHub and project links |
| Source type | User supplied |
| Stored source name | `additional-github-project-links-2026-11-16.txt` |
| Acquisition date | 2026-11-16 |
| Original entries | 20 |
| Import batch | `BATCH-SUPPLEMENT-20` |
| Import status | Completed |

The supplemental entries include links to the Three Harmonics and Verse & Variable projects and the associated GitHub account and repositories.

One normalized URL duplicates a target already present in the master directory. Both source entries are retained, while the corresponding canonical link is deduplicated.

### 4.3 SRC-BRIEF-001 — Profile knowledge brief

| Field | Value |
|---|---|
| Source identifier | `SRC-BRIEF-001` |
| Source name | Profile knowledge brief supplied for import |
| Source type | Other AI / vendor unattributed |
| Acquisition date | 2026-11-16 |
| Imported source records | 14 |
| Import batch | `BATCH-BRIEF-001` |
| Import status | Completed with warnings |

The source contains profile identity strings, research themes, a working research narrative and publication-classification guidance.

The originating AI vendor is not asserted because the available source metadata does not establish it.

### 4.4 SRC-REPORT-001 — Database build report

| Field | Value |
|---|---|
| Source identifier | `SRC-REPORT-001` |
| Source name | Database build report supplied for import |
| Source type | Other AI / vendor unattributed |
| Acquisition date | 2026-11-16 |
| Imported source records | 1 |
| Import batch | `BATCH-REPORT-001` |
| Import status | Completed |

The report documents the construction of the 400-link directory and its category counts.

Its aggregate figures are retained as source information and are not automatically treated as separate academic works or independently verified academic records.

### 4.5 ORCID keyword documentation

`ORCID_KEYWORDS.md` is maintained as a repository-level research keyword and academic indexing document.

It organizes research topics, methods, experimental techniques, academic-context terms and broader intellectual areas using the ORCID keyword material and supplementary keyword information supplied for the archive.

It is a documentation and discovery resource, not a separately imported source dataset in the current SQLite database.

Consequently, its presence in the repository does not increase the registered source dataset count or import batch count.

The document distinguishes research topics from institutional names, conference names, awards, professional roles, platforms and research-output titles. Keyword inclusion alone does not establish a formal appointment, affiliation, award, publication or specific research contribution.

---

## 5. Historical datasets awaiting incorporation

Additional databases and exports have been supplied or referenced in previous project conversations.

They are not yet counted as imported source datasets in the canonical database.

The following materials remain candidates for comparison and integration. The names below omit duplicate-upload suffixes; check each artifact's current exact filename before use.

| Historical source artifact | Information available | Current status |
|---|---|---|
| `links.json` | Reported 400-link JSON export | Awaiting record-level comparison |
| `links.csv` | Reported matching 400-row CSV export | Awaiting record-level comparison |
| `pravinkumar_ghodake_knowledge.db` | Previously inspected SQLite database; six tables and 437 rows were reported | Awaiting import |
| `pravinkumar_ghodake_ai_context_brief.md` | Earlier profile context brief | Awaiting comparison |
| `ghodake_profile.db` | Historical profile database export | Awaiting import |
| `Ghodake Profile Database (JSON).json` | Historical structured profile export | Awaiting import |
| `pravinkumar_ghodake_knowledge.json` | Structured knowledge export; vendor attribution not established | Awaiting import |
| Perplexity JSON and SQL schema export | Historical structured source export | Awaiting file-level comparison |
| Earlier ChatGPT knowledge-base package | Previously generated database and documentation package | Awaiting comparison |

Some files were uploaded more than once during earlier analysis, which caused automatic `(1)` suffixes to be added to filenames. The profile owner later manually corrected the filenames. Those suffixes were upload-name artifacts, not dataset versions or source identifiers.

Earlier inventories containing the suffixes may therefore have inaccurate filenames. Before importing or reconciling an artifact, inspect its current exact filename and contents. A name suffix alone does not establish that two files are different datasets.

Historical file descriptions are retained as provenance leads. They do not substitute for re-inspection of the original files during import.

The 400-link JSON and CSV exports must be compared with the already imported master directory before any additional link records are added.

---

## 6. Migration and validation record

The Version 1.0-to-1.1 migration was tested on a separate copy of the baseline database before it was applied to the canonical database.

The baseline SHA-256 was checked and matched:

`16d00294c2ed71963399a2dafdd1e8256f0d8bfbf45580ed7b8f42ed73904cde`

The SQLite command-line tool used for the migration and fresh-schema checks reported version 3.54.1, 64-bit.

### 6.1 Migrated test-copy checks

The migrated test copy reported:

- Foreign-key enforcement enabled (`1`).
- SQLite `integrity_check` result: `ok`.
- `foreign_key_check`: no violations returned.
- Schema metadata version: `1.1`.
- Database status metadata: `Schema v1.1 migration`.
- Canonical records: 431.
- Links: 419.
- Research themes: 10.
- Source datasets: 4.
- Import batches: 4.
- Source records: 435.
- Record-provenance relationships: 433.
- 42 tables, 41 triggers and 11 views.

### 6.2 Existing-data preservation comparison

A database comparison was run between the Version 1.0 baseline and the migrated test copy for these tables:

- `records`
- `people`
- `links`
- `research_themes`
- `claims`
- `sources`
- `import_batches`
- `source_records`
- `record_provenance`

Each comparison reported zero changes, zero inserted rows and zero deleted rows. The existing rows in those tables were reported unchanged.

### 6.3 Migration behavior checks

The following checks were run against the migrated test copy using temporary records and rollback-capable transactions:

- An invalid person subtype was rejected with the expected message: `people requires record_type person`.
- A follow-up check confirmed that the rejected insertion left no test rows behind.
- Test project, contributor, creative-work and project-work relationship rows were created and counted; cleanup left no test rows behind.
- Test conference output, submission, presentation and participation relationships were created and counted; cleanup left no test rows behind.
- Project-release relationships, release/source relationships, content and code license entries, keyword assignments and reconciliation records were checked; cleanup left no test rows behind.
- An update trigger refreshed the `updated_at` timestamp during a test update.
- Verification events using the `content` and `url_availability` scopes were checked; two distinct scopes were present and cleanup left no test rows behind.
- Multiple participation roles for the same test conference/person combination were retained.
- A reconciliation item linked to both a canonical record and a source record was checked.
- Final integrity, foreign-key and row-preservation checks were repeated after the behavior tests.
- The listed baseline tables again showed no changes, inserts or deletes after cleanup.

### 6.4 Fresh-schema validation

The Version 1.1 `schema.sql` was loaded into a separate blank test database. The initial comparison found that the file lacked `idx_verification_scope`. The index was added to `schema.sql`, and a new fresh test database was built from the corrected file.

The corrected fresh-schema database reported:

| Validation item | Result |
|---|---|
| Foreign-key enforcement | Enabled (`1`) |
| SQLite `integrity_check` | `ok` |
| `foreign_key_check` | No violations returned |
| Schema version metadata | `1.1` |
| Database status metadata | `Fresh schema v1.1 definition` |
| Tables | 42 |
| Triggers | 41 |
| Views | 11 |

The corrected fresh-schema database was compared with the migrated test copy:

- Table columns, order, types, nullability, defaults and primary-key metadata: no differences.
- Foreign-key definitions: no differences.
- Index definitions, uniqueness, partial-index status and indexed-column details: no differences.
- Table definitions: matched after normalizing layout whitespace and double quotes around identifiers.
- Trigger and view definitions: matched after the same normalization. Single-quoted SQL text was preserved during comparison.

### 6.5 Canonical publication check

After the migration candidate passed its checks, it was uploaded to the repository as `02-ai-knowledge-base/profile.sqlite`.

The published database was downloaded again and its SHA-256 was compared with the tested local candidate. The hashes matched.

The v1.0 baseline SHA-256 is retained in this manifest as historical provenance. The Version 1.1 file hash is not listed here.

### 6.6 What the checks establish

The checks provide evidence that:

- The migration completed on the separate test copy and the canonical database.
- The compared pre-existing records were preserved in the listed tables.
- The migrated and fresh-schema test databases passed SQLite integrity and foreign-key checks.
- The tested record-type, relationship and trigger rules behaved as expected on the migration test copy.
- The corrected `schema.sql` creates the tested Version 1.1 structure from a blank database.
- The fresh-schema and migrated test-copy definitions agree on the compared columns, foreign keys, indexes, tables, triggers and views.
- The published database matches the tested local candidate by SHA-256.

They do not establish the factual correctness of every profile claim, the completeness of every source dataset, or the reliability of external websites and search indexes.

The checks were run by the profile owner. The results above are recorded from the outputs supplied for this manifest and have not been independently audited.

---

## 7. Source and verification policy

The profile owner maintains the archive and states that the supplied academic, professional and profile information and source links have been manually and independently checked against their relevant references.

The database maintains source attribution and verification history to support traceability.

The following distinctions are maintained:

- Source provenance identifies where information originated.
- Record verification describes the evidence review associated with a canonical record.
- Link availability describes whether a URL is currently accessible.
- Historical verification records preserve previous checks.
- Technical validation checks database structure and consistency.
- Reconciliation records document differences, duplicates, corrections and decisions between source datasets.

These are separate aspects of data stewardship.

Repository documentation provides context and discovery information. It does not replace the source records or evidence associated with individual claims.

The presence of an institution, conference, award, professional role or research topic in a keyword index does not independently establish a specific relationship or activity. Such details should be represented through their relevant records and supporting references.

---

## 8. Single-database policy

`profile.sqlite` is the sole canonical database published in this directory.

Additional source databases are incorporated into this canonical database through documented import and reconciliation procedures.

The project does not maintain multiple competing canonical databases.

The database preserves:

- Source dataset identifiers
- Original source record identifiers
- Original source table names
- Original record payloads
- Import batch information
- Canonical record relationships
- Verification events
- Conflicts and their resolution history
- Historical record changes

Original database files remain available as profile-owner backups outside this public repository.

Repository documentation may be updated independently of the SQLite database, provided that such changes do not misrepresent the database's actual contents, schema or import status.

---

## 9. Research and intellectual project coverage

The knowledge base is intended to cover the profile's scientific, academic, creative and intellectual work.

Its scope includes:

### 9.1 Scientific and academic research

- Nonlinear ultrasonics and nonlinear elastic waves
- Harmonic generation, harmonic scattering and wave mixing
- Mechanical, acoustic and phononic metamaterials
- Structural health monitoring and nondestructive evaluation
- Damage quantification and early-stage damage detection
- Computational, theoretical and experimental mechanics
- Mechanics of composite materials
- Impact mechanics and fracture mechanics
- Inverse problems, inverse design and optimization
- Machine learning and uncertainty quantification in mechanics
- Advanced wave control and emerging metamaterial research

### 9.2 Research methods and experimental work

- Finite element modelling and numerical simulation
- Computational and mathematical methods
- Experimental mechanics and material characterization
- Ultrasonic measurement and guided-wave techniques
- Digital image correlation and high-speed imaging
- Impact testing and dynamic mechanical experiments
- Shape optimization and topology optimization
- Bayesian inverse methods and surrogate modelling

The detailed research keyword and indexing taxonomy is maintained separately in `ORCID_KEYWORDS.md`.

### 9.3 Literature, creative work and interdisciplinary projects

The wider intellectual profile also includes:

- Literature and multilingual creative writing
- Independent literary publishing
- Research communication
- Novel digital publishing and website design
- Independent software and digital projects
- Intellectual essays and interdisciplinary exploration

These activities are treated as connected parts of the broader intellectual and creative portfolio, while remaining distinguishable from scientific research outputs.

Related records are connected through the canonical database rather than maintained as competing profiles.

---

## 10. Maintenance and version history

New source datasets and records are incorporated through documented updates.

Every significant update should identify:

1. The originating source.
2. The acquisition or update date.
3. The records imported or modified.
4. Any duplicate records identified.
5. Any conflicts or corrections.
6. The resulting database version.
7. The validation results.

The canonical database must remain structurally consistent with its published schema and data dictionary.

Documentation changes should also be traceable. Updates to the README, keyword index, manifest, data dictionary and build report should describe the repository's actual contents and current status.

A documentation-only update does not, by itself, constitute a database schema migration or database rebuild.

Previous information should remain traceable rather than being silently overwritten.

---

## 11. Current project status

**Current stage:** Canonical Version 1.1 database published and verified; historical-source reconciliation and structured profile expansion remain in progress.

### Completed

- Initial SQLite database generation.
- Initial schema version 1.0 and baseline SHA-256 record.
- Import of the 400-entry master link directory.
- Import of 20 supplemental project and GitHub URLs.
- Import of the supplied profile brief and build report.
- Registration of four source datasets.
- Initial provenance and verification-history structure.
- Migration of a separate baseline copy to schema version 1.1.
- SQLite integrity and foreign-key checks on the migrated test copy.
- Comparison showing the listed pre-existing tables unchanged after migration.
- Savepoint-based checks of selected Version 1.1 relationships, constraints, triggers and cleanup behavior.
- Fresh-database creation using the corrected Version 1.1 `schema.sql`.
- Fresh-schema integrity and foreign-key checks.
- Structural comparison of the fresh-schema and migrated test-copy databases.
- Addition of the missing `idx_verification_scope` index to `schema.sql`.
- Publication of the tested Version 1.1 candidate as the canonical `profile.sqlite`.
- Download and SHA-256 verification of the published database against the tested local candidate.
- Updated project README and expanded research and intellectual scope.
- Preparation of the ORCID keyword and research index.
- Updated migration plan, data dictionary, manifest and build report.

### Remaining

- Inspect and compare historical ChatGPT and Perplexity database files.
- Audit exact source filenames after the duplicate-upload suffix corrections.
- Reconcile historical datasets at the record level.
- Reconcile research works, publications and publication versions.
- Populate structured education and professional appointment records.
- Add detailed authorship and conference presentation records.
- Structure independent scientific, literary and digital projects.
- Update and validate `profile.sqlite` after future approved data changes.
- Create the comprehensive profile knowledge brief.
- Improve public-facing profile and project pages.
- Maintain metadata, crawler policy and sitemap information.
- Monitor search-engine discovery and indexing.

---

## 12. Canonical database policy

`profile.sqlite` is the sole canonical database published in this directory.

The canonical database is now Version 1.1. The Version 1.0 baseline remains preserved as a profile-owner backup.

Historical databases and exports are treated as source materials for comparison, reconciliation and integration.

The project does not maintain multiple competing canonical databases.

The canonical database must preserve source provenance, historical information, documented corrections and relationships between records.

All future changes should follow reproducible import, reconciliation, migration and validation procedures.

---

**Maintained by:** Pravinkumar Ramchandra Ghodake

**Canonical database:** `profile.sqlite`

**Database format:** SQLite

**Current schema:** Version 1.1

**Migration:** Version 1.0 to Version 1.1

**Migration and fresh-schema validation:** Passed

**Canonical database publication:** Completed and SHA-256 verified
