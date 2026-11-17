# Data Dictionary — Academic and Intellectual Knowledge Base

**File:** `02-ai-knowledge-base/DATA_DICTIONARY.md`  
**Document status:** Proposed schema reference  
**Current database schema:** Version 1.0  
**Target schema described here:** Version 1.1  
**Migration status:** Prepared; not executed against the canonical `profile.sqlite` database  
**Last updated:** 2026-11-18

---

## 1. Purpose and status

This document defines the meaning, intended use, and relationships of the principal data structures in the Academic and Intellectual Knowledge Base.

It describes two distinct states:

1. **Version 1.0 — current database baseline.** These are the structures recorded in the inspected `profile.sqlite` database and the committed Version 1.0 schema.
2. **Version 1.1 — proposed target design.** These are the changes described by `migrations/001_schema_v1_0_to_v1_1.sql`.

Version 1.1 is documented here as a design target. Its new tables, columns, triggers, and views must not be treated as present in the canonical database until the migration has been tested, approved, and applied. The migration has not been executed against the canonical database.

This document is a human-readable companion to `schema.sql` and the migration script. The SQL files remain authoritative for exact constraints, column types, foreign keys, indexes, triggers, and executable definitions. For unchanged Version 1.0 tables, this dictionary describes the table's purpose without guessing at column definitions not repeated in the Version 1.1 migration.

## 2. Data-model principles

### 2.1 Canonical records

`records` is the central registry of canonical entities. A canonical record has one `record_id` and one `record_type`. Specialized tables hold domain-specific attributes and refer back to that record.

The canonical record title and description are stored in `records.title` and `records.description`. In the proposed Version 1.1 design, `research_outputs` no longer has a separate title column; the title remains in `records`.

### 2.2 Source records and provenance

Source records describe imported or captured material from which canonical records, claims, relationships, keyword assignments, or other information may be derived.

A source record is not automatically a verified fact. Its origin and content are preserved so that a reader can trace information back to the material from which it came.

`record_provenance` connects canonical records to source records. The proposed Version 1.1 design also introduces dedicated many-to-many source-association tables for project releases, license assignments, and keyword assignments.

### 2.3 Verification is scoped

A record's verification status and a link's availability status describe different things.

- `records.verification_status` describes the epistemic or review state of the canonical record.
- `links.link_status` describes the status of the URL or link record as represented in the Version 1.0 model. It must not be interpreted as proof that the linked content verifies every claim associated with it.
- `verification_events.verification_scope` (proposed in Version 1.1) identifies what kind of verification activity an event concerns.

A URL being reachable does not by itself prove that the page's content is accurate, current, or sufficient evidence for a claim.

### 2.4 Null and unknown values

A `NULL` value means that the value is not recorded in that field. It must not be silently converted into a factual assertion. A status such as `unknown` is an explicit controlled value only where the relevant column's CHECK constraint permits it.

### 2.5 Dates and times

The schema stores date and time values as text. Use consistent ISO 8601 representations where applicable. Do not infer missing start dates, end dates, publication dates, event dates, or effective dates.

### 2.6 Authorship and participation

Authorship, presentation, attendance, organization, reviewing, and other conference roles are distinct relationships. A submission record does not prove that a contribution was accepted or presented. A presentation record does not by itself prove attendance by every author.

## 3. Canonical record structure

### 3.1 `records`

The central table for canonical entities.

| Column | Meaning |
|---|---|
| `record_id` | Stable primary key for the canonical record. |
| `record_type` | Controlled type identifying the domain-specific kind of record. |
| `canonical_key` | Optional normalized key used to identify a record within its type; unique together with `record_type` when present. |
| `title` | Canonical display title or name. |
| `description` | Canonical descriptive text. |
| `verification_status` | Current verification/review classification for the record. |
| `valid_from` | Beginning of the period during which the represented information is valid, when known. |
| `valid_to` | End of that validity period, when known. |
| `is_current` | Integer flag indicating whether the record is treated as current (`1`) or not (`0`). |
| `supersedes_record_id` | Optional self-reference to the prior canonical record superseded by this record. |
| `created_at` | Timestamp when the record was created. |
| `updated_at` | Timestamp of the latest tracked update. |

