-- ============================================================
-- PRAVINKUMAR GHODAKE — ACADEMIC AND INTELLECTUAL KNOWLEDGE BASE
-- Migration: Version 1.0 -> Version 1.1
--
-- File:
-- migrations/001_schema_v1_0_to_v1_1.sql
--
-- Starting database:
-- profile.sqlite
--
-- Starting schema: 1.0
-- Target schema:   1.1
--
-- IMPORTANT:
-- 1. Run only against a separate copy of profile.sqlite.
-- 2. Verify the original database SHA-256 externally.
-- 3. Run using sqlite3 with the -bail option.
-- 4. This script checks the expected Version 1.0 baseline.
-- 5. Any failed guard must stop execution.
-- 6. The original canonical database must remain untouched.
--
-- The records table must be rebuilt to extend its CHECK
-- constraint. Foreign-key enforcement is temporarily disabled
-- for this controlled rebuild and restored before validation.
--
-- ============================================================


-- ------------------------------------------------------------
-- 1. INITIAL CONNECTION CONFIGURATION
-- ------------------------------------------------------------

PRAGMA foreign_keys = ON;

PRAGMA busy_timeout = 5000;


-- ------------------------------------------------------------
-- 2. CREATE MIGRATION GUARD
-- ------------------------------------------------------------

CREATE TEMP TABLE _migration_guard (
    ok INTEGER NOT NULL CHECK (ok = 1)
);


-- ------------------------------------------------------------
-- 3. VERIFY THE EXPECTED VERSION 1.0 BASELINE
--
-- The inspected baseline:
-- 431 canonical records
-- 419 links
-- 10 research themes
-- 4 source datasets
-- 4 import batches
-- 435 source records
-- 433 provenance relationships
--
-- Stop if the database differs from this baseline.
-- ------------------------------------------------------------

INSERT INTO _migration_guard (ok)
SELECT CASE

    WHEN
        (
            SELECT metadata_value
            FROM schema_metadata
            WHERE metadata_key = 'schema_version'
        ) = '1.0'

        AND (SELECT COUNT(*) FROM records) = 431
        AND (SELECT COUNT(*) FROM links) = 419
        AND (SELECT COUNT(*) FROM research_themes) = 10
        AND (SELECT COUNT(*) FROM people) = 1
        AND (SELECT COUNT(*) FROM claims) = 1

        AND (SELECT COUNT(*) FROM sources) = 4
        AND (SELECT COUNT(*) FROM import_batches) = 4
        AND (SELECT COUNT(*) FROM source_records) = 435
        AND (SELECT COUNT(*) FROM record_provenance) = 433

        AND (
            SELECT COUNT(DISTINCT canonical_record_id)
            FROM record_provenance
        ) = 431

        AND (
            SELECT COUNT(*)
            FROM source_records
            WHERE content_hash IS NULL
               OR content_hash = ''
        ) = 0

        AND (
            SELECT COUNT(*)
            FROM links
            WHERE url IS NULL
               OR url = ''
        ) = 0

        AND (
            SELECT COUNT(*)
            FROM (
                SELECT normalized_url
                FROM links
                WHERE normalized_url IS NOT NULL
                  AND normalized_url <> ''
                GROUP BY normalized_url
                HAVING COUNT(*) > 1
            )
        ) = 0

        -- Specialized tables expected to be empty
        -- according to the actual Version 1.0 inspection.

        AND (SELECT COUNT(*) FROM institutions) = 0
        AND (SELECT COUNT(*) FROM identifiers) = 0
        AND (SELECT COUNT(*) FROM education) = 0
        AND (SELECT COUNT(*) FROM appointments) = 0
        AND (SELECT COUNT(*) FROM research_outputs) = 0
        AND (SELECT COUNT(*) FROM output_authors) = 0
        AND (SELECT COUNT(*) FROM conferences) = 0
        AND (SELECT COUNT(*) FROM presentations) = 0
        AND (SELECT COUNT(*) FROM awards) = 0
        AND (SELECT COUNT(*) FROM research_relationships) = 0
        AND (SELECT COUNT(*) FROM verification_events) = 0
        AND (SELECT COUNT(*) FROM conflicts) = 0
        AND (SELECT COUNT(*) FROM conflict_items) = 0
        AND (SELECT COUNT(*) FROM claim_evidence) = 0

        AND (
            SELECT integrity_check
            FROM pragma_integrity_check
            LIMIT 1
        ) = 'ok'

        AND (
            SELECT COUNT(*)
            FROM pragma_foreign_key_check
        ) = 0

    THEN 1
    ELSE 0
END;

DELETE FROM _migration_guard;


-- ------------------------------------------------------------
-- 4. CONTROLLED FOREIGN-KEY HANDLING
--
-- SQLite requires foreign-key enforcement to be disabled
-- before beginning a transaction that rebuilds a referenced
-- parent table.
--
-- Enforcement will be restored and checked before completion.
-- ------------------------------------------------------------

PRAGMA foreign_keys = OFF;

BEGIN IMMEDIATE;


