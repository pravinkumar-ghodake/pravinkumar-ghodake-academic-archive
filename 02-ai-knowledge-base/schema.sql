
-- ============================================================
-- PRAVINKUMAR GHODAKE — CONSOLIDATED ACADEMIC KNOWLEDGE BASE
-- Canonical SQLite database schema
-- Version: 1.0
--
-- One canonical database.
-- Multiple source datasets.
-- Traceable provenance and verification history.
-- ============================================================

PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- ------------------------------------------------------------
-- 1. SCHEMA METADATA
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS schema_metadata (
    metadata_key TEXT PRIMARY KEY,
    metadata_value TEXT NOT NULL,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT OR IGNORE INTO schema_metadata
    (metadata_key, metadata_value)
VALUES
    ('schema_version', '1.0'),
    ('database_name', 'Pravinkumar Ghodake Academic Knowledge Base'),
    ('database_status', 'Initial schema'),
    ('created_at', CURRENT_TIMESTAMP);

-- ------------------------------------------------------------
-- 2. COMMON RECORD REGISTRY
-- All canonical entities receive one stable record ID.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS records (
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
            'other'
        )
    ),

    canonical_key TEXT,
    title TEXT,
    description TEXT,

    verification_status TEXT NOT NULL DEFAULT 'unverified'
        CHECK (verification_status IN (
            'verified',
            'historically_checked',
            'user_attested',
            'title_inferred',
            'unverified',
            'disputed',
            'superseded'
        )),

    valid_from TEXT,
    valid_to TEXT,

    is_current INTEGER NOT NULL DEFAULT 1
        CHECK (is_current IN (0, 1)),

    supersedes_record_id TEXT
        REFERENCES records(record_id),

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(record_type, canonical_key)
);

CREATE INDEX IF NOT EXISTS idx_records_type
    ON records(record_type);

CREATE INDEX IF NOT EXISTS idx_records_verification
    ON records(verification_status);

CREATE INDEX IF NOT EXISTS idx_records_title
    ON records(title);

