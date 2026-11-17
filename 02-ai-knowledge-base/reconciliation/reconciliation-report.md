# Reconciliation Report

## Academic and Intellectual Knowledge Base

**Profile:** Pravinkumar Ramchandra Ghodake  
**Canonical database:** `../profile.sqlite`  
**Schema version:** 1.0  
**Report date:** 2026-11-17  
**Report status:** Initial baseline — historical-source reconciliation pending

---

## 1. Purpose

This report documents the reconciliation of historical profile information, academic records, research outputs, source links, structured datasets and knowledge-base exports against the canonical SQLite database.

The purpose is to establish a transparent and repeatable process for:

- Comparing information from different historical sources.
- Identifying duplicate records and equivalent representations.
- Detecting genuine factual discrepancies.
- Preserving original source information and provenance.
- Resolving differences using appropriate supporting evidence.
- Preventing unsupported information from entering the canonical database.
- Maintaining one authoritative structured database.
- Recording reconciliation decisions and their rationale.

This report is a working record. It will be updated as historical source materials are inspected, compared and incorporated.

It does not assume that every identified historical source has already been examined or reconciled.

---

## 2. Canonical knowledge-base reference

The canonical structured database is:

`profile.sqlite`

It is the authoritative database maintained in:

`02-ai-knowledge-base/`

The canonical database is supported by:

- `README.md`
- `ORCID_KEYWORDS.md`
- `MANIFEST.md`
- `DATABASE_BUILD_REPORT.md`
- `DATA_DICTIONARY.md`
- `schema.sql`
- `PROFILE_KNOWLEDGE_BRIEF.md`

The canonical database is intended to contain structured profile entities, academic and professional information, research outputs, projects, source references and provenance relationships.

Historical databases and exports are treated as source materials for examination and potential integration. They are not competing canonical databases.

### 2.1 Recorded database baseline

The following figures were recorded in the existing database documentation:

| Measure | Recorded value |
|---|---:|
| Canonical records | 431 |
| Canonical link records | 419 |
| Original source records | 435 |
| Provenance relationships | 433 |
| Research themes | 10 |
| Profile subject records | 1 |
| Registered source datasets | 4 |
| Import batches | 4 |
| Registered claims | 1 |

**Important:** These are previously documented baseline figures. They are reproduced here for reconciliation context and have not been independently re-counted as part of preparing this report.

They should not be interpreted as publication counts, unique research-output counts, or counts of distinct academic contributions.

A fresh database audit will be recorded separately when the relevant database queries and integrity checks are performed.

---

## 3. Reconciliation principles

All reconciliation work follows the principles below.

### 3.1 Preserve source provenance

Every imported or reconciled record should retain enough information to identify its origin.

Where available, preserve:

- Original filename
- Source dataset identifier
- Original source record identifier
- Acquisition date
- Import batch
- Original value
- Normalized value
- Relationship to the canonical record
- Reconciliation decision
- Supporting reference

A normalized record should not erase the existence of its original source representation.

### 3.2 One canonical representation, multiple source references

Where multiple source records represent the same underlying entity, they may be associated with one canonical record.

However, the source records and their provenance must remain distinguishable.

For example, two source files may contain the same URL. The canonical database may retain one normalized link record while preserving both original source entries and their respective provenance.

### 3.3 Do not confuse duplicates with discrepancies

A duplicate is not necessarily an error.

Two records may be equivalent even when they differ in:

- Capitalization
- Formatting
- URL representation
- Abbreviations
- Naming conventions
- Metadata completeness
- File format

A discrepancy exists when two sources make materially different claims about the same subject or event.

These situations require different reconciliation decisions.

### 3.4 Do not resolve differences by assumption

When sources disagree, do not automatically:

- Prefer the newest file.
- Prefer the largest database.
- Prefer an AI-generated summary.
- Prefer a particular export format.
- Delete one representation.
- Combine different academic contributions.
- Infer missing authorship or institutional information.

The relevant source evidence must be examined before a factual decision is recorded.

### 3.5 Preserve historical information

A correction to a canonical record should not erase the historical source value.

Where appropriate, preserve the earlier value, identify its source and document why the canonical representation was changed.

### 3.6 Separate factual and technical validation

The following are separate validation activities:

1. Factual verification of profile information.
2. Source provenance validation.
3. Duplicate and discrepancy reconciliation.
4. Database schema validation.
5. Database integrity validation.
6. URL availability checking.

