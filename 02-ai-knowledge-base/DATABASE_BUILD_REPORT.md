# Database Build Report

## 1. Project identification

**Project:** Pravinkumar Ramchandra Ghodake — Academic & Intellectual Knowledge Base

**Canonical database:** `profile.sqlite`

**Database format:** SQLite

**Canonical database schema:** Version 1.0 baseline

**Migration target:** Version 1.1

**Build stage:** Version 1.1 migration and fresh-schema definition tested on separate copies; canonical deployment pending

**Report last updated:** 2026-11-18

---

## 2. Purpose

The database provides a consolidated, structured and machine-readable representation of the academic, scientific, professional, creative and intellectual profile of Pravinkumar Ramchandra Ghodake.

It is designed to integrate information from multiple independently maintained databases, source collections, academic records and other relevant materials into one canonical database.

The database preserves source attribution, original source records, provenance relationships, verification history and links between related records.

The objective is to maintain one authoritative database while retaining traceability to original source material.

The database is progressively developed through documented imports, reconciliation, validation and schema improvements.

---

## 3. Initial database contents

The canonical Version 1.0 baseline contains the following records. The counts were also confirmed after migrating a separate copy to Version 1.1.

| Content | Records |
|---|---:|
| Profile subject records | 1 |
| Canonical records | 431 |
| Canonical links | 419 |
| Original link entries | 420 |
| Original source records | 435 |
| Provenance relationships | 433 |
| Research themes | 10 |
| Working research narrative | 1 |
| Registered source datasets | 4 |
| Import batches | 4 |
| Registered claims | 1 |

### 3.1 Link consolidation

The master link directory contains 400 original link entries.

A supplemental source contributed another 20 entries, resulting in 420 original link entries.

After URL normalization and canonical deduplication, these entries resolve to 419 canonical link records.

The original source entries and their provenance relationships are retained. Deduplicating a canonical URL does not mean that an original source entry has been silently discarded.

### 3.2 Interpretation of counts

The figures are database record counts, not publication counts, unique research-work counts, DOI counts or counts of independently authored academic contributions.

One underlying intellectual contribution may eventually be connected to multiple records, such as a journal publication, conference abstract, presentation, dataset or repository entry.

These record types must be distinguished during future reconciliation.

The current figures do not represent the final complete academic and intellectual profile.

---

## 4. Registered source datasets

The canonical Version 1.0 database contains four registered source datasets.

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

One normalized URL duplicates a target already present in the master directory.

Both source entries are retained, while the corresponding canonical link is deduplicated.

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

### 4.5 Duplicate-upload filename note

Some database and documentation files were uploaded more than once during earlier analysis. The duplicate uploads led to automatic `(1)` suffixes being added to filenames. The profile owner later manually corrected the filenames.

Those suffixes were upload-name artifacts. They should not be interpreted as data versions, source identifiers or evidence that the files contain different records.

Earlier inventories that included `(1)` may contain inaccurate filenames. Before importing or reconciling a historical artifact, check its current exact filename and inspect the file itself. Do not treat two names as distinct datasets solely because one previously had an automatic suffix.

---

## 5. Database structure and schema status

The canonical database remains at schema version 1.0. Version 1.1 adds structured support for further academic, professional, project, creative-work, release, licensing, keyword and reconciliation records.

The tested Version 1.1 schema contains the following object counts:

| Object type | Count |
|---|---:|
| Tables | 42 |
| Triggers | 41 |
| Views | 11 |

The Version 1.1 schema supports the following functional areas:

- Profile identity and people
- Institutions and academic identifiers
- Education and appointments
- Research outputs and authorship
- Conferences and presentations
- Research themes and relationships
- Academic and professional links
- Awards and recognition
- Source datasets and import batches
- Original source records and provenance
- Profile claims and claim evidence
- Conflicts and verification history
- Projects, contributors and creative works
- Releases, licenses and keyword assignments
- Reconciliation items and their relationships
- Database change history