-- ------------------------------------------------------------
-- 5. VERIFY STARTING VERSION AGAIN INSIDE TRANSACTION
-- ------------------------------------------------------------

INSERT INTO _migration_guard (ok)
SELECT CASE
    WHEN (
        SELECT metadata_value
        FROM schema_metadata
        WHERE metadata_key = 'schema_version'
    ) = '1.0'
    THEN 1
    ELSE 0
END;

DELETE FROM _migration_guard;


-- ------------------------------------------------------------
-- 6. DROP EXISTING VIEWS
--
-- They will be recreated after the structural changes.
-- ------------------------------------------------------------

DROP VIEW IF EXISTS v_profile_subject;
DROP VIEW IF EXISTS v_research_outputs;
DROP VIEW IF EXISTS v_academic_links;
DROP VIEW IF EXISTS v_record_source_count;


-- ------------------------------------------------------------
-- 7. REBUILD RECORDS WITH EXPANDED RECORD-TYPE TAXONOMY
--
-- New canonical record types:
-- project
-- creative_work
-- conference_submission
--
-- Project releases remain project-specific child records.
-- ------------------------------------------------------------

CREATE TABLE records_v11 (

    record_id TEXT PRIMARY KEY,

    record_type TEXT NOT NULL CHECK (
        record_type IN (
            'person',
            'institution',
            'identifier',
            'education',
            'appointment',
            'research_output',
            'conference',
            'presentation',
            'research_theme',
            'research_relationship',
            'link',
            'claim',
            'award',
            'project',
            'creative_work',
            'conference_submission',
            'other'
        )
    ),

    canonical_key TEXT,
    title TEXT,
    description TEXT,

    verification_status TEXT NOT NULL DEFAULT 'unverified'
        CHECK (
            verification_status IN (
                'verified',
                'historically_checked',
                'user_attested',
                'title_inferred',
                'unverified',
                'disputed',
                'superseded'
            )
        ),

    valid_from TEXT,
    valid_to TEXT,

    is_current INTEGER NOT NULL DEFAULT 1
        CHECK (is_current IN (0, 1)),

    supersedes_record_id TEXT
        REFERENCES records_v11(record_id),

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(record_type, canonical_key)
);


INSERT INTO records_v11 (
    record_id,
    record_type,
    canonical_key,
    title,
    description,
    verification_status,
    valid_from,
    valid_to,
    is_current,
    supersedes_record_id,
    created_at,
    updated_at
)
SELECT
    record_id,
    record_type,
    canonical_key,
    title,
    description,
    verification_status,
    valid_from,
    valid_to,
    is_current,
    supersedes_record_id,
    created_at,
    updated_at
FROM records;


DROP TABLE records;

ALTER TABLE records_v11 RENAME TO records;


CREATE INDEX idx_records_type
    ON records(record_type);

CREATE INDEX idx_records_verification
    ON records(verification_status);

CREATE INDEX idx_records_title
    ON records(title);


-- ------------------------------------------------------------
-- 8. REBUILD RESEARCH OUTPUTS
--
-- records.title becomes the single canonical title.
--
-- The actual Version 1.0 research_outputs table was empty.
-- The migration precondition checks this before rebuilding.
-- ------------------------------------------------------------

CREATE TABLE research_outputs_v11 (

    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    output_type TEXT NOT NULL CHECK (
        output_type IN (
            'journal_article',
            'conference_proceedings',
            'conference_abstract',
            'oral_presentation',
            'poster_presentation',
            'thesis',
            'dataset',
            'preprint',
            'technical_report',
            'book_chapter',
            'other'
        )
    ),

    abstract TEXT,

    doi TEXT,
    publication_date TEXT,
    publication_year INTEGER,

    venue TEXT,
    publisher TEXT,
    volume TEXT,
    issue TEXT,
    page_range TEXT,

    publication_status TEXT CHECK (
        publication_status IN (
            'published',
            'accepted',
            'submitted',
            'preprint',
            'unpublished',
            'unknown'
        )
    ),

    peer_review_status TEXT CHECK (
        peer_review_status IN (
            'peer_reviewed',
            'not_peer_reviewed',
            'unknown',
            'not_applicable'
        )
    ),

    primary_url TEXT,
    supplementary_data_url TEXT,

    notes TEXT
);


INSERT INTO research_outputs_v11 (
    record_id,
    output_type,
    abstract,
    doi,
    publication_date,
    publication_year,
    venue,
    publisher,
    volume,
    issue,
    page_range,
    publication_status,
    peer_review_status,
    primary_url,
    supplementary_data_url,
    notes
)
SELECT
    record_id,
    output_type,
    abstract,
    doi,
    publication_date,
    publication_year,
    venue,
    publisher,
    volume,
    issue,
    page_range,
    publication_status,
    peer_review_status,
    primary_url,
    supplementary_data_url,
    notes
FROM research_outputs;


DROP TABLE research_outputs;

ALTER TABLE research_outputs_v11 RENAME TO research_outputs;


CREATE UNIQUE INDEX idx_research_outputs_doi
    ON research_outputs(doi)
    WHERE doi IS NOT NULL AND doi <> '';

