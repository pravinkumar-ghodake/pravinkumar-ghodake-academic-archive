# Schema v1.1 Migration Plan

## Pravinkumar Ghodake Academic and Intellectual Knowledge Base

**Profile:** Pravinkumar Ramchandra Ghodake  
**Canonical database:** `profile.sqlite`  
**Inspected database:** `profile.sqlite`  
**Current schema version:** 1.0  
**Target schema version:** 1.1  
**Plan date:** 2026-11-17  
**Last reviewed:** 2026-11-18  
**Status:** Proposed target design; migration SQL drafted; review and testing pending  
**Migration execution:** Not started  
**Database modifications:** None; the canonical database remains at Version 1.0

---

## 1. Purpose

This document establishes the design and migration plan for upgrading the canonical SQLite database from schema version 1.0 to schema version 1.1.

The objective is to strengthen the database architecture before importing the larger academic, scientific, professional, literary, creative and digital portfolio.

Version 1.1 will extend the existing database rather than replace its fundamental architecture.

The migration aims to:

- Preserve all existing canonical records.
- Preserve original source records and provenance.
- Introduce structured project and creative-work records.
- Support project contributors and independent intellectual projects.
- Represent software and content licensing separately.
- Improve conference contribution and participation records.
- Introduce structured reconciliation decisions.
- Improve database constraints and record-type consistency.
- Establish a structured keyword-indexing system.
- Separate factual verification from URL availability.
- Improve record timestamps and change tracking.
- Maintain a single canonical SQLite database.

This plan is based on the actual Version 1.0 database inspection results recorded below, not solely on the original SQL definition.

The migration SQL has been drafted but has not been tested or applied to the canonical database.

---

## 2. Actual Version 1.0 database inspection

### 2.1 Inspected database file

The inspected database is:

`profile.sqlite`

This is the canonical Version 1.0 SQLite database maintained in the repository.

| Attribute | Inspected value |
|---|---|
| Database filename | `profile.sqlite` |
| SQLite version | 3.46.1 |
| File size | 1,351,680 bytes |
| Approximate size | 1.29 MiB |
| Schema version | 1.0 |
| Database integrity | Passed |
| Foreign-key violations | 0 |
| Inspection mode | Read-only |

**SHA-256:**

`16d00294c2ed71963399a2dafdd1e8256f0d8bfbf45580ed7b8f42ed73904cde`

The checksum identifies the inspected canonical database and should be retained as its inspection reference.

The original canonical database should remain unchanged until the migration has been successfully tested and approved.

### 2.2 Structural inspection results

The actual database contains:

| Database object | Actual count |
|---|---:|
| Tables | 25 |
| Views | 4 |
| Indexes | 30 |
| **Total canonical records** | **431** |

The previously documented structural counts are therefore confirmed by the inspected database.

### 2.3 SQLite integrity results

| Check | Actual result |
|---|---|
| SQLite integrity check | `ok` |
| Foreign-key violations | 0 |
| Schema version | 1.0 |
| Database modification during inspection | None |

The integrity check and foreign-key check passed.

However, the inspection connection reported foreign-key enforcement as disabled.

This is an important connection-level setting and is addressed in the migration safety requirements in Section 12.

---

## 3. Actual record inventory

The canonical record distribution is:

| Record type | Actual records |
|---|---:|
| Links | 419 |
| Research themes | 10 |
| Profile subject | 1 |
| Profile claim | 1 |
| **Total canonical records** | **431** |

The sum of these record categories accounts for all 431 canonical records.

### 3.1 Supporting source information

| Component | Actual records |
|---|---:|
| Registered source datasets | 4 |
| Import batches | 4 |
| Original source records | 435 |
| Record provenance relationships | 433 |

The database contains multiple source representations supporting its canonical records.

The difference between the 435 original source records and the 433 provenance relationships is explained by two source records that do not currently have canonical provenance relationships.

These are identified in Section 5.

### 3.2 Existing specialized-table population

The inspected database currently contains zero records in the following specialized tables:

| Table | Actual records |
|---|---:|
| `education` | 0 |
| `institutions` | 0 |
| `identifiers` | 0 |
| `appointments` | 0 |
| `research_outputs` | 0 |
| `output_authors` | 0 |
| `conferences` | 0 |
| `presentations` | 0 |
| `awards` | 0 |
| `research_relationships` | 0 |
| `verification_events` | 0 |
| `conflicts` | 0 |

The `people` table contains the profile-subject record, and the existing canonical link, research-theme and claim records are represented through their corresponding specialized tables.

The inspection also confirms that all 431 canonical records have corresponding specialized-table records and provenance relationships.

### 3.3 Consequence for migration design

The current database is primarily a:

