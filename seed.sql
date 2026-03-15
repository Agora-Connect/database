-- Agora seed data
-- Populates all 18 tables with realistic synthetic data

USE agora_db;

-- Users (20 rows)
INSERT INTO User (email, name, university, reputation_score, created_at) VALUES
('alice.johnson@stcloudstate.edu',   'Alice Johnson',   'Saint Cloud State University', 142, '2025-08-20 09:00:00'),
('bob.smith@stcloudstate.edu',       'Bob Smith',       'Saint Cloud State University',  89, '2025-08-21 10:15:00'),
('carol.white@stcloudstate.edu',     'Carol White',     'Saint Cloud State University', 210, '2025-08-22 11:30:00'),
('david.lee@stcloudstate.edu',       'David Lee',       'Saint Cloud State University',  55, '2025-08-23 08:45:00'),
('emma.davis@stcloudstate.edu',      'Emma Davis',      'Saint Cloud State University', 300, '2025-08-24 14:00:00'),
('frank.garcia@stcloudstate.edu',    'Frank Garcia',    'Saint Cloud State University',  12, '2025-08-25 09:30:00'),
('grace.martinez@stcloudstate.edu',  'Grace Martinez',  'Saint Cloud State University', 175, '2025-08-26 10:00:00'),
('henry.wilson@stcloudstate.edu',    'Henry Wilson',    'Saint Cloud State University',  67, '2025-08-27 11:00:00'),
('isabel.moore@stcloudstate.edu',    'Isabel Moore',    'Saint Cloud State University', 230, '2025-08-28 13:00:00'),
('james.taylor@stcloudstate.edu',    'James Taylor',    'Saint Cloud State University',  40, '2025-08-29 15:00:00'),
('karen.anderson@stcloudstate.edu',  'Karen Anderson',  'Saint Cloud State University', 115, '2025-09-01 08:00:00'),
('liam.thomas@stcloudstate.edu',     'Liam Thomas',     'Saint Cloud State University',  78, '2025-09-02 09:00:00'),
('mia.jackson@stcloudstate.edu',     'Mia Jackson',     'Saint Cloud State University', 190, '2025-09-03 10:00:00'),
('noah.harris@stcloudstate.edu',     'Noah Harris',     'Saint Cloud State University',  25, '2025-09-04 11:00:00'),
('olivia.clark@stcloudstate.edu',    'Olivia Clark',    'Saint Cloud State University', 260, '2025-09-05 12:00:00'),
('peter.lewis@stcloudstate.edu',     'Peter Lewis',     'Saint Cloud State University',  48, '2025-09-06 13:00:00'),
('quinn.robinson@stcloudstate.edu',  'Quinn Robinson',  'Saint Cloud State University', 135, '2025-09-07 14:00:00'),
('rachel.walker@stcloudstate.edu',   'Rachel Walker',   'Saint Cloud State University',  92, '2025-09-08 15:00:00'),
('samuel.hall@stcloudstate.edu',     'Samuel Hall',     'Saint Cloud State University', 155, '2025-09-09 08:30:00'),
('tara.allen@stcloudstate.edu',      'Tara Allen',      'Saint Cloud State University',  33, '2025-09-10 09:30:00');

-- Courses (10 rows)
INSERT INTO Course (code, name, description, created_at) VALUES
('CSCI 301', 'Data Structures',              'Arrays, linked lists, trees, graphs, and algorithm analysis.',           '2025-08-15 08:00:00'),
('CSCI 411', 'Database Systems',             'Relational model, SQL, normalization, transactions, and query optimization.', '2025-08-15 08:00:00'),
('CSCI 350', 'Operating Systems',            'Process management, memory, file systems, and concurrency.',             '2025-08-15 08:00:00'),
('CSCI 480', 'Software Engineering',         'SDLC, design patterns, testing, and agile methodologies.',              '2025-08-15 08:00:00'),
('MATH 221', 'Calculus II',                  'Integration techniques, series, and differential equations.',            '2025-08-15 08:00:00'),
('MATH 310', 'Linear Algebra',               'Vectors, matrices, eigenvalues, and linear transformations.',            '2025-08-15 08:00:00'),
('CSCI 460', 'Computer Networks',            'OSI model, TCP/IP, routing, and network security.',                     '2025-08-15 08:00:00'),
('CSCI 320', 'Programming Languages',        'Syntax, semantics, type systems, and language paradigms.',              '2025-08-15 08:00:00'),
('STAT 380', 'Probability and Statistics',   'Probability distributions, hypothesis testing, and regression.',         '2025-08-15 08:00:00'),
('CSCI 499', 'Senior Capstone Project',      'End-to-end software project from design through deployment.',           '2025-08-15 08:00:00');