CREATE INDEX idx_research_outputs_year
    ON research_outputs(publication_year);

CREATE INDEX idx_research_outputs_type
    ON research_outputs(output_type);


-- ------------------------------------------------------------
-- 9. REBUILD CONFLICT ITEMS
--
-- Introduce a dedicated primary key.
-- Require at least one associated canonical or source record.
-- ------------------------------------------------------------

CREATE TABLE conflict_items_v11 (

    conflict_item_id INTEGER PRIMARY KEY AUTOINCREMENT,

    conflict_id TEXT NOT NULL
        REFERENCES conflicts(conflict_id),

    record_id TEXT
        REFERENCES records(record_id),

    source_record_id TEXT
        REFERENCES source_records(source_record_id),

    competing_value TEXT,
    notes TEXT,

    CHECK (
        record_id IS NOT NULL
        OR source_record_id IS NOT NULL
    )
);


INSERT INTO conflict_items_v11 (
    conflict_id,
    record_id,
    source_record_id,
    competing_value,
    notes
)
SELECT
    conflict_id,
    record_id,
    source_record_id,
    competing_value,
    notes
FROM conflict_items;


DROP TABLE conflict_items;

ALTER TABLE conflict_items_v11 RENAME TO conflict_items;


-- ------------------------------------------------------------
-- 10. CONFERENCE SUBMISSIONS
--
-- Each submission is a distinct record.
-- A submission is not itself proof of presentation.
-- ------------------------------------------------------------

CREATE TABLE conference_submissions (

    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    conference_record_id TEXT NOT NULL
        REFERENCES conferences(record_id),

    output_record_id TEXT
        REFERENCES research_outputs(record_id),

    submission_status TEXT NOT NULL DEFAULT 'unknown'
        CHECK (
            submission_status IN (
                'draft',
                'submitted',
                'accepted',
                'rejected',
                'withdrawn',
                'unknown'
            )
        ),

    submitted_at TEXT,
    decision_date TEXT,

    notes TEXT
);


CREATE INDEX idx_conference_submissions_conference
    ON conference_submissions(conference_record_id);

CREATE INDEX idx_conference_submissions_output
    ON conference_submissions(output_record_id);


-- ------------------------------------------------------------
-- 11. EXTEND PRESENTATIONS
--
-- A presentation may link to a research output and/or
-- the associated conference submission.
-- ------------------------------------------------------------

ALTER TABLE presentations
ADD COLUMN output_record_id TEXT
REFERENCES research_outputs(record_id);

ALTER TABLE presentations
ADD COLUMN submission_record_id TEXT
REFERENCES conference_submissions(record_id);


CREATE INDEX idx_presentations_output
    ON presentations(output_record_id);

CREATE INDEX idx_presentations_submission
    ON presentations(submission_record_id);


-- ------------------------------------------------------------
-- 12. PROJECTS
-- ------------------------------------------------------------

CREATE TABLE projects (

    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    project_type TEXT NOT NULL
        CHECK (
            project_type IN (
                'research',
                'literary',
                'creative',
                'publishing',
                'website',
                'software',
                'digital_platform',
                'research_communication',
                'interdisciplinary',
                'other'
            )
        ),

    project_status TEXT NOT NULL DEFAULT 'unknown'
        CHECK (
            project_status IN (
                'planned',
                'active',
                'paused',
                'completed',
                'archived',
                'discontinued',
                'unknown'
            )
        ),

    start_date TEXT,
    end_date TEXT,

    primary_url TEXT,
    description TEXT,
    notes TEXT
);


CREATE INDEX idx_projects_type
    ON projects(project_type);

CREATE INDEX idx_projects_status
    ON projects(project_status);


-- ------------------------------------------------------------
-- 13. PROJECT CONTRIBUTORS
-- ------------------------------------------------------------

CREATE TABLE project_contributors (

    contributor_id INTEGER PRIMARY KEY AUTOINCREMENT,

    project_record_id TEXT NOT NULL
        REFERENCES projects(record_id),

    person_record_id TEXT NOT NULL
        REFERENCES people(record_id),

    contributor_role TEXT NOT NULL,

    contributor_order INTEGER
        CHECK (
            contributor_order IS NULL
            OR contributor_order >= 1
        ),

    start_date TEXT,
    end_date TEXT,

    notes TEXT,

    UNIQUE (
        project_record_id,
        person_record_id,
        contributor_role
    )
);


CREATE INDEX idx_project_contributors_person
    ON project_contributors(person_record_id);


-- ------------------------------------------------------------
-- 14. CREATIVE WORKS
-- ------------------------------------------------------------

CREATE TABLE creative_works (

    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    work_type TEXT NOT NULL,

    language TEXT,
    medium TEXT,

    publication_date TEXT,
    publisher TEXT,

    primary_url TEXT,

    description TEXT,
    notes TEXT
);


CREATE INDEX idx_creative_works_type
    ON creative_works(work_type);

CREATE INDEX idx_creative_works_language
    ON creative_works(language);


-- ------------------------------------------------------------
-- 15. PROJECT-TO-CREATIVE-WORK RELATIONSHIPS
-- ------------------------------------------------------------

