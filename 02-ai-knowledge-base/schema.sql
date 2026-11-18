-- ============================================================
-- PRAVINKUMAR GHODAKE — ACADEMIC AND INTELLECTUAL KNOWLEDGE BASE
-- Canonical SQLite database schema
-- Schema version: 1.1
--
-- This file defines an empty Version 1.1 database. It contains
-- schema only, not the profile's records.
--
-- For an existing Version 1.0 database, use:
-- migrations/001_schema_v1_0_to_v1_1.sql
--
-- Create a new database only. Do not run this over profile.sqlite.
-- Run with sqlite3 -bail so a failed statement stops the script.
--
-- VALIDATION RECORD — SEPARATE TEST COPY, 2026-11-18
-- The owner reported that the Version 1.0 to 1.1 migration was
-- rehearsed on profile-v11-test.sqlite, not on the canonical file.
--
-- Reported results:
--   integrity_check: ok
--   foreign_keys: 1
--   foreign_key_check: no rows
--   schema version: 1.1
--   tables: 42; views: 11; triggers: 41
--   preserved canonical records: 431
--   preserved links: 419
--   preserved research themes: 10
--   preserved sources: 4
--   preserved import batches: 4
--   preserved source records: 435
--   preserved provenance relationships: 433
--
-- The owner also reported zero row changes in sqldiff comparisons
-- for records, people, links, research_themes, claims, sources,
-- import_batches, source_records and record_provenance.
--
-- Representative savepoint checks were reported for record-type
-- rejection; projects, contributors and creative works; conference
-- submissions, presentations and participation roles; separate
-- code and written-content licences; release and source links;
-- keywords and reconciliation records; verification scopes; and
-- updated_at handling. Temporary test rows were rolled back.
--
-- These results document structural, preservation and behavior
-- checks on the test copy. They do not establish factual accuracy
-- of each profile record or external source.
-- ============================================================

PRAGMA foreign_keys = ON;

BEGIN IMMEDIATE;