Passing one type of validation does not automatically establish that the others have passed.

---

## 4. Registered source datasets

The following four source datasets were recorded in the existing database documentation.

| Source ID | Source description | Imported records or entries | Import batch | Recorded status |
|---|---|---:|---|---|
| `SRC-MASTER-400` | Original master link directory | 400 entries | `BATCH-MASTER-400` | Completed |
| `SRC-SUPPLEMENT-20` | Additional GitHub and project links | 20 entries | `BATCH-SUPPLEMENT-20` | Completed |
| `SRC-BRIEF-001` | `PROFILE_KNOWLEDGE_BRIEF(1).md` | 14 source records | `BATCH-BRIEF-001` | Completed with warnings |
| `SRC-REPORT-001` | `BUILD_REPORT(3).md` | 1 source record | `BATCH-REPORT-001` | Completed |

### 4.1 SRC-MASTER-400

**Original source name:** `300 PLUS LINKS OF ME HAHA`  
**Stored source artifact:** `master-link-directory-transcribed.md`  
**Acquisition date:** 2026-11-16  
**Original entries:** 400  
**Import batch:** `BATCH-MASTER-400`

This dataset contains the original master link directory supplied for the knowledge-base construction.

It contains 11 original sections.

The original source structure and entries should be preserved as provenance material.

### 4.2 SRC-SUPPLEMENT-20

**Stored source artifact:** `additional-github-project-links-2026-11-16.txt`  
**Acquisition date:** 2026-11-16  
**Original entries:** 20  
**Import batch:** `BATCH-SUPPLEMENT-20`

This dataset contains additional GitHub and project links.

It includes additional project and repository references, including Three Harmonics and Verse & Variable.

One normalized URL duplicates a destination already present in the master directory.

Both original source entries are retained, while the canonical database contains one corresponding canonical link record.

### 4.3 SRC-BRIEF-001

**Original source filename:** `PROFILE_KNOWLEDGE_BRIEF(1).md`  
**Source classification:** Other AI / vendor unattributed  
**Acquisition date:** 2026-11-16  
**Imported source records:** 14  
**Import batch:** `BATCH-BRIEF-001`

This source contains identity descriptions, research themes, a working research narrative and publication-classification guidance.

Its original content should be compared with the current profile documents and canonical records.

The generating platform or vendor has not been established from the available source description. It must not be attributed to ChatGPT, Perplexity or another platform without supporting evidence.

### 4.4 SRC-REPORT-001

**Original source filename:** `BUILD_REPORT(3).md`  
**Source classification:** Other AI / vendor unattributed  
**Acquisition date:** 2026-11-16  
**Imported source records:** 1  
**Import batch:** `BATCH-REPORT-001`

This source describes the construction of the 400-entry link directory and related aggregate information.

Its figures are treated as historical build documentation, not as independent academic facts.

---

## 5. Confirmed reconciliation result

### 5.1 Master directory and supplemental links

The master directory and supplemental link list contain:

| Source | Original entries |
|---|---:|
| Master directory | 400 |
| Supplemental list | 20 |
| **Total original entries** | **420** |

The recorded canonical representation contains:

**419 canonical link records.**

The difference is explained by one normalized URL appearing in both source collections.

The reconciliation treatment is:

- Preserve the original master-directory entry.
- Preserve the original supplemental-list entry.
- Retain their separate source provenance.
- Associate both with the same canonical link record.
- Avoid creating a second canonical link record for the same normalized destination.

**Recorded outcome:** One duplicate destination is represented by one canonical link record while both source entries remain preserved.

This is a documented deduplication result, not evidence of a broader unresolved factual conflict.

---

## 6. Historical source materials awaiting reconciliation

The following historical materials have been identified for comparison with the canonical database.

Their presence in this register does not mean that their full contents have already been inspected or imported.

| Historical source material | Description or reported characteristics | Reconciliation status |
|---|---|---|
| `links(1).json` | Reported 400-link JSON dataset | Pending comparison |
| `links(1).csv` | Reported matching 400-row CSV dataset | Pending comparison |
| `pravinkumar_ghodake_knowledge.db` | Previously described as containing six tables and 437 rows | Pending reinspection |
| `pravinkumar_ghodake_ai_context_brief.md` | Earlier context brief, previously described as 27 lines | Pending comparison |
| `ghodake_profile(1).db` | Historical Perplexity-labelled database export | Pending inspection |
| `Ghodake Profile Database (JSON)(1).json` | Historical Perplexity-related structured profile export | Pending inspection |
| `pravinkumar_ghodake_knowledge.json` | Historical structured profile material; vendor attribution not established | Pending inspection |
| Perplexity JSON and SQL schema export | Historical structured data and schema material | Pending inspection |
| Earlier ChatGPT knowledge-base package | Historical knowledge-base materials | Pending inspection |