**Version 1.1 record types:**

- `person`
- `institution`
- `identifier`
- `education`
- `appointment`
- `research_output`
- `conference`
- `presentation`
- `research_theme`
- `research_relationship`
- `link`
- `claim`
- `award`
- `project` — added in Version 1.1
- `creative_work` — added in Version 1.1
- `conference_submission` — added in Version 1.1
- `other`

### 3.2 `verification_status` values

The proposed Version 1.1 CHECK constraint permits the following values:

| Value | Meaning |
|---|---|
| `verified` | Reviewed and verified under the archive's applicable verification process. The supporting evidence and scope should be recorded. |
| `historically_checked` | Checked against historical material or a historical reference. This does not automatically establish present-day status. |
| `user_attested` | Attested by the profile subject or information provider; distinguish this from independent source verification. |
| `title_inferred` | The title or label was inferred rather than directly established from a source. |
| `unverified` | Not yet verified in the database's verification workflow. |
| `disputed` | Conflicting evidence or unresolved disagreement exists. |
| `superseded` | This record has been replaced by a later record or representation. |

These labels describe the state of a record in the database. They do not replace the evidence trail or explain the quality of a source on their own.

## 4. Version 1.0 tables retained in the model

The following tables form the pre-existing Version 1.0 model. Their detailed column definitions remain in the authoritative `schema.sql` file. Their purpose is summarized here; this document does not invent additional columns for them.

| Table | Purpose |
|---|---|
| `schema_metadata` | Stores database-level metadata, including the schema version and database status. |
| `people` | Person-specific details for canonical person records, including the profile-subject record. |
| `institutions` | Institution-specific details for canonical institution records. |
| `identifiers` | Persistent or external identifiers associated with canonical records. |
| `education` | Education-related details associated with canonical education records. |
| `appointments` | Appointment or position details associated with canonical appointment records. |
| `research_outputs` | Bibliographic and publication metadata for research outputs. Modified in Version 1.1; see Section 5.2. |
| `output_authors` | Author/person relationships for research outputs, including author ordering where recorded. |
| `conferences` | Conference/event metadata. |
| `presentations` | Presentation/contribution metadata. Extended in Version 1.1; see Section 5.3. |
| `research_themes` | Structured research-theme records. |
| `research_relationships` | Relationships between research entities or themes. |
| `links` | Canonical URL/link records and link metadata. The existing table remains the URL registry. |
| `awards` | Award-specific details associated with canonical award records. |
| `sources` | Registered source datasets or source collections. |
| `import_batches` | Records the import batch or processing run associated with source ingestion. |
| `source_records` | Individual source-level records captured from a source dataset. |
| `record_provenance` | Links canonical records to the source records supporting or contributing to them. |
| `claims` | Structured profile or knowledge claims. |
| `claim_evidence` | Evidence relationships for claims. |
| `conflicts` | Reconciliation/conflict cases concerning inconsistent or competing information. |
| `conflict_items` | Individual canonical/source items associated with a conflict. Rebuilt in Version 1.1; see Section 5.4. |
| `verification_events` | History of verification or review events. Extended in Version 1.1; see Section 5.5. |
| `change_log` | Records database changes or change-history information. |

### 4.1 Existing views

The Version 1.0 model includes the following views, recreated by the proposed Version 1.1 migration:

| View | Purpose |
|---|---|
| `v_profile_subject` | Presents the profile-subject person record with selected fields from `people` and `records`. |
| `v_research_outputs` | Presents research-output metadata together with the canonical title and verification status. |
| `v_academic_links` | Presents link records together with the associated canonical record's verification status. |
| `v_record_source_count` | Counts distinct source records associated with each canonical record through `record_provenance`. |

## 5. Version 1.1 changes to existing tables

### 5.1 `records`

The record table is rebuilt to expand the `record_type` CHECK constraint. Three new types are included: `project`, `creative_work`, and `conference_submission`.

The proposed Version 1.1 rebuild preserves existing record identifiers and existing record values. It does not import new academic records.