### 5.1 Schema files and their roles

The repository uses two SQL files for different purposes:

- `schema.sql` defines Version 1.1 for creating a new, empty database.
- `migrations/001_schema_v1_0_to_v1_1.sql` upgrades an existing Version 1.0 database to Version 1.1 while preserving its data.

The migration script was tested on a separate copy of the Version 1.0 baseline. The fresh-database definition in `schema.sql` was also loaded into a separate blank test database and compared with the migrated test copy.

The canonical `profile.sqlite` has not been replaced by either test database.

---

## 6. Migration and technical validation

The Version 1.0-to-1.1 migration was tested on a separate copy of the baseline database. The canonical baseline file was not used as the migration test target.

The baseline file’s SHA-256 was checked and matched:

`16d00294c2ed71963399a2dafdd1e8256f0d8bfbf45580ed7b8f42ed73904cde`

The SQLite command-line tool used for the checks reported version 3.54.1, 64-bit.

### 6.1 Migration test-copy results

The migrated test copy reported:

| Validation item | Result |
|---|---|
| Foreign-key enforcement | Enabled (`1`) |
| SQLite integrity check | `ok` |
| Foreign-key check | No violations returned |
| Schema metadata | Version `1.1` |
| Database status metadata | `Schema v1.1 migration` |
| Canonical records | 431 |
| Links | 419 |
| Research themes | 10 |
| Source datasets | 4 |
| Import batches | 4 |
| Source records | 435 |
| Record provenance relationships | 433 |
| Tables | 42 |
| Triggers | 41 |
| Views | 11 |

### 6.2 Existing-data preservation comparison

A database comparison was run between the baseline and migrated test copy for these existing tables:

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

This comparison covers the listed tables. It is not a claim that every possible database value or every external source record has been independently checked for factual accuracy.

### 6.3 Migration behavior checks

The following checks were run against the migrated test copy using temporary test records and rollback-capable transactions:

- An invalid person subtype was rejected with the expected message: `people requires record_type person`.
- A follow-up check confirmed that the rejected insertion left no test rows behind.
- Test project, contributor, creative-work and project-work relationship rows were created and counted; cleanup left no test rows behind.
- Test conference output, submission, presentation and participation relationships were created and counted; cleanup left no test rows behind.
- Project-release relationships, release/source relationships, content and code licenses, keyword assignments and reconciliation records were checked; cleanup left no test rows behind.
- An update trigger refreshed the `updated_at` timestamp during a test update.
- Verification events using the `content` and `url_availability` scopes were checked; two distinct scopes were present and cleanup left no test rows behind.
- Multiple participation roles for the same test conference/person combination were retained.
- A reconciliation item linked to both a canonical record and a source record was checked.
- Final integrity, foreign-key and row-preservation checks were repeated after the behavior tests.
- The listed baseline tables again showed no changes, inserts or deletes after cleanup.

### 6.4 Fresh-database schema validation

The updated `schema.sql` was loaded into a new blank test database. The first comparison found that `schema.sql` lacked the `idx_verification_scope` index. That index was added to `schema.sql`, and a new blank test database was created from the corrected file.

The corrected fresh-schema database reported:

| Validation item | Result |
|---|---|
| Foreign-key enforcement | Enabled (`1`) |
| SQLite integrity check | `ok` |
| Foreign-key check | No violations returned |
| Schema metadata | Version `1.1` |
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

These checks confirm that the tested fresh-schema definition and migrated test-copy schema agree on the compared structures. They do not mean that the canonical database has been migrated.

### 6.5 What these checks establish

The checks provide evidence that:

- The migration completed on the separate test copy.
- The compared pre-existing records were preserved in the listed tables.
- The migrated and fresh-schema test databases passed SQLite integrity and foreign-key checks.
- The tested record-type, relationship and trigger rules behaved as expected on the migration test copy.
- The fresh `schema.sql` definition creates the tested Version 1.1 structure.
- The fresh and migrated test-copy definitions agree on the compared columns, foreign keys, indexes, tables, triggers and views.