The descriptions above are preliminary source-identification details. They must be checked against the actual files before any import or reconciliation decision is made.

### 6.1 Special handling for the 400-link JSON and CSV files

The reported 400-entry JSON file and 400-row CSV file must be compared with the already registered master directory.

The comparison must establish:

- Whether they contain the same 400 original entries.
- Whether their ordering differs.
- Whether any fields were transformed or omitted.
- Whether URLs were normalized differently.
- Whether either file contains additional metadata.
- Whether the two files are independent exports of the same source dataset.

They must not be blindly imported as additional link collections.

If they represent the same original master directory, they should be linked as alternate representations or supporting exports of that source, rather than counted as new independent link entries.

### 6.2 Special handling for historical databases

Each historical database must be inspected before integration.

The inspection should document:

- File identity and format
- Database schema
- Table names
- Column names and data types
- Record counts
- Primary and foreign keys
- Unique constraints
- Existing identifiers
- Source metadata
- Available timestamps
- Relationships between tables
- Potential duplicate records
- Potentially new information

The previously reported six-table and 437-row description of `pravinkumar_ghodake_knowledge.db` is a preliminary inspection note. It must be reproduced against the actual file before being treated as a current database inspection result.

Historical database records must not be copied directly into the canonical database without mapping their structure and provenance.

---

## 7. Reconciliation scope

The following information categories are included in the reconciliation process.

### 7.1 Identity and profile information

Compare:

- Full name
- Name variants
- ORCID
- Academic and professional descriptors
- Research identity
- Profile descriptions
- Public biography information

The established identity descriptors are:

- Independent Researcher
- Scientist
- PhD Student
- Postdoc Student

These descriptors should not be converted into separate chronological appointments without evidence.

The public doctoral-status description remains **PhD Student**.

Location information is excluded from the public profile.

### 7.2 Education and institutional records

Compare:

- Qualifications
- Degrees
- Academic programmes
- Research status
- Institutional records
- Departments
- Dates
- Supporting references

Do not infer an affiliation, employment relationship, appointment or degree-awarding relationship from an institution name appearing in a keyword list or unrelated source.

### 7.3 Publications and research outputs

Compare:

- Titles
- Publication types
- Authors
- Author order
- Publication dates
- DOI values
- Publisher records
- Journal information
- Conference proceedings
- Abstracts
- Repository versions
- Record identifiers

Distinguish unique research works from:

- Different platform records for the same work
- Duplicate DOI entries
- Preprints and published versions
- Abstracts and full papers
- Conference submissions and presentations
- Repository deposits
- Repeated metadata records

A platform entry is not automatically a distinct research publication.

### 7.4 Authorship and collaboration

Authorship must be checked for each work individually.

The reconciliation process must preserve:

- Complete author list
- Actual author order
- Solo-authored contributions
- Collaborative contributions
- Co-author relationships
- Differences between author, presenter and contributor roles

Collaborators must not be assigned to works solely because they appear elsewhere in the profile.

### 7.5 Conferences and presentations

Compare:

- Conference name
- Meeting edition
- Event dates
- Abstract title
- Submission status
- Acceptance status
- Presentation status
- Presenter
- Authors
- Session role
- Organizing role
- Supporting event references

Conference submission, acceptance, presentation, attendance and organization are distinct activities.

The two iNCMDAO-related contributions must remain separate records.

### 7.6 Awards, grants and recognition

Compare:

- Award or grant name
- Issuing organization
- Award category
- Recipient
- Year or date
- Associated event
- Supporting source

The GitHub README and repository records are the designated sources to examine for the supplied awards information.

The outdated Google Sites awards page must not override more current supporting records without an evidence-based reason.

### 7.7 Creative, literary and digital projects

Compare:

- Project names
- Website addresses
- Publishing records
- Software repositories
- Release records
- DOI deposits
- Project descriptions
- Contributors
- Content licences
- Software licences
- Associated documentation

Literature, multilingual writing, independent publishing, website design, software and digital projects remain important parts of the broader intellectual portfolio.

They must not automatically be classified as scientific publications or reduced to unrelated hobbies.

