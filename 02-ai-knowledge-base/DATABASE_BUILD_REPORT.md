# Database Build Report

## 1. Project

**Database:** Pravinkumar Ghodake Academic Knowledge Base

**Primary database:** `profile.sqlite`

**Database format:** SQLite

**Schema version:** 1.0

**Build stage:** Initial database construction

## 2. Purpose

The database provides one consolidated, structured and
machine-readable representation of the academic and
professional profile of Pravinkumar Ramchandra Ghodake.

It is designed to integrate information from multiple
independent databases and source collections into one
canonical database.

## 3. Initial database contents

The initial build includes:

| Content | Records |
|---|---:|
| Profile identity | 1 |
| Canonical links | 419 |
| Original link entries | 420 |
| Research themes | 10 |
| Working research narrative | 1 |
| Source datasets | 4 |
| Original source records | 435 |
| Provenance relationships | 433 |

Some original link entries resolve to the same canonical
URL. Their separate source references are retained.

## 4. Database structure

The schema includes tables for:

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
- Database change history

## 5. Validation

The initial database build was checked for:

- SQLite database integrity
- Foreign-key consistency
- Table and index creation
- Database view creation
- Basic database access

Reported initial validation results:

| Check | Result |
|---|---|
| SQLite integrity check | Passed |
| Foreign-key violations | 0 |
| Tables | 25 |
| Views | 4 |
| Indexes | 30 |

## 6. Source integration status

The database is designed to combine records from ChatGPT,
Perplexity, user-provided directories and other relevant
academic information sources.

The initial build does not yet represent the complete
record-level integration of all historical databases.

Additional datasets will be incorporated progressively
into the same canonical database.

## 7. Data quality and verification

Records retain source attribution and verification status.

A source-listed entry is not automatically an independently
verified academic fact.

Research outputs must be classified separately as journal
articles, conference proceedings, conference abstracts,
presentations, datasets, theses and other record types.

Duplicates and conflicting claims should be documented
without silently discarding their original provenance.

## 8. Maintenance and versioning

The database is intended to be continuously maintained.

Future updates should document:

- New source datasets
- Newly imported records
- Updated academic information
- Duplicate resolution
- Verification changes
- Conflict resolution
- Database schema changes

Existing historical records should remain traceable.

## 9. Current status

This is an initial working build.

The database will evolve as additional historical datasets,
academic records and independently checked information
are incorporated.

The canonical database should be updated through
documented and reproducible import procedures.
