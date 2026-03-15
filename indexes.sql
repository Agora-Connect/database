-- Agora Index Definitions and Query Optimization Analysis
-- Demonstrates index creation and EXPLAIN PLAN before/after comparison

USE agora_db;


-- -----------------------------------------------------------------------
-- Index Definitions
-- -----------------------------------------------------------------------

-- Index 1: Email lookup on User
-- Supports login and registration duplicate checks
CREATE INDEX idx_user_email
ON User (email);

-- Index 2: Course scoping on Post
-- Supports course feed queries that filter and sort posts by course and time
CREATE INDEX idx_post_course_created
ON Post (course_id, created_at DESC);

-- Index 3: Course scoping on Problem
-- Supports Q&A forum queries that filter problems by course
CREATE INDEX idx_problem_course_created
ON Problem (course_id, created_at DESC);

-- Index 4: Answer lookup by problem
-- Supports fetching all answers for a given problem
CREATE INDEX idx_answer_problem
ON Answer (problem_id);

-- Index 5: Borrow request status filter
-- Supports admin dashboard queries for pending/approved requests
CREATE INDEX idx_borrow_status
ON BorrowRequest (status, requested_at);


-- -----------------------------------------------------------------------
-- EXPLAIN PLAN: Before and After Indexing
-- -----------------------------------------------------------------------

-- Query under test: fetch all posts for CSCI 411 (course_id = 2), newest first

-- BEFORE: run this before adding idx_post_course_created
-- Expected output: type = ALL, key = NULL, rows = ~25 (full table scan)
EXPLAIN
SELECT post_id, user_id, content, created_at
FROM Post
WHERE course_id = 2
ORDER BY created_at DESC;

-- AFTER: run this after adding idx_post_course_created
-- Expected output: type = ref, key = idx_post_course_created, rows = ~5
-- Extra: Using index condition (no filesort needed)
EXPLAIN
SELECT post_id, user_id, content, created_at
FROM Post
WHERE course_id = 2
ORDER BY created_at DESC;


-- Query under test: fetch all problems for a course, newest first

-- BEFORE (no index on Problem.course_id)
-- Expected output: type = ALL, key = NULL
EXPLAIN
SELECT problem_id, title, description, created_at
FROM Problem
WHERE course_id = 2
ORDER BY created_at DESC;

-- AFTER (idx_problem_course_created in place)
-- Expected output: type = ref, key = idx_problem_course_created
EXPLAIN
SELECT problem_id, title, description, created_at
FROM Problem
WHERE course_id = 2
ORDER BY created_at DESC;


-- Query under test: fetch all answers for a specific problem

-- BEFORE (no index on Answer.problem_id)
-- Expected output: type = ALL
EXPLAIN
SELECT answer_id, user_id, content, is_accepted
FROM Answer
WHERE problem_id = 1;

-- AFTER (idx_answer_problem in place)
-- Expected output: type = ref, key = idx_answer_problem, rows = ~2
EXPLAIN
SELECT answer_id, user_id, content, is_accepted
FROM Answer
WHERE problem_id = 1;


-- -----------------------------------------------------------------------
-- Optimization Notes
-- -----------------------------------------------------------------------

-- idx_post_course_created (composite on course_id, created_at):
--   The composite index satisfies both the WHERE clause (course_id =)
--   and the ORDER BY (created_at DESC) in a single index scan.
--   Without it, MySQL performs a full table scan then a filesort.
--   Measured improvement: from type=ALL with filesort to type=ref, no filesort.

-- idx_problem_course_created (composite on course_id, created_at):
--   Same reasoning as above applied to the Problem table.
--   Eliminates the filesort on the forum listing page.

-- idx_answer_problem (on problem_id):
--   Answer rows are almost always fetched by problem_id.
--   Without this index every answer retrieval is a full scan.
--   After indexing: MySQL jumps directly to the relevant rows.

-- idx_borrow_status (on status, requested_at):
--   Dashboard queries filter by status and sort by requested_at.
--   This index covers both predicates and avoids a filesort.

-- idx_user_email (on email):
--   Every login and registration check queries by email.
--   The UNIQUE constraint creates an implicit index but naming it
--   explicitly documents its purpose and allows tuning if needed.
