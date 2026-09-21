# FormulaShare review notes

## Purpose

This note records architectural lessons from the open-source [FormulaShare-DX](https://github.com/LawrenceLoz/FormulaShare-DX) project. FormulaShare is MIT licensed by Lawrence Newcombe.

FormulaShare validates the need for a standalone logging framework. It implements valuable operational logging, but the implementation is coupled to FormulaShare custom objects, sharing-rule metrics, fflib and its batch services. ApexSignal should generalise the recurring observability concerns.

## Patterns worth adopting

### Asynchronous error ingestion

FormulaShare uses `Database.RaisesPlatformEvents` and a `BatchApexErrorEvent` handler to preserve errors from failed batch-scope transactions.

ApexSignal should provide an optional adapter that converts Salesforce asynchronous error events into structured signal entries containing:

- source event type and event UUID;
- asynchronous job and parent job IDs;
- root correlation and execution IDs when resolvable;
- request ID;
- batch phase and job scope;
- exception type, message and stack trace;
- truncation metadata.

Event UUID should be usable as a deduplication key because Platform Events may be delivered more than once.

### Summary and detail storage

FormulaShare separates batch summaries, record logs, rule metrics and error details. ApexSignal should likewise avoid one oversized log record.

The target storage model should distinguish a correlated transaction or operation from its individual entries. ApexConvoy retains job state and failed work items; ApexSignal retains diagnostic evidence.

### Retention and administration

FormulaShare demonstrates:

- retention settings in Custom Metadata;
- batch deletion of old logs;
- different retention periods for different log categories;
- operational reporting and administration;
- safe truncation of large messages and stack traces.

ApexSignal should implement bounded, restartable cleanup with storage reporting and protected-record support.

### Security and resilience

Useful practices include:

- allow-listing relevant event sources;
- deduplicating deliveries;
- bulk upsert with partial success;
- avoiding sensitive details in fallback debug output;
- checking permissions and choosing an explicit data-access mode.

## Patterns to improve rather than reproduce

- Do not bind the logger to one application's object model.
- Do not expose only one exception slot that a later failure can overwrite.
- Do not use comma-separated fields for repeated failures.
- Do not scatter direct `System.debug()` calls through business code.
- Do not allow a failing sink to recursively log its own failure.
- Do not claim that same-transaction persistent logs survive rollback.

## Framework boundary

- ApexSignal owns structured diagnostic and operational events.
- ApexConvoy owns jobs, attempts, checkpoints, retries and failed work items.
- Correlation identifiers connect the two.
- Integration is provided through an optional adapter.
- Both frameworks remain independently deployable.

## Clean-room and attribution rule

Concepts may inform ApexSignal's design. FormulaShare source must not be copied without preserving its MIT copyright and licence notice. ApexSignal implementations should remain independently designed and covered by their own tests and ADRs.