-- Enrollments (40 rows — each student enrolled in 2–4 courses)
INSERT INTO Enrollment (user_id, course_id, enrolled_at) VALUES
(1, 1, '2025-08-28 10:00:00'), (1, 2, '2025-08-28 10:01:00'), (1, 5, '2025-08-28 10:02:00'),
(2, 1, '2025-08-28 10:10:00'), (2, 3, '2025-08-28 10:11:00'), (2, 4, '2025-08-28 10:12:00'),
(3, 2, '2025-08-28 10:20:00'), (3, 6, '2025-08-28 10:21:00'),
(4, 1, '2025-08-28 10:30:00'), (4, 5, '2025-08-28 10:31:00'), (4, 7, '2025-08-28 10:32:00'),
(5, 2, '2025-08-28 10:40:00'), (5, 4, '2025-08-28 10:41:00'), (5, 10, '2025-08-28 10:42:00'),
(6, 3, '2025-08-28 10:50:00'), (6, 7, '2025-08-28 10:51:00'),
(7, 2, '2025-08-28 11:00:00'), (7, 8, '2025-08-28 11:01:00'), (7, 9, '2025-08-28 11:02:00'),
(8, 1, '2025-08-28 11:10:00'), (8, 3, '2025-08-28 11:11:00'),
(9, 2, '2025-08-28 11:20:00'), (9, 6, '2025-08-28 11:21:00'), (9, 9, '2025-08-28 11:22:00'),
(10, 4, '2025-08-28 11:30:00'), (10, 5, '2025-08-28 11:31:00'),
(11, 1, '2025-08-28 11:40:00'), (11, 2, '2025-08-28 11:41:00'),
(12, 3, '2025-08-28 11:50:00'), (12, 7, '2025-08-28 11:51:00'), (12, 8, '2025-08-28 11:52:00'),
(13, 2, '2025-08-28 12:00:00'), (13, 9, '2025-08-28 12:01:00'),
(14, 5, '2025-08-28 12:10:00'), (14, 6, '2025-08-28 12:11:00'),
(15, 2, '2025-08-28 12:20:00'), (15, 4, '2025-08-28 12:21:00'), (15, 10, '2025-08-28 12:22:00'),
(16, 1, '2025-08-28 12:30:00'), (16, 3, '2025-08-28 12:31:00');

-- Tags (15 rows)
INSERT INTO Tag (name) VALUES
('databases'), ('sql'), ('normalization'), ('algorithms'), ('data-structures'),
('os'), ('networking'), ('midterm'), ('homework'), ('exam-prep'),
('linear-algebra'), ('calculus'), ('python'), ('concurrency'), ('study-group');

-- Posts (25 rows)
INSERT INTO Post (user_id, course_id, content, is_anonymous, created_at) VALUES
(1,  2,  'Just finished setting up MySQL on my machine — anyone else getting a charset error on macOS?', FALSE, '2025-09-10 09:00:00'),
(2,  1,  'Can someone explain the difference between a B-tree and a B+ tree? The textbook explanation is confusing me.', FALSE, '2025-09-11 10:00:00'),
(3,  2,  'Reminder: the ER diagram assignment is due this Friday. Start early.', FALSE, '2025-09-12 08:30:00'),
(4,  5,  'Does anyone have a good resource for integration by parts? The examples in the book are not great.', FALSE, '2025-09-12 11:00:00'),
(5,  4,  'Our team is using Git for the capstone project. Happy to help anyone who is new to version control.', FALSE, '2025-09-13 14:00:00'),
(6,  3,  'I keep getting a segfault in my process scheduler code. Anyone seen this before?', FALSE, '2025-09-14 09:00:00'),
(7,  2,  'Pro tip: draw your ER diagram before writing any SQL. Saves a lot of time refactoring later.', FALSE, '2025-09-15 10:00:00'),
(8,  1,  'Has anyone implemented merge sort iteratively instead of recursively? Curious if it is worth it.', FALSE, '2025-09-15 11:00:00'),
(9,  2,  'Indexing lecture today was really good. EXPLAIN PLAN makes so much more sense now.', FALSE, '2025-09-16 13:00:00'),
(10, 5,  'Studying for the Calculus II midterm. Anyone want to form a study group?', FALSE, '2025-09-17 15:00:00'),
(11, 2,  'What is the difference between 2NF and 3NF? I keep mixing them up.', FALSE, '2025-09-18 09:00:00'),
(1,  2,  'Here is a quick cheat sheet I made for SQL join types — hope it helps someone.', FALSE, '2025-09-19 10:00:00'),
(13, 9,  'Anyone else struggling with hypothesis testing? The p-value interpretation is tricky.', FALSE, '2025-09-19 11:00:00'),
(3,  6,  'Just solved the matrix diagonalization problem from last week. Key insight: find eigenvectors first.', FALSE, '2025-09-20 09:00:00'),
(15, 2,  'Transaction isolation levels explained in plain English: read the Wikipedia article on serializability. It is actually clear.', FALSE, '2025-09-20 14:00:00'),
(5,  10, 'Agora team checking in. We are about 60 percent done with the database layer.', FALSE, '2025-09-21 10:00:00'),
(7,  8,  'Haskell is hurting my brain but also kind of beautiful? Anyone else feel this way?', FALSE, '2025-09-22 11:00:00'),
(9,  6,  'Quick linear algebra tip: to check if vectors are linearly independent, form a matrix and row reduce.', FALSE, '2025-09-22 14:00:00'),
(12, 7,  'The TCP three-way handshake finally clicked for me. Drawing it out as a timeline diagram really helped.', FALSE, '2025-09-23 09:00:00'),
(2,  3,  'Does anyone have notes from the memory management lecture? I missed it.', TRUE,  '2025-09-23 10:00:00'),
(4,  1,  'Red-black trees are way harder to implement than AVL trees. Anyone agree?', FALSE, '2025-09-24 09:00:00'),
(16, 1,  'Office hours are super helpful for algorithm questions. Professor goes through examples very carefully.', FALSE, '2025-09-24 15:00:00'),
(17, 2,  'Working on the indexing report. Saw a 3x speedup after adding a composite index on (course_id, created_at). Wild.', FALSE, '2025-09-25 10:00:00'),
(19, 9,  'Stat study session this Sunday at the library — DM me if you want to join.', FALSE, '2025-09-25 11:00:00'),
(20, 5,  'Is there a difference between improper integrals and definite integrals with infinite limits? Someone clarify please.', FALSE, '2025-09-26 09:00:00');

