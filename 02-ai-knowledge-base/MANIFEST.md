# Manifest — Academic & Intellectual Knowledge Base

**Project:** Pravinkumar Ramchandra Ghodake — Academic & Intellectual Knowledge Base

**Canonical database:** `profile.sqlite`

**Database format:** SQLite

**Current schema:** Version 1.0

**Manifest last updated:** 2026-11-17

---

## 1. Purpose

This manifest documents the files, datasets, source records,
provenance and integration status of the consolidated
academic and intellectual knowledge base.

The project maintains one canonical database on GitHub.

Information from multiple independently maintained
datasets and source collections is progressively
incorporated into this database.

Original database files are retained by the profile owner
as local backups. Imported source records and their
provenance are maintained inside the canonical database.

This manifest is updated whenever a source is added,
an import is completed, or a significant database
structure or documentation change is made.

## 2. Current repository files

| File or directory | Purpose | Current status |
|---|---|---|
| `README.md` | Project overview, identity and data stewardship | Present |
| `profile.sqlite` | Consolidated canonical database | Present; initial populated build |
| `schema.sql` | SQLite database schema | Present; version 1.0 |
| `DATA_DICTIONARY.md` | Table and field documentation | Present; schema alignment to be completed |
| `DATABASE_BUILD_REPORT.md` | Build statistics and validation | Present |
| `MANIFEST.md` | Source and file provenance register | Present |
| `PROFILE_KNOWLEDGE_BRIEF.md` | Human-readable academic and intellectual profile | Planned |
| `migrations/` | Versioned schema migrations | Planned |
| `reconciliation/` | Reconciliation reports and documented decisions | Planned |
| `exports/` | Generated CSV and JSON representations | Optional future addition |

## 3. Current canonical database inventory

The initial populated database contains the following records.

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

The 420 original link entries from the master directory
and supplemental list resolve to 419 canonical link records.

Original source entries are retained through the
source-record and provenance structure.

These counts describe the current database build.
They are not claimed to represent the final complete
academic and intellectual profile.

## 4. Registered source datasets

The following source datasets are currently registered
in the `sources` table of `profile.sqlite`.

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

The directory contains 400 link entries organised
into 11 original sections.

Its stored transcription preserves the supplied
section organisation and URL entries.

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

The supplemental entries include links to the
Three Harmonics and Verse & Variable projects
and the associated GitHub account and repositories.

One normalized URL duplicates a target already
present in the master directory. Both source entries
are retained, while the canonical link is deduplicated.

### SRC-BRIEF-001 — Profile knowledge brief

| Field | Value |
|---|---|
| Original filename | `PROFILE_KNOWLEDGE_BRIEF(1).md` |
| Source type | Other AI / vendor unattributed |
| Acquisition date | 2026-11-16 |
| Imported source records | 14 |
| Import batch | `BATCH-BRIEF-001` |
| Import status | Completed with warnings |

The source contains profile identity strings,
research themes, a working research narrative
and publication-classification guidance.

The originating AI vendor is not asserted because
the available source metadata does not establish it.

### SRC-REPORT-001 — Database build report

| Field | Value |
|---|---|
| Original filename | `BUILD_REPORT(3).md` |
| Source type | Other AI / vendor unattributed |
| Acquisition date | 2026-11-16 |
| Imported source records | 1 |
| Import batch | `BATCH-REPORT-001` |
| Import status | Completed |

The report documents the construction of the
400-link directory and its category counts.

Its aggregate figures are retained as source information
and are not automatically treated as separate
independently verified academic records.

## 5. Historical datasets awaiting incorporation

Additional databases and exports have been supplied
or referenced in previous project conversations.

They are not yet counted as imported source datasets
in the current canonical database.

The following historical materials remain candidates
for comparison and integration.

| Historical source artifact | Information available | Current status |
|---|---|---|
| `links(1).json` | Reported 400-link JSON export | Awaiting record-level comparison |
| `links(1).csv` | Reported matching 400-row CSV export | Awaiting record-level comparison |
| `pravinkumar_ghodake_knowledge.db` | Previously inspected SQLite database; six tables and 437 rows were reported | Awaiting import |
| `pravinkumar_ghodake_ai_context_brief.md` | Earlier 27-line profile context brief | Awaiting comparison |
| `ghodake_profile(1).db` | Historical Perplexity-labelled database export | Awaiting import |
| `Ghodake Profile Database (JSON)(1).json` | Historical Perplexity-related structured profile export | Awaiting import |
| `pravinkumar_ghodake_knowledge.json` | Structured knowledge export; vendor attribution not established | Awaiting import |
| Perplexity JSON and SQL schema export | Historical structured source export | Awaiting file-level comparison |
| Earlier ChatGPT knowledge-base package | Previously generated database and documentation package | Awaiting comparison |

Historical file descriptions are retained as provenance
leads. They do not substitute for re-inspection
of the original files during import.

In particular, the reported 400-link JSON and CSV exports
must be compared with the already imported master
directory before any additional link records are added.

## 6. Source and verification policy

The profile owner maintains the archive and states that
the supplied academic, professional and profile information
and source links have been manually and independently
checked against their relevant references.

The database maintains source attribution and
verification history to support traceability.

The following distinctions are maintained:

- Source provenance identifies where information originated.
- Record verification describes the evidence review
  associated with a canonical record.
- Link availability describes whether a URL is accessible.
- Historical verification records preserve previous checks.
- Reconciliation records document corrections and
  differences between source datasets.

These are separate aspects of data stewardship.

## 7. Single-database policy

`profile.sqlite` is the sole canonical database
published in this directory.

Additional source databases are incorporated into
the existing canonical database through documented
import and reconciliation procedures.

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

Original database files remain available as
profile-owner backups outside this public repository.

## 8. Research and intellectual project coverage

The knowledge base is intended to cover the profile's
scientific, academic, creative and intellectual work.

This includes:

- Academic qualifications and professional roles
- Independent scientific research
- Publications and conference contributions
- Research datasets and software
- Literature and multilingual creative writing
- Independent publishing initiatives
- Website and software development
- Intellectual essays and independent projects

Related records are connected through the canonical
database rather than maintained as competing profiles.

## 9. Maintenance and version history

New source datasets and records are incorporated
through documented updates.

Every significant update should identify:

1. The originating source.
2. The acquisition or update date.
3. The records imported or modified.
4. Any duplicate records identified.
5. Any conflicts or corrections.
6. The resulting database version.
7. The validation results.

The canonical database must remain structurally
consistent with its published schema and data dictionary.

Previous information should remain traceable
rather than being silently overwritten.

## 10. Current project status

**Current stage:** Initial canonical database and
documentation established.

**Completed:**
- Initial SQLite database generation.
- Initial schema version 1.0.
- Import of the 400-entry master link directory.
- Import of 20 supplemental project and GitHub URLs.
- Import of the supplied profile brief and build report.
- Initial provenance and verification-history structure.
- Database integrity and foreign-key validation.

**Remaining:**
- Incorporation of historical ChatGPT and Perplexity database records.
- Reconciliation of research outputs and publication versions.
- Population of academic qualifications and professional appointments.
- Detailed authorship and conference presentation records.
- Structured representation of independent projects and releases.
- Schema migration and documentation updates.
- Creation of the comprehensive profile knowledge brief.
- Public-facing profile pages and discovery improvements.

---

**Maintained by:** Pravinkumar Ramchandra Ghodake

**Canonical database:** `profile.sqlite`

**Current schema:** Version 1.0