CREATE TABLE project_creative_works (

    project_record_id TEXT NOT NULL
        REFERENCES projects(record_id),

    creative_work_record_id TEXT NOT NULL
        REFERENCES creative_works(record_id),

    relationship_type TEXT NOT NULL,

    notes TEXT,

    PRIMARY KEY (
        project_record_id,
        creative_work_record_id
    )
);


CREATE INDEX idx_project_creative_works_work
    ON project_creative_works(creative_work_record_id);


-- ------------------------------------------------------------
-- 16. PROJECT RELEASES
--
-- Releases are child records, not common records.
-- ------------------------------------------------------------

CREATE TABLE project_releases (

    release_id INTEGER PRIMARY KEY AUTOINCREMENT,

    project_record_id TEXT NOT NULL
        REFERENCES projects(record_id),

    release_version TEXT,

    release_type TEXT NOT NULL
        CHECK (
            release_type IN (
                'software_release',
                'content_release',
                'publication_release',
                'website_update',
                'dataset_release',
                'other'
            )
        ),

    release_date TEXT,

    release_url TEXT,
    repository_url TEXT,

    notes TEXT
);


CREATE INDEX idx_project_releases_project
    ON project_releases(project_record_id);


-- ------------------------------------------------------------
-- 17. RECORD-LEVEL LICENSING
-- ------------------------------------------------------------

CREATE TABLE record_licenses (

    license_assignment_id INTEGER PRIMARY KEY AUTOINCREMENT,

    record_id TEXT NOT NULL
        REFERENCES records(record_id),

    license_scope TEXT NOT NULL
        CHECK (
            license_scope IN (
                'code',
                'written_content',
                'creative_work',
                'dataset',
                'documentation',
                'media',
                'other'
            )
        ),

    applicable_component TEXT,

    license_name TEXT NOT NULL,
    license_identifier TEXT,
    license_url TEXT,

    effective_date TEXT,

    source_record_id TEXT
        REFERENCES source_records(source_record_id),

    notes TEXT
);


CREATE INDEX idx_record_licenses_record
    ON record_licenses(record_id);

CREATE INDEX idx_record_licenses_scope
    ON record_licenses(license_scope);


-- ------------------------------------------------------------
-- 18. CONFERENCE PARTICIPATION
-- ------------------------------------------------------------

CREATE TABLE conference_participations (

    participation_id INTEGER PRIMARY KEY AUTOINCREMENT,

    conference_record_id TEXT NOT NULL
        REFERENCES conferences(record_id),

    person_record_id TEXT NOT NULL
        REFERENCES people(record_id),

    presentation_record_id TEXT
        REFERENCES presentations(record_id),

    submission_record_id TEXT
        REFERENCES conference_submissions(record_id),

    participation_role TEXT NOT NULL
        CHECK (
            participation_role IN (
                'author',
                'presenter',
                'co_presenter',
                'attendee',
                'organizer',
                'committee_member',
                'session_chair',
                'reviewer',
                'other'
            )
        ),

    participation_status TEXT NOT NULL DEFAULT 'unknown'
        CHECK (
            participation_status IN (
                'invited',
                'submitted',
                'accepted',
                'presented',
                'attended',
                'completed',
                'withdrawn',
                'unknown'
            )
        ),

    participation_date TEXT,

    notes TEXT
);


CREATE INDEX idx_conference_participations_conference
    ON conference_participations(conference_record_id);

CREATE INDEX idx_conference_participations_person
    ON conference_participations(person_record_id);

CREATE INDEX idx_conference_participations_presentation
    ON conference_participations(presentation_record_id);


-- ------------------------------------------------------------
-- 19. RECONCILIATION DECISIONS
-- ------------------------------------------------------------

CREATE TABLE reconciliation_decisions (

    decision_id TEXT PRIMARY KEY,

    decision_date TEXT NOT NULL,

    reconciliation_category TEXT NOT NULL,

    classification TEXT NOT NULL
        CHECK (
            classification IN (
                'exact_duplicate',
                'equivalent_representation',
                'complementary_information',
                'updated_information',
                'factual_discrepancy',
                'source_specific_information',
                'unsupported_information',
                'not_comparable',
                'pending_assessment'
            )
        ),

    decision_status TEXT NOT NULL DEFAULT 'proposed'
        CHECK (
            decision_status IN (
                'proposed',
                'under_review',
                'approved',
                'implemented',
                'unresolved',
                'deferred'
            )
        ),

    decision_summary TEXT NOT NULL,
    decision_rationale TEXT,

    evidence_summary TEXT,

    implemented_at TEXT,

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    notes TEXT
);


CREATE INDEX idx_reconciliation_decisions_status
    ON reconciliation_decisions(decision_status);

CREATE INDEX idx_reconciliation_decisions_date
    ON reconciliation_decisions(decision_date);


-- ------------------------------------------------------------
-- 20. RECONCILIATION DECISION ITEMS
-- ------------------------------------------------------------