-- Problems (20 rows)
INSERT INTO Problem (user_id, course_id, title, description, created_at) VALUES
(2,  2,  'What is the difference between 2NF and 3NF?',
    'I understand partial dependencies but I am not sure how transitive dependencies differ. Can someone give a concrete example?',
    '2025-09-11 09:00:00'),
(4,  1,  'How does quicksort handle already-sorted arrays?',
    'My quicksort is O(n^2) on sorted input. Is this expected? How can I fix it?',
    '2025-09-12 10:00:00'),
(6,  3,  'Why does my semaphore implementation cause a deadlock?',
    'I have two threads each waiting for a resource the other holds. I tried reordering the acquire calls but still deadlock.',
    '2025-09-13 11:00:00'),
(8,  1,  'When should I use a hash map vs a balanced BST?',
    'Both give fast lookups but I am not sure which to choose for my project. What are the tradeoffs?',
    '2025-09-14 09:00:00'),
(10, 5,  'How do I solve integrals with trigonometric substitution?',
    'The substitution rules make sense individually but I am not sure when to apply each one.',
    '2025-09-14 14:00:00'),
(12, 7,  'What is the difference between TCP and UDP?',
    'I know TCP is reliable and UDP is not but I need a deeper explanation of how the reliability mechanisms work.',
    '2025-09-15 10:00:00'),
(14, 6,  'How do I find eigenvalues of a 3x3 matrix?',
    'I know the formula det(A - lambda*I) = 0 but the algebra gets messy. Any shortcuts?',
    '2025-09-15 11:00:00'),
(1,  2,  'What does EXPLAIN output in MySQL actually tell you?',
    'I ran EXPLAIN on a query and got a lot of columns I do not understand. What should I focus on?',
    '2025-09-16 09:00:00'),
(3,  2,  'Is Boyce-Codd Normal Form always better than 3NF?',
    'The lecture said BCNF can cause lossless decomposition issues. When would you choose 3NF over BCNF?',
    '2025-09-17 10:00:00'),
(5,  4,  'What design pattern should I use for a plugin system?',
    'I want to allow third-party code to extend my application without modifying the core. What patterns apply here?',
    '2025-09-17 11:00:00'),
(7,  2,  'When should I use a clustered vs non-clustered index?',
    'I understand what they are but I am not sure how to decide which one to use for a given query.',
    '2025-09-18 09:00:00'),
(9,  2,  'How does a transaction rollback work internally in MySQL?',
    'I know ROLLBACK undoes changes but I am curious how MySQL tracks what needs to be undone.',
    '2025-09-18 14:00:00'),
(11, 2,  'Can a foreign key reference a non-primary key column?',
    'My schema has a unique column that is not the primary key. Can I create a foreign key pointing to it?',
    '2025-09-19 09:00:00'),
(13, 9,  'What is the difference between Type I and Type II errors?',
    'I keep confusing false positives and false negatives. Can someone give an intuitive example?',
    '2025-09-19 11:00:00'),
(15, 2,  'What is the READ COMMITTED isolation level and when should I use it?',
    'I understand SERIALIZABLE but READ COMMITTED confuses me. What anomalies does it prevent and which does it allow?',
    '2025-09-20 10:00:00'),
(17, 8,  'What is the difference between call-by-value and call-by-reference semantics?',
    'I thought I understood this in C but now in Haskell the semantics seem completely different.',
    '2025-09-21 09:00:00'),
(19, 9,  'How do I interpret a p-value in practice?',
    'My p-value is 0.03. My professor says reject the null but I am not sure what that means practically.',
    '2025-09-21 11:00:00'),
(2,  3,  'What is the difference between a mutex and a semaphore?',
    'I have read the definitions but I am still not sure when to use one vs the other in practice.',
    '2025-09-22 09:00:00'),
(4,  5,  'How do you evaluate an improper integral that diverges?',
    'I set up the limit correctly but I am not sure how to determine whether it converges or diverges.',
    '2025-09-22 14:00:00'),
(16, 1,  'What is amortized analysis and when do you use it?',
    'My professor mentioned it in the context of dynamic arrays. I am not clear on the concept.',
    '2025-09-23 10:00:00');