**Link and research-theme foundation with source provenance.**

It is not yet a populated academic publication, education or conference database.

This is an important architectural opportunity.

The existing specialized tables for publications, education, authorship, conferences, presentations, awards, conflicts and verification events are empty.

Consequently, Version 1.1 can establish stronger structures in these areas before the larger academic dataset is imported.

This does not remove the need to preserve the existing 431 canonical records, their identifiers, source relationships and provenance.

---

## 4. Actual data-quality findings

The following findings were recorded during inspection of the populated Version 1.0 database.

### 4.1 Canonical records and provenance

**Result: Passed**

- All 431 canonical records have corresponding specialized-table records.
- All 431 canonical records have provenance relationships.
- The database contains 433 provenance relationships.
- No duplicate canonical keys were detected.

The provenance relationships should be preserved during migration.

### 4.2 Original source-record payloads

**Result: Passed**

All 435 source-record payloads contain valid JSON.

All 435 source records have content hashes.

This means the existing original source payloads already have individual content-integrity references.

These content hashes must be retained.

### 4.3 Duplicate and empty URL checks

**Result: Passed**

The inspection detected:

- No empty URLs.
- No duplicate normalized URLs.
- No duplicate canonical keys.

The existing link collection therefore has no detected duplicate normalized URL values in the inspected database.

A stronger uniqueness constraint is still a design decision because future URL-normalization rules and link relationships must be considered before enforcing it.

### 4.4 Correctly deduplicated GitHub account URL

The same GitHub account URL appears in both:

- The master directory source dataset.
- The supplemental link source dataset.

It is represented by:

- One canonical link record.
- Two separate provenance relationships.

This is the intended treatment.

Both original source entries remain traceable while the canonical database avoids creating duplicate destination records.

No modification to this relationship is required.

### 4.5 Source-only records

Two source records currently have no canonical provenance relationship:

| Source record ID | Description |
|---|---|
| `BRIEF-RULE-001` | Methodological instruction from the original profile brief |
| `BUILD-REPORT-CONTENT` | Preserved build-report text |

These are source-only materials.

Their lack of canonical provenance is not automatically a database error.

They should remain preserved as original source records. They should not be forced into the canonical profile as factual academic or biographical records.

The future reconciliation framework should be able to retain and classify source-only material.

### 4.6 Missing source-file checksums

Two registered source datasets lack recorded source-level SHA-256 checksums:

- Master directory dataset.
- Supplemental link dataset.

This is distinct from the individual source-record content hashes, which are present for all 435 source records.

Proposed action:

Calculate and register the original source-file checksum when the corresponding original source artifact is available.

Do not fabricate a source-file checksum from the imported records or payloads.

### 4.7 Research themes

The ten existing research themes have:

| Field | Actual state |
|---|---|
| Number of themes | 10 |
| Theme classifications | All `unclassified` |
| Record verification status | All `title_inferred` |
| Keyword arrays | Empty |

These records remain provisional.

They must not be silently treated as a completed structured import of `ORCID_KEYWORDS.md`.

Their classification and keyword relationships should be reviewed before importing the larger research-interest taxonomy.

### 4.8 Profile claim

The database contains one profile-related claim originating from the unattributed AI brief.

Its current characteristics are:

- Classified as `title_inferred`.
- No claim-evidence rows.
- Derived from an unattributed AI-generated source.
- Represents a working profile interpretation rather than an independently established biographical fact.

This claim should remain provisional and source-attributed.

It should not be promoted to a definitive profile statement merely because it is present in the database.

---

## 5. Verification semantics and current database status

This is one of the most important design areas for Version 1.1.

The profile owner has stated that supplied profile information and links have been manually and independently checked against relevant references.

The current database nevertheless records all 419 links as unverified.

This is not necessarily a factual contradiction.

The database currently distinguishes insufficiently between different kinds of verification.

### 5.1 Actual link-status values

| Field | Actual value |
|---|---|
| Number of link records | 419 |
| `links.link_status` | All 419 `unverified` |
| `records.verification_status` for link records | All 419 `unverified` |
| Verification-history events | 0 |

The database does not currently contain individual verification events documenting those manual checks.

It also does not establish that all 419 URLs are currently reachable.

### 5.2 Three separate verification dimensions

Version 1.1 should distinguish the following:

**1. Reference/content verification**

Whether the associated information has been checked against an appropriate reference.

Examples:

- Publication title checked against a publisher record.
- Academic information checked against an institutional record.
- Project information checked against an official repository.
- Profile information checked against a relevant original reference.

**2. URL availability**

Whether the linked destination is currently reachable and what response or redirection status has been observed.

Possible states include:

- Active
- Redirected
- Broken
- Restricted
- Unverified

