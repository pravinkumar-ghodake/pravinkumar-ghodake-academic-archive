# Manifest — Academic & Intellectual Knowledge Base

**Project:** Pravinkumar Ramchandra Ghodake — Academic & Intellectual Knowledge Base

**Canonical database:** `profile.sqlite`

**Database format:** SQLite

**Current schema:** Version 1.0

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
| `README.md` | Project overview, identity, research and intellectual scope, and data stewardship | Present; overview and scope documented |
| `ORCID_KEYWORDS.md` | Categorized research keyword and academic indexing document | Present; companion index |
| `profile.sqlite` | Consolidated canonical database | Present; initial populated build, schema version 1.0 |
| `schema.sql` | SQLite database schema | Present; version 1.0 |
| `DATA_DICTIONARY.md` | Table and field documentation | Present; schema alignment review pending |
| `DATABASE_BUILD_REPORT.md` | Build statistics, source information and validation results | Present; update planned after database review |
| `MANIFEST.md` | Source, file and project provenance register | Present; inventory and status review in progress |
| `PROFILE_KNOWLEDGE_BRIEF.md` | Human-readable academic and intellectual profile | Present; review and reconciliation ongoing |
| `links.csv` | Structured link data in CSV format | Present; relationship to the canonical database pending comparison |
| `links.json` | Structured link data in JSON format | Present; relationship to the canonical database pending comparison |
| `SCHEMA_V1_1_MIGRATION_PLAN.md` | Plan for a proposed schema migration | Present; canonical database remains at version 1.0 |
| `migrations/` | Versioned schema migration files | Present; migration execution status to be confirmed |
| `reconciliation/` | Reconciliation reports and documented decisions | Present; records to be reviewed as reconciliation proceeds |
| `exports/` | Generated CSV and JSON representations | Not present; optional future addition |

The repository file inventory describes documentation and database artifacts separately from the source datasets registered inside the SQLite database.

The presence of a file in the repository does not by itself establish that its contents have been imported into `profile.sqlite`.

---

## 3. Current canonical database inventory

The initial populated database contains the following recorded inventory.

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

These counts describe the recorded initial database build. They are not claimed to represent the final complete academic and intellectual profile.

The counts should be reconciled against `profile.sqlite` and the latest `DATABASE_BUILD_REPORT.md` after a database rebuild or additional import.

Documentation changes to `README.md`, `ORCID_KEYWORDS.md` and `MANIFEST.md` do not independently change these database counts.

---

## 4. Registered source datasets

The following source datasets are currently registered in the `sources` table of `profile.sqlite`.

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
| Original filename | `PROFILE_KNOWLEDGE_BRIEF.md` |
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
| Original filename | `BUILD_REPORT(3).md` |
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

The document distinguishes research topics from institutional names, conference names, awards, professional roles, platforms and research-output titles. Keyword inclusion alone does not establish a formal appointment, affiliation, award, publication or specific research contribution.

The repository-level `links.csv` and `links.json` are listed in Section 2. Their relationship to the canonical database should be established by comparing their contents before treating them as database exports or additional imported datasets.

---

## 5. Historical datasets awaiting incorporation

Additional databases and exports have been supplied or referenced in previous project conversations.

They are not yet counted as imported source datasets in the current canonical database.

The following historical materials remain candidates for comparison and integration.

| Historical source artifact | Information available | Current status |
|---|---|---|
| `links.json` | Reported 400-link JSON export | Awaiting record-level comparison |
| `links.csv` | Reported matching 400-row CSV export | Awaiting record-level comparison |
| `pravinkumar_ghodake_knowledge.db` | Previously inspected SQLite database; six tables and 437 rows were reported | Awaiting import |
| `pravinkumar_ghodake_ai_context_brief.md` | Earlier 27-line profile context brief | Awaiting comparison |
| `ghodake_profile.db` | Historical Perplexity-labelled database export | Awaiting import |
| `Ghodake Profile Database (JSON).json` | Historical Perplexity-related structured profile export | Awaiting import |
| `pravinkumar_ghodake_knowledge.json` | Structured knowledge export; vendor attribution not established | Awaiting import |
| Perplexity JSON and SQL schema export | Historical structured source export | Awaiting file-level comparison |
| Earlier ChatGPT knowledge-base package | Previously generated database and documentation package | Awaiting comparison |