-- Answers (35 rows)
INSERT INTO Answer (problem_id, user_id, content, is_accepted, created_at) VALUES
-- Problem 1: 2NF vs 3NF
(1, 1,  '2NF removes partial dependencies on a composite key. 3NF goes further and removes transitive dependencies — where a non-key column depends on another non-key column. Example: if a table has (student_id, course_id, instructor_name, instructor_office), the last two columns depend on instructor, not the full key. That is a transitive dependency violating 3NF.', TRUE,  '2025-09-11 10:00:00'),
(1, 5,  'Think of it this way: 2NF is about the primary key, 3NF is about everything else. Once you fix partial dependencies (2NF), check if any non-key attribute determines another non-key attribute (3NF violation).', FALSE, '2025-09-11 11:00:00'),
-- Problem 2: Quicksort on sorted input
(2, 3,  'Yes, this is expected behavior with a naive pivot selection. Quicksort degrades to O(n^2) when the pivot is always the smallest or largest element, which happens with sorted input. Fix: use median-of-three pivot selection or randomize the pivot.', TRUE,  '2025-09-12 11:00:00'),
(2, 9,  'Another fix is to use the random pivot strategy — pick a random index, swap it with the last element, then proceed normally. This makes worst-case behavior extremely unlikely in practice.', FALSE, '2025-09-12 14:00:00'),
-- Problem 3: Semaphore deadlock
(3, 1,  'This is a classic circular wait condition. The fix is to enforce a consistent lock acquisition order across all threads. If thread A always acquires lock 1 before lock 2, and thread B does the same, deadlock cannot occur.', TRUE,  '2025-09-13 12:00:00'),
-- Problem 4: Hash map vs BST
(4, 5,  'Use a hash map when you only need O(1) average lookup/insert and do not care about ordering. Use a BST when you need sorted iteration, range queries, or guaranteed O(log n) worst case. Hash maps can degrade to O(n) with bad hash functions.', TRUE,  '2025-09-14 10:00:00'),
(4, 15, 'Also consider: hash maps use more memory and rehashing can be expensive. BSTs have better cache locality in some implementations. For most use cases where you just need fast lookup, hash maps win.', FALSE, '2025-09-14 13:00:00'),
-- Problem 5: Trig substitution
(5, 7,  'The pattern to remember: sqrt(a^2 - x^2) → use x = a*sin(theta); sqrt(a^2 + x^2) → use x = a*tan(theta); sqrt(x^2 - a^2) → use x = a*sec(theta). Identify the form under the radical and match it.', TRUE,  '2025-09-14 16:00:00'),
-- Problem 6: TCP vs UDP
(6, 4,  'TCP uses sequence numbers, acknowledgments, and retransmission to guarantee delivery and ordering. UDP just fires packets and does not track them. Use TCP for anything that requires correctness (HTTP, email). Use UDP when speed matters more than reliability (video streaming, DNS).', TRUE,  '2025-09-15 11:00:00'),
(6, 19, 'A helpful mental model: TCP is like sending a letter with delivery confirmation, UDP is like dropping a postcard in the mailbox and hoping it arrives.', FALSE, '2025-09-15 13:00:00'),
-- Problem 7: Eigenvalues of 3x3
(7, 3,  'For 3x3 matrices the characteristic polynomial is cubic, so the algebra is inherently messy. Shortcut: for triangular matrices the eigenvalues are just the diagonal entries. For symmetric matrices, try to spot obvious eigenvalues and factor them out to reduce to a 2x2.', TRUE,  '2025-09-15 14:00:00'),
-- Problem 8: EXPLAIN output
(8, 5,  'Focus on these columns: type (should be ref or eq_ref, not ALL or index), key (which index is being used), rows (estimated rows scanned), and Extra (watch for Using filesort or Using temporary — those indicate performance issues).', TRUE,  '2025-09-16 10:00:00'),
-- Problem 9: BCNF vs 3NF
(9, 11, 'Choose 3NF when you need to preserve functional dependencies after decomposition. BCNF is stricter and sometimes forces you to lose a dependency to achieve it. In practice, if your schema is in 3NF and there are no anomalies, it is usually fine to leave it there.', TRUE,  '2025-09-17 11:00:00'),
-- Problem 10: Plugin pattern
(10, 2, 'Use the Strategy pattern for interchangeable algorithms, or the Plugin/Extension pattern via interfaces. In practice this usually means: define a well-typed interface, have plugins implement it, and use a registry (a dictionary or service locator) to discover them at runtime.', TRUE,  '2025-09-17 14:00:00'),
-- Problem 11: Clustered vs non-clustered
(11, 1, 'Clustered index determines the physical storage order of the table — there can only be one per table (usually the primary key). Non-clustered indexes are separate structures that point back to the row. Use clustered for your most common range queries; use non-clustered for everything else.', TRUE,  '2025-09-18 10:00:00'),
-- Problem 12: Rollback internals
(12, 17, 'MySQL uses the undo log (part of InnoDB) to track the before-image of every row change within a transaction. On ROLLBACK, it reads the undo log in reverse and restores each row to its previous state. The redo log is used for crash recovery, not rollback.', TRUE,  '2025-09-18 16:00:00'),
-- Problem 13: FK on non-PK
(13, 9, 'Yes, MySQL allows a foreign key to reference any column with a UNIQUE constraint, not just the primary key. The referenced column must have an index (a UNIQUE constraint creates one automatically).', TRUE,  '2025-09-19 10:00:00'),
-- Problem 14: Type I vs Type II errors
(14, 7, 'Type I error (false positive): you reject the null hypothesis when it is actually true. Type II error (false negative): you fail to reject the null when it is actually false. Example: a pregnancy test. Type I = test says positive but you are not pregnant. Type II = test says negative but you are pregnant.', TRUE,  '2025-09-19 13:00:00'),
-- Problem 15: READ COMMITTED
(15, 3, 'READ COMMITTED prevents dirty reads (reading uncommitted data from another transaction) but allows non-repeatable reads (the same row can return different values if re-read within the same transaction because another transaction committed between reads). Good balance for most OLTP workloads.', TRUE,  '2025-09-20 11:00:00'),
-- Problem 16: Call-by-value vs call-by-reference
(16, 8, 'In call-by-value a copy of the argument is passed — the function cannot modify the caller variable. In call-by-reference the memory address is passed — the function can modify the original. Haskell uses call-by-need (lazy evaluation), which is different from both — expressions are evaluated only when their value is actually needed.', TRUE,  '2025-09-21 10:00:00'),
-- Problem 17: p-value
(17, 13, 'A p-value of 0.03 means: if the null hypothesis were true, you would see results as extreme as yours only 3 percent of the time. Since 0.03 < 0.05 (your alpha), you reject the null. Practically: there is statistically significant evidence that your effect is real, but statistical significance does not equal practical significance — consider effect size too.', TRUE, '2025-09-21 14:00:00'),
-- Problem 18: Mutex vs semaphore
(18, 6, 'A mutex is a binary lock with ownership — only the thread that locked it can unlock it. A semaphore is a counter-based signaling mechanism — any thread can signal it. Use a mutex to protect a critical section. Use a semaphore to coordinate between threads (e.g., producer-consumer).', TRUE,  '2025-09-22 10:00:00'),
-- Problem 19: Divergent improper integral
(19, 11, 'For integrals like integral from 1 to infinity of 1/x dx, compute the limit: lim(b → inf) integral from 1 to b of 1/x dx = lim(b → inf) [ln(b) - ln(1)] = infinity. Since the limit is infinite, the integral diverges. Compare with 1/x^2 whose limit is 1 — that one converges.', TRUE,  '2025-09-22 16:00:00'),
-- Problem 20: Amortized analysis
(20, 5, 'Amortized analysis gives the average cost per operation over a sequence of operations, even if individual operations vary in cost. For dynamic arrays: most appends are O(1), but occasional resize operations are O(n). Amortized over n appends, the total is O(n), so each append is O(1) amortized.', TRUE,  '2025-09-23 11:00:00'),
(20, 17, 'The accounting method is useful here: charge each append a small extra cost as credit. Accumulate credits until a resize is needed, then spend the credits to pay for the resize. This keeps the amortized cost constant.', FALSE, '2025-09-23 13:00:00');