They do not establish the factual correctness of every profile claim, the completeness of every source dataset, or the reliability of external websites and search indexes.

The checks were run by the profile owner, and the results above are recorded from the outputs supplied for this report. This report does not claim that the checks were independently audited.

---

## 7. Data provenance and verification

The profile owner maintains the archive and states that supplied academic, professional and profile information and source links have been manually and independently checked against their relevant references.

The database maintains source attribution and verification history to support traceability.

The following concepts are kept distinct:

| Concept | Meaning |
|---|---|
| Source provenance | Identifies where information originated |
| Record verification | Documents whether profile information has been checked against relevant evidence |
| Link availability | Describes whether a URL is currently accessible |
| Technical validation | Checks the structural integrity and consistency of the database |
| Reconciliation | Documents differences, duplicates, corrections and decisions between source records |

A record's factual verification status and the current accessibility of its associated URL are separate matters.

For example, a previously checked academic record may remain supported by retained source information even if its external URL later becomes unavailable.

### 7.1 Academic record classification

Research outputs must be classified according to their actual nature.

Relevant categories include:

- Journal articles
- Conference proceedings
- Conference abstracts
- Conference presentations
- Research datasets
- Theses
- Books and book chapters
- Software and technical releases
- Other documented intellectual contributions

A single underlying research contribution may have several associated records or versions.

These must be linked appropriately rather than automatically counted as separate research works.

---

## 8. Source integration status and limitations

The database is designed to combine records from:

- ChatGPT-generated knowledge-base and database materials
- Perplexity-related knowledge-base and database materials
- User-provided directories and datasets
- Academic and professional records
- Repository and project information
- Other relevant source collections

The initial build does not yet represent complete record-level integration of all historical databases.

Additional datasets will be incorporated progressively into the same canonical database.

### 8.1 Historical materials awaiting reconciliation

The following materials have been identified for future comparison and integration. Names here omit the duplicate-upload suffixes; check each artifact's current exact filename before use.

- `links.json`
- `links.csv`
- `pravinkumar_ghodake_knowledge.db`
- `pravinkumar_ghodake_ai_context_brief.md`
- `ghodake_profile.db`
- `Ghodake Profile Database (JSON).json`
- `pravinkumar_ghodake_knowledge.json`
- Perplexity JSON and SQL schema exports
- Earlier ChatGPT knowledge-base packages

Their reported contents and historical descriptions are not treated as verified import results until the original files have been inspected and compared.

The 400-link JSON and CSV exports must be compared with the already imported master directory before any additional link records are added.

### 8.2 Current coverage limitations

The canonical database is not yet the complete structured representation of every academic and intellectual activity.

Further work is required for:

- Detailed education records
- Professional appointments and institutional history
- Publication and research-work relationships
- Author lists and author order
- Conference submissions and presentations
- Awards, grants and professional service
- Independent scientific, literary and digital projects
- Software releases, DOI deposits and licensing relationships
- Comprehensive research-output reconciliation

These areas are part of the planned expansion and should not be represented as fully populated merely because the schema anticipates them.

---

## 9. Repository documentation and indexing

The database is accompanied by documentation that explains its purpose, scope, organization and maintenance.

The current documentation includes:

| File | Purpose |
|---|---|
| `README.md` | Project overview, identity, research and intellectual scope, and data stewardship |
| `ORCID_KEYWORDS.md` | Categorized research keywords and academic indexing terms |
| `MANIFEST.md` | Repository file inventory, source register and integration status |
| `DATA_DICTIONARY.md` | Table and field documentation |
| `schema.sql` | Version 1.1 schema definition for creating a fresh database |
| `migrations/001_schema_v1_0_to_v1_1.sql` | Migration from schema v1.0 to v1.1 |
| `SCHEMA_V1_1_MIGRATION_PLAN.md` | Migration rationale, scope and validation plan |
| `DATABASE_BUILD_REPORT.md` | Database construction, migration checks, counts, validation and limitations |