### 5.2 `research_outputs`

The proposed Version 1.1 table uses `records.title` as the single canonical title and contains the following output-specific fields:

| Column | Meaning |
|---|---|
| `record_id` | Primary key and foreign key to the canonical research-output record. |
| `output_type` | Controlled output category. |
| `abstract` | Abstract or summary text. |
| `doi` | Digital Object Identifier, where available. |
| `publication_date` | Publication date as recorded. |
| `publication_year` | Publication year. |
| `venue` | Journal, conference, or other publication venue. |
| `publisher` | Publisher, where applicable. |
| `volume` | Volume information. |
| `issue` | Issue information. |
| `page_range` | Page range or equivalent pagination details. |
| `publication_status` | Publication lifecycle status. |
| `peer_review_status` | Peer-review status. |
| `primary_url` | Primary publication/output URL retained in this table for compatibility. |
| `supplementary_data_url` | URL for supplementary data, where applicable. |
| `notes` | Additional notes. |

**Allowed `output_type` values:** `journal_article`, `conference_proceedings`, `conference_abstract`, `oral_presentation`, `poster_presentation`, `thesis`, `dataset`, `preprint`, `technical_report`, `book_chapter`, `other`.

**Allowed `publication_status` values:** `published`, `accepted`, `submitted`, `preprint`, `unpublished`, `unknown`.

**Allowed `peer_review_status` values:** `peer_reviewed`, `not_peer_reviewed`, `unknown`, `not_applicable`.

### 5.3 `presentations`

Two nullable foreign-key columns are added:

| Column | Meaning |
|---|---|
| `output_record_id` | Optional link to the related canonical research output. |
| `submission_record_id` | Optional link to the associated conference submission record. |

The existing presentation-to-conference relationship remains part of the Version 1.0 presentation structure. Version 1.1 consistency triggers are intended to prevent a presentation and its submission from referring to different conferences.

### 5.4 `conflict_items`

The table is rebuilt with the following fields:

| Column | Meaning |
|---|---|
| `conflict_item_id` | New integer surrogate primary key. |
| `conflict_id` | Required foreign key to the parent conflict. |
| `record_id` | Optional foreign key to a canonical record. |
| `source_record_id` | Optional foreign key to a source record. |
| `competing_value` | Value or representation involved in the conflict. |
| `notes` | Additional context. |

At least one of `record_id` or `source_record_id` must be non-NULL.

### 5.5 `verification_events`

A nullable `verification_scope` column is added.

Allowed values:

- `content`
- `reference`
- `metadata`
- `url_availability`
- `historical`

This scope distinguishes the subject of a verification event. In particular, URL availability must not be conflated with verification of page content or a factual claim.

## 6. Version 1.1 new tables

All tables in this section are proposed additions. They should be considered part of the live schema only after successful migration and validation.

### 6.1 `conference_submissions`

Represents a distinct submission to a conference. A submission is not itself proof of acceptance or presentation.

| Column | Meaning |
|---|---|
| `record_id` | Primary key; also a canonical record of type `conference_submission`. |
| `conference_record_id` | Required conference reference. |
| `output_record_id` | Optional related research-output reference. |
| `submission_status` | Submission state. |
| `submitted_at` | Submission date/time, when known. |
| `decision_date` | Decision date, when known. |
| `notes` | Additional information. |

Allowed `submission_status` values: `draft`, `submitted`, `accepted`, `rejected`, `withdrawn`, `unknown`.

### 6.2 `projects`

Stores project-specific attributes. The canonical title and description are stored in `records`; project URLs are connected through `record_links` to the existing `links` table.

| Column | Meaning |
|---|---|
| `record_id` | Primary key and foreign key to a canonical record of type `project`. |
| `project_type` | Project category. |
| `project_status` | Project lifecycle/status. |
| `start_date` | Start date, when known. |
| `end_date` | End date, when known. |
| `notes` | Additional notes. |

Allowed `project_type` values: `research`, `literary`, `creative`, `publishing`, `website`, `software`, `digital_platform`, `research_communication`, `interdisciplinary`, `other`.

