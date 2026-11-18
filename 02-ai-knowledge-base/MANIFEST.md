# Manifest — Academic & Intellectual Knowledge Base

**Project:** Pravinkumar Ramchandra Ghodake — Academic & Intellectual Knowledge Base

**Canonical database:** `profile.sqlite`

**Database format:** SQLite

**Canonical database schema:** Version 1.0 baseline

**Migration target:** Version 1.1

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
| `profile.sqlite` | Consolidated canonical database | Present; baseline database, schema version 1.0 |
| `schema.sql` | Schema definition for creating a new database | Intended to describe schema version 1.1; fresh-database validation pending |
| `migrations/001_schema_v1_0_to_v1_1.sql` | Migration from schema version 1.0 to 1.1 | Present; tested on a separate database copy |
| `SCHEMA_V1_1_MIGRATION_PLAN.md` | Migration scope, decisions and validation plan | Present; updated |
| `DATA_DICTIONARY.md` | Database tables, fields and relationships | Present; schema alignment to be completed |
| `DATABASE_BUILD_REPORT.md` | Database build, migration checks, counts and limitations | Present; updated for the v1.1 test |
| `MANIFEST.md` | Repository file inventory, source register and integration status | Present; current revision |
| `PROFILE_KNOWLEDGE_BRIEF.md` | Human-readable profile | Planned |
| `reconciliation/` | Reconciliation history and documented decisions | Present; ongoing |
| `exports/` | Generated CSV and JSON representations | Optional future addition |

The repository file inventory describes documentation and database artifacts separately from the source datasets registered inside SQLite.

The v1.1 migration was tested on a separate copy. The canonical `profile.sqlite` has not been replaced by that test copy.

---

## 3. Canonical database inventory

The baseline canonical database contains the following records.

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

These counts describe the current baseline database. They are not claimed to represent the final complete academic and intellectual profile.

Documentation changes to `README.md`, `ORCID_KEYWORDS.md`, `MANIFEST.md` and `DATABASE_BUILD_REPORT.md` do not independently change these database counts.

### 3.1 Migration test-copy inventory

A separate copy of the baseline database was migrated to schema version 1.1 for testing. Its data counts remained:

| Database component | Test-copy count after migration |
|---|---:|
| Canonical records | 431 |
| Canonical links | 419 |
| Original source records | 435 |
| Provenance relationships | 433 |
| Research themes | 10 |
| Registered source datasets | 4 |
| Import batches | 4 |

The migrated test copy contained 42 tables, 41 triggers and 11 views.

These structural counts describe the test copy after migration. They do not mean that the canonical `profile.sqlite` has already been migrated.

---

## 4. Registered source datasets

The following source datasets are registered in the `sources` table of the baseline `profile.sqlite`.

### SRC-MASTER-400 — Master link directory

| Field | Value |
|---|---|
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

### SRC-SUPPLEMENT-20 — Additional GitHub and project links

| Field | Value |
|---|---|
| Source name | Additional GitHub and project links |
| Source type | User supplied |
| Stored source name | `additional-github-project-links-2026-11-16.txt` |
| Acquisition date | 2026-11-16 |
| Original entries | 20 |
| Import batch | `BATCH-SUPPLEMENT-20` |
| Import status | Completed |

The supplemental entries include links to the Three Harmonics and Verse & Variable projects and the associated GitHub account and repositories.

One normalized URL duplicates a target already present in the master directory. Both source entries are retained, while the canonical link is deduplicated.

### SRC-BRIEF-001 — Profile knowledge brief

| Field | Value |
|---|---|
| Original filename | Profile knowledge brief supplied for import |
| Source type | Other AI / vendor unattributed |
| Acquisition date | 2026-11-16 |
| Imported source records | 14 |
| Import batch | `BATCH-BRIEF-001` |
| Import status | Completed with warnings |

The source contains profile identity strings, research themes, a working research narrative and publication-classification guidance.

The originating AI vendor is not asserted because the available source metadata does not establish it.