CREATE TABLE reconciliation_decision_items (

    decision_item_id INTEGER PRIMARY KEY AUTOINCREMENT,

    decision_id TEXT NOT NULL
        REFERENCES reconciliation_decisions(decision_id),

    canonical_record_id TEXT
        REFERENCES records(record_id),

    source_record_id TEXT
        REFERENCES source_records(source_record_id),

    item_role TEXT NOT NULL,

    observed_value TEXT,

    notes TEXT,

    CHECK (
        canonical_record_id IS NOT NULL
        OR source_record_id IS NOT NULL
    )
);


CREATE INDEX idx_reconciliation_items_decision
    ON reconciliation_decision_items(decision_id);

CREATE INDEX idx_reconciliation_items_canonical
    ON reconciliation_decision_items(canonical_record_id);

CREATE INDEX idx_reconciliation_items_source
    ON reconciliation_decision_items(source_record_id);


-- ------------------------------------------------------------
-- 21. KEYWORD TAXONOMY
-- ------------------------------------------------------------

CREATE TABLE keywords (

    keyword_id INTEGER PRIMARY KEY AUTOINCREMENT,

    keyword_text TEXT NOT NULL,

    normalized_keyword TEXT NOT NULL,

    keyword_category TEXT NOT NULL
        CHECK (
            keyword_category IN (
                'research_domain',
                'research_topic',
                'method',
                'material',
                'experimental_technique',
                'computational_technique',
                'application',
                'academic_discipline',
                'identity_descriptor',
                'platform_discovery',
                'other'
            )
        ),

    description TEXT,

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (
        keyword_category,
        normalized_keyword
    )
);


CREATE INDEX idx_keywords_category
    ON keywords(keyword_category);


CREATE INDEX idx_keywords_text
    ON keywords(keyword_text);


-- ------------------------------------------------------------
-- 22. RECORD-TO-KEYWORD RELATIONSHIPS
-- ------------------------------------------------------------

CREATE TABLE record_keywords (

    record_keyword_id INTEGER PRIMARY KEY AUTOINCREMENT,

    record_id TEXT NOT NULL
        REFERENCES records(record_id),

    keyword_id INTEGER NOT NULL
        REFERENCES keywords(keyword_id),

    assignment_classification TEXT NOT NULL DEFAULT 'unclassified'
        CHECK (
            assignment_classification IN (
                'core',
                'established',
                'adjacent',
                'application',
                'method',
                'indexing_term',
                'discovery',
                'unclassified'
            )
        ),

    source_record_id TEXT
        REFERENCES source_records(source_record_id),

    assignment_notes TEXT,

    assigned_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE INDEX idx_record_keywords_record
    ON record_keywords(record_id);

CREATE INDEX idx_record_keywords_keyword
    ON record_keywords(keyword_id);

CREATE INDEX idx_record_keywords_source
    ON record_keywords(source_record_id);


-- ------------------------------------------------------------
-- 23. VERIFICATION-EVENT SCOPE
-- ------------------------------------------------------------

ALTER TABLE verification_events
ADD COLUMN verification_scope TEXT
CHECK (
    verification_scope IN (
        'content',
        'reference',
        'metadata',
        'url_availability',
        'historical'
    )
);


CREATE INDEX idx_verification_scope
    ON verification_events(verification_scope);


-- ------------------------------------------------------------
-- 24. RECORD-TYPE VALIDATION TRIGGERS
--
-- Specialized tables must reference records of the expected type.
-- ------------------------------------------------------------


-- PEOPLE

CREATE TRIGGER trg_people_type_insert
BEFORE INSERT ON people
WHEN NOT EXISTS (
    SELECT 1
    FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'person'
)
BEGIN
    SELECT RAISE(ABORT, 'people requires record_type person');
END;


CREATE TRIGGER trg_people_type_update
BEFORE UPDATE OF record_id ON people
WHEN NOT EXISTS (
    SELECT 1
    FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'person'
)
BEGIN
    SELECT RAISE(ABORT, 'people requires record_type person');
END;


-- INSTITUTIONS

CREATE TRIGGER trg_institutions_type_insert
BEFORE INSERT ON institutions
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'institution'
)
BEGIN
    SELECT RAISE(ABORT, 'institutions requires record_type institution');
END;


CREATE TRIGGER trg_institutions_type_update
BEFORE UPDATE OF record_id ON institutions
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'institution'
)
BEGIN
    SELECT RAISE(ABORT, 'institutions requires record_type institution');
END;


-- IDENTIFIERS

CREATE TRIGGER trg_identifiers_type_insert
BEFORE INSERT ON identifiers
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'identifier'
)
BEGIN
    SELECT RAISE(ABORT, 'identifiers requires record_type identifier');
END;


CREATE TRIGGER trg_identifiers_type_update
BEFORE UPDATE OF record_id ON identifiers
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'identifier'
)
BEGIN
    SELECT RAISE(ABORT, 'identifiers requires record_type identifier');
END;


-- EDUCATION

CREATE TRIGGER trg_education_type_insert
BEFORE INSERT ON education
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'education'
)
BEGIN
    SELECT RAISE(ABORT, 'education requires record_type education');
END;