Allowed `project_status` values: `planned`, `active`, `paused`, `completed`, `archived`, `discontinued`, `unknown`.

### 6.3 `project_contributors`

Associates people with projects and records their roles.

| Column | Meaning |
|---|---|
| `contributor_id` | Integer primary key. |
| `project_record_id` | Required reference to a project. |
| `person_record_id` | Required reference to a person. |
| `contributor_role` | Role of the person in the project. |
| `contributor_order` | Optional positive ordering value. |
| `start_date` | Start of the person's contribution, when known. |
| `end_date` | End of the person's contribution, when known. |
| `notes` | Additional context. |

The combination of project, person, and contributor role is unique.

### 6.4 `creative_works`

Stores creative-work attributes. The canonical title and description are stored in `records`; URLs are connected through `record_links`.

| Column | Meaning |
|---|---|
| `record_id` | Primary key and foreign key to a canonical record of type `creative_work`. |
| `work_type` | Type or form of creative work. |
| `language` | Language of the work, where applicable. |
| `medium` | Medium or format. |
| `publication_date` | Publication/release date, when known. |
| `publisher` | Publisher, where applicable. |
| `notes` | Additional notes. |

### 6.5 `project_creative_works`

Associates a project with a creative work.

| Column | Meaning |
|---|---|
| `project_record_id` | Required project reference. |
| `creative_work_record_id` | Required creative-work reference. |
| `relationship_type` | Nature of the relationship between the project and work. |
| `notes` | Additional context. |

The project/work pair is the composite primary key.

### 6.6 `record_links`

Connects a canonical record to one or more URL records in `links`. It avoids storing project or creative-work URLs as duplicated free-text values.

| Column | Meaning |
|---|---|
| `record_id` | Canonical record being linked. |
| `link_record_id` | URL/link record in the existing `links` table. |
| `link_role` | Purpose of the link. |
| `display_order` | Positive ordering value for displaying links. |
| `notes` | Additional context. |

Allowed `link_role` values: `primary`, `homepage`, `repository`, `publication`, `documentation`, `demo`, `download`, `source`, `related`, `other`.

The `(record_id, link_record_id)` pair is unique. The proposed schema also permits no more than one `primary` link per canonical record. A record cannot link to itself as a link record.

### 6.7 `project_releases`

Represents a version or release belonging to a project. A release is a child row, not a canonical record in this design.

| Column | Meaning |
|---|---|
| `release_id` | Integer primary key. |
| `project_record_id` | Required parent project reference. |
| `release_version` | Version or release label, when applicable. |
| `release_type` | Controlled release category. |
| `release_date` | Release date, when known. |
| `notes` | Additional context. |

Allowed `release_type` values: `software_release`, `content_release`, `publication_release`, `website_update`, `dataset_release`, `other`.

The `(project_record_id, release_version)` pair is unique under the proposed schema.

### 6.8 `project_release_links`

Connects a project release to URL records in `links`.

| Column | Meaning |
|---|---|
| `release_id` | Required project-release reference. |
| `link_record_id` | Required URL/link record reference. |
| `link_role` | Role of the URL for the release. |
| `display_order` | Positive display order. |
| `notes` | Additional context. |

Allowed `link_role` values: `release`, `repository`, `download`, `documentation`, `demo`, `other`.

### 6.9 `project_release_sources`

Associates one or more source records with a project release.

| Column | Meaning |
|---|---|
| `release_id` | Required project-release reference. |
| `source_record_id` | Required source-record reference. |
| `source_role` | Provenance role of the source. |
| `evidence_note` | Explanation of what the source supports. |
| `added_at` | Timestamp when the association was recorded. |

Allowed `source_role` values: `origin`, `supporting`, `corroborating`, `release_announcement`, `repository_metadata`, `other`.

The release/source pair is the composite primary key.

### 6.10 `record_licenses`

Records a license assignment that applies either to a canonical record or to one project release. Exactly one of `record_id` or `release_id` must be populated.