### SRC-REPORT-001 — Database build report

| Field | Value |
|---|---|
| Original filename | Database build report supplied for import |
| Source type | Other AI / vendor unattributed |
| Acquisition date | 2026-11-16 |
| Imported source records | 1 |
| Import batch | `BATCH-REPORT-001` |
| Import status | Completed |

The report documents the construction of the 400-link directory and its category counts.

Its aggregate figures are retained as source information and are not automatically treated as separate independently verified academic records.

### ORCID keyword documentation

`ORCID_KEYWORDS.md` is maintained as a repository-level research keyword and academic indexing document.

It organizes research topics, methods, experimental techniques, academic-context terms and broader intellectual areas using the ORCID keyword material and supplementary keyword information supplied for the archive.

It is a documentation and discovery resource, not a separately imported source dataset in the current SQLite database.

Consequently, its presence in the repository does not increase the registered source dataset count or import batch count.

Keyword inclusion alone does not establish a formal appointment, affiliation, award, publication or specific research contribution. Such details should be represented through their relevant records and supporting references.

### Duplicate-upload filename note

Some database and documentation files were uploaded more than once during earlier analysis. The duplicate uploads led to automatic `(1)` suffixes being added to filenames. The profile owner later manually corrected the filenames.

Those suffixes were upload-name artifacts. They should not be interpreted as data versions, source identifiers or evidence that the files contain different records.

Earlier inventories that included `(1)` may therefore contain inaccurate filenames. Before importing or reconciling a historical artifact, check its current exact filename and inspect the file itself. Do not treat two names as distinct datasets solely because one previously had an automatic suffix.

---

## 5. Historical datasets awaiting incorporation

Additional databases and exports have been supplied or referenced in previous project conversations.

They are not yet counted as imported source datasets in the current canonical database.

The following materials remain candidates for comparison and integration. The names below omit the duplicate-upload suffixes; check each artifact’s current exact filename before use.

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

Historical file descriptions are retained as provenance leads. They do not substitute for re-inspection of the original files during import.

In particular, the reported 400-link JSON and CSV exports must be compared with the already imported master directory before any additional link records are added.

---

## 6. Migration and validation record

The baseline database file’s SHA-256 was checked and matched:

`16d00294c2ed71963399a2dafdd1e8256f0d8bfbf45580ed7b8f42ed73904cde`

The v1.0-to-v1.1 migration was run on a separate test copy, not on the canonical baseline file.

The SQLite command-line tool used for the checks reported version 3.54.1, 64-bit.

The migrated test copy reported:

- Foreign-key enforcement enabled.
- SQLite `integrity_check` result: `ok`.
- `foreign_key_check`: no violations returned.
- Schema version metadata: `1.1`.
- Database status metadata: `Schema v1.1 migration`.
- 42 tables, 41 triggers and 11 views.

A database comparison between the baseline and migrated test copy reported zero changes, zero inserts and zero deletes in each of these tables:

- `records`
- `people`
- `links`
- `research_themes`
- `claims`
- `sources`
- `import_batches`
- `source_records`
- `record_provenance`

The following behavior checks were run against the test copy using temporary records and rollback-capable transactions:

- An invalid person subtype was rejected with `people requires record_type person`; a follow-up check showed no leftover rows.
- Project, contributor, creative-work and project-work relationship records were created, counted and removed.
- Conference output, submission, presentation and participation relationships were created, counted and removed.
- Project release, release/source, content-license, code-license, keyword-assignment and reconciliation records were checked and removed.
- An update trigger refreshed the `updated_at` timestamp.
- Verification events with `content` and `url_availability` scopes were checked.
- Multiple participation roles for the same test conference/person were retained.
- A reconciliation item linked to both a canonical record and a source record was checked.
- Final integrity, foreign-key and data-preservation checks were repeated after cleanup.

The final checks showed no leftover test rows. The table comparisons again showed no changes, inserts or deletes in the listed pre-existing tables.