-- CommentOnPost (20 rows)
INSERT INTO CommentOnPost (post_id, user_id, content, created_at) VALUES
(1,  3,  'Same issue here. Fixed it by adding --default-authentication-plugin=mysql_native_password to the config.',    '2025-09-10 09:30:00'),
(1,  7,  'Worked for me on macOS 14 after running brew upgrade mysql.',                                                  '2025-09-10 10:00:00'),
(2,  5,  'B+ tree stores all data in leaf nodes and links them — great for range queries. B-tree stores data in all nodes.',  '2025-09-11 10:30:00'),
(3,  8,  'Thanks for the reminder! Started mine last night.',                                                            '2025-09-12 09:00:00'),
(5,  10, 'Git rebase vs merge is something I still struggle with. Would love a quick explainer.',                         '2025-09-13 15:00:00'),
(7,  2,  'Agreed. I wasted two hours last semester because I wrote SQL before designing the schema properly.',            '2025-09-15 10:30:00'),
(9,  4,  'EXPLAIN PLAN is one of those things that seems intimidating but makes sense once you run it a few times.',      '2025-09-16 13:30:00'),
(10, 14, 'I am in for the study group. Sunday afternoon works for me.',                                                  '2025-09-17 15:30:00'),
(10, 20, 'Me too. Let us meet at the library study rooms.',                                                              '2025-09-17 16:00:00'),
(11, 3,  '2NF: no non-key attribute partially depends on the key. 3NF: no non-key attribute transitively depends on the key.', '2025-09-18 09:30:00'),
(12, 6,  'This cheat sheet is really helpful. Mind if I share it with my study group?',                                  '2025-09-19 10:30:00'),
(14, 9,  'Diagonalization only works if the matrix has n linearly independent eigenvectors. Good reminder.',              '2025-09-20 09:30:00'),
(16, 2,  'What stack are you using for the database layer? MySQL or PostgreSQL?',                                        '2025-09-21 10:30:00'),
(17, 4,  'Haskell type inference is where it gets really beautiful. Once you get it, you cannot go back.',               '2025-09-22 11:30:00'),
(19, 3,  'Drawing the timeline was exactly how our professor explained it too. Visual learners unite.',                  '2025-09-23 09:30:00'),
(21, 11, 'Red-black trees are painful to implement but once you get the rotations down it clicks.',                      '2025-09-24 09:30:00'),
(22, 17, 'Professor also posts recorded office hours on the course portal — helpful if you cannot attend live.',         '2025-09-24 15:30:00'),
(23, 9,  'Composite indexes are underused. Great tip.',                                                                  '2025-09-25 10:30:00'),
(24, 1,  'I will be there! What topics are you covering?',                                                               '2025-09-25 11:30:00'),
(25, 7,  'An improper integral with infinite limits is defined as the limit of a proper integral. If the limit exists and is finite, it converges.', '2025-09-26 09:30:00');

