-- Agora Transaction Management
-- Demonstrates COMMIT, ROLLBACK, SAVEPOINT, and isolation level changes

USE agora_db;


-- -----------------------------------------------------------------------
-- Transaction 1: Post a problem and tag it atomically
-- If either the problem insert or the tag assignment fails,
-- neither change is committed.
-- -----------------------------------------------------------------------

START TRANSACTION;

INSERT INTO Problem (user_id, course_id, title, description, created_at)
VALUES (1, 2, 'What is a covering index?',
        'I keep seeing the term covering index in query optimization articles. How does it differ from a regular index?',
        NOW());

-- Capture the new problem_id
SET @new_problem_id = LAST_INSERT_ID();

-- Tag it with 'databases' (tag_id = 1) and 'sql' (tag_id = 2)
INSERT INTO ProblemTag (problem_id, tag_id) VALUES (@new_problem_id, 1);
INSERT INTO ProblemTag (problem_id, tag_id) VALUES (@new_problem_id, 2);

COMMIT;


-- -----------------------------------------------------------------------
-- Transaction 2: ROLLBACK demonstration
-- Attempts to update a user's reputation score, then rolls back intentionally
-- to show that uncommitted changes are fully discarded.
-- -----------------------------------------------------------------------

START TRANSACTION;

-- Give user 1 a temporary bonus
UPDATE User SET reputation_score = reputation_score + 50 WHERE user_id = 1;

-- Verify the change is visible within this transaction
SELECT user_id, name, reputation_score FROM User WHERE user_id = 1;

-- Decide to undo — perhaps input validation failed
ROLLBACK;

-- The score is now back to its original value
SELECT user_id, name, reputation_score FROM User WHERE user_id = 1;


-- -----------------------------------------------------------------------
-- Transaction 3: SAVEPOINT — Borrow request approval workflow
-- Approving a borrow request involves updating the request status and
-- incrementing the owner's reputation. SAVEPOINT allows partial rollback
-- if the reputation update fails while preserving the status change.
-- -----------------------------------------------------------------------

START TRANSACTION;

-- Step 1: approve the borrow request
UPDATE BorrowRequest
SET status = 'approved', updated_at = NOW()
WHERE request_id = 2;

SAVEPOINT after_status_update;

-- Step 2: reward the resource owner for sharing
UPDATE User
SET reputation_score = reputation_score + 10
WHERE user_id = (
    SELECT owner_id FROM BorrowRequest WHERE request_id = 2
);

-- If the reputation update fails, roll back only that step
-- (uncomment to simulate failure):
-- ROLLBACK TO SAVEPOINT after_status_update;

-- Both steps succeeded — commit everything
COMMIT;


-- -----------------------------------------------------------------------
-- Transaction 4: Prevent double enrollment anomaly
-- Without a transaction, two concurrent requests could both pass the
-- duplicate check and both insert, violating the UNIQUE constraint.
-- The transaction plus the UNIQUE constraint on (user_id, course_id)
-- guarantees atomicity.
-- -----------------------------------------------------------------------

START TRANSACTION;

-- Check if the enrollment already exists
SELECT COUNT(*) AS already_enrolled
FROM Enrollment
WHERE user_id = 5 AND course_id = 3;

-- Only insert if the above count is 0
-- In application code this is a conditional; here we show the intent
INSERT INTO Enrollment (user_id, course_id, enrolled_at)
VALUES (5, 3, NOW());

COMMIT;
-- If user 5 is already enrolled in course 3, MySQL raises a duplicate key error
-- and the transaction is rolled back automatically.


-- -----------------------------------------------------------------------
-- Isolation Level Demonstration
-- -----------------------------------------------------------------------

-- Default isolation level in MySQL InnoDB
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- READ COMMITTED: allows non-repeatable reads; prevents dirty reads
-- Use when you want fresh reads and can tolerate slightly inconsistent snapshots
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- SERIALIZABLE: highest isolation; each transaction sees a fully consistent snapshot
-- Prevents dirty reads, non-repeatable reads, and phantom reads
-- Use for financial or academic integrity operations
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- READ UNCOMMITTED: lowest isolation; allows dirty reads
-- Rarely used in production; shown here for completeness
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Verify current isolation level
SELECT @@SESSION.transaction_isolation;

-- Reset to default
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