CREATE TRIGGER trg_education_type_update
BEFORE UPDATE OF record_id ON education
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'education'
)
BEGIN
    SELECT RAISE(ABORT, 'education requires record_type education');
END;


-- APPOINTMENTS

CREATE TRIGGER trg_appointments_type_insert
BEFORE INSERT ON appointments
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'appointment'
)
BEGIN
    SELECT RAISE(ABORT, 'appointments requires record_type appointment');
END;


CREATE TRIGGER trg_appointments_type_update
BEFORE UPDATE OF record_id ON appointments
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'appointment'
)
BEGIN
    SELECT RAISE(ABORT, 'appointments requires record_type appointment');
END;


-- RESEARCH OUTPUTS

CREATE TRIGGER trg_research_outputs_type_insert
BEFORE INSERT ON research_outputs
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'research_output'
)
BEGIN
    SELECT RAISE(ABORT, 'research_outputs requires record_type research_output');
END;


CREATE TRIGGER trg_research_outputs_type_update
BEFORE UPDATE OF record_id ON research_outputs
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'research_output'
)
BEGIN
    SELECT RAISE(ABORT, 'research_outputs requires record_type research_output');
END;


-- CONFERENCES

CREATE TRIGGER trg_conferences_type_insert
BEFORE INSERT ON conferences
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'conference'
)
BEGIN
    SELECT RAISE(ABORT, 'conferences requires record_type conference');
END;


CREATE TRIGGER trg_conferences_type_update
BEFORE UPDATE OF record_id ON conferences
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'conference'
)
BEGIN
    SELECT RAISE(ABORT, 'conferences requires record_type conference');
END;


-- PRESENTATIONS

CREATE TRIGGER trg_presentations_type_insert
BEFORE INSERT ON presentations
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'presentation'
)
BEGIN
    SELECT RAISE(ABORT, 'presentations requires record_type presentation');
END;


CREATE TRIGGER trg_presentations_type_update
BEFORE UPDATE OF record_id ON presentations
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'presentation'
)
BEGIN
    SELECT RAISE(ABORT, 'presentations requires record_type presentation');
END;


-- RESEARCH THEMES

CREATE TRIGGER trg_research_themes_type_insert
BEFORE INSERT ON research_themes
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'research_theme'
)
BEGIN
    SELECT RAISE(ABORT, 'research_themes requires record_type research_theme');
END;


CREATE TRIGGER trg_research_themes_type_update
BEFORE UPDATE OF record_id ON research_themes
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'research_theme'
)
BEGIN
    SELECT RAISE(ABORT, 'research_themes requires record_type research_theme');
END;


-- RESEARCH RELATIONSHIPS

CREATE TRIGGER trg_research_relationships_type_insert
BEFORE INSERT ON research_relationships
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'research_relationship'
)
BEGIN
    SELECT RAISE(ABORT, 'research_relationships requires record_type research_relationship');
END;


CREATE TRIGGER trg_research_relationships_type_update
BEFORE UPDATE OF record_id ON research_relationships
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'research_relationship'
)
BEGIN
    SELECT RAISE(ABORT, 'research_relationships requires record_type research_relationship');
END;


-- LINKS

CREATE TRIGGER trg_links_type_insert
BEFORE INSERT ON links
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'link'
)
BEGIN
    SELECT RAISE(ABORT, 'links requires record_type link');
END;


CREATE TRIGGER trg_links_type_update
BEFORE UPDATE OF record_id ON links
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'link'
)
BEGIN
    SELECT RAISE(ABORT, 'links requires record_type link');
END;


-- AWARDS

CREATE TRIGGER trg_awards_type_insert
BEFORE INSERT ON awards
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'award'
)
BEGIN
    SELECT RAISE(ABORT, 'awards requires record_type award');
END;


CREATE TRIGGER trg_awards_type_update
BEFORE UPDATE OF record_id ON awards
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'award'
)
BEGIN
    SELECT RAISE(ABORT, 'awards requires record_type award');
END;


-- CLAIMS

CREATE TRIGGER trg_claims_type_insert
BEFORE INSERT ON claims
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'claim'
)
BEGIN
    SELECT RAISE(ABORT, 'claims requires record_type claim');
END;


CREATE TRIGGER trg_claims_type_update
BEFORE UPDATE OF record_id ON claims
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'claim'
)
BEGIN
    SELECT RAISE(ABORT, 'claims requires record_type claim');
END;


-- PROJECTS

CREATE TRIGGER trg_projects_type_insert
BEFORE INSERT ON projects
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'project'
)
BEGIN
    SELECT RAISE(ABORT, 'projects requires record_type project');
END;


CREATE TRIGGER trg_projects_type_update
BEFORE UPDATE OF record_id ON projects
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'project'
)
BEGIN
    SELECT RAISE(ABORT, 'projects requires record_type project');
END;


-- CREATIVE WORKS

CREATE TRIGGER trg_creative_works_type_insert
BEFORE INSERT ON creative_works
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'creative_work'
)
BEGIN
    SELECT RAISE(ABORT, 'creative_works requires record_type creative_work');
END;