These documentation files improve human readability and machine discovery.

They are not additional imported database datasets and do not independently change the number of registered sources or records in `profile.sqlite`.

The detailed research keyword index organizes scientific research domains, computational methods, experimental techniques and wider academic-context terms.

Research keywords provide indexing context. They should not be interpreted as proof that every topic is represented in every publication or research contribution.

---

## 10. Maintenance and versioning

The database is intended to be continuously maintained.

Future updates should document:

- New source datasets
- Newly imported records
- Updated academic information
- Duplicate resolution
- Verification changes
- Conflict resolution
- Database schema changes
- Technical validation results
- Changes to record relationships and provenance

Every significant database update should identify its source, import date, import batch, records affected, reconciliation decisions and resulting database version.

Schema changes should be managed through documented and tested migrations.

Existing historical records and source provenance should remain traceable rather than being silently overwritten.

Documentation changes should remain aligned with the actual database and repository contents.

A documentation-only update does not, by itself, constitute a database schema migration or database rebuild.

---

## 11. Current status

**Current database stage:** Canonical Version 1.0 database established; Version 1.1 migration and fresh-schema definition tested on separate copies; canonical deployment and historical-source reconciliation remain pending.

### Completed

- Initial SQLite database generation.
- Initial schema version 1.0.
- Import of the 400-entry master link directory.
- Import of 20 supplemental project and GitHub URLs.
- Import of the supplied profile brief and build report.
- Registration of four source datasets.
- Initial provenance and verification-history structure.
- Baseline database SHA-256 confirmation.
- Migration of a separate baseline copy to schema version 1.1.
- SQLite integrity and foreign-key checks on the migrated test copy.
- Comparison showing the listed pre-existing tables unchanged after migration.
- Savepoint-based checks of selected Version 1.1 relationships, constraints, triggers and cleanup behavior.
- Fresh-database creation using the corrected Version 1.1 `schema.sql`.
- Fresh-schema integrity and foreign-key checks.
- Structural comparison of the fresh-schema and migrated test-copy databases.
- Updated project README and expanded research and intellectual scope.
- Preparation of the ORCID keyword and research index.
- Updated migration plan and data dictionary.
- Updated manifest and build report to record migration and fresh-schema validation results.

### Remaining

- Review and approve deployment of Version 1.1 to the canonical `profile.sqlite`.
- Inspect and compare historical ChatGPT and Perplexity database files.
- Audit exact source filenames after the duplicate-upload suffix corrections.
- Reconcile historical datasets at the record level.
- Reconcile research works, publications and publication versions.
- Add structured education and professional appointment records.
- Add detailed authorship and conference presentation records.
- Structure independent scientific, literary and digital projects.
- Rebuild and validate the canonical `profile.sqlite` after an approved schema migration and data changes.
- Create the comprehensive profile knowledge brief.
- Improve public-facing profile and project pages.
- Maintain metadata, crawler policy and sitemap information.
- Monitor search-engine discovery and indexing.

---

## 12. Canonical database policy

`profile.sqlite` is the sole canonical database published in this directory.

The Version 1.1 migration was tested on a separate copy. The fresh-schema test database and migrated test copy have not replaced the canonical database.

Historical databases and exports are treated as source materials for comparison, reconciliation and integration.

The project does not maintain multiple competing canonical databases.

The canonical database must preserve source provenance, historical information, documented corrections and relationships between records.

All future changes should follow reproducible import, reconciliation, migration and validation procedures.

---

**Maintained by:** Pravinkumar Ramchandra Ghodake

**Canonical database:** `profile.sqlite`

**Database format:** SQLite

**Canonical schema:** Version 1.0 baseline

**Migration target:** Version 1.1

**Migration validation:** Passed on a separate test copy

**Fresh-schema validation:** Passed on a separate blank test database

**Canonical database deployment:** Not performed