-- CommentOnProblem (15 rows)
INSERT INTO CommentOnProblem (problem_id, user_id, content, created_at) VALUES
(1,  6,  'Also check out the Wikipedia page on database normalization — has great visual examples.',             '2025-09-11 09:30:00'),
(2,  11, 'The randomized pivot is the easiest fix and works well in practice.',                                 '2025-09-12 10:30:00'),
(3,  15, 'Have you checked if both threads acquire locks in the same order? That is usually the root cause.',   '2025-09-13 11:30:00'),
(5,  18, 'Khan Academy has a great series on trig substitution with practice problems.',                        '2025-09-14 14:30:00'),
(6,  2,  'For most applications today you should prefer HTTP/3 which uses QUIC (UDP-based) over TCP.',          '2025-09-15 10:30:00'),
(8,  13, 'The rows column in EXPLAIN is just an estimate — do not treat it as exact.',                         '2025-09-16 09:30:00'),
(9,  16, 'For the course project I would aim for 3NF unless the professor specifically asks for BCNF.',         '2025-09-17 10:30:00'),
(11, 4,  'Worth noting: in InnoDB the primary key is always the clustered index.',                              '2025-09-18 09:30:00'),
(12, 2,  'The undo log also supports MVCC — multiple versions of a row can exist simultaneously for different transactions.', '2025-09-18 14:30:00'),
(14, 20, 'A common mnemonic: Type I — you cried wolf (false alarm). Type II — missed the wolf (missed detection).', '2025-09-19 11:30:00'),
(15, 18, 'READ COMMITTED is the default isolation level in many databases including Oracle and SQL Server.',    '2025-09-20 10:30:00'),
(17, 8,  'Also remember that a p-value near 0.05 does not mean strong evidence — consider reporting effect size and confidence intervals too.', '2025-09-21 11:30:00'),
(18, 10, 'Semaphores can also be used for throttling — limit the number of concurrent threads accessing a resource.', '2025-09-22 09:30:00'),
(19, 6,  'The p-series test is your friend here: sum of 1/n^p converges if p > 1.',                            '2025-09-22 14:30:00'),
(20, 3,  'Amortized analysis is also used to analyze splay trees and union-find data structures.',              '2025-09-23 10:30:00');

-- CommentOnAnswer (10 rows)
INSERT INTO CommentOnAnswer (answer_id, user_id, content, created_at) VALUES
(1,  4,  'The example with instructor_office really made it click. Thank you.',          '2025-09-11 10:30:00'),
(3,  8,  'Median-of-three also helps with the equal-elements case, not just sorted input.', '2025-09-12 11:30:00'),
(5,  16, 'The consistent lock ordering rule is the standard fix. Good explanation.',      '2025-09-13 12:30:00'),
(8,  1,  'The sin/tan/sec pattern is exactly what I needed. Bookmarking this.',          '2025-09-14 16:30:00'),
(12, 14, 'Using filesort does not always mean an index will help — sometimes the sort is unavoidable.', '2025-09-16 10:30:00'),
(17, 2,  'The pregnancy test example is the clearest explanation of Type I/II I have seen.', '2025-09-19 13:30:00'),
(20, 6,  'Call-by-need vs call-by-name is a subtle distinction worth looking up too.',   '2025-09-21 10:30:00'),
(22, 15, 'The 3 percent explanation is exactly what was missing from my textbook.',      '2025-09-21 14:30:00'),
(24, 12, 'Accounting method explanation is cleaner than the potential method for this case.', '2025-09-23 11:30:00'),
(9,  3,  'The hash map vs BST tradeoff matters a lot in embedded systems where memory is constrained.', '2025-09-14 13:30:00');

-- UpvoteOnPost (30 rows)
INSERT INTO UpvoteOnPost (post_id, user_id, created_at) VALUES
(1, 2, '2025-09-10 09:30:00'), (1, 4, '2025-09-10 10:00:00'), (1, 6, '2025-09-10 10:30:00'),
(2, 1, '2025-09-11 10:30:00'), (2, 3, '2025-09-11 11:00:00'),
(3, 5, '2025-09-12 09:00:00'), (3, 7, '2025-09-12 09:30:00'), (3, 9, '2025-09-12 10:00:00'),
(5, 2, '2025-09-13 14:30:00'), (5, 8, '2025-09-13 15:00:00'), (5, 10, '2025-09-13 15:30:00'),
(7, 1, '2025-09-15 10:30:00'), (7, 3, '2025-09-15 11:00:00'), (7, 5, '2025-09-15 11:30:00'), (7, 11, '2025-09-15 12:00:00'),
(9, 2, '2025-09-16 13:30:00'), (9, 6, '2025-09-16 14:00:00'),
(12, 4, '2025-09-19 10:30:00'), (12, 8, '2025-09-19 11:00:00'), (12, 14, '2025-09-19 11:30:00'),
(15, 1, '2025-09-20 14:30:00'), (15, 9, '2025-09-20 15:00:00'), (15, 13, '2025-09-20 15:30:00'),
(17, 6, '2025-09-22 11:30:00'), (17, 12, '2025-09-22 12:00:00'),
(19, 1, '2025-09-23 09:30:00'), (19, 7, '2025-09-23 10:00:00'), (19, 15, '2025-09-23 10:30:00'),
(23, 3, '2025-09-25 10:30:00'), (23, 11, '2025-09-25 11:00:00');