CREATE TRIGGER trg_creative_works_type_update
BEFORE UPDATE OF record_id ON creative_works
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'creative_work'
)
BEGIN
    SELECT RAISE(ABORT, 'creative_works requires record_type creative_work');
END;


-- CONFERENCE SUBMISSIONS

CREATE TRIGGER trg_conference_submissions_type_insert
BEFORE INSERT ON conference_submissions
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'conference_submission'
)
BEGIN
    SELECT RAISE(ABORT, 'conference_submissions requires record_type conference_submission');
END;


CREATE TRIGGER trg_conference_submissions_type_update
BEFORE UPDATE OF record_id ON conference_submissions
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.record_id
      AND record_type = 'conference_submission'
)
BEGIN
    SELECT RAISE(ABORT, 'conference_submissions requires record_type conference_submission');
END;


-- OUTPUT AUTHORS

CREATE TRIGGER trg_output_authors_type_insert
BEFORE INSERT ON output_authors
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.output_record_id
      AND record_type = 'research_output'
)
BEGIN
    SELECT RAISE(ABORT, 'output_authors requires a research_output record');
END;


CREATE TRIGGER trg_output_authors_type_update
BEFORE UPDATE OF output_record_id ON output_authors
WHEN NOT EXISTS (
    SELECT 1 FROM records
    WHERE record_id = NEW.output_record_id
      AND record_type = 'research_output'
)
BEGIN
    SELECT RAISE(ABORT, 'output_authors requires a research_output record');
END;


-- ------------------------------------------------------------
-- 25. PREVENT INVALID PARENT RECORD-TYPE CHANGES
-- ------------------------------------------------------------