**3. Historical verification**

Whether the information was checked at an earlier date, by whom, and against what supporting evidence.

A historical check does not automatically establish that a URL remains reachable today.

### 5.3 Proposed verification architecture

The existing fields should be assigned clear responsibilities.

| Existing field or table | Proposed responsibility |
|---|---|
| `records.verification_status` | Verification state of the canonical record's substantive information |
| `links.link_status` | Current recorded URL availability state |
| `verification_events` | Historical record of what was checked, how and when |
| `claim_evidence` | Evidence associated with an individual profile claim |

The verification-event structure should be extended with an explicit verification scope.

The drafted migration currently allows these scopes:

- `content`
- `reference`
- `metadata`
- `url_availability`
- `historical`

These values remain subject to design review before migration approval.

### 5.4 Important rule

Do not mark all 419 links as `active` merely because their information has previously been manually checked.

Do not automatically change their factual verification status either.

Existing values should remain intact until appropriate verification events and supporting references are documented.

---

## 6. Version 1.1 design objectives

The actual database inspection supports the following design objectives.

1. Preserve the current 431 canonical records.
2. Preserve all 435 original source records and their content hashes.
3. Preserve all 433 existing provenance relationships.
4. Retain source-only material without forcing canonical factual records.
5. Establish dedicated project and creative-work structures.
6. Introduce project-level contributor relationships.
7. Separate software and content licensing.
8. Improve conference contribution and participation modelling.
9. Introduce structured reconciliation decisions.
10. Correct the conflict-item primary-key design before conflict records are introduced.
11. Establish structured research keyword indexing.
12. Separate factual verification from URL availability.
13. Enforce record-type consistency.
14. Establish a single canonical title policy.
15. Improve timestamp handling.
16. Preserve existing URLs and their source relationships.
17. Enable safe future imports of academic and professional records.

The target remains one canonical SQLite database.

---

## 7. Proposed Version 1.1 tables

The following tables are proposed additions.

The initial Version 1.1 definitions are drafted in `migrations/001_schema_v1_0_to_v1_1.sql`. They remain proposed until the design review and migration testing are complete. The migration has not been applied to the canonical database.

### 7.1 Projects

**Proposed table:** `projects`

Purpose:

Represent independent scientific, literary, publishing, software, website and digital projects.

Potential fields:

- `record_id`
- `project_type`
- `project_status`
- `start_date`
- `end_date`
- `primary_url`
- `description`
- `notes`

The project's canonical title should be maintained through `records.title`.

Potential project types include:

- Scientific research project
- Literary project
- Creative writing project
- Independent publishing initiative
- Website or digital platform
- Software project
- Research communication project
- Interdisciplinary intellectual project
- Other

A project type describes the nature of the work. It does not establish an institutional appointment or employment relationship.

### 7.2 Project contributors

**Proposed table:** `project_contributors`

Purpose:

Represent the people involved in individual projects and their specific roles.

Potential fields:

- `project_record_id`
- `person_record_id`
- `contributor_role`
- `contributor_order`
- `start_date`
- `end_date`
- `notes`

This supports independently maintained projects as well as collaborative projects.

Contributor roles must be recorded per project.

### 7.3 Creative works

**Proposed table:** `creative_works`

Purpose:

Represent literary, multilingual, intellectual and other creative outputs separately from scientific research publications.

Potential fields:

- `record_id`
- `work_type`
- `language`
- `medium`
- `publication_date`
- `publisher`
- `primary_url`
- `description`
- `notes`

The canonical title will be maintained in `records.title`.

### 7.4 Project and creative-work relationships

**Proposed table:** `project_creative_works`

Purpose:

Connect individual creative works to broader literary, publishing and intellectual projects.

Potential fields:

- `project_record_id`
- `creative_work_record_id`
- `relationship_type`
- `notes`

An individual creative work should remain independently identifiable even when it belongs to a larger project.

### 7.5 Project releases

**Proposed table:** `project_releases`

Purpose:

Represent identifiable software, publishing or digital-project releases.

Potential fields:

- `release_id`
- `project_record_id`
- `release_version`
- `release_type`
- `release_date`
- `release_url`
- `repository_url`
- `notes`

The drafted migration models project releases as project-specific child records, not as common entities in `records`.

### 7.6 Record-level licensing

**Proposed table:** `record_licenses`

Purpose:

Record licence information for individual records and specific project components.

Potential fields:

- `license_assignment_id`
- `record_id`
- `license_scope`
- `license_name`
- `license_identifier`
- `license_url`
- `applicable_component`
- `effective_date`
- `source_record_id`
- `notes`

Proposed licence scopes:

- Code
- Written content
- Creative work
- Dataset
- Documentation
- Media
- Other

