# database

MySQL database design and implementation for the Agora academic collaboration platform.

This repository contains all database work for the project — from schema design and normalization through complex queries, indexing, transactions, and a NoSQL component.

---

## Contents

| File | Description |
|------|-------------|
| `schema.sql` | Complete MySQL schema — 18 tables, primary keys, foreign keys, UNIQUE constraints, CHECK constraints, and BEFORE INSERT/UPDATE triggers enforcing business rules |
| `seed.sql` | Synthetic dataset — ~410 rows across all 18 tables for testing and demonstration |
| `queries.sql` | Required SQL queries — 5 SELECT, 5 JOIN, 3 GROUP BY + aggregate, 3 subqueries, 2 views, 2 relational algebra expressions |
| `indexes.sql` | Index definitions and EXPLAIN PLAN analysis showing performance before and after indexing |
| `transactions.sql` | Transaction demonstrations — COMMIT, ROLLBACK, SAVEPOINT, and isolation level changes |
| `mongodb.js` | NoSQL component — MongoDB `activity_logs` collection with insertMany, find, filter, and aggregate queries |
| `app.py` | Python application — SELECT, INSERT, UPDATE, DELETE with prepared statements and a programmatic transaction |

---

## Schema Overview

The schema models an academic collaboration platform restricted to verified SCSU students, with 18 relational tables normalized to 3NF.

**Core entities:** User, Course, Enrollment (weak entity — composite PK), Tag

**Content:** Post, Problem, Answer, Resource, BorrowRequest (weak entity)

**Interactions:** CommentOnPost, CommentOnProblem, CommentOnAnswer, UpvoteOnPost, UpvoteOnProblem, UpvoteOnAnswer, Follow

**Junctions:** PostTag, ProblemTag

Business rules enforced at the database level:

| Rule | Enforcement |
|------|------------|
| One enrollment per student per course | Composite `PRIMARY KEY (user_id, course_id)` on Enrollment |
| One answer per student per problem | `UNIQUE (problem_id, user_id)` on Answer |
| Only one accepted answer per problem | `BEFORE UPDATE` trigger on Answer |
| One upvote per user per content item | `UNIQUE` constraints on each upvote table |
| A user cannot follow themselves | `BEFORE INSERT` trigger on Follow |
| A user cannot borrow their own resource | `BEFORE INSERT` trigger on BorrowRequest |
| Resource type restricted to valid academic materials | `CHECK` constraint on Resource.type |

---

## Running the Schema

**Prerequisites:** MySQL 8.0+

```bash
# Connect to MySQL
mysql -u root -p

# Create the database and all tables
source /path/to/schema.sql

# Load synthetic seed data (~410 rows)
source /path/to/seed.sql

# Run all complex queries
source /path/to/queries.sql

# Run index definitions and EXPLAIN PLAN analysis
source /path/to/indexes.sql

# Run transaction demonstrations
source /path/to/transactions.sql
```

---

## MongoDB Component

**Prerequisites:** MongoDB shell (`mongosh`) with a running MongoDB instance.

```bash
mongosh
# Then inside the shell:
load("/path/to/mongodb.js")
```

---

## Python Application

**Prerequisites:** Python 3.8+ and `mysql-connector-python`

```bash
pip install mysql-connector-python
```

**Run against local MySQL (defaults):**
```bash
python app.py
```

**Run against a remote host (e.g., AWS RDS):**
```bash
DB_HOST=<rds-endpoint> DB_USER=agora_admin DB_PASS=<password> python app.py
```

All connection parameters are read from environment variables with sensible local defaults — no edits to the source file needed.

---

## Related Repositories

| Repository | Purpose |
|-----------|---------|
| [Agora](https://github.com/Agora-Connect/Agora) | Production Flask application |
| [database](https://github.com/Agora-Connect/database) | **This repo** — MySQL schema, queries, and all database deliverables |
| [docs](https://github.com/Agora-Connect/docs) | Design documents, ER diagram, normalization steps |

---

## License

MIT License
