-- Agora Complex Queries
-- Covers: 5 SELECT, 5 JOIN, 3 GROUP BY + aggregate, 3 subqueries, 2 views, 2 relational algebra

USE agora_db;


-- -----------------------------------------------------------------------
-- SECTION 1: Basic SELECT Queries
-- -----------------------------------------------------------------------

-- Q1. All users sorted by reputation score (highest first)
SELECT user_id, name, email, reputation_score
FROM User
ORDER BY reputation_score DESC;

-- Q2. All open borrow requests (status = pending)
SELECT request_id, resource_id, requester_id, owner_id, requested_at
FROM BorrowRequest
WHERE status = 'pending'
ORDER BY requested_at ASC;

-- Q3. All problems posted in the Database Systems course (course_id = 2)
SELECT problem_id, title, created_at
FROM Problem
WHERE course_id = 2
ORDER BY created_at DESC;

-- Q4. All answers that have been accepted
SELECT answer_id, problem_id, user_id, created_at
FROM Answer
WHERE is_accepted = TRUE
ORDER BY problem_id;

-- Q5. All non-anonymous posts created in September 2025
SELECT post_id, user_id, course_id, LEFT(content, 80) AS preview, created_at
FROM Post
WHERE is_anonymous = FALSE
  AND created_at BETWEEN '2025-09-01 00:00:00' AND '2025-09-30 23:59:59'
ORDER BY created_at DESC;


-- -----------------------------------------------------------------------
-- SECTION 2: JOIN Queries
-- -----------------------------------------------------------------------

-- J1. INNER JOIN — Posts with author name and course code
SELECT p.post_id,
       u.name          AS author,
       c.code          AS course,
       LEFT(p.content, 80) AS preview,
       p.created_at
FROM Post p
INNER JOIN User   u ON p.user_id   = u.user_id
INNER JOIN Course c ON p.course_id = c.course_id
ORDER BY p.created_at DESC;

-- J2. INNER JOIN — Each answer with the problem title and the answering user's name
SELECT a.answer_id,
       pr.title        AS problem,
       u.name          AS answered_by,
       a.is_accepted,
       a.created_at
FROM Answer a
INNER JOIN Problem pr ON a.problem_id = pr.problem_id
INNER JOIN User    u  ON a.user_id    = u.user_id
ORDER BY pr.problem_id, a.is_accepted DESC;

-- J3. LEFT OUTER JOIN — All problems and their accepted answer (NULL if none)
SELECT pr.problem_id,
       pr.title,
       a.answer_id    AS accepted_answer_id,
       u.name         AS accepted_by
FROM Problem pr
LEFT JOIN Answer a ON pr.problem_id = a.problem_id AND a.is_accepted = TRUE
LEFT JOIN User   u ON a.user_id     = u.user_id
ORDER BY pr.problem_id;

-- J4. INNER JOIN — Borrow requests with resource title, requester name, and owner name
SELECT br.request_id,
       r.title        AS resource,
       req.name       AS requester,
       own.name       AS owner,
       br.status,
       br.requested_at
FROM BorrowRequest br
INNER JOIN Resource r  ON br.resource_id  = r.resource_id
INNER JOIN User     req ON br.requester_id = req.user_id
INNER JOIN User     own ON br.owner_id     = own.user_id
ORDER BY br.requested_at DESC;

-- J5. SELF JOIN — All follow pairs with both user names
SELECT f.follow_id,
       follower.name  AS follower,
       followed.name  AS following,
       f.created_at
FROM Follow    f
INNER JOIN User follower ON f.follower_id = follower.user_id
INNER JOIN User followed ON f.followed_id = followed.user_id
ORDER BY follower.name;


-- -----------------------------------------------------------------------
-- SECTION 3: GROUP BY + Aggregate Queries
-- -----------------------------------------------------------------------

-- G1. Number of problems posted per course, sorted by most active
SELECT c.code,
       c.name,
       COUNT(pr.problem_id) AS total_problems
FROM Course  c
LEFT JOIN Problem pr ON c.course_id = pr.course_id
GROUP BY c.course_id, c.code, c.name
ORDER BY total_problems DESC;

-- G2. Top 10 users by total upvotes received across posts, problems, and answers
SELECT u.user_id,
       u.name,
       COALESCE(up.post_upvotes, 0)    AS post_upvotes,
       COALESCE(upr.problem_upvotes, 0) AS problem_upvotes,
       COALESCE(ua.answer_upvotes, 0)  AS answer_upvotes,
       COALESCE(up.post_upvotes, 0)
           + COALESCE(upr.problem_upvotes, 0)
           + COALESCE(ua.answer_upvotes, 0) AS total_upvotes
FROM User u
LEFT JOIN (
    SELECT p.user_id, COUNT(*) AS post_upvotes
    FROM UpvoteOnPost uop
    INNER JOIN Post p ON uop.post_id = p.post_id
    GROUP BY p.user_id
) up ON u.user_id = up.user_id
LEFT JOIN (
    SELECT pr.user_id, COUNT(*) AS problem_upvotes
    FROM UpvoteOnProblem uopr
    INNER JOIN Problem pr ON uopr.problem_id = pr.problem_id
    GROUP BY pr.user_id
) upr ON u.user_id = upr.user_id
LEFT JOIN (
    SELECT a.user_id, COUNT(*) AS answer_upvotes
    FROM UpvoteOnAnswer uoa
    INNER JOIN Answer a ON uoa.answer_id = a.answer_id
    GROUP BY a.user_id
) ua ON u.user_id = ua.user_id
ORDER BY total_upvotes DESC
LIMIT 10;