The licensing system must allow different licensing arrangements for different parts of the same project.

A repository-level code licence must not automatically be interpreted as the licence for every piece of written or creative content.

### 7.7 Conference participation

**Proposed table:** `conference_participations`

Purpose:

Represent individual roles and activities at conferences, scientific meetings and academic events.

Potential fields:

- `participation_id`
- `conference_record_id`
- `person_record_id`
- `presentation_record_id`
- `participation_role`
- `participation_status`
- `participation_date`
- `notes`

Potential roles:

- Author
- Presenter
- Co-presenter
- Attendee
- Organizer
- Committee member
- Session chair
- Reviewer
- Other

Participation roles and participation statuses should be stored separately.

This table must support multiple contributors and roles for a single event.

### 7.8 Presentation-to-output relationship

**Proposed modification:** add an optional `output_record_id` to `presentations`.

Purpose:

Link a presentation to its corresponding research output or conference abstract where the relationship is supported.

This will distinguish:

- Research output or conference abstract
- Conference submission or accepted contribution
- Actual presentation
- Individual conference participation

A submission does not automatically prove that a presentation occurred.

A presentation must remain its own distinct record.

The two iNCMDAO-related contributions must remain separate and should retain their respective titles, authorship, submission records and presentation information.

### 7.9 Reconciliation decisions

**Proposed table:** `reconciliation_decisions`

Purpose:

Represent formal source-comparison decisions in the canonical database.

Potential fields:

- `decision_id`
- `decision_date`
- `reconciliation_category`
- `classification`
- `decision_status`
- `decision_summary`
- `decision_rationale`
- `evidence_summary`
- `implemented_at`
- `notes`

Potential classifications:

- Exact duplicate
- Equivalent representation
- Complementary information
- Updated information
- Factual discrepancy
- Source-specific information
- Unsupported information
- Not comparable
- Pending assessment

Potential decision statuses:

- Proposed
- Under review
- Approved
- Implemented
- Unresolved
- Deferred

### 7.10 Reconciliation decision items

**Proposed table:** `reconciliation_decision_items`

Purpose:

Associate decisions with original source records and canonical records.

Potential fields:

- `decision_item_id`
- `decision_id`
- `canonical_record_id`
- `source_record_id`
- `item_role`
- `observed_value`
- `notes`

A decision should be able to involve multiple source records and multiple canonical records.

The structure should support source-only records as well as source records already linked to canonical entities.

### 7.11 Keyword taxonomy

**Proposed tables:**

- `keywords`
- `record_keywords`

Purpose:

Provide structured research and academic keyword indexing.

The existing ten research themes and the extensive `ORCID_KEYWORDS.md` taxonomy should be represented through a consistent, traceable indexing model.

Potential keyword categories include:

- Research domain
- Research topic
- Method
- Material
- Experimental technique
- Computational technique
- Application
- Academic discipline
- Identity or profile descriptor
- Platform or discovery term

A keyword assignment should be able to identify its origin or supporting source where available.

The indexing system must distinguish:

- A central research specialization
- An established research topic
- An adjacent research interest
- A method
- An application
- An ORCID indexing term
- A broader discovery keyword

Keyword presence must not automatically imply an equal level of specialization or prove that a technique was used in every research output.

### 7.12 Verification-event enhancement

**Proposed modification:** add an explicit verification scope to `verification_events`.

Purpose:

Distinguish content/reference checks from URL availability checks and historical verification.

Potential field:

- `verification_scope`

The drafted migration currently constrains this field to the scopes listed in Section 5.3. These values remain proposed until the migration design is approved.

This is intended to preserve the existing verification history model while making its meaning clearer.

---

## 8. Proposed modifications to existing tables

### 8.1 Records

The `records.record_type` CHECK constraint should be expanded to include the approved new entity types.

The drafted migration adds:

- `project`
- `creative_work`
- `conference_submission`

Project releases remain project-specific child records and are not added as a `records.record_type`.

This change requires rebuilding the `records` table because SQLite does not directly support replacing an existing CHECK constraint through a simple `ALTER TABLE`.

The final set of record types must be approved before the migration is executed.

### 8.2 Research outputs and canonical titles

The current schema stores titles in both:

- `records.title`
- `research_outputs.title`

This creates a potential inconsistency.

The inspected `research_outputs` table contains zero records.

This provides an opportunity to establish the canonical title policy before publication imports begin.

**Proposed policy:**

`records.title` will be the single canonical title.

`research_outputs` will retain publication-specific metadata such as:

- Output type
- Abstract
- DOI
- Publication date
- Publication year
- Venue
- Publisher
- Volume
- Issue
- Page range
- Publication status
- Peer-review status
- Primary URL
- Supplementary data URL
- Notes