| Column | Meaning |
|---|---|
| `license_assignment_id` | Integer primary key. |
| `record_id` | Optional canonical-record target. Mutually exclusive with `release_id`. |
| `release_id` | Optional project-release target. Mutually exclusive with `record_id`. |
| `license_scope` | Type of material covered by the license. |
| `applicable_component` | Optional component or part to which the license applies. |
| `license_name` | Required license name. |
| `license_identifier` | Optional standard identifier or SPDX-style identifier. |
| `license_url` | Optional URL for the license text or reference. |
| `effective_date` | Effective date, when known. |
| `notes` | Additional scope or interpretation notes. |

Allowed `license_scope` values: `code`, `written_content`, `creative_work`, `dataset`, `documentation`, `media`, `other`.

A license assignment for one component must not be interpreted as licensing every other component of a project or repository.

### 6.11 `license_assignment_sources`

Associates one or more source records with a license assignment.

| Column | Meaning |
|---|---|
| `license_assignment_id` | Required license-assignment reference. |
| `source_record_id` | Required source-record reference. |
| `source_role` | Role of the source in documenting the license. |
| `evidence_note` | Explanation of what the source establishes. |
| `added_at` | Timestamp when the association was recorded. |

Allowed `source_role` values: `origin`, `supporting`, `corroborating`, `license_text`, `repository_metadata`, `other`.

### 6.12 `conference_participations`

Represents a person's role or participation status in a conference. It may optionally reference a presentation and/or submission.

| Column | Meaning |
|---|---|
| `participation_id` | Integer primary key. |
| `conference_record_id` | Required conference reference. |
| `person_record_id` | Required person reference. |
| `presentation_record_id` | Optional presentation reference. |
| `submission_record_id` | Optional conference-submission reference. |
| `participation_role` | Person's role at the conference. |
| `participation_status` | State of that participation. |
| `participation_date` | Relevant participation date, when known. |
| `notes` | Additional context. |

Allowed `participation_role` values: `author`, `presenter`, `co_presenter`, `attendee`, `organizer`, `committee_member`, `session_chair`, `reviewer`, `other`.

Allowed `participation_status` values: `invited`, `submitted`, `accepted`, `presented`, `attended`, `completed`, `withdrawn`, `unknown`.

The migration's consistency triggers are intended to ensure the linked presentation and submission belong to the same conference.

### 6.13 `reconciliation_decisions`

Stores a decision or assessment made while reconciling different representations or sources.

| Column | Meaning |
|---|---|
| `decision_id` | Text primary key. |
| `decision_date` | Required date of the decision or assessment. |
| `reconciliation_category` | Subject/category of reconciliation. |
| `classification` | Controlled classification of the relationship or discrepancy. |
| `decision_status` | Workflow status of the decision. |
| `decision_summary` | Required concise summary. |
| `decision_rationale` | Reasoning behind the decision. |
| `evidence_summary` | Summary of the evidence considered. |
| `implemented_at` | Timestamp when an approved decision was implemented, if applicable. |
| `created_at` | Creation timestamp. |
| `notes` | Additional context. |

Allowed `classification` values: `exact_duplicate`, `equivalent_representation`, `complementary_information`, `updated_information`, `factual_discrepancy`, `source_specific_information`, `unsupported_information`, `not_comparable`, `pending_assessment`.

Allowed `decision_status` values: `proposed`, `under_review`, `approved`, `implemented`, `unresolved`, `deferred`.

### 6.14 `reconciliation_decision_items`

Identifies canonical and/or source records considered in a reconciliation decision.

| Column | Meaning |
|---|---|
| `decision_item_id` | Integer primary key. |
| `decision_id` | Required parent decision reference. |
| `canonical_record_id` | Optional canonical-record reference. |
| `source_record_id` | Optional source-record reference. |
| `item_role` | Role of this item in the decision. |
| `observed_value` | Value or representation observed in the item. |
| `notes` | Additional context. |

At least one of `canonical_record_id` or `source_record_id` must be non-NULL.

### 6.15 `keywords`

Controlled keyword vocabulary used for discovery and classification.