-- UpvoteOnProblem (25 rows)
INSERT INTO UpvoteOnProblem (problem_id, user_id, created_at) VALUES
(1, 1,  '2025-09-11 09:30:00'), (1, 3,  '2025-09-11 09:45:00'), (1, 5,  '2025-09-11 10:00:00'),
(2, 4,  '2025-09-12 10:30:00'), (2, 6,  '2025-09-12 11:00:00'),
(3, 2,  '2025-09-13 11:30:00'), (3, 8,  '2025-09-13 12:00:00'), (3, 10, '2025-09-13 12:30:00'),
(4, 3,  '2025-09-14 09:30:00'), (4, 7,  '2025-09-14 10:00:00'),
(5, 9,  '2025-09-14 14:30:00'), (5, 11, '2025-09-14 15:00:00'),
(8, 2,  '2025-09-16 09:30:00'), (8, 6,  '2025-09-16 10:00:00'), (8, 12, '2025-09-16 10:30:00'),
(9, 4,  '2025-09-17 10:30:00'), (9, 14, '2025-09-17 11:00:00'),
(11, 1, '2025-09-18 09:30:00'), (11, 5, '2025-09-18 10:00:00'), (11, 13, '2025-09-18 10:30:00'),
(12, 7, '2025-09-18 14:30:00'), (12, 15, '2025-09-18 15:00:00'),
(15, 3, '2025-09-20 10:30:00'), (15, 9, '2025-09-20 11:00:00'),
(20, 2, '2025-09-23 10:30:00');

-- UpvoteOnAnswer (25 rows)
INSERT INTO UpvoteOnAnswer (answer_id, user_id, created_at) VALUES
(1,  3,  '2025-09-11 10:30:00'), (1,  4,  '2025-09-11 11:00:00'), (1,  6,  '2025-09-11 11:30:00'),
(2,  7,  '2025-09-11 11:30:00'),
(3,  5,  '2025-09-12 11:30:00'), (3,  8,  '2025-09-12 12:00:00'),
(6,  1,  '2025-09-14 10:30:00'), (6,  9,  '2025-09-14 11:00:00'), (6,  11, '2025-09-14 11:30:00'),
(8,  2,  '2025-09-14 16:30:00'), (8,  6,  '2025-09-14 17:00:00'),
(9,  3,  '2025-09-15 11:30:00'), (9,  7,  '2025-09-15 12:00:00'),
(12, 4,  '2025-09-16 10:30:00'), (12, 10, '2025-09-16 11:00:00'), (12, 14, '2025-09-16 11:30:00'),
(13, 2,  '2025-09-17 11:30:00'), (13, 8,  '2025-09-17 12:00:00'),
(16, 3,  '2025-09-18 10:30:00'), (16, 11, '2025-09-18 11:00:00'),
(18, 1,  '2025-09-19 10:30:00'), (18, 5,  '2025-09-19 11:00:00'),
(21, 4,  '2025-09-20 11:30:00'), (21, 12, '2025-09-20 12:00:00'),
(25, 6,  '2025-09-23 11:30:00');

-- Follow (20 rows)
INSERT INTO Follow (follower_id, followed_id, created_at) VALUES
(1, 3,  '2025-09-01 10:00:00'), (1, 5,  '2025-09-01 10:05:00'), (1, 9,  '2025-09-01 10:10:00'),
(2, 1,  '2025-09-02 09:00:00'), (2, 7,  '2025-09-02 09:05:00'),
(3, 5,  '2025-09-02 10:00:00'), (3, 15, '2025-09-02 10:05:00'),
(4, 2,  '2025-09-03 09:00:00'), (4, 11, '2025-09-03 09:05:00'),
(5, 1,  '2025-09-03 10:00:00'), (5, 9,  '2025-09-03 10:05:00'),
(6, 3,  '2025-09-04 09:00:00'),
(7, 5,  '2025-09-04 10:00:00'), (7, 13, '2025-09-04 10:05:00'),
(8, 1,  '2025-09-05 09:00:00'), (8, 17, '2025-09-05 09:05:00'),
(9, 3,  '2025-09-05 10:00:00'), (9, 7,  '2025-09-05 10:05:00'),
(10, 5, '2025-09-06 09:00:00'),
(11, 9, '2025-09-06 10:00:00');