The duplicated `research_outputs.title` column should be removed from the Version 1.1 design.

Appropriate validation must ensure that a research-output record has a non-empty canonical title in `records`.

### 8.3 Presentations

Add an optional `output_record_id` relationship.

The migration must preserve all existing presentation metadata and should not infer relationships that have not been established by source evidence.

The existing presentations table is empty, so the new design can be established before conference imports.

### 8.4 Conflict items

The current `conflict_items` table uses a composite primary key involving nullable columns:

- `conflict_id`
- `record_id`
- `source_record_id`

This is not a sufficiently explicit integrity design.

The table currently contains no records.

**Proposed replacement:**

- Introduce `conflict_item_id` as a dedicated primary key.
- Retain the foreign key to `conflicts`.
- Retain the optional foreign key to `records`.
- Retain the optional foreign key to `source_records`.
- Require at least one of `record_id` or `source_record_id` to be populated.
- Preserve `competing_value` and `notes`.

The table should be rebuilt during migration.

### 8.5 Record-type consistency

Foreign-key relationships alone do not ensure that a specialized table references the correct record type.

For example, a record referenced by `research_outputs.record_id` must have `records.record_type = 'research_output'`.

Version 1.1 should introduce appropriate validation triggers for specialized tables.

At minimum, consider:

- People
- Institutions
- Identifiers
- Education
- Appointments
- Research outputs
- Conferences
- Presentations
- Conference submissions
- Research themes
- Research relationships
- Links
- Awards
- Claims
- Projects
- Creative works

Project releases are project-specific child records rather than common `records` entities.

Validation should be applied during insertion and when a specialized record or its parent record is updated.

The drafted migration includes record-type validation triggers. The preflight and pre-commit guards must also check that the existing populated records match their specialized-table types; triggers alone do not verify existing rows.

The complete trigger inventory will be documented in the revised `schema.sql`.

### 8.6 Record timestamps

The current `records.updated_at` field has a default value but no automatic update mechanism in the supplied SQL.

Introduce a controlled update trigger to update the timestamp when relevant record fields change.

The trigger should:

- Avoid uncontrolled recursive updates.
- Avoid changing `created_at`.
- Not overwrite an explicitly managed historical timestamp unintentionally.
- Be tested with the SQLite version used for migration.

### 8.7 Source checksums

The existing `sources` table already includes `checksum_sha256`.

No new field is required for the two missing source-file checksums.

Once the original source artifacts are available, calculate their SHA-256 values and update the corresponding source records.

The 435 existing source-record content hashes must remain unchanged.

### 8.8 URL uniqueness and indexes

The actual database contains no duplicate normalized URLs.

This is a positive finding.

However, enforcing a unique constraint should depend on the final normalization policy and the intended treatment of multiple relationships to one destination.

The existing index should be preserved unless the audit establishes a reason to change it.

---

## 9. Migration implications of the actual database

The populated database audit changes the migration strategy in several important ways.

### 9.1 No existing publication data needs to be migrated

The `research_outputs` table is empty.

Therefore:

- The canonical-title policy can be established before publication records are imported.
- The final research-output structure can be defined without transforming existing publication rows.
- The `output_authors` table can be revised before authorship relationships are imported.

### 9.2 No existing education or institution records need transformation

The `education` and `institutions` tables are empty.

The Version 1.1 design can establish the desired constraints before academic history is imported.

### 9.3 No existing conference or presentation records need transformation

The `conferences` and `presentations` tables are empty.

The revised conference contribution model can be established before importing the relevant academic event records.

### 9.4 No existing conflict records need transformation

The `conflicts` table is empty.

The conflict-item structure can be corrected before any actual conflicts are registered.

### 9.5 No existing verification events need transformation

The `verification_events` table is empty.

A more precise verification-scope design can be introduced before verification-history imports begin.

### 9.6 Existing records still require preservation

Although many specialized tables are empty, the following records must be preserved:

- 431 canonical records
- 435 source records
- 4 source datasets
- 4 import batches
- 433 provenance relationships
- All existing source identifiers
- All source payloads
- All source-record content hashes
- All existing link relationships
- All existing research-theme records
- The existing profile subject and profile claim

The migration must not treat the empty specialized tables as permission to discard the existing foundation.

---

## 10. Proposed Version 1.1 architecture

The intended architecture consists of five connected areas.

### 10.1 Identity and academic records

Existing structures to retain:

- People
- Institutions
- Identifiers
- Education
- Appointments
- Awards
- Research outputs
- Output authors
- Conferences
- Presentations
- Research themes
- Research relationships

### 10.2 Projects and creative work

Proposed additions:

