# database

MySQL database design and implementation for the Agora academic collaboration platform.

This repository contains all database work for the project — from schema design and normalization through complex queries, indexing, transactions, and a NoSQL component. The MySQL database defined here powers the live Agora application.

---

## Contents

| File | Description |
|------|-------------|
| `schema.sql` | Complete MySQL schema — 18 tables with primary keys, foreign keys, CHECK constraints, UNIQUE constraints, and a trigger enforcing one accepted answer per problem |
| `seed.sql` | Synthetic dataset — 350+ rows across all 18 tables for testing and demonstration |
| `queries.sql` | Required SQL queries — 5 SELECT, 5 JOIN, 3 GROUP BY + aggregate, 3 subqueries, 2 views, 2 relational algebra expressions |
| `indexes.sql` | Index definitions and EXPLAIN PLAN analysis showing performance before and after indexing |
| `transactions.sql` | Transaction demonstrations — COMMIT, ROLLBACK, SAVEPOINT, and isolation level changes |
| `mongodb.js` | NoSQL component — MongoDB `activity_logs` collection with insert, find, filter, and aggregate queries |
| `app.py` | Python application using `mysql-connector-python` — SELECT, INSERT, UPDATE, DELETE with prepared statements and a programmatic transaction |

---

## Schema Overview

The schema models an academic collaboration platform with 18 relational tables:

**Core entities:** User, Course, Enrollment (weak entity), Tag

**Content:** Post, Problem, Answer, Resource, BorrowRequest (weak entity)

**Interactions:** CommentOnPost, CommentOnProblem, CommentOnAnswer, UpvoteOnPost, UpvoteOnProblem, UpvoteOnAnswer, Follow

**Junctions:** PostTag, ProblemTag

Key business rules enforced at the database level:
- One enrollment per student per course — `UNIQUE(user_id, course_id)`
- One answer per student per problem — `UNIQUE(problem_id, user_id)`
- Only one accepted answer per problem — enforced by trigger
- One upvote per user per content item — `UNIQUE` constraints on each upvote table
- A user cannot follow themselves — `CHECK(follower_id != follower_id)`
- Resource type restricted to valid academic materials — `CHECK` on `type`

---

## Running the Schema

```bash
# 1. Connect to MySQL
mysql -u root -p

# 2. Run the schema (creates agora_db and all tables)
source schema.sql

# 3. Load seed data
source seed.sql

# 4. Run queries
source queries.sql
```

---

## Python Application

```bash
pip install mysql-connector-python
python app.py
```

Update the `DB_*` constants at the top of `app.py` to match your MySQL connection.

---

## Organization

| Repository | Purpose |
|-----------|---------|
| [Agora](https://github.com/Agora-Connect/Agora) | Production Flask application powered by this database |
| [database](https://github.com/Agora-Connect/database) | **This repo** — MySQL schema, queries, and all database deliverables |
| [docs](https://github.com/Agora-Connect/docs) | Design documents, ER diagram, normalization steps |

---

## License

MIT License