Historical file descriptions are retained as provenance leads. They do not substitute for re-inspection of the original files during import.

The historical files named `links.json` and `links.csv` should be distinguished from the current repository files `links.json` and `links.csv`. Their contents must be compared with the master directory and the canonical database before any additional link records are added.

---

## 6. Source and verification policy

The profile owner maintains the archive and states that the supplied academic, professional and profile information and source links have been manually and independently checked against their relevant references.

The database maintains source attribution and verification history to support traceability.

The following distinctions are maintained:

- Source provenance identifies where information originated.
- Record verification describes the evidence review associated with a canonical record.
- Link availability describes whether a URL is accessible.
- Historical verification records preserve previous checks.
- Reconciliation records document corrections and differences between source datasets.

These are separate aspects of data stewardship.

Repository documentation provides context and discovery information. It does not replace the source records or evidence associated with individual claims.

Similarly, the presence of an institution, conference, award, professional role or research topic in a keyword index does not independently establish a specific relationship or activity. Such details should be represented through their relevant records and supporting references.

---

## 7. Single-database policy

`profile.sqlite` is the sole canonical database published in this directory.

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

Repository documentation may be updated independently of the SQLite database, provided that such changes do not misrepresent the database's actual contents, schema or import status.

---

## 8. Research and intellectual project coverage

The knowledge base is intended to cover the profile's scientific, academic, creative and intellectual work.

Its scope includes:

### 8.1 Scientific and academic research

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

### 8.2 Research methods and experimental work

- Finite element modelling and numerical simulation
- Computational and mathematical methods
- Experimental mechanics and material characterization
- Ultrasonic measurement and guided-wave techniques
- Digital image correlation and high-speed imaging
- Impact testing and dynamic mechanical experiments
- Shape optimization and topology optimization
- Bayesian inverse methods and surrogate modelling

The detailed research keyword and indexing taxonomy is maintained separately in `ORCID_KEYWORDS.md`.

### 8.3 Literature, creative work and interdisciplinary projects

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

## 9. Maintenance and version history

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

Documentation changes should also be traceable. In particular, updates to the README, keyword index, manifest and build report should describe the repository's actual contents and current status.

A documentation-only update does not, by itself, constitute a database schema migration or database rebuild.

Previous information should remain traceable rather than being silently overwritten.

---

## 10. Current project status

**Current stage:** Initial canonical database and documentation established; documentation harmonisation and historical-source reconciliation underway.

### Completed

- Initial SQLite database generation.
- Initial schema version 1.0.
- Import of the 400-entry master link directory.
- Import of 20 supplemental project and GitHub URLs.
- Import of the supplied profile brief and build report.
- Initial provenance and verification-history structure.
- Database integrity and foreign-key validation.
- Project overview and research and intellectual scope documented in the README.
- Description of literature, creative work and interdisciplinary projects in the README.
- ORCID keyword and research index added to the repository.
- Profile knowledge brief added to the repository.
- Initial manifest structure and source inventory established.

### Remaining

- Reconcile the current `links.csv` and `links.json` with `profile.sqlite` and the historical link files.
- Update `DATABASE_BUILD_REPORT.md` against the canonical database and actual repository files.
- Incorporate historical ChatGPT and Perplexity database records after file-level comparison.
- Reconcile research outputs and publication versions.
- Populate academic qualifications and professional appointments from their relevant records.
- Complete detailed authorship and conference presentation records.
- Structure records for independent projects and releases.
- Review and validate the proposed schema version 1.1 migration; the canonical database remains at version 1.0 until a migration is applied.
- Update `DATA_DICTIONARY.md` following schema decisions.
- Rebuild and validate `profile.sqlite` after approved data or schema changes.
- Review and maintain the existing profile knowledge brief against the canonical records.
- Improve public-facing profile pages and discovery.
- Review metadata, crawler access and sitemap coverage.
- Monitor search-engine discovery and indexing.

---

**Maintained by:** Pravinkumar Ramchandra Ghodake

**Canonical database:** `profile.sqlite`

**Current schema:** Version 1.0
