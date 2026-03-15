# database — Early Prototype

> **This repository is an early-stage prototype and is not the production database.**
> The production app uses PostgreSQL on Railway. See the [Agora](https://github.com/Agora-Connect/Agora) repository.

---

This repository contains artifacts from the initial SQLite-based prototype built during the planning phase of the Agora project.

## What's here

- `agora.db` — SQLite database file from the prototype phase
- `query.py` — Sample queries used to test the initial schema

## Status

**Reference only.** The production system moved to PostgreSQL (hosted on Railway) with SQLAlchemy ORM. All schema definitions live in `app/models.py` in the main [Agora](https://github.com/Agora-Connect/Agora) repository.

## Production Repository

See [github.com/Agora-Connect/Agora](https://github.com/Agora-Connect/Agora) for the live application.