CREATE TABLE schema_metadata(
  metadata_key TEXT PRIMARY KEY,
  metadata_value TEXT NOT NULL,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE people(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  preferred_name TEXT,
  full_name TEXT NOT NULL,
  given_name TEXT,
  family_name TEXT,
  name_variants_json TEXT,
  biography_summary TEXT,
  is_profile_subject INTEGER NOT NULL DEFAULT 0 CHECK(is_profile_subject IN(0,1)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX idx_single_profile_subject ON people(
  is_profile_subject
) WHERE is_profile_subject=1;

CREATE TABLE institutions(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  institution_name TEXT NOT NULL,
  institution_type TEXT,
  country TEXT,
  website_url TEXT,
  official_domain TEXT
);

CREATE INDEX idx_institution_name ON institutions(institution_name);

CREATE TABLE identifiers(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  person_record_id TEXT NOT NULL REFERENCES people(record_id),
  identifier_type TEXT NOT NULL,
  identifier_value TEXT NOT NULL,
  identifier_url TEXT,
  issuing_platform TEXT,
  UNIQUE(identifier_type, identifier_value)
);

CREATE INDEX idx_identifier_person ON identifiers(person_record_id);

CREATE TABLE education(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  person_record_id TEXT NOT NULL REFERENCES people(record_id),
  institution_record_id TEXT REFERENCES institutions(record_id),
  institution_name TEXT,
  qualification TEXT,
  discipline TEXT,
  department TEXT,
  start_date TEXT,
  end_date TEXT,
  status TEXT,
  description TEXT
);

CREATE INDEX idx_education_person ON education(person_record_id);

CREATE TABLE appointments(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  person_record_id TEXT NOT NULL REFERENCES people(record_id),
  institution_record_id TEXT REFERENCES institutions(record_id),
  institution_name TEXT,
  department TEXT,
  role_title TEXT NOT NULL,
  appointment_type TEXT CHECK(appointment_type IN('academic_position','teaching','research','committee','membership','scholarship','other')),
  start_date TEXT,
  end_date TEXT,
  description TEXT
);

CREATE INDEX idx_appointments_person ON appointments(person_record_id);

CREATE TABLE output_authors(
  output_record_id TEXT NOT NULL REFERENCES records(record_id),
  author_record_id TEXT NOT NULL REFERENCES people(record_id),
  author_order INTEGER NOT NULL,
  author_role TEXT,
  is_corresponding INTEGER NOT NULL DEFAULT 0 CHECK(is_corresponding IN(0,1)),
  PRIMARY KEY(output_record_id, author_record_id),
  UNIQUE(output_record_id, author_order)
);

CREATE INDEX idx_output_authors_author ON output_authors(author_record_id);

CREATE TABLE conferences(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
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

CREATE INDEX idx_conference_name ON conferences(conference_name);

CREATE TABLE presentations(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  conference_record_id TEXT REFERENCES conferences(record_id),
  presenter_record_id TEXT REFERENCES people(record_id),
  presentation_title TEXT NOT NULL,
  presentation_type TEXT CHECK(presentation_type IN('oral','poster','invited_talk','keynote','other')),
  presentation_date TEXT,
  session_name TEXT,
  abstract TEXT,
  official_url TEXT,
  output_record_id TEXT REFERENCES research_outputs(record_id),
  submission_record_id TEXT REFERENCES conference_submissions(record_id)
);

CREATE INDEX idx_presentations_conference
  ON presentations(conference_record_id);

CREATE INDEX idx_presentations_presenter
  ON presentations(presenter_record_id);

CREATE TABLE research_themes(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  theme_name TEXT NOT NULL UNIQUE,
  theme_classification TEXT CHECK(theme_classification IN('core','established','adjacent','application','future_interest','unclassified')),
  description TEXT,
  keywords_json TEXT
);

CREATE TABLE research_relationships(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  source_theme_record_id TEXT NOT NULL REFERENCES research_themes(record_id),
  target_theme_record_id TEXT NOT NULL REFERENCES research_themes(record_id),
  relationship_type TEXT NOT NULL,
  explanation TEXT,
  supporting_evidence TEXT,
  CHECK(source_theme_record_id <> target_theme_record_id)
);

CREATE TABLE links(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  linked_record_id TEXT REFERENCES records(record_id),
  url TEXT NOT NULL,
  normalized_url TEXT,
  link_label TEXT,
  link_category TEXT,
  platform TEXT,
  host TEXT,
  link_status TEXT NOT NULL DEFAULT 'unverified' CHECK(link_status IN('active','redirected','broken','restricted','unverified')),
  last_checked_at TEXT,
  notes TEXT
);

CREATE INDEX idx_links_host ON links(host);
CREATE INDEX idx_links_category ON links(link_category);
CREATE INDEX idx_links_normalized ON links(normalized_url);

CREATE TABLE awards(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  person_record_id TEXT NOT NULL REFERENCES people(record_id),
  award_name TEXT NOT NULL,
  awarding_body TEXT,
  award_year INTEGER,
  award_type TEXT,
  description TEXT,
  official_url TEXT
);

CREATE INDEX idx_awards_person ON awards(person_record_id);

CREATE TABLE sources(
  source_id TEXT PRIMARY KEY,
  source_name TEXT NOT NULL,
  source_type TEXT NOT NULL CHECK(source_type IN('chatgpt','perplexity','other_ai','user_supplied','academic_platform','publisher','conference','institution','other')),
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

CREATE INDEX idx_sources_type ON sources(source_type);

CREATE TABLE import_batches(
  import_batch_id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL REFERENCES sources(source_id),
  import_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  importer TEXT,
  import_method TEXT,
  records_seen INTEGER DEFAULT 0,
  records_imported INTEGER DEFAULT 0,
  records_skipped INTEGER DEFAULT 0,
  records_flagged INTEGER DEFAULT 0,
  import_status TEXT NOT NULL DEFAULT 'pending' CHECK(import_status IN('pending','completed','completed_with_warnings','failed')),
  notes TEXT
);

CREATE TABLE source_records(
  source_record_id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL REFERENCES sources(source_id),
  import_batch_id TEXT REFERENCES import_batches(import_batch_id),
  original_table_name TEXT,
  original_record_id TEXT,
  source_locator TEXT,
  raw_payload TEXT NOT NULL,
  content_hash TEXT,
  imported_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes TEXT,
  UNIQUE(import_batch_id, source_locator)
);

CREATE INDEX idx_source_records_source ON source_records(source_id);

CREATE INDEX idx_source_records_original_id
  ON source_records(original_record_id);

CREATE TABLE record_provenance(
  provenance_id INTEGER PRIMARY KEY AUTOINCREMENT,
  canonical_record_id TEXT NOT NULL REFERENCES records(record_id),
  source_record_id TEXT NOT NULL REFERENCES source_records(source_record_id),
  relationship_type TEXT NOT NULL DEFAULT 'derived_from',
  confidence TEXT CHECK(confidence IN('high','medium','low','undetermined')),
  notes TEXT,
  UNIQUE(canonical_record_id, source_record_id, relationship_type)
);

CREATE INDEX idx_provenance_canonical
  ON record_provenance(canonical_record_id);

CREATE INDEX idx_provenance_source
  ON record_provenance(source_record_id);

CREATE TABLE claims(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  subject_person_record_id TEXT REFERENCES people(record_id),
  claim_category TEXT NOT NULL,
  claim_predicate TEXT NOT NULL,
  claim_value TEXT NOT NULL,
  claim_unit TEXT,
  valid_from TEXT,
  valid_to TEXT,
  claim_notes TEXT
);

CREATE INDEX idx_claims_category ON claims(claim_category);
CREATE INDEX idx_claims_subject ON claims(subject_person_record_id);

CREATE TABLE claim_evidence(
  evidence_id INTEGER PRIMARY KEY AUTOINCREMENT,
  claim_record_id TEXT NOT NULL REFERENCES claims(record_id),
  source_record_id TEXT REFERENCES source_records(source_record_id),
  evidence_url TEXT,
  evidence_excerpt TEXT,
  evidence_type TEXT CHECK(evidence_type IN('primary_source','publisher_record','institutional_record','conference_record','secondary_source','user_statement','ai_generated','other')),
  assessment TEXT,
  checked_at TEXT,
  CHECK(source_record_id IS NOT NULL OR evidence_url IS NOT NULL)
);

CREATE INDEX idx_claim_evidence_claim ON claim_evidence(claim_record_id);

CREATE TABLE conflicts(
  conflict_id TEXT PRIMARY KEY,
  conflict_type TEXT NOT NULL,
  description TEXT NOT NULL,
  conflict_status TEXT NOT NULL DEFAULT 'open' CHECK(conflict_status IN('open','under_review','resolved','unresolved','accepted_as_ambiguous')),
  resolution TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at TEXT
);

CREATE TABLE verification_events(
  verification_id INTEGER PRIMARY KEY AUTOINCREMENT,
  record_id TEXT NOT NULL REFERENCES records(record_id),
  source_record_id TEXT REFERENCES source_records(source_record_id),
  verification_status TEXT NOT NULL,
  verification_method TEXT,
  verified_by TEXT,
  evidence_url TEXT,
  verification_notes TEXT,
  verified_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  verification_scope TEXT CHECK(verification_scope IN('content','reference','metadata','url_availability','historical'))
);

CREATE INDEX idx_verification_record
  ON verification_events(record_id);

CREATE INDEX idx_verification_scope
  ON verification_events(verification_scope);

CREATE TABLE change_log(
  change_id INTEGER PRIMARY KEY AUTOINCREMENT,
  record_id TEXT REFERENCES records(record_id),
  change_action TEXT NOT NULL CHECK(change_action IN('created','updated','merged','superseded','verified','reclassified','archived')),
  previous_values_json TEXT,
  new_values_json TEXT,
  change_reason TEXT,
  changed_by TEXT,
  changed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_change_log_record ON change_log(record_id);
CREATE INDEX idx_change_log_date ON change_log(changed_at);

CREATE TABLE records(
  record_id TEXT PRIMARY KEY,
  record_type TEXT NOT NULL CHECK(record_type IN(
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
  )),
  canonical_key TEXT,
  title TEXT,
  description TEXT,
  verification_status TEXT NOT NULL DEFAULT 'unverified'
    CHECK(verification_status IN(
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
  is_current INTEGER NOT NULL DEFAULT 1 CHECK(is_current IN(0,1)),
  supersedes_record_id TEXT REFERENCES records(record_id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(record_type, canonical_key)
);

CREATE INDEX idx_records_type ON records(record_type);
CREATE INDEX idx_records_verification ON records(verification_status);
CREATE INDEX idx_records_title ON records(title);

CREATE TABLE research_outputs(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  output_type TEXT NOT NULL CHECK(output_type IN(
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
  )),
  abstract TEXT,
  doi TEXT,
  publication_date TEXT,
  publication_year INTEGER,
  venue TEXT,
  publisher TEXT,
  volume TEXT,
  issue TEXT,
  page_range TEXT,
  publication_status TEXT CHECK(publication_status IN(
    'published',
    'accepted',
    'submitted',
    'preprint',
    'unpublished',
    'unknown'
  )),
  peer_review_status TEXT CHECK(peer_review_status IN(
    'peer_reviewed',
    'not_peer_reviewed',
    'unknown',
    'not_applicable'
  )),
  primary_url TEXT,
  supplementary_data_url TEXT,
  notes TEXT
);

CREATE UNIQUE INDEX idx_research_outputs_doi
  ON research_outputs(doi)
  WHERE doi IS NOT NULL AND doi <> '';

CREATE INDEX idx_research_outputs_year
  ON research_outputs(publication_year);

CREATE INDEX idx_research_outputs_type
  ON research_outputs(output_type);

CREATE TABLE conflict_items(
  conflict_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
  conflict_id TEXT NOT NULL REFERENCES conflicts(conflict_id),
  record_id TEXT REFERENCES records(record_id),
  source_record_id TEXT REFERENCES source_records(source_record_id),
  competing_value TEXT,
  notes TEXT,
  CHECK(record_id IS NOT NULL OR source_record_id IS NOT NULL)
);

CREATE TABLE conference_submissions(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  conference_record_id TEXT NOT NULL REFERENCES conferences(record_id),
  output_record_id TEXT REFERENCES research_outputs(record_id),
  submission_status TEXT NOT NULL DEFAULT 'unknown'
    CHECK(submission_status IN(
      'draft',
      'submitted',
      'accepted',
      'rejected',
      'withdrawn',
      'unknown'
    )),
  submitted_at TEXT,
  decision_date TEXT,
  notes TEXT
);

CREATE INDEX idx_conference_submissions_conference
  ON conference_submissions(conference_record_id);

CREATE INDEX idx_conference_submissions_output
  ON conference_submissions(output_record_id);

CREATE INDEX idx_presentations_output
  ON presentations(output_record_id);

CREATE INDEX idx_presentations_submission
  ON presentations(submission_record_id);

CREATE TABLE projects(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  project_type TEXT NOT NULL CHECK(project_type IN(
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
  )),
  project_status TEXT NOT NULL DEFAULT 'unknown' CHECK(project_status IN(
    'planned',
    'active',
    'paused',
    'completed',
    'archived',
    'discontinued',
    'unknown'
  )),
  start_date TEXT,
  end_date TEXT,
  notes TEXT
);

CREATE INDEX idx_projects_type ON projects(project_type);
CREATE INDEX idx_projects_status ON projects(project_status);

CREATE TABLE project_contributors(
  contributor_id INTEGER PRIMARY KEY AUTOINCREMENT,
  project_record_id TEXT NOT NULL REFERENCES projects(record_id),
  person_record_id TEXT NOT NULL REFERENCES people(record_id),
  contributor_role TEXT NOT NULL,
  contributor_order INTEGER CHECK(contributor_order IS NULL OR contributor_order >= 1),
  start_date TEXT,
  end_date TEXT,
  notes TEXT,
  UNIQUE(project_record_id, person_record_id, contributor_role)
);

CREATE INDEX idx_project_contributors_person
  ON project_contributors(person_record_id);

CREATE TABLE creative_works(
  record_id TEXT PRIMARY KEY REFERENCES records(record_id) ON DELETE RESTRICT,
  work_type TEXT NOT NULL,
  language TEXT,
  medium TEXT,
  publication_date TEXT,
  publisher TEXT,
  notes TEXT
);

CREATE INDEX idx_creative_works_type ON creative_works(work_type);
CREATE INDEX idx_creative_works_language ON creative_works(language);

CREATE TABLE project_creative_works(
  project_record_id TEXT NOT NULL REFERENCES projects(record_id),
  creative_work_record_id TEXT NOT NULL REFERENCES creative_works(record_id),
  relationship_type TEXT NOT NULL,
  notes TEXT,
  PRIMARY KEY(project_record_id, creative_work_record_id)
);

CREATE INDEX idx_project_creative_works_work
  ON project_creative_works(creative_work_record_id);

CREATE TABLE record_links(
  record_id TEXT NOT NULL REFERENCES records(record_id) ON DELETE CASCADE,
  link_record_id TEXT NOT NULL REFERENCES links(record_id) ON DELETE RESTRICT,
  link_role TEXT NOT NULL DEFAULT 'related' CHECK(link_role IN(
    'primary',
    'homepage',
    'repository',
    'publication',
    'documentation',
    'demo',
    'download',
    'source',
    'related',
    'other'
  )),
  display_order INTEGER NOT NULL DEFAULT 1 CHECK(display_order >= 1),
  notes TEXT,
  PRIMARY KEY(record_id, link_record_id),
  CHECK(record_id <> link_record_id)
);

CREATE INDEX idx_record_links_link ON record_links(link_record_id);
CREATE INDEX idx_record_links_role ON record_links(link_role);

CREATE UNIQUE INDEX idx_record_links_one_primary
  ON record_links(record_id)
  WHERE link_role = 'primary';

CREATE TABLE project_releases(
  release_id INTEGER PRIMARY KEY AUTOINCREMENT,
  project_record_id TEXT NOT NULL REFERENCES projects(record_id) ON DELETE CASCADE,
  release_version TEXT,
  release_type TEXT NOT NULL CHECK(release_type IN(
    'software_release',
    'content_release',
    'publication_release',
    'website_update',
    'dataset_release',
    'other'
  )),
  release_date TEXT,
  notes TEXT,
  UNIQUE(project_record_id, release_version)
);

CREATE INDEX idx_project_releases_project
  ON project_releases(project_record_id);

CREATE INDEX idx_project_releases_date
  ON project_releases(release_date);

CREATE TABLE project_release_links(
  release_id INTEGER NOT NULL REFERENCES project_releases(release_id) ON DELETE CASCADE,
  link_record_id TEXT NOT NULL REFERENCES links(record_id) ON DELETE RESTRICT,
  link_role TEXT NOT NULL CHECK(link_role IN(
    'release',
    'repository',
    'download',
    'documentation',
    'demo',
    'other'
  )),
  display_order INTEGER NOT NULL DEFAULT 1 CHECK(display_order >= 1),
  notes TEXT,
  PRIMARY KEY(release_id, link_record_id)
);

CREATE INDEX idx_project_release_links_link
  ON project_release_links(link_record_id);

CREATE INDEX idx_project_release_links_role
  ON project_release_links(link_role);

CREATE TABLE project_release_sources(
  release_id INTEGER NOT NULL REFERENCES project_releases(release_id) ON DELETE CASCADE,
  source_record_id TEXT NOT NULL REFERENCES source_records(source_record_id) ON DELETE RESTRICT,
  source_role TEXT NOT NULL DEFAULT 'supporting' CHECK(source_role IN(
    'origin',
    'supporting',
    'corroborating',
    'release_announcement',
    'repository_metadata',
    'other'
  )),
  evidence_note TEXT,
  added_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(release_id, source_record_id)
);

CREATE INDEX idx_project_release_sources_source
  ON project_release_sources(source_record_id);

CREATE TABLE record_licenses(
  license_assignment_id INTEGER PRIMARY KEY AUTOINCREMENT,
  record_id TEXT REFERENCES records(record_id) ON DELETE CASCADE,
  release_id INTEGER REFERENCES project_releases(release_id) ON DELETE CASCADE,
  license_scope TEXT NOT NULL CHECK(license_scope IN(
    'code',
    'written_content',
    'creative_work',
    'dataset',
    'documentation',
    'media',
    'other'
  )),
  applicable_component TEXT,
  license_name TEXT NOT NULL,
  license_identifier TEXT,
  license_url TEXT,
  effective_date TEXT,
  notes TEXT,
  CHECK(
    (record_id IS NOT NULL AND release_id IS NULL)
    OR
    (record_id IS NULL AND release_id IS NOT NULL)
  )
);

CREATE INDEX idx_record_licenses_record ON record_licenses(record_id);
CREATE INDEX idx_record_licenses_release ON record_licenses(release_id);
CREATE INDEX idx_record_licenses_scope ON record_licenses(license_scope);

CREATE TABLE license_assignment_sources(
  license_assignment_id INTEGER NOT NULL
    REFERENCES record_licenses(license_assignment_id) ON DELETE CASCADE,
  source_record_id TEXT NOT NULL
    REFERENCES source_records(source_record_id) ON DELETE RESTRICT,
  source_role TEXT NOT NULL DEFAULT 'supporting' CHECK(source_role IN(
    'origin',
    'supporting',
    'corroborating',
    'license_text',
    'repository_metadata',
    'other'
  )),
  evidence_note TEXT,
  added_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(license_assignment_id, source_record_id)
);

CREATE INDEX idx_license_assignment_sources_source
  ON license_assignment_sources(source_record_id);

CREATE TABLE conference_participations(
  participation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  conference_record_id TEXT NOT NULL REFERENCES conferences(record_id),
  person_record_id TEXT NOT NULL REFERENCES people(record_id),
  presentation_record_id TEXT REFERENCES presentations(record_id),
  submission_record_id TEXT REFERENCES conference_submissions(record_id),
  participation_role TEXT NOT NULL CHECK(participation_role IN(
    'author',
    'presenter',
    'co_presenter',
    'attendee',
    'organizer',
    'committee_member',
    'session_chair',
    'reviewer',
    'other'
  )),
  participation_status TEXT NOT NULL DEFAULT 'unknown' CHECK(participation_status IN(
    'invited',
    'submitted',
    'accepted',
    'presented',
    'attended',
    'completed',
    'withdrawn',
    'unknown'
  )),
  participation_date TEXT,
  notes TEXT
);

CREATE INDEX idx_conference_participations_conference
  ON conference_participations(conference_record_id);

CREATE INDEX idx_conference_participations_person
  ON conference_participations(person_record_id);

CREATE INDEX idx_conference_participations_presentation
  ON conference_participations(presentation_record_id);

CREATE TABLE reconciliation_decisions(
  decision_id TEXT PRIMARY KEY,
  decision_date TEXT NOT NULL,
  reconciliation_category TEXT NOT NULL,
  classification TEXT NOT NULL CHECK(classification IN(
    'exact_duplicate',
    'equivalent_representation',
    'complementary_information',
    'updated_information',
    'factual_discrepancy',
    'source_specific_information',
    'unsupported_information',
    'not_comparable',
    'pending_assessment'
  )),
  decision_status TEXT NOT NULL DEFAULT 'proposed' CHECK(decision_status IN(
    'proposed',
    'under_review',
    'approved',
    'implemented',
    'unresolved',
    'deferred'
  )),
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

CREATE TABLE reconciliation_decision_items(
  decision_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
  decision_id TEXT NOT NULL REFERENCES reconciliation_decisions(decision_id),
  canonical_record_id TEXT REFERENCES records(record_id),
  source_record_id TEXT REFERENCES source_records(source_record_id),
  item_role TEXT NOT NULL,
  observed_value TEXT,
  notes TEXT,
  CHECK(canonical_record_id IS NOT NULL OR source_record_id IS NOT NULL)
);

CREATE INDEX idx_reconciliation_items_decision
  ON reconciliation_decision_items(decision_id);

CREATE INDEX idx_reconciliation_items_canonical
  ON reconciliation_decision_items(canonical_record_id);

CREATE INDEX idx_reconciliation_items_source
  ON reconciliation_decision_items(source_record_id);

CREATE TABLE keywords(
  keyword_id INTEGER PRIMARY KEY AUTOINCREMENT,
  keyword_text TEXT NOT NULL,
  normalized_keyword TEXT NOT NULL,
  keyword_category TEXT NOT NULL CHECK(keyword_category IN(
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
  )),
  description TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(keyword_category, normalized_keyword)
);

CREATE INDEX idx_keywords_category ON keywords(keyword_category);
CREATE INDEX idx_keywords_text ON keywords(keyword_text);

CREATE TABLE record_keywords(
  record_keyword_id INTEGER PRIMARY KEY AUTOINCREMENT,
  record_id TEXT NOT NULL REFERENCES records(record_id),
  keyword_id INTEGER NOT NULL REFERENCES keywords(keyword_id),
  assignment_classification TEXT NOT NULL DEFAULT 'unclassified'
    CHECK(assignment_classification IN(
      'core',
      'established',
      'adjacent',
      'application',
      'method',
      'indexing_term',
      'discovery',
      'unclassified'
    )),
  assignment_notes TEXT,
  assigned_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(record_id, keyword_id)
);

CREATE INDEX idx_record_keywords_record ON record_keywords(record_id);
CREATE INDEX idx_record_keywords_keyword ON record_keywords(keyword_id);

CREATE TABLE record_keyword_sources(
  record_keyword_id INTEGER NOT NULL
    REFERENCES record_keywords(record_keyword_id) ON DELETE CASCADE,
  source_record_id TEXT NOT NULL
    REFERENCES source_records(source_record_id) ON DELETE RESTRICT,
  source_role TEXT NOT NULL DEFAULT 'supporting' CHECK(source_role IN(
    'origin',
    'supporting',
    'corroborating',
    'curatorial',
    'imported_from',
    'other'
  )),
  evidence_note TEXT,
  added_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(record_keyword_id, source_record_id)
);

CREATE INDEX idx_record_keyword_sources_source
  ON record_keyword_sources(source_record_id);

CREATE TRIGGER trg_conference_participations_consistency_insert
BEFORE INSERT ON conference_participations
WHEN
    (
        NEW.presentation_record_id IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM presentations p
            WHERE p.record_id = NEW.presentation_record_id
              AND p.conference_record_id IS NEW.conference_record_id
        )
    )
    OR
    (
        NEW.submission_record_id IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM conference_submissions cs
            WHERE cs.record_id = NEW.submission_record_id
              AND cs.conference_record_id IS NEW.conference_record_id
        )
    )
    OR
    (
        NEW.presentation_record_id IS NOT NULL
        AND NEW.submission_record_id IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM presentations p
            WHERE p.record_id = NEW.presentation_record_id
              AND p.submission_record_id IS NEW.submission_record_id
        )
    )
BEGIN
    SELECT RAISE(
        ABORT,
        'Conference participation references inconsistent conference records'
    );
END;

CREATE TRIGGER trg_conference_participations_consistency_update
BEFORE UPDATE OF
    conference_record_id,
    presentation_record_id,
    submission_record_id
ON conference_participations
WHEN
    (
        NEW.presentation_record_id IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM presentations p
            WHERE p.record_id = NEW.presentation_record_id
              AND p.conference_record_id IS NEW.conference_record_id
        )
    )
    OR
    (
        NEW.submission_record_id IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM conference_submissions cs
            WHERE cs.record_id = NEW.submission_record_id
              AND cs.conference_record_id IS NEW.conference_record_id
        )
    )
    OR
    (
        NEW.presentation_record_id IS NOT NULL
        AND NEW.submission_record_id IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM presentations p
            WHERE p.record_id = NEW.presentation_record_id
              AND p.submission_record_id IS NEW.submission_record_id
        )
    )
BEGIN
    SELECT RAISE(
        ABORT,
        'Conference participation references inconsistent conference records'
    );
END;

CREATE TRIGGER trg_presentations_conference_consistency_insert
BEFORE INSERT ON presentations
WHEN NEW.submission_record_id IS NOT NULL
 AND NOT EXISTS (
    SELECT 1
    FROM conference_submissions cs
    WHERE cs.record_id = NEW.submission_record_id
      AND cs.conference_record_id IS NEW.conference_record_id
 )
BEGIN
    SELECT RAISE(
        ABORT,
        'Presentation and submission must belong to the same conference'
    );
END;

CREATE TRIGGER trg_presentations_conference_consistency_update
BEFORE UPDATE OF
    conference_record_id,
    submission_record_id
ON presentations
WHEN
    (
        NEW.submission_record_id IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM conference_submissions cs
            WHERE cs.record_id = NEW.submission_record_id
              AND cs.conference_record_id IS NEW.conference_record_id
        )
    )
    OR EXISTS (
        SELECT 1
        FROM conference_participations cp
        WHERE cp.presentation_record_id = NEW.record_id
          AND cp.conference_record_id IS NOT NEW.conference_record_id
    )
    OR EXISTS (
        SELECT 1
        FROM conference_participations cp
        WHERE cp.presentation_record_id = NEW.record_id
          AND cp.submission_record_id IS NOT NULL
          AND cp.submission_record_id IS NOT NEW.submission_record_id
    )
BEGIN
    SELECT RAISE(
        ABORT,
        'Presentation update would create inconsistent conference relationships'
    );
END;

CREATE TRIGGER trg_conference_submissions_conference_consistency_update
BEFORE UPDATE OF conference_record_id
ON conference_submissions
WHEN
    EXISTS (
        SELECT 1
        FROM presentations p
        WHERE p.submission_record_id = OLD.record_id
          AND p.conference_record_id IS NOT NEW.conference_record_id
    )
    OR EXISTS (
        SELECT 1
        FROM conference_participations cp
        WHERE cp.submission_record_id = OLD.record_id
          AND cp.conference_record_id IS NOT NEW.conference_record_id
    )
BEGIN
    SELECT RAISE(
        ABORT,
        'Submission conference change would invalidate related records'
    );
END;

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

CREATE TRIGGER trg_records_prevent_invalid_type_change
BEFORE UPDATE OF record_type ON records
WHEN
    (
        EXISTS (SELECT 1 FROM people WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'person'
    )
    OR
    (
        EXISTS (SELECT 1 FROM institutions WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'institution'
    )
    OR
    (
        EXISTS (SELECT 1 FROM identifiers WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'identifier'
    )
    OR
    (
        EXISTS (SELECT 1 FROM education WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'education'
    )
    OR
    (
        EXISTS (SELECT 1 FROM appointments WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'appointment'
    )
    OR
    (
        EXISTS (SELECT 1 FROM research_outputs WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'research_output'
    )
    OR
    (
        EXISTS (SELECT 1 FROM conferences WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'conference'
    )
    OR
    (
        EXISTS (SELECT 1 FROM presentations WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'presentation'
    )
    OR
    (
        EXISTS (SELECT 1 FROM research_themes WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'research_theme'
    )
    OR
    (
        EXISTS (SELECT 1 FROM research_relationships WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'research_relationship'
    )
    OR
    (
        EXISTS (SELECT 1 FROM links WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'link'
    )
    OR
    (
        EXISTS (SELECT 1 FROM awards WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'award'
    )
    OR
    (
        EXISTS (SELECT 1 FROM claims WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'claim'
    )
    OR
    (
        EXISTS (SELECT 1 FROM projects WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'project'
    )
    OR
    (
        EXISTS (SELECT 1 FROM creative_works WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'creative_work'
    )
    OR
    (
        EXISTS (SELECT 1 FROM conference_submissions WHERE record_id = OLD.record_id)
        AND NEW.record_type <> 'conference_submission'
    )
BEGIN
    SELECT RAISE(ABORT, 'record_type change conflicts with specialized-table relationship');
END;

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
JOIN records r ON r.record_id = p.record_id
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
JOIN records r ON r.record_id = ro.record_id;

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
JOIN records r ON r.record_id = l.record_id;

CREATE VIEW v_record_source_count AS
SELECT
    r.record_id,
    r.record_type,
    r.title,
    COUNT(DISTINCT rp.source_record_id) AS source_record_count
FROM records r
LEFT JOIN record_provenance rp ON rp.canonical_record_id = r.record_id
GROUP BY r.record_id, r.record_type, r.title;

CREATE VIEW v_projects AS
SELECT
    r.record_id,
    r.title,
    r.description,
    p.project_type,
    p.project_status,
    p.start_date,
    p.end_date,
    (
        SELECT l.url
        FROM record_links rl
        JOIN links l ON l.record_id = rl.link_record_id
        WHERE rl.record_id = p.record_id
          AND rl.link_role IN ('primary', 'homepage')
        ORDER BY
            CASE rl.link_role
                WHEN 'primary' THEN 1
                ELSE 2
            END,
            rl.display_order
        LIMIT 1
    ) AS primary_url,
    r.verification_status
FROM projects p
JOIN records r ON r.record_id = p.record_id;

CREATE VIEW v_creative_works AS
SELECT
    r.record_id,
    r.title,
    r.description,
    cw.work_type,
    cw.language,
    cw.medium,
    cw.publication_date,
    cw.publisher,
    (
        SELECT l.url
        FROM record_links rl
        JOIN links l ON l.record_id = rl.link_record_id
        WHERE rl.record_id = cw.record_id
          AND rl.link_role IN ('primary', 'homepage')
        ORDER BY
            CASE rl.link_role
                WHEN 'primary' THEN 1
                ELSE 2
            END,
            rl.display_order
        LIMIT 1
    ) AS primary_url,
    r.verification_status
FROM creative_works cw
JOIN records r ON r.record_id = cw.record_id;

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
JOIN records r ON r.record_id = cs.record_id;

CREATE VIEW v_keyword_index AS
SELECT
    rk.record_keyword_id,
    rk.record_id,
    r.title,
    k.keyword_id,
    k.keyword_text,
    k.keyword_category,
    rk.assignment_classification,
    rk.assignment_notes,
    COUNT(DISTINCT rks.source_record_id) AS source_count
FROM record_keywords rk
JOIN records r ON r.record_id = rk.record_id
JOIN keywords k ON k.keyword_id = rk.keyword_id
LEFT JOIN record_keyword_sources rks
  ON rks.record_keyword_id = rk.record_keyword_id
GROUP BY
    rk.record_keyword_id,
    rk.record_id,
    r.title,
    k.keyword_id,
    k.keyword_text,
    k.keyword_category,
    rk.assignment_classification,
    rk.assignment_notes;

CREATE VIEW v_keyword_assignment_sources AS
SELECT
    rks.record_keyword_id,
    rk.record_id,
    r.title,
    k.keyword_text,
    rks.source_record_id,
    rks.source_role,
    rks.evidence_note,
    rks.added_at
FROM record_keyword_sources rks
JOIN record_keywords rk ON rk.record_keyword_id = rks.record_keyword_id
JOIN records r ON r.record_id = rk.record_id
JOIN keywords k ON k.keyword_id = rk.keyword_id;

CREATE VIEW v_project_releases AS
SELECT
    pr.release_id,
    pr.project_record_id,
    r.title AS project_title,
    pr.release_version,
    pr.release_type,
    pr.release_date,
    pr.notes,
    (
        SELECT l.url
        FROM project_release_links prl
        JOIN links l ON l.record_id = prl.link_record_id
        WHERE prl.release_id = pr.release_id
          AND prl.link_role = 'release'
        ORDER BY prl.display_order
        LIMIT 1
    ) AS release_url,
    (
        SELECT l.url
        FROM project_release_links prl
        JOIN links l ON l.record_id = prl.link_record_id
        WHERE prl.release_id = pr.release_id
          AND prl.link_role = 'repository'
        ORDER BY prl.display_order
        LIMIT 1
    ) AS repository_url,
    (
        SELECT COUNT(*)
        FROM project_release_sources prs
        WHERE prs.release_id = pr.release_id
    ) AS source_count
FROM project_releases pr
JOIN records r ON r.record_id = pr.project_record_id;

CREATE VIEW v_license_assignments AS
SELECT
    rl.license_assignment_id,
    rl.record_id,
    r.title AS record_title,
    rl.release_id,
    pr.project_record_id,
    pr.release_version,
    rl.license_scope,
    rl.applicable_component,
    rl.license_name,
    rl.license_identifier,
    rl.license_url,
    rl.effective_date,
    (
        SELECT COUNT(*)
        FROM license_assignment_sources las
        WHERE las.license_assignment_id = rl.license_assignment_id
    ) AS source_count,
    rl.notes
FROM record_licenses rl
LEFT JOIN records r ON r.record_id = rl.record_id
LEFT JOIN project_releases pr ON pr.release_id = rl.release_id;


INSERT INTO schema_metadata (metadata_key, metadata_value)
VALUES
  ('schema_version', '1.1'),
  ('database_name', 'Pravinkumar Ghodake Academic Knowledge Base'),
  ('database_status', 'Fresh schema v1.1 definition'),
  ('created_at', CURRENT_TIMESTAMP);

COMMIT;


-- Post-creation checks. These inspect the new empty schema and
-- do not insert or alter profile records.

PRAGMA foreign_keys;
PRAGMA integrity_check;
PRAGMA foreign_key_check;

SELECT
    metadata_key,
    metadata_value
FROM schema_metadata
WHERE metadata_key IN ('schema_version', 'database_status');

SELECT
    type,
    COUNT(*) AS object_count
FROM sqlite_schema
WHERE type IN ('table', 'view', 'trigger')
  AND name NOT LIKE 'sqlite_%'
GROUP BY type
ORDER BY type;