These checks provide evidence about the tested migration, compared data and tested database behavior. They do not establish the factual correctness of every profile claim, the completeness of every source dataset, or the reliability of external websites and search indexes. The results are recorded from the outputs supplied by the profile owner; they have not been independently audited.

The new `schema.sql` is intended to describe the v1.1 structure for a fresh database. A fresh-database creation check using that file remains pending.

---

## 7. Source and verification policy

The profile owner maintains the archive and states that supplied academic, professional and profile information and source links have been manually and independently checked against their relevant references.

The database maintains source attribution and verification history to support traceability.

The following distinctions are maintained:

- Source provenance identifies where information originated.
- Record verification describes the evidence review associated with a canonical record.
- Link availability describes whether a URL is accessible.
- Historical verification records preserve previous checks.
- Technical validation checks database structure and consistency.
- Reconciliation records document differences, duplicates, corrections and decisions between source datasets.

These are separate aspects of data stewardship.

Repository documentation provides context and discovery information. It does not replace source records or evidence associated with individual claims.

The presence of an institution, conference, award, professional role or research topic in a keyword index does not independently establish a specific relationship or activity. Such details should be represented through their relevant records and supporting references.

---

## 8. Single-database policy

`profile.sqlite` is the sole canonical database published in this directory.

The v1.1 migration test was performed on a separate copy. The test copy did not replace the canonical database.

Additional source databases are incorporated into the existing canonical database through documented import and reconciliation procedures.

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

Repository documentation may be updated independently of the SQLite database, provided that such changes do not misrepresent the database’s actual contents, schema or import status.

---

## 9. Research and intellectual project coverage

The knowledge base is intended to cover the profile’s scientific, academic, creative and intellectual work.

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

Documentation changes should also be traceable. Updates to the README, keyword index, manifest and build report should describe the repository’s actual contents and current status.

A documentation-only update does not, by itself, constitute a database schema migration or database rebuild.

Previous information should remain traceable rather than being silently overwritten.

---

## 11. Current project status

**Current stage:** Baseline canonical database established at schema version 1.0; v1.0-to-v1.1 migration tested on a separate copy; historical-source reconciliation and structured profile expansion remain underway.

### Completed

- Initial SQLite database generation.
- Initial schema version 1.0.
- Import of the 400-entry master link directory.
- Import of 20 supplemental project and GitHub URLs.
- Import of the supplied profile brief and build report.
- Initial provenance and verification-history structure.
- Baseline database SHA-256 confirmation.
- Migration of a separate baseline copy to schema version 1.1.
- SQLite integrity and foreign-key checks on the migrated test copy.
- Comparison showing the listed pre-existing tables unchanged after migration.
- Savepoint-based checks of selected v1.1 relationships, constraints, triggers and cleanup behavior.
- Updated README project overview and research and intellectual scope.
- Preparation of the ORCID keyword and research index.
- Updated manifest structure and migration documentation.

### Remaining

- Run and document a fresh-database creation check using the current `schema.sql`.
- Decide when to migrate the canonical `profile.sqlite`, after reviewing the test results and migration plan.
- Inspect and compare historical ChatGPT and Perplexity database files.
- Audit exact source filenames after the duplicate-upload suffix corrections.
- Reconcile historical datasets at the record level.
- Reconcile research works, publications and publication versions.
- Populate structured education and professional appointment records.
- Add detailed authorship and conference presentation records.
- Structure independent scientific, literary and digital projects.
- Update `DATA_DICTIONARY.md` to match the v1.1 schema.
- Rebuild and validate the canonical `profile.sqlite` after approved data and schema changes.
- Create the comprehensive profile knowledge brief.
- Maintain public-facing profile pages, metadata, crawler policy and sitemap information.
- Monitor search-engine discovery and indexing.

---

**Maintained by:** Pravinkumar Ramchandra Ghodake

**Canonical database:** `profile.sqlite`

**Canonical database schema:** Version 1.0 baseline

**Migration target:** Version 1.1

**Migration validation:** Completed on a separate test copy

**Fresh-database validation of `schema.sql`:** Pending