-- ------------------------------------------------------------
-- 3. PEOPLE AND PROFILE IDENTITY
-- Includes the main profile subject and other authors.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS people (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    preferred_name TEXT,
    full_name TEXT NOT NULL,
    given_name TEXT,
    family_name TEXT,

    name_variants_json TEXT,
    biography_summary TEXT,

    is_profile_subject INTEGER NOT NULL DEFAULT 0
        CHECK (is_profile_subject IN (0, 1)),

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_single_profile_subject
    ON people(is_profile_subject)
    WHERE is_profile_subject = 1;

-- ------------------------------------------------------------
-- 4. INSTITUTIONS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS institutions (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    institution_name TEXT NOT NULL,
    institution_type TEXT,
    country TEXT,
    website_url TEXT,
    official_domain TEXT
);

CREATE INDEX IF NOT EXISTS idx_institution_name
    ON institutions(institution_name);

-- ------------------------------------------------------------
-- 5. ACADEMIC AND PROFESSIONAL IDENTIFIERS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS identifiers (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    person_record_id TEXT NOT NULL
        REFERENCES people(record_id),

    identifier_type TEXT NOT NULL,
    identifier_value TEXT NOT NULL,
    identifier_url TEXT,
    issuing_platform TEXT,

    UNIQUE(identifier_type, identifier_value)
);

CREATE INDEX IF NOT EXISTS idx_identifier_person
    ON identifiers(person_record_id);

-- ------------------------------------------------------------
-- 6. EDUCATION
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS education (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    person_record_id TEXT NOT NULL
        REFERENCES people(record_id),

    institution_record_id TEXT
        REFERENCES institutions(record_id),

    institution_name TEXT,
    qualification TEXT,
    discipline TEXT,
    department TEXT,

    start_date TEXT,
    end_date TEXT,

    status TEXT,
    description TEXT
);

CREATE INDEX IF NOT EXISTS idx_education_person
    ON education(person_record_id);

-- ------------------------------------------------------------
-- 7. APPOINTMENTS, TEACHING AND MEMBERSHIPS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS appointments (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    person_record_id TEXT NOT NULL
        REFERENCES people(record_id),

    institution_record_id TEXT
        REFERENCES institutions(record_id),

    institution_name TEXT,
    department TEXT,

    role_title TEXT NOT NULL,

    appointment_type TEXT CHECK (
        appointment_type IN (
            'academic_position',
            'teaching',
            'research',
            'committee',
            'membership',
            'scholarship',
            'other'
        )
    ),

    start_date TEXT,
    end_date TEXT,
    description TEXT
);

CREATE INDEX IF NOT EXISTS idx_appointments_person
    ON appointments(person_record_id);

-- ------------------------------------------------------------
-- 8. AUTHORS
-- Authors are linked to people records.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS output_authors (
    output_record_id TEXT NOT NULL
        REFERENCES records(record_id),

    author_record_id TEXT NOT NULL
        REFERENCES people(record_id),

    author_order INTEGER NOT NULL,

    author_role TEXT,
    is_corresponding INTEGER NOT NULL DEFAULT 0
        CHECK (is_corresponding IN (0, 1)),

    PRIMARY KEY(output_record_id, author_record_id),
    UNIQUE(output_record_id, author_order)
);

-- ------------------------------------------------------------
-- 9. RESEARCH OUTPUTS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS research_outputs (
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

    title TEXT NOT NULL,
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

CREATE UNIQUE INDEX IF NOT EXISTS idx_research_outputs_doi
    ON research_outputs(doi)
    WHERE doi IS NOT NULL AND doi <> '';

CREATE INDEX IF NOT EXISTS idx_research_outputs_year
    ON research_outputs(publication_year);

CREATE INDEX IF NOT EXISTS idx_research_outputs_type
    ON research_outputs(output_type);

-- ------------------------------------------------------------
-- 10. CONFERENCES
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS conferences (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    conference_name TEXT NOT NULL,
    edition TEXT,

    organiser TEXT,
    host_institution TEXT,

    city TEXT,
    country TEXT,

    start_date TEXT,
    end_date TEXT,

    official_url TEXT
);

CREATE INDEX IF NOT EXISTS idx_conference_name
    ON conferences(conference_name);

-- ------------------------------------------------------------
-- 11. PRESENTATIONS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS presentations (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    conference_record_id TEXT
        REFERENCES conferences(record_id),

    presenter_record_id TEXT
        REFERENCES people(record_id),

    presentation_title TEXT NOT NULL,

    presentation_type TEXT CHECK (
        presentation_type IN (
            'oral',
            'poster',
            'invited_talk',
            'keynote',
            'other'
        )
    ),

    presentation_date TEXT,
    session_name TEXT,

    abstract TEXT,
    official_url TEXT
);

CREATE INDEX IF NOT EXISTS idx_presentations_conference
    ON presentations(conference_record_id);

-- ------------------------------------------------------------
-- 12. RESEARCH THEMES
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS research_themes (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    theme_name TEXT NOT NULL UNIQUE,

    theme_classification TEXT CHECK (
        theme_classification IN (
            'core',
            'established',
            'adjacent',
            'application',
            'future_interest',
            'unclassified'
        )
    ),

    description TEXT,
    keywords_json TEXT
);

-- ------------------------------------------------------------
-- 13. RELATIONSHIPS BETWEEN RESEARCH THEMES
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS research_relationships (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    source_theme_record_id TEXT NOT NULL
        REFERENCES research_themes(record_id),

    target_theme_record_id TEXT NOT NULL
        REFERENCES research_themes(record_id),

    relationship_type TEXT NOT NULL,

    explanation TEXT,
    supporting_evidence TEXT,

    CHECK (
        source_theme_record_id <> target_theme_record_id
    )
);

-- ------------------------------------------------------------
-- 14. ACADEMIC AND PROFESSIONAL LINKS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS links (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    linked_record_id TEXT
        REFERENCES records(record_id),

    url TEXT NOT NULL,
    normalized_url TEXT,

    link_label TEXT,
    link_category TEXT,
    platform TEXT,
    host TEXT,

    link_status TEXT NOT NULL DEFAULT 'unverified'
        CHECK (link_status IN (
            'active',
            'redirected',
            'broken',
            'restricted',
            'unverified'
        )),

    last_checked_at TEXT,
    notes TEXT
);

CREATE INDEX IF NOT EXISTS idx_links_host
    ON links(host);

CREATE INDEX IF NOT EXISTS idx_links_category
    ON links(link_category);

CREATE INDEX IF NOT EXISTS idx_links_normalized
    ON links(normalized_url);

-- ------------------------------------------------------------
-- 15. AWARDS AND RECOGNITION
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS awards (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    person_record_id TEXT NOT NULL
        REFERENCES people(record_id),

    award_name TEXT NOT NULL,
    awarding_body TEXT,
    award_year INTEGER,

    award_type TEXT,
    description TEXT,
    official_url TEXT
);

-- ------------------------------------------------------------
-- 16. SOURCE DATASETS
-- Each original database or document is registered here.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS sources (
    source_id TEXT PRIMARY KEY,

    source_name TEXT NOT NULL,

    source_type TEXT NOT NULL CHECK (
        source_type IN (
            'chatgpt',
            'perplexity',
            'other_ai',
            'user_supplied',
            'academic_platform',
            'publisher',
            'conference',
            'institution',
            'other'
        )
    ),

    original_filename TEXT,
    original_format TEXT,

    source_version TEXT,
    source_created_at TEXT,
    acquired_at TEXT,

    original_location TEXT,
    checksum_sha256 TEXT,

    description TEXT,
    notes TEXT,

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_sources_type
    ON sources(source_type);

-- ------------------------------------------------------------
-- 17. IMPORT BATCHES
-- Records when and how a dataset was incorporated.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS import_batches (
    import_batch_id TEXT PRIMARY KEY,

    source_id TEXT NOT NULL
        REFERENCES sources(source_id),

    import_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    importer TEXT,
    import_method TEXT,

    records_seen INTEGER DEFAULT 0,
    records_imported INTEGER DEFAULT 0,
    records_skipped INTEGER DEFAULT 0,
    records_flagged INTEGER DEFAULT 0,

    import_status TEXT NOT NULL DEFAULT 'pending'
        CHECK (import_status IN (
            'pending',
            'completed',
            'completed_with_warnings',
            'failed'
        )),

    notes TEXT
);

-- ------------------------------------------------------------
-- 18. ORIGINAL SOURCE RECORDS
-- Preserves the original imported row or object as JSON text.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS source_records (
    source_record_id TEXT PRIMARY KEY,

    source_id TEXT NOT NULL
        REFERENCES sources(source_id),

    import_batch_id TEXT
        REFERENCES import_batches(import_batch_id),

    original_table_name TEXT,
    original_record_id TEXT,
    source_locator TEXT,

    raw_payload TEXT NOT NULL,

    content_hash TEXT,

    imported_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    notes TEXT,

    UNIQUE(import_batch_id, source_locator)
);

CREATE INDEX IF NOT EXISTS idx_source_records_source
    ON source_records(source_id);

CREATE INDEX IF NOT EXISTS idx_source_records_original_id
    ON source_records(original_record_id);

-- ------------------------------------------------------------
-- 19. RECORD PROVENANCE
-- Connects canonical records to every supporting source row.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS record_provenance (
    provenance_id INTEGER PRIMARY KEY AUTOINCREMENT,

    canonical_record_id TEXT NOT NULL
        REFERENCES records(record_id),

    source_record_id TEXT NOT NULL
        REFERENCES source_records(source_record_id),

    relationship_type TEXT NOT NULL DEFAULT 'derived_from',

    confidence TEXT CHECK (
        confidence IN (
            'high',
            'medium',
            'low',
            'undetermined'
        )
    ),

    notes TEXT,

    UNIQUE(
        canonical_record_id,
        source_record_id,
        relationship_type
    )
);

CREATE INDEX IF NOT EXISTS idx_provenance_canonical
    ON record_provenance(canonical_record_id);

CREATE INDEX IF NOT EXISTS idx_provenance_source
    ON record_provenance(source_record_id);

-- ------------------------------------------------------------
-- 20. PROFILE CLAIMS
-- Structured claims about the profile subject.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS claims (
    record_id TEXT PRIMARY KEY
        REFERENCES records(record_id) ON DELETE RESTRICT,

    subject_person_record_id TEXT
        REFERENCES people(record_id),

    claim_category TEXT NOT NULL,
    claim_predicate TEXT NOT NULL,

    claim_value TEXT NOT NULL,
    claim_unit TEXT,

    valid_from TEXT,
    valid_to TEXT,

    claim_notes TEXT
);

CREATE INDEX IF NOT EXISTS idx_claims_category
    ON claims(claim_category);

-- ------------------------------------------------------------
-- 21. CLAIM EVIDENCE
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS claim_evidence (
    evidence_id INTEGER PRIMARY KEY AUTOINCREMENT,

    claim_record_id TEXT NOT NULL
        REFERENCES claims(record_id),

    source_record_id TEXT
        REFERENCES source_records(source_record_id),

    evidence_url TEXT,
    evidence_excerpt TEXT,

    evidence_type TEXT CHECK (
        evidence_type IN (
            'primary_source',
            'publisher_record',
            'institutional_record',
            'conference_record',
            'secondary_source',
            'user_statement',
            'ai_generated',
            'other'
        )
    ),

    assessment TEXT,
    checked_at TEXT,

    CHECK (
        source_record_id IS NOT NULL
        OR evidence_url IS NOT NULL
    )
);

CREATE INDEX IF NOT EXISTS idx_claim_evidence_claim
    ON claim_evidence(claim_record_id);

-- ------------------------------------------------------------
-- 22. CONFLICTS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS conflicts (
    conflict_id TEXT PRIMARY KEY,

    conflict_type TEXT NOT NULL,

    description TEXT NOT NULL,

    conflict_status TEXT NOT NULL DEFAULT 'open'
        CHECK (conflict_status IN (
            'open',
            'under_review',
            'resolved',
            'unresolved',
            'accepted_as_ambiguous'
        )),

    resolution TEXT,

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TEXT
);

CREATE TABLE IF NOT EXISTS conflict_items (
    conflict_id TEXT NOT NULL
        REFERENCES conflicts(conflict_id),

    record_id TEXT
        REFERENCES records(record_id),

    source_record_id TEXT
        REFERENCES source_records(source_record_id),

    competing_value TEXT,
    notes TEXT,

    PRIMARY KEY(
        conflict_id,
        record_id,
        source_record_id
    )
);

-- ------------------------------------------------------------
-- 23. VERIFICATION HISTORY
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS verification_events (
    verification_id INTEGER PRIMARY KEY AUTOINCREMENT,

    record_id TEXT NOT NULL
        REFERENCES records(record_id),

    source_record_id TEXT
        REFERENCES source_records(source_record_id),

    verification_status TEXT NOT NULL,

    verification_method TEXT,
    verified_by TEXT,

    evidence_url TEXT,
    verification_notes TEXT,

    verified_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_verification_record
    ON verification_events(record_id);

-- ------------------------------------------------------------
-- 24. CHANGE HISTORY
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS change_log (
    change_id INTEGER PRIMARY KEY AUTOINCREMENT,

    record_id TEXT
        REFERENCES records(record_id),

    change_action TEXT NOT NULL CHECK (
        change_action IN (
            'created',
            'updated',
            'merged',
            'superseded',
            'verified',
            'reclassified',
            'archived'
        )
    ),

    previous_values_json TEXT,
    new_values_json TEXT,

    change_reason TEXT,
    changed_by TEXT,

    changed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_change_log_record
    ON change_log(record_id);

CREATE INDEX IF NOT EXISTS idx_change_log_date
    ON change_log(changed_at);

-- ------------------------------------------------------------
-- 25. USEFUL DATABASE VIEWS
-- ------------------------------------------------------------

CREATE VIEW IF NOT EXISTS v_profile_subject AS
SELECT
    p.record_id,
    p.preferred_name,
    p.full_name,
    p.biography_summary,
    r.verification_status,
    r.created_at,
    r.updated_at
FROM people p
JOIN records r ON r.record_id = p.record_id
WHERE p.is_profile_subject = 1;

CREATE VIEW IF NOT EXISTS v_research_outputs AS
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
JOIN records r ON r.record_id = ro.record_id;

CREATE VIEW IF NOT EXISTS v_academic_links AS
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
JOIN records r ON r.record_id = l.record_id;

CREATE VIEW IF NOT EXISTS v_record_source_count AS
SELECT
    r.record_id,
    r.record_type,
    r.title,
    COUNT(DISTINCT rp.source_record_id) AS source_record_count
FROM records r
LEFT JOIN record_provenance rp
    ON rp.canonical_record_id = r.record_id
GROUP BY r.record_id, r.record_type, r.title;

-- ------------------------------------------------------------
-- 26. INITIAL INDEXING AND COMMIT
-- ------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_output_authors_author
    ON output_authors(author_record_id);

CREATE INDEX IF NOT EXISTS idx_presentations_presenter
    ON presentations(presenter_record_id);

CREATE INDEX IF NOT EXISTS idx_awards_person
    ON awards(person_record_id);

CREATE INDEX IF NOT EXISTS idx_claims_subject
    ON claims(subject_person_record_id);

COMMIT;

-- ============================================================
-- END OF SCHEMA
-- ============================================================