CREATE TRIGGER trg_records_prevent_invalid_type_change
BEFORE UPDATE OF record_type ON records
WHEN
    (
        EXISTS (
            SELECT 1 FROM people
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'person'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM institutions
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'institution'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM identifiers
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'identifier'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM education
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'education'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM appointments
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'appointment'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM research_outputs
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'research_output'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM conferences
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'conference'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM presentations
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'presentation'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM research_themes
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'research_theme'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM research_relationships
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'research_relationship'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM links
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'link'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM awards
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'award'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM claims
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'claim'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM projects
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'project'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM creative_works
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'creative_work'
    )
    OR
    (
        EXISTS (
            SELECT 1 FROM conference_submissions
            WHERE record_id = OLD.record_id
        )
        AND NEW.record_type <> 'conference_submission'
    )
BEGIN
    SELECT RAISE(ABORT, 'record_type change conflicts with specialized-table relationship');
END;


-- ------------------------------------------------------------
-- 26. AUTOMATIC UPDATED_AT MANAGEMENT
-- ------------------------------------------------------------

CREATE TRIGGER trg_records_updated_at
AFTER UPDATE OF
    record_type,
    canonical_key,
    title,
    description,
    verification_status,
    valid_from,
    valid_to,
    is_current,
    supersedes_record_id
ON records

FOR EACH ROW

WHEN NEW.updated_at = OLD.updated_at

BEGIN

    UPDATE records
    SET updated_at = CURRENT_TIMESTAMP
    WHERE record_id = NEW.record_id;

END;


-- ------------------------------------------------------------
-- 27. RECREATE EXISTING VIEWS
-- ------------------------------------------------------------

CREATE VIEW v_profile_subject AS

SELECT
    p.record_id,
    p.preferred_name,
    p.full_name,
    p.biography_summary,
    r.verification_status,
    r.created_at,
    r.updated_at

FROM people p

JOIN records r
    ON r.record_id = p.record_id

WHERE p.is_profile_subject = 1;


CREATE VIEW v_research_outputs AS

SELECT
    r.record_id,
    r.title,
    ro.output_type,
    ro.doi,
    ro.publication_year,
    ro.venue,
    ro.publisher,
    ro.publication_status,
    ro.peer_review_status,
    r.verification_status,
    ro.primary_url

FROM research_outputs ro

JOIN records r
    ON r.record_id = ro.record_id;


CREATE VIEW v_academic_links AS

SELECT
    l.record_id,
    l.url,
    l.link_label,
    l.link_category,
    l.platform,
    l.host,
    l.link_status,
    r.verification_status

FROM links l

JOIN records r
    ON r.record_id = l.record_id;


CREATE VIEW v_record_source_count AS

SELECT
    r.record_id,
    r.record_type,
    r.title,
    COUNT(DISTINCT rp.source_record_id) AS source_record_count

FROM records r

LEFT JOIN record_provenance rp
    ON rp.canonical_record_id = r.record_id

GROUP BY
    r.record_id,
    r.record_type,
    r.title;


-- ------------------------------------------------------------
-- 28. NEW PROJECT VIEW
-- ------------------------------------------------------------

CREATE VIEW v_projects AS

SELECT
    r.record_id,
    r.title,
    r.description,
    p.project_type,
    p.project_status,
    p.start_date,
    p.end_date,
    p.primary_url,
    r.verification_status

FROM projects p

JOIN records r
    ON r.record_id = p.record_id;


-- ------------------------------------------------------------
-- 29. NEW CREATIVE-WORK VIEW
-- ------------------------------------------------------------

CREATE VIEW v_creative_works AS

SELECT
    r.record_id,
    r.title,
    cw.work_type,
    cw.language,
    cw.medium,
    cw.publication_date,
    cw.publisher,
    cw.primary_url,
    r.verification_status

FROM creative_works cw

JOIN records r
    ON r.record_id = cw.record_id;


-- ------------------------------------------------------------
-- 30. NEW CONFERENCE-SUBMISSION VIEW
-- ------------------------------------------------------------

CREATE VIEW v_conference_submissions AS

SELECT
    cs.record_id,
    r.title,
    cs.conference_record_id,
    cs.output_record_id,
    cs.submission_status,
    cs.submitted_at,
    cs.decision_date

FROM conference_submissions cs

JOIN records r
    ON r.record_id = cs.record_id;


-- ------------------------------------------------------------
-- 31. NEW KEYWORD INDEX VIEW
-- ------------------------------------------------------------

CREATE VIEW v_keyword_index AS

SELECT
    rk.record_id,
    r.title,
    k.keyword_id,
    k.keyword_text,
    k.keyword_category,
    rk.assignment_classification,
    rk.source_record_id

FROM record_keywords rk

JOIN records r
    ON r.record_id = rk.record_id

JOIN keywords k
    ON k.keyword_id = rk.keyword_id;


-- ------------------------------------------------------------
-- 32. UPDATE SCHEMA METADATA
--
-- This is deliberately performed after structural operations.
-- ------------------------------------------------------------

UPDATE schema_metadata

SET
    metadata_value = '1.1',
    updated_at = CURRENT_TIMESTAMP

WHERE metadata_key = 'schema_version';


UPDATE schema_metadata

SET
    metadata_value = 'Schema v1.1 migration',
    updated_at = CURRENT_TIMESTAMP

WHERE metadata_key = 'database_status';


-- ------------------------------------------------------------
-- 33. PRE-COMMIT VALIDATION
--
-- Any failed check causes the migration guard to fail.
-- Execute with sqlite3 -bail so failure stops the script.
-- ------------------------------------------------------------

INSERT INTO _migration_guard (ok)

SELECT CASE

    WHEN
        (
            SELECT metadata_value
            FROM schema_metadata
            WHERE metadata_key = 'schema_version'
        ) = '1.1'

        AND (SELECT COUNT(*) FROM records) = 431
        AND (SELECT COUNT(*) FROM links) = 419
        AND (SELECT COUNT(*) FROM research_themes) = 10

        AND (SELECT COUNT(*) FROM sources) = 4
        AND (SELECT COUNT(*) FROM import_batches) = 4
        AND (SELECT COUNT(*) FROM source_records) = 435
        AND (SELECT COUNT(*) FROM record_provenance) = 433

        AND (
            SELECT COUNT(*)
            FROM pragma_foreign_key_check
        ) = 0

        AND (
            SELECT integrity_check
            FROM pragma_integrity_check
            LIMIT 1
        ) = 'ok'

    THEN 1
    ELSE 0
END;


DELETE FROM _migration_guard;

DROP TABLE _migration_guard;


-- ------------------------------------------------------------
-- 34. COMMIT
-- ------------------------------------------------------------

COMMIT;


-- ------------------------------------------------------------
-- 35. RESTORE FOREIGN-KEY ENFORCEMENT
-- ------------------------------------------------------------

PRAGMA foreign_keys = ON;


-- ------------------------------------------------------------
-- 36. FINAL POST-MIGRATION CHECKS
-- ------------------------------------------------------------

PRAGMA foreign_keys;

PRAGMA integrity_check;

PRAGMA foreign_key_check;


-- ------------------------------------------------------------
-- 37. FINAL VERSION AND RECORD COUNTS
-- ------------------------------------------------------------

SELECT
    metadata_key,
    metadata_value

FROM schema_metadata

WHERE metadata_key IN (
    'schema_version',
    'database_status'
);


SELECT
    'canonical_records' AS metric,
    COUNT(*) AS value
FROM records

UNION ALL

SELECT
    'links',
    COUNT(*)
FROM links

UNION ALL

SELECT
    'research_themes',
    COUNT(*)
FROM research_themes

UNION ALL

SELECT
    'source_datasets',
    COUNT(*)
FROM sources

UNION ALL

SELECT
    'import_batches',
    COUNT(*)
FROM import_batches

UNION ALL

SELECT
    'source_records',
    COUNT(*)
FROM source_records

UNION ALL

SELECT
    'record_provenance',
    COUNT(*)
FROM record_provenance;


-- ------------------------------------------------------------
-- END OF MIGRATION
--
-- Expected schema version: 1.1
-- Expected canonical records: 431
-- Expected links: 419
-- Expected research themes: 10
-- Expected source datasets: 4
-- Expected import batches: 4
-- Expected source records: 435
-- Expected provenance relationships: 433
--
-- No new academic records have been imported by this script.
-- No existing profile records have been intentionally deleted.
-- ------------------------------------------------------------