| Column | Meaning |
|---|---|
| `keyword_id` | Integer primary key. |
| `keyword_text` | Display form of the keyword. |
| `normalized_keyword` | Normalized form used for matching/deduplication within a category. |
| `keyword_category` | Controlled keyword category. |
| `description` | Optional explanation of the keyword. |
| `created_at` | Creation timestamp. |

Allowed `keyword_category` values: `research_domain`, `research_topic`, `method`, `material`, `experimental_technique`, `computational_technique`, `application`, `academic_discipline`, `identity_descriptor`, `platform_discovery`, `other`.

The pair `(keyword_category, normalized_keyword)` is unique.

### 6.16 `record_keywords`

Associates a canonical record with a keyword.

| Column | Meaning |
|---|---|
| `record_keyword_id` | Integer primary key. |
| `record_id` | Required canonical-record reference. |
| `keyword_id` | Required keyword reference. |
| `assignment_classification` | Classification of the keyword's relationship to the record. |
| `assignment_notes` | Explanation of the assignment. |
| `assigned_at` | Timestamp when the association was recorded. |

Allowed `assignment_classification` values: `core`, `established`, `adjacent`, `application`, `method`, `indexing_term`, `discovery`, `unclassified`.

The `(record_id, keyword_id)` pair is unique. A keyword association is an indexing/classification relationship; it does not by itself prove expertise, authorship, institutional affiliation, or an output in that subject.

### 6.17 `record_keyword_sources`

Associates one or more source records with a keyword assignment.

| Column | Meaning |
|---|---|
| `record_keyword_id` | Required keyword-assignment reference. |
| `source_record_id` | Required source-record reference. |
| `source_role` | Role of the source in supporting or explaining the assignment. |
| `evidence_note` | Explanation of the source's relevance. |
| `added_at` | Timestamp when the association was recorded. |

Allowed `source_role` values: `origin`, `supporting`, `corroborating`, `curatorial`, `imported_from`, `other`.

The assignment/source pair is the composite primary key. An assignment may have no source association while its provenance is not yet recorded; this should not be mistaken for evidence that no source exists.

## 7. Relationships at a glance

| Parent / subject | Related table | Relationship |
|---|---|---|
| `records` | Domain-specific tables | One canonical record may have one corresponding specialized row, according to its record type. |
| `records` | `record_provenance` | Canonical records are linked to supporting source records. |
| `records` | `record_links` | A canonical record may be associated with multiple link records. |
| `projects` | `project_contributors` | A project may have multiple person contributors. |
| `projects` | `project_creative_works` | A project may be related to multiple creative works. |
| `projects` | `project_releases` | A project may have multiple release rows. |
| `project_releases` | `project_release_links` | A release may have multiple URL/link records. |
| `project_releases` | `project_release_sources` | A release may have multiple source records. |
| `records` or `project_releases` | `record_licenses` | A license assignment targets exactly one canonical record or one project release. |
| `record_licenses` | `license_assignment_sources` | A license assignment may have multiple supporting sources. |
| `conferences` | `conference_submissions` | A conference may receive multiple submissions. |
| `conferences` | `presentations` | Presentations retain their existing conference relationship. |
| `conferences` | `conference_participations` | A conference may have multiple people and participation roles. |
| `research_outputs` | `conference_submissions` / `presentations` | Submissions and presentations may refer to related research outputs. |
| `reconciliation_decisions` | `reconciliation_decision_items` | A decision may consider multiple canonical and/or source records. |
| `records` | `record_keywords` | A canonical record may have multiple keyword assignments. |
| `record_keywords` | `record_keyword_sources` | A keyword assignment may be supported by multiple source records. |

## 8. Views proposed for Version 1.1

The migration recreates the four existing views and adds seven proposed views.

| View | Purpose |
|---|---|
| `v_profile_subject` | Profile-subject person record and selected canonical metadata. |
| `v_research_outputs` | Research outputs with canonical titles and verification status. |
| `v_academic_links` | Link records with canonical verification status. |
| `v_record_source_count` | Number of distinct provenance source records per canonical record. |
| `v_projects` | Project records, project attributes, canonical description, and primary/homepage URL resolved through `record_links`. |
| `v_creative_works` | Creative works, canonical description, and primary/homepage URL resolved through `record_links`. |
| `v_conference_submissions` | Conference submissions with canonical title and related conference/output fields. |
| `v_keyword_index` | Record-to-keyword assignments with classification and source count. |
| `v_keyword_assignment_sources` | Detailed source associations for keyword assignments. |
| `v_project_releases` | Project release details, release/repository URLs, and source count. |
| `v_license_assignments` | License assignments with canonical record or release context and source count. |

