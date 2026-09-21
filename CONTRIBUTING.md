# Contributing

Thank you for helping improve ApexSignal.

## Principles

Changes should preserve bulk safety, transaction awareness, structured data, security and framework independence.

## Workflow

1. Open or select an issue.
2. Create a focused branch.
3. Add or update Apex tests.
4. Run all local tests in a scratch org.
5. Open a pull request explaining the behaviour and design trade-offs.

## Definition of done

- Apex compiles at the project's source API version.
- Tests cover positive, negative and bulk behaviour.
- Public APIs and architectural decisions are documented.
- No credentials, tokens, personal data or customer information appear in fixtures or logs.
- Logging code does not introduce DML or callouts per log statement.

## Clean-room rule

Do not contribute proprietary source code, metadata or documentation belonging to an employer or client.