-- Resources (15 rows)
INSERT INTO Resource (user_id, course_id, title, type, file_path, created_at) VALUES
(1,  2,  'MySQL Indexing Cheat Sheet',            'notes',       '/resources/mysql_index_cheatsheet.pdf',   '2025-09-10 10:00:00'),
(3,  2,  'Database Normalization Summary',         'study_guide', '/resources/normalization_guide.pdf',      '2025-09-11 09:00:00'),
(5,  4,  'Software Design Patterns Reference',     'notes',       '/resources/design_patterns.pdf',          '2025-09-12 10:00:00'),
(7,  8,  'Haskell Type System Overview',           'notes',       '/resources/haskell_types.pdf',            '2025-09-13 11:00:00'),
(9,  6,  'Linear Algebra Formula Sheet',           'study_guide', '/resources/linear_algebra_formulas.pdf',  '2025-09-14 09:00:00'),
(11, 1,  'Algorithm Complexity Cheat Sheet',       'study_guide', '/resources/big_o_cheatsheet.pdf',         '2025-09-14 10:00:00'),
(13, 9,  'Probability Distributions Reference',    'study_guide', '/resources/probability_ref.pdf',          '2025-09-15 09:00:00'),
(15, 2,  'SQL Transaction Isolation Levels Notes', 'notes',       '/resources/isolation_levels.pdf',         '2025-09-16 10:00:00'),
(2,  3,  'Operating Systems Past Exam 2024',       'past_exam',   '/resources/os_exam_2024.pdf',             '2025-09-17 09:00:00'),
(4,  5,  'Calculus II Integration Techniques',     'study_guide', '/resources/calc2_integration.pdf',        '2025-09-17 10:00:00'),
(6,  7,  'Networking Protocol Reference',          'notes',       '/resources/networking_protocols.pdf',     '2025-09-18 09:00:00'),
(8,  1,  'Data Structures Past Exam 2024',         'past_exam',   '/resources/ds_exam_2024.pdf',             '2025-09-18 10:00:00'),
(17, 2,  'Database Systems Textbook (Ramakrishnan)', 'textbook',  NULL,                                      '2025-09-19 09:00:00'),
(19, 9,  'Applied Statistics Textbook',            'textbook',    NULL,                                      '2025-09-20 09:00:00'),
(3,  2,  'ER Diagram Practice Problems',           'study_guide', '/resources/er_practice.pdf',              '2025-09-21 09:00:00');

-- BorrowRequests (15 rows)
INSERT INTO BorrowRequest (resource_id, requester_id, owner_id, status, requested_at, updated_at) VALUES
(13, 3,  17, 'approved',  '2025-09-20 10:00:00', '2025-09-20 11:00:00'),
(13, 7,  17, 'pending',   '2025-09-21 09:00:00', '2025-09-21 09:00:00'),
(14, 2,  19, 'approved',  '2025-09-21 10:00:00', '2025-09-21 11:00:00'),
(14, 10, 19, 'pending',   '2025-09-22 09:00:00', '2025-09-22 09:00:00'),
(9,  5,  2,  'approved',  '2025-09-19 10:00:00', '2025-09-19 11:00:00'),
(9,  11, 2,  'returned',  '2025-09-15 10:00:00', '2025-09-18 10:00:00'),
(12, 1,  8,  'approved',  '2025-09-20 09:00:00', '2025-09-20 10:00:00'),
(12, 6,  8,  'declined',  '2025-09-21 09:00:00', '2025-09-21 10:00:00'),
(1,  4,  1,  'pending',   '2025-09-22 10:00:00', '2025-09-22 10:00:00'),
(3,  9,  5,  'approved',  '2025-09-18 09:00:00', '2025-09-18 10:00:00'),
(6,  14, 11, 'returned',  '2025-09-12 09:00:00', '2025-09-16 09:00:00'),
(7,  16, 13, 'pending',   '2025-09-23 09:00:00', '2025-09-23 09:00:00'),
(8,  18, 15, 'approved',  '2025-09-17 10:00:00', '2025-09-17 11:00:00'),
(10, 20, 4,  'pending',   '2025-09-24 09:00:00', '2025-09-24 09:00:00'),
(15, 12, 3,  'approved',  '2025-09-22 10:00:00', '2025-09-22 11:00:00');

-- PostTag (25 rows)
INSERT INTO PostTag (post_id, tag_id) VALUES
(1,  2), (1,  1),
(2,  4), (2,  5),
(3,  1), (3,  2),
(4,  12),
(6,  6), (6,  14),
(7,  1), (7,  2),
(9,  1), (9,  2),
(10, 12), (10, 15),
(11, 1), (11, 3),
(12, 1), (12, 2),
(15, 1), (15, 2),
(17, 13),
(19, 7),
(21, 4), (21, 5);

-- ProblemTag (25 rows)
INSERT INTO ProblemTag (problem_id, tag_id) VALUES
(1,  1), (1,  3),
(2,  4), (2,  5),
(3,  6), (3,  14),
(4,  4), (4,  5),
(5,  12),
(6,  7),
(7,  11),
(8,  1), (8,  2),
(9,  1), (9,  3),
(10, 13),
(11, 1), (11, 2),
(12, 1), (12, 2),
(14, 9),
(15, 1), (15, 2),
(17, 9),
(18, 6), (18, 14);