### 7.8 Links and digital identifiers

Compare:

- Original URL
- Normalized URL
- Redirected URL, where checked
- DOI
- ORCID
- GitHub repository
- Personal or project website
- Academic platform record
- Source-list position
- Availability-check date

A URL being unavailable at a later date does not by itself establish that the original source record was invalid.

---

## 8. Reconciliation classifications

Each comparison should receive an explicit classification.

| Classification | Meaning | Typical treatment |
|---|---|---|
| Exact duplicate | Same record and same substantive information | Preserve provenance; avoid duplicate canonical entity |
| Equivalent representation | Same underlying entity with different formatting or metadata representation | Link to one canonical entity and preserve source representations |
| Complementary information | Sources contain different but compatible details | Merge supported details with separate provenance |
| Updated information | A source contains a later or corrected value | Assess evidence and retain historical values where appropriate |
| Factual discrepancy | Sources make materially different claims | Investigate and document the resolution |
| Source-specific information | Information belongs to a particular platform or source | Preserve it as source-specific metadata |
| Unsupported information | A claim lacks adequate supporting evidence | Do not promote it into the canonical factual record |
| Not comparable | Sources refer to different entities, events or versions | Keep separate records |
| Pending assessment | Evidence has not yet been examined sufficiently | Leave unresolved and record the next required action |

A classification describes the relationship between source representations. It does not automatically determine which source is factually correct.

---

## 9. Evidence and decision rules

When a discrepancy is identified, the decision should be based on the most relevant available evidence.

Evidence may include:

- Official institutional records
- Publisher records
- DOI registration records
- Official conference programmes
- Original award documentation
- Research repository records
- Author-maintained source material
- Original source datasets
- Historical database records
- Other directly relevant references

The decision record should identify the evidence actually examined.

Do not claim that a source was checked if it was not inspected.

Where a decision cannot be supported confidently, retain the discrepancy as unresolved.

### 9.1 Source authority is context-dependent

No single source should automatically be treated as authoritative for every type of information.

For example:

- A publisher record is relevant to publication metadata.
- An official institutional record is relevant to institutional information.
- An original conference programme is relevant to presentation details.
- A GitHub repository may be relevant to software and project records.
- An author-maintained profile may provide useful context and source links.

The appropriate source depends on the claim being reconciled.

---

## 10. Reconciliation workflow

Each historical source should pass through the following workflow.

### Stage 1 — Source identification

Record:

- Filename
- File format
- Source origin, if known
- Acquisition date, if known
- File size, where useful
- Available metadata
- Existing source identifier, if assigned

### Stage 2 — Source inspection

Inspect the original file.

For structured formats, document the schema and available records.

For documents, identify sections, claims, links and references.

Do not rely only on a previous summary of a file.

### Stage 3 — Record extraction

Extract records while preserving their original values and source identifiers.

Avoid silently normalizing away information that may be useful for later comparison.

### Stage 4 — Comparison

Compare extracted records against:

- Existing canonical entities
- Existing source records
- Existing provenance relationships
- Other historical sources
- Relevant supporting references

### Stage 5 — Classification

Assign an appropriate reconciliation classification.

Record unresolved issues separately.

### Stage 6 — Decision

Document whether the record should be:

- Linked to an existing canonical entity
- Added as a new canonical entity
- Retained as source-specific metadata
- Updated using supported evidence
- Kept as a separate entity
- Deferred pending further evidence

### Stage 7 — Import or update

Only after the comparison and decision should the relevant database import or update be performed.

Preserve provenance and avoid destructive changes.

### Stage 8 — Validation

After integration, validate:

- Record counts
- Identifier uniqueness
- Foreign-key relationships
- Provenance relationships
- Expected constraints
- Database integrity
- Relevant application queries

Record the validation results and date.

---

## 11. Reconciliation decision log

Every material reconciliation decision should be recorded in a decision log.

Use the following structure:

| Field | Description |
|---|---|
| Decision ID | Unique reconciliation decision identifier |
| Date | Date of assessment |
| Source IDs | Source datasets involved |
| Source records | Original source record identifiers |
| Canonical entity | Relevant canonical record, if available |
| Category | Identity, education, publication, conference, award, project, link or other |
| Classification | Reconciliation classification |
| Observed difference | What differs between the records |
| Evidence examined | Actual sources reviewed |
| Decision | Action taken or reason for retaining the discrepancy |
| Rationale | Explanation of the decision |
| Database action | Import, update, link, preserve, defer or no action |
| Validation | Relevant post-change checks |
| Status | Proposed, approved, implemented or unresolved |