- Projects
- Project contributors
- Creative works
- Project-to-creative-work relationships
- Project releases
- Record-level licensing

### 10.3 Conference participation

Proposed improvements:

- Direct research-output relationship for presentations
- Conference participation roles
- Multiple people and roles per event
- Clear distinction between authorship, submission, presentation and attendance

### 10.4 Source and reconciliation management

Existing structures to retain:

- Sources
- Import batches
- Source records
- Record provenance
- Conflicts
- Conflict items
- Claims
- Claim evidence

Proposed additions:

- Reconciliation decisions
- Reconciliation decision items

### 10.5 Research indexing and verification

Proposed additions and improvements:

- Keyword taxonomy
- Record-to-keyword relationships
- Verification scopes
- Clear URL availability semantics
- Controlled timestamp handling

The architecture remains a single canonical SQLite database supported by documented source provenance.

---

## 11. Migration sequence

The migration must follow a controlled sequence.

### Stage 1 — Preserve the original database

Create a backup of the original Version 1.0 database.

Record:

- Filename
- File size
- Database version
- SHA-256 checksum
- Backup date

Preserve the inspected file checksum as the historical inspection reference:

`16d00294c2ed71963399a2dafdd1e8256f0d8bfbf45580ed7b8f42ed73904cde`

Do not overwrite the original database during initial migration testing.

### Stage 2 — Finalize Version 1.1 design

Confirm:

- Final record-type taxonomy.
- New table definitions.
- New foreign-key relationships.
- Keyword taxonomy.
- Verification semantics.
- Conference participation structure.
- Canonical-title policy.
- Conflict-item primary key.
- Record-type validation triggers and existing-record consistency checks.
- Timestamp behavior.
- Index and view changes.

Record every approved design decision.

### Stage 3 — Review and finalize the drafted migration SQL

Migration file:

`migrations/001_schema_v1_0_to_v1_1.sql`

The migration has been drafted and is under review. Before testing it, confirm that it:

- Confirms the expected starting schema version.
- Checks that it is running against the intended database version.
- Preserves the current canonical records.
- Preserves source records and content hashes.
- Preserves provenance relationships.
- Checks that existing records match their specialized-table types.
- Rebuilds constrained tables where required.
- Creates the approved new tables.
- Adds approved relationships.
- Adds appropriate indexes and triggers.
- Recreates affected views.
- Checks integrity and foreign keys before commit.
- Updates schema metadata only after successful structural changes.
- Restores foreign-key enforcement after the transaction.

The script is intended for a separate copy of Version 1.0 `profile.sqlite` and must not be run against the canonical database during review.

### Stage 4 — Test using a separate database copy

The initial migration must run against a copy of the Version 1.0 database.

Do not apply the migration directly to the original canonical database.

The test should verify:

- Table definitions.
- Indexes.
- Views.
- Triggers.
- Existing record preservation.
- Foreign-key consistency.
- Constraint behavior.
- New table relationships.
- Schema metadata.
- Rollback behavior.

### Stage 5 — Compare pre-migration and post-migration databases

Compare the original and migrated copies.

At minimum, verify preservation of:

| Component | Version 1.0 baseline |
|---|---:|
| Canonical records | 431 |
| Links | 419 |
| Research themes | 10 |
| Profile subject | 1 |
| Profile claims | 1 |
| Registered source datasets | 4 |
| Import batches | 4 |
| Original source records | 435 |
| Provenance relationships | 433 |

Any expected change to these figures must be explicitly documented and justified.

### Stage 6 — Validate Version 1.1 functionality

Test representative valid and invalid operations.

Examples:

- Create a project.
- Associate a project contributor.
- Create a creative work.
- Link a creative work to a publishing project.
- Assign separate code and content licences.
- Connect a presentation to a research output.
- Record multiple conference participation roles.
- Create a reconciliation decision.
- Associate source-only and canonical records with a reconciliation decision.
- Add research keywords to records.
- Record a content-verification event.
- Record a separate URL-availability event.
- Confirm automatic timestamp changes.
- Verify that incompatible record types are rejected.

These tests should be performed only on the separate migration-test database.

### Stage 7 — Final approval and adoption

Only after the migration has passed all validation checks should the migrated copy become eligible to replace the canonical Version 1.0 database.

Preserve the original database backup.

The final adoption must be documented.

---

## 12. Migration and SQLite connection safety

### 12.1 Foreign-key enforcement

The inspection connection reported:

`PRAGMA foreign_keys = OFF`

However, the actual database passed:

`PRAGMA foreign_key_check`

with zero violations.

These observations are compatible.

Foreign-key enforcement is a connection-level SQLite setting. It is not a permanent setting stored in the database file.

### 12.2 Migration procedure

