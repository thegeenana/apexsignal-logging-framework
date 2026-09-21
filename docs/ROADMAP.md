# Roadmap

## v0.1 — Core signal pipeline

- [x] Structured entry model
- [x] Levels and correlation IDs
- [x] Shared and event-specific context
- [x] Exception capture
- [x] Governor-limit snapshot
- [x] Transaction buffer and explicit flush
- [x] Sink interface and debug sink
- [x] Fail-open/fail-closed policy
- [x] Unit-test foundation

## v0.2 — Durable Salesforce logging

- [ ] Log transaction and log entry custom objects
- [ ] Bulk persistent-object sink
- [ ] Platform Event sink with documented publish semantics
- [ ] Configuration through Custom Metadata
- [ ] Minimum levels by namespace, class or operation
- [ ] Field and pattern redaction
- [ ] Payload-size limits and truncation markers

## v0.3 — Async correlation

- [ ] Queueable correlation carrier
- [ ] Batch and scheduled job context
- [ ] HTTP correlation header helper
- [ ] Transaction finalisation patterns
- [ ] Retry and duplicate-delivery semantics

## v0.4 — Operations

- [ ] LWC log explorer
- [ ] Correlation timeline
- [ ] Saved filters and error summaries
- [ ] Retention and purge jobs
- [ ] Health metrics and export adapters

## Future integrations

- Optional ApexRail trigger adapter
- Optional ApexConvoy batch adapter
- External observability sink reference implementation
