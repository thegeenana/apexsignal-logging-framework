# ADR-001: Buffer entries and flush explicitly

- **Status:** Accepted
- **Date:** 2026-09-21

## Context

Writing one database row or publishing one event for every log statement wastes governor limits and couples application code to storage.

## Decision

Log methods create structured entries in a transaction-scoped in-memory buffer. The application calls `ApexSignal.flush()` at an appropriate boundary. Each sink receives the entries as one collection.

## Consequences

- Log calls remain cheap and bulk-oriented.
- Sink implementations can perform one bulk operation.
- Applications must deliberately choose finalisation boundaries.
- Unflushed entries are lost, so integrations and framework adapters should own reliable flush patterns.
- A sink's durability still depends on Salesforce transaction and transport semantics.