The drafted migration starts with foreign-key enforcement enabled and runs its baseline checks. Because it rebuilds the referenced `records` table, it then disables foreign-key enforcement **before** `BEGIN IMMEDIATE`.

During the transaction, the migration checks `PRAGMA foreign_key_check` and database integrity before it commits. A failed guard must stop the run; use the `sqlite3 -bail` procedure specified in the SQL file.

After a successful commit, the script enables foreign-key enforcement again and runs final checks. Do not change `PRAGMA foreign_keys` while the transaction is active.

Run this procedure only on a separate test copy of the database. Preserve the canonical Version 1.0 database until the tested migration is reviewed and approved.

### 12.3 SQLite version

The inspected database uses SQLite 3.46.1.

Migration SQL and table-rebuild operations should be tested against this version or a compatible later version.

Any SQLite-specific feature used by the migration must be documented.

---

## 13. Required validation

The Version 1.1 migration must pass the following checks.

### 13.1 SQLite integrity

Required:

- `PRAGMA integrity_check`
- `PRAGMA foreign_key_check`

Expected:

- Database integrity result: `ok`
- No unintended foreign-key violations.

### 13.2 Structural validation

Verify:

- Expected table definitions.
- Expected column names and types.
- Expected primary keys.
- Expected foreign keys.
- Expected CHECK constraints.
- Expected unique constraints.
- Expected indexes.
- Expected views.
- Expected triggers.

### 13.3 Canonical record preservation

Compare original and migrated:

- Record identifiers.
- Record types.
- Canonical keys.
- Titles.
- Verification statuses.
- Current/superseded status.
- Source references.
- Provenance relationships.
- Specialized-table record-type relationships.

Existing stable record identifiers should remain unchanged.

### 13.4 Source-record preservation

Verify:

- All 435 source records remain present.
- All 435 source payloads remain valid JSON.
- All 435 source-record content hashes remain unchanged.
- The two source-only records remain preserved.
- The original 433 provenance relationships remain intact.
- The duplicate GitHub URL still has one canonical link record with two provenance relationships.

### 13.5 Link validation

Verify:

- All 419 existing links remain present.
- No empty URLs are introduced.
- No unintended duplicate normalized URLs are introduced.
- Existing link labels and categories are preserved.
- Existing link availability states are not changed without documented evidence.

### 13.6 Research-theme validation

Verify:

- All ten existing research themes remain present.
- Their original names and descriptions are preserved.
- Their existing verification statuses remain traceable.
- Their classifications are not automatically promoted.
- Keyword relationships are introduced only through approved, source-attributed assignments.

### 13.7 Relationship validation

Test:

- Project-to-contributor relationships.
- Project-to-creative-work relationships.
- Project-to-release relationships.
- Record-to-licence relationships.
- Conference-to-presentation relationships.
- Presentation-to-output relationships.
- Conference-to-participation relationships.
- Reconciliation-decision relationships.
- Record-to-keyword relationships.
- Source-to-canonical provenance relationships.

### 13.8 Verification validation

Confirm that:

- Content verification and URL availability remain distinct.
- Historical verification can be recorded separately.
- A manually checked reference does not automatically imply current URL availability.
- Existing unverified link states remain unchanged unless supported by actual checks.
- Verification events retain their source and evidence relationships.

### 13.9 Version validation

The database should report:

`schema_version = 1.1`

Only after every required migration operation has succeeded.

The migration must not update the schema version prematurely.

---

## 14. Decisions requiring approval

The actual database inspection establishes a strong basis for the Version 1.1 design, but several structural decisions still require final approval.

| Decision | Proposed direction | Status |
|---|---|---|
| Extend record-type taxonomy | Add `project`, `creative_work` and `conference_submission`; keep project releases as child records | Drafted; approval pending |
| Project categories | Controlled project-type classification | Proposed |
| Project contributors | Explicit person-to-project roles | Proposed |
| Creative works | Separate specialized table | Proposed |
| Project releases | Project-specific child records | Drafted; approval pending |
| Record-level licensing | Separate scopes for code, content, data and documentation | Proposed |
| Conference participation | Dedicated participation table | Proposed |
| Presentation-to-output relationship | Add `output_record_id` | Proposed |
| Research-output title | Use `records.title` as canonical title | Proposed |
| Conflict-item primary key | Introduce `conflict_item_id` | Proposed |
| Record-type triggers and existing-data checks | Add specialized-table type validation and migration guards | Drafted; approval pending |
| Automatic update timestamps | Controlled timestamp triggers | Proposed |
| Keyword indexing | Add `keywords` and `record_keywords` | Proposed |
| Verification scope | Distinguish content and URL checks | Drafted; approval pending |
| Source-file checksums | Calculate missing checksums from original files | Pending source-file availability |
| URL uniqueness | Retain current structure until normalization policy is approved | Pending |
| Final new table columns and constraints | Drafted in migration SQL; review before approval | Pending |