### 11.1 Decision log entries

No additional historical-source factual discrepancy is declared resolved in this initial report beyond the documented master/supplemental link deduplication in Section 5.

Additional decisions will be added after the relevant source files have been inspected.

---

## 12. Current reconciliation status

The following table summarizes the state of work at the time this report was prepared.

| Area | Current status | Next action |
|---|---|---|
| Master link directory | Imported | Preserve source and canonical relationships |
| Supplemental links | Imported | Preserve the documented duplicate relationship |
| Master/supplemental URL deduplication | Documented | Retain the existing provenance representation |
| Original profile brief | Imported with warnings | Compare its claims against current profile documentation |
| Historical build report | Imported | Preserve as historical build documentation |
| 400-link JSON export | Pending | Compare with the imported master directory |
| 400-row CSV export | Pending | Compare with JSON and the imported master directory |
| Historical SQLite database | Pending | Reinspect schema and records |
| Earlier AI context brief | Pending | Compare claims and source references |
| Historical Perplexity-labelled exports | Pending | Inspect files and establish source provenance |
| Historical ChatGPT package | Pending | Inspect contents and compare with canonical records |
| Education records | Future reconciliation work | Compare source records and supporting references |
| Publication and authorship records | Future reconciliation work | Reconcile individual works and author lists |
| Conference contributions | Future reconciliation work | Reconcile individual submissions and presentations |
| Awards and recognition | Future reconciliation work | Compare designated source records |
| Literature and digital projects | Future reconciliation work | Reconcile projects, releases and licences |

**Overall status:** The initial source register and one documented link-deduplication result are available. Historical database and export comparisons remain pending.

---

## 13. Database change control

Reconciliation should not result in uncontrolled database modifications.

Before applying structural or large-scale data changes:

1. Preserve a backup of the current canonical database.
2. Inspect the current schema.
3. Identify the affected tables and relationships.
4. Prepare a documented migration or import plan.
5. Check existing constraints and identifiers.
6. Test the proposed changes on a separate copy.
7. Validate the resulting data.
8. Record the change and validation outcome.
9. Update the data dictionary and build documentation where necessary.

Schema migrations should be handled separately from routine record reconciliation.

The canonical database should only be replaced or updated after the relevant changes have been tested.

---

## 14. Reports and documentation affected by reconciliation

Reconciliation results may require updates to:

- `MANIFEST.md`
- `DATABASE_BUILD_REPORT.md`
- `DATA_DICTIONARY.md`
- `PROFILE_KNOWLEDGE_BRIEF.md`
- `ORCID_KEYWORDS.md`
- `README.md`
- `schema.sql`
- `profile.sqlite`

Not every reconciliation decision requires every document to change.

Documentation should be updated only where the corresponding information, schema, source inventory or project status actually changes.

The reconciliation report itself should remain the central log of comparison status, findings and decisions.

---

## 15. Limitations and unresolved work

This report is an initial reconciliation baseline.

The existence of a historical file does not establish that:

- Its original contents are complete.
- Its records are factually correct.
- Its metadata is current.
- Its generating platform is known.
- Its records have been imported.
- Its records are distinct from existing canonical records.

Likewise, a previously reported table count, row count or source-record count must be reproduced against the original file before being treated as a newly verified technical result.

Unresolved items should remain explicitly unresolved until adequate evidence is available.

No discrepancy should be manufactured merely to populate the report.

No source should be discarded merely because it differs in formatting or structure from the canonical database.

---

## 16. Guiding objective

The objective of reconciliation is not simply to combine the largest possible number of records.

It is to establish a reliable, traceable and internally consistent knowledge base in which:

- Every important record has identifiable provenance.
- Duplicate representations are handled consistently.
- Distinct academic contributions remain distinct.
- Authorship and institutional information are preserved accurately.
- Historical information remains traceable.
- Genuine discrepancies are documented and investigated.
- Unsupported claims are not silently adopted.
- Database changes remain controlled and reproducible.

The canonical database should represent the best-supported structured account of the profile while preserving the historical source material needed to understand how that representation was established.

---

**Maintained by:** Pravinkumar Ramchandra Ghodake  
**Repository area:** `02-ai-knowledge-base/`  
**Canonical database:** `profile.sqlite`  
**Report:** `reconciliation/reconciliation-report.md`
