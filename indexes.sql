-- Agora Index Definitions and Query Optimization Analysis
-- Demonstrates index creation and EXPLAIN PLAN before/after comparison
-- Tested against MySQL 9.6.0

USE agora_db;


-- -----------------------------------------------------------------------
-- Index Definitions
-- -----------------------------------------------------------------------

-- Index 1: Composite index on Post(course_id, created_at)
-- Optimizes the course feed query: WHERE course_id = ? ORDER BY created_at DESC
-- Eliminates a full table scan AND a filesort in a single index scan.
CREATE INDEX idx_post_course_created
ON Post (course_id, created_at DESC);

-- Index 2: Composite index on Problem(course_id, created_at)
-- Same reasoning applied to the Q&A forum listing page.
CREATE INDEX idx_problem_course_created
ON Problem (course_id, created_at DESC);

-- Index 3: Index on Answer(problem_id)
-- Supports fetching all answers for a given problem.
-- NOTE: The UNIQUE constraint uq_answer_user_problem(problem_id, user_id)
-- already covers this lookup because problem_id is its leading column.
-- This explicit index documents intent; MySQL uses the UNIQUE index in practice.
CREATE INDEX idx_answer_problem
ON Answer (problem_id);

-- Index 4: Composite index on BorrowRequest(status, requested_at)
-- Optimizes admin dashboard queries that filter by status and sort by date.
CREATE INDEX idx_borrow_status
ON BorrowRequest (status, requested_at);

-- Index 5: Index on User(email)
-- Supports login and registration duplicate checks.
-- NOTE: The UNIQUE constraint uq_user_email already provides an implicit index
-- on email. This explicit index documents intent; both serve the same lookup.
CREATE INDEX idx_user_email
ON User (email);


-- -----------------------------------------------------------------------
-- EXPLAIN PLAN: Before and After Indexing
-- (IGNORE INDEX simulates the no-index state for before/after comparison)
-- -----------------------------------------------------------------------


-- ── Query 1: Course feed — posts for a given course, newest first ─────────

-- BEFORE (no composite index — full table scan + filesort)
-- Observed output:
--   -> Sort: post.created_at DESC  (cost=2.75 rows=25)
--       -> Filter: (post.course_id = 2)  (cost=2.75 rows=25)
--           -> Table scan on Post  (cost=2.75 rows=25)
EXPLAIN SELECT post_id, user_id, content, created_at
FROM Post IGNORE INDEX (idx_post_course_created)
WHERE course_id = 2
ORDER BY created_at DESC;

-- AFTER (composite index — single index scan, no filesort)
-- Observed output:
--   -> Index lookup on Post using idx_post_course_created (course_id = 2)  (cost=1.43 rows=8)
EXPLAIN SELECT post_id, user_id, content, created_at
FROM Post
WHERE course_id = 2
ORDER BY created_at DESC;

-- Analysis:
--   Without the index: MySQL scans all 25 rows, applies a filter, then sorts.
--   With idx_post_course_created: MySQL jumps directly to rows matching course_id=2
--   and reads them in created_at order from the index — no filesort needed.
--   Cost drops from 2.75 to 1.43; rows examined drops from 25 to 8.


-- ── Query 2: Q&A forum — problems for a course, newest first ─────────────

-- BEFORE
-- Observed output:
--   -> Sort: problem.created_at DESC  (cost=2.35 rows=21)
--       -> Filter: (problem.course_id = 2)  (cost=2.35 rows=21)
--           -> Table scan on Problem  (cost=2.35 rows=21)
EXPLAIN SELECT problem_id, title, description, created_at
FROM Problem IGNORE INDEX (idx_problem_course_created)
WHERE course_id = 2
ORDER BY created_at DESC;

-- AFTER
-- Observed output:
--   -> Index lookup on Problem using idx_problem_course_created (course_id = 2)  (cost=1.33 rows=8)
EXPLAIN SELECT problem_id, title, description, created_at
FROM Problem
WHERE course_id = 2
ORDER BY created_at DESC;

-- Analysis: Same pattern as Post. Full scan + filesort replaced by a direct
-- index lookup. Cost 2.35 → 1.33; rows examined 21 → 8.


-- ── Query 3: Answers for a problem ───────────────────────────────────────

-- BEFORE
EXPLAIN SELECT answer_id, user_id, content, is_accepted
FROM Answer IGNORE INDEX (idx_answer_problem)
WHERE problem_id = 1;

-- AFTER
EXPLAIN SELECT answer_id, user_id, content, is_accepted
FROM Answer
WHERE problem_id = 1;

-- Analysis:
--   idx_answer_problem is effectively redundant: the UNIQUE constraint
--   uq_answer_user_problem(problem_id, user_id) already has problem_id as its
--   leading column, so MySQL uses that index for WHERE problem_id = ? lookups
--   regardless of idx_answer_problem. Both EXPLAIN plans show an index lookup
--   via uq_answer_user_problem. The explicit index documents design intent but
--   adds no measurable performance gain here.


-- -----------------------------------------------------------------------
-- Optimization Summary
-- -----------------------------------------------------------------------

-- idx_post_course_created (Post.course_id, Post.created_at):
--   Composite index satisfies both the WHERE predicate and the ORDER BY in one
--   scan. Eliminates filesort. Cost improvement: 2.75 → 1.43 (48% reduction).

-- idx_problem_course_created (Problem.course_id, Problem.created_at):
--   Identical pattern on the Problem table.
--   Cost improvement: 2.35 → 1.33 (43% reduction).

-- idx_answer_problem (Answer.problem_id):
--   Redundant with uq_answer_user_problem — UNIQUE constraint already covers
--   the leading column. No measurable gain; retained for documentation.

-- idx_borrow_status (BorrowRequest.status, BorrowRequest.requested_at):
--   Covers the admin dashboard filter (status =) and sort (requested_at) pattern.

-- idx_user_email (User.email):
--   Redundant with uq_user_email UNIQUE constraint, which creates an implicit
--   index on email. Retained for documentation and explicit naming.