No proposed structural change should be considered implemented until it has been tested.

---

## 15. Planned migration deliverables

| Deliverable | Purpose | Status |
|---|---|---|
| `SCHEMA_V1_1_MIGRATION_PLAN.md` | Version 1.1 design and migration documentation | Current document |
| Actual Version 1.0 inspection baseline | Original database evidence and record counts | Completed |
| `migrations/001_schema_v1_0_to_v1_1.sql` | Executable migration | Drafted; review and testing pending |
| Updated `schema.sql` | Complete Version 1.1 schema definition | Pending migration review |
| Updated `DATA_DICTIONARY.md` | New tables, relationships and field documentation | To be reconciled with finalized migration |
| Updated `DATABASE_BUILD_REPORT.md` | Actual inspection and migration validation results | To be updated |
| Updated `MANIFEST.md` | Repository inventory and file status | Pending |
| Version 1.1 test database | Safely migrated and validated database copy | Not started |
| Canonical Version 1.1 database | Approved migrated database | Not authorized |

---

## 16. Change-control rules

The following rules apply throughout the migration process:

1. Preserve the original Version 1.0 database.
2. Keep a separate backup and record its SHA-256 fingerprint.
3. Do not execute untested SQL against the canonical database.
4. Enable foreign-key enforcement on each migration or import connection. For the controlled `records` table rebuild, disable it before the transaction and restore it after commit, as documented in the migration SQL. Do not toggle it inside the transaction.
5. Preserve all existing canonical record identifiers.
6. Preserve source records and their original payloads.
7. Preserve provenance relationships.
8. Do not delete source-only material merely because it has no canonical relationship.
9. Do not silently promote provisional themes or claims to verified facts.
10. Do not infer missing authorship, affiliation or conference participation.
11. Do not merge distinct conference contributions.
12. Do not apply one licence to every component of a project without evidence.
13. Do not conflate URL availability with factual verification.
14. Do not impose uniqueness constraints without examining their effect on existing data.
15. Update schema metadata only after successful migration.
16. Document material schema and data decisions.
17. Retain rollback capability until the new canonical database has been validated.

---

## 17. Current implementation status

| Activity | Status |
|---|---|
| Version 1.0 SQL definition review | Completed |
| Actual populated database inspection | Completed |
| SQLite integrity check | Passed |
| Foreign-key violation check | Passed |
| Structural counts confirmed | Completed |
| Canonical record inventory confirmed | Completed |
| Source-record integrity checks | Passed |
| Existing link deduplication reviewed | Completed |
| Source-only records identified | Completed |
| Missing source-file checksums identified | Completed |
| Research-theme provisional status identified | Completed |
| Profile claim evidence gap identified | Completed |
| Verification semantics reviewed | Completed |
| Proposed Version 1.1 structures | Documented |
| Migration SQL draft | Completed; review pending |
| Existing-record type-consistency safeguards | To be added and reviewed |
| Final schema design approval | Pending |
| Migration testing | Not started |
| Version 1.1 database validation | Not started |
| Canonical database replacement | Not authorized |

**Overall status:** The actual Version 1.0 database has been inspected, and the proposed Version 1.1 migration SQL has been drafted. The next task is to reconcile the plan with the SQL, add and review the existing-record type-consistency safeguards, and then test the migration on a separate database copy. The canonical database remains unchanged.

---

## 18. Guiding objective

Version 1.1 is intended to turn the existing link-and-research-theme foundation into a comprehensive academic and intellectual knowledge base.

It must support:

- Academic identity and institutional records.
- Research outputs and authorship.
- Conference submissions and presentations.
- Research themes and keyword indexing.
- Independent scientific projects.
- Literature and multilingual creative work.
- Independent publishing.
- Websites and digital platforms.
- Software and technical projects.
- Project contributors and collaborations.
- Licensing and intellectual-property distinctions.
- Source provenance and reconciliation.
- Verification history and structured evidence.

The migration must achieve this without sacrificing the reliability of the existing 431 canonical records and 435 preserved source records.

The objective is not merely to increase database size or the number of tables.

The objective is a trustworthy, transparent, traceable, maintainable and interoperable archive under the profile owner's control.

---

**Maintained by:** Pravinkumar Ramchandra Ghodake  
**Repository area:** `02-ai-knowledge-base/`  
**Canonical database:** `profile.sqlite`  
**Inspected database:** `profile.sqlite`  
**Current schema:** 1.0  
**Target schema:** 1.1  
**Migration status:** SQL drafted; review and testing pending