-- G3. Most-used tags across posts and problems combined
SELECT t.name AS tag,
       COUNT(*) AS usage_count
FROM Tag t
LEFT JOIN PostTag    pt  ON t.tag_id = pt.tag_id
LEFT JOIN ProblemTag prt ON t.tag_id = prt.tag_id
GROUP BY t.tag_id, t.name
ORDER BY usage_count DESC;


-- -----------------------------------------------------------------------
-- SECTION 4: Subqueries
-- -----------------------------------------------------------------------

-- S1. Scalar subquery — Users whose reputation is above the platform average
SELECT user_id, name, reputation_score
FROM User
WHERE reputation_score > (
    SELECT AVG(reputation_score) FROM User
)
ORDER BY reputation_score DESC;

-- S2. Nested subquery — Problems that have received at least one upvote
--     but have no accepted answer yet
SELECT problem_id, title, created_at
FROM Problem
WHERE problem_id IN (
    SELECT DISTINCT problem_id FROM UpvoteOnProblem
)
AND problem_id NOT IN (
    SELECT problem_id FROM Answer WHERE is_accepted = TRUE
)
ORDER BY created_at;

-- S3. Correlated subquery — For each user, show their most recently posted problem
SELECT u.name,
       pr.title,
       pr.created_at
FROM User u
INNER JOIN Problem pr ON u.user_id = pr.user_id
WHERE pr.created_at = (
    SELECT MAX(pr2.created_at)
    FROM Problem pr2
    WHERE pr2.user_id = u.user_id
)
ORDER BY u.name;


-- -----------------------------------------------------------------------
-- SECTION 5: Views
-- -----------------------------------------------------------------------

-- V1. UserReputation — Student leaderboard with total accepted answers and upvotes
CREATE OR REPLACE VIEW UserReputation AS
SELECT u.user_id,
       u.name,
       u.reputation_score,
       COUNT(DISTINCT a.answer_id) AS accepted_answers,
       COALESCE(SUM(uoa.upvote_count), 0) AS answer_upvotes_received
FROM User u
LEFT JOIN Answer a ON u.user_id = a.user_id AND a.is_accepted = TRUE
LEFT JOIN (
    SELECT a2.user_id, COUNT(*) AS upvote_count
    FROM UpvoteOnAnswer uoa2
    INNER JOIN Answer a2 ON uoa2.answer_id = a2.answer_id
    GROUP BY a2.user_id
) uoa ON u.user_id = uoa.user_id
GROUP BY u.user_id, u.name, u.reputation_score
ORDER BY u.reputation_score DESC;

-- V2. CourseActivity — Summary of activity per course
CREATE OR REPLACE VIEW CourseActivity AS
SELECT c.course_id,
       c.code,
       c.name,
       COUNT(DISTINCT e.user_id)   AS enrolled_students,
       COUNT(DISTINCT p.post_id)   AS total_posts,
       COUNT(DISTINCT pr.problem_id) AS total_problems,
       COUNT(DISTINCT r.resource_id) AS total_resources
FROM Course c
LEFT JOIN Enrollment e  ON c.course_id = e.course_id
LEFT JOIN Post       p  ON c.course_id = p.course_id
LEFT JOIN Problem    pr ON c.course_id = pr.course_id
LEFT JOIN Resource   r  ON c.course_id = r.course_id
GROUP BY c.course_id, c.code, c.name
ORDER BY total_problems DESC;


-- -----------------------------------------------------------------------
-- SECTION 6: Relational Algebra Notation
-- -----------------------------------------------------------------------

-- RA1. Users enrolled in course CSCI 411 (course_id = 2)
--
-- Step 1: Select the course record for CSCI 411
--   σ code='CSCI 411' (Course)
--
-- Step 2: Natural join with Enrollment, then natural join with User
--   π user_id, name, email (
--       User ⋈ Enrollment ⋈ σ code='CSCI 411' (Course)
--   )
--
-- SQL equivalent:
SELECT u.user_id, u.name, u.email
FROM User u
NATURAL JOIN Enrollment e
NATURAL JOIN (SELECT * FROM Course WHERE code = 'CSCI 411') c;

-- RA2. Problems that received at least one upvote (upvoted problems)
--
-- Step 1: Project problem_ids that appear in UpvoteOnProblem
--   π problem_id (UpvoteOnProblem)
--
-- Step 2: Join with Problem to get full problem details
--   Problem ⋈ π problem_id (UpvoteOnProblem)
--
-- Step 3: Project desired attributes
--   π problem_id, title, created_at (
--       Problem ⋈ π problem_id (UpvoteOnProblem)
--   )
--
-- SQL equivalent:
SELECT DISTINCT pr.problem_id, pr.title, pr.created_at
FROM Problem pr
INNER JOIN (
    SELECT DISTINCT problem_id FROM UpvoteOnProblem
) upvoted ON pr.problem_id = upvoted.problem_id
ORDER BY pr.created_at;
