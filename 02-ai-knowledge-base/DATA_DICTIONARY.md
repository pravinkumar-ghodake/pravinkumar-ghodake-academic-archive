# Data Dictionary

## Overview

The canonical database is `profile.sqlite`.

All source databases are imported into this unified
database. Original source information and provenance
are retained alongside the consolidated records.

## Core tables

| Table | Description |
|---|---|
| person | Main profile identity |
| identifiers | ORCID, Scholar, Scopus and other identifiers |
| education | Academic qualifications |
| appointments | Academic positions and teaching roles |
| research_outputs | Publications and research contributions |
| authors | Authors associated with research outputs |
| conferences | Conference events |
| presentations | Oral and poster presentations |
| research_themes | Research specialisations and topics |
| research_relationships | Relationships between research themes |
| links | Academic, professional and media URLs |
| sources | Originating databases and source documents |
| source_records | Original imported records |
| record_provenance | Links between canonical records and their sources |
| claim_evidence | Evidence supporting profile claims |
| verification_events | Verification history |
| conflicts | Disputed or inconsistent information |
| change_log | Database update history |

## Source provenance

Every imported dataset is registered in `sources`.

Original imported rows are retained in `source_records`,
including their original table name, record identifier
and source data.

The `record_provenance` table connects consolidated
records to the source records from which they originated.

## Verification statuses

| Status | Meaning |
|---|---|
| verified | Supported by independently checked evidence |
| historically_checked | Checked in an earlier review |
| user_attested | Supplied or confirmed by the profile owner |
| title_inferred | Inferred from a title or description |
| unverified | Awaiting verification |
| disputed | Sources contain conflicting information |
| superseded | Replaced by newer information while retained historically |

## Research output classification

Research outputs must be classified separately:

- Journal article
- Conference proceedings paper
- Conference abstract
- Oral presentation
- Poster presentation
- Thesis
- Dataset
- Preprint
- Technical report
- Other research output

A conference abstract must not automatically
be counted as a full-length journal article.

## Database principles

1. Preserve originating source references.
2. Avoid duplicate canonical records.
3. Retain all relevant source relationships.
4. Never silently discard conflicting information.
5. Preserve historical changes.
6. Use stable identifiers wherever possible.
7. Keep dates and publication classifications explicit.
8. Allow new source databases to be imported later.