## 9. Verification, evidence, and interpretation rules

1. A source record records what a source contains; it does not automatically establish the truth of every statement in that source.
2. A canonical record should preserve provenance through `record_provenance` or the applicable specialized source-association table.
3. Use `verification_events` to preserve verification history and identify the scope of each event.
4. Distinguish user attestation from independent source verification.
5. Distinguish reference/content verification from URL availability.
6. Do not use `title_inferred` as if it were a verified title.
7. Do not interpret a keyword assignment as proof of specialization, professional role, institutional affiliation, or authorship.
8. Do not infer conference presentation or attendance from submission status alone.
9. Keep authorship and author order at the individual output/contribution level. Do not generalize one work's author arrangement to all works.
10. Record disagreements as reconciliation decisions or conflicts rather than silently overwriting source-specific information.
11. A license assignment applies only to its declared target and scope. A project-level license does not automatically establish the license of every release, dataset, document, or third-party component.

## 10. Version 1.0 inspection baseline

The recorded read-only inspection of the canonical `profile.sqlite` database reported the following Version 1.0 baseline:

| Metric | Recorded value |
|---|---:|
| Canonical records | 431 |
| Link records | 419 |
| Research themes | 10 |
| Profile-subject person records | 1 |
| Claim records | 1 |
| Registered source datasets | 4 |
| Import batches | 4 |
| Source records | 435 |
| Provenance relationships | 433 |
| Tables | 25 |
| Views | 4 |
| Indexes | 30 |
| SQLite integrity check | `ok` |
| Foreign-key check | 0 violations |

Recorded database file details at the time of inspection:

- Filename: `profile.sqlite`
- File size: 1,351,680 bytes
- SQLite version reported by the inspection: 3.46.1
- SHA-256: `16d00294c2ed71963399a2dafdd1e8256f0d8bfbf45580ed7b8f42ed73904cde`

These are historical inspection results, not a live query. Re-run database checks when migration testing is resumed. The Version 1.1 migration contains baseline guards and expected record counts; any mismatch must be investigated rather than bypassed.

The inspection also noted that the 10 research-theme rows were provisional and used inferred titles/unclassified verification states. That state should not be interpreted as a completed import or validation of the separate ORCID keyword index.

## 11. Schema and deployment status

| Item | Status |
|---|---|
| Version 1.0 schema | Existing baseline |
| `profile.sqlite` | Canonical database; retain unchanged until an approved migration |
| Version 1.1 migration plan | Created |
| Version 1.1 migration SQL | Prepared; execution not confirmed |
| Version 1.1 data dictionary | Proposed reference in this file |
| Migration test on a separate database copy | Deferred |
| Version 1.1 integrity and relationship validation | Pending |
| Canonical database deployment | Not authorized / not performed |

**Important:** A table or field described as Version 1.1 proposed is not evidence that it already exists in `profile.sqlite`. Do not update the live schema version to `1.1` until the migration has been tested and approved.

## 12. Authoritative project files

- `schema.sql` — Version 1.0 schema definition and baseline SQL reference.
- `migrations/001_schema_v1_0_to_v1_1.sql` — proposed Version 1.0-to-1.1 migration.
- `SCHEMA_V1_1_MIGRATION_PLAN.md` — migration rationale, scope, and implementation plan.
- `DATABASE_BUILD_REPORT.md` — recorded database construction and inspection information.
- `reconciliation/reconciliation-report.md` — reconciliation methodology and findings.
- `MANIFEST.md` — archive file inventory and project structure.

When this dictionary and an executable SQL definition differ, inspect the SQL and update this document after the schema decision is confirmed. Do not silently alter the SQL or the canonical database to make the documentation appear consistent.
