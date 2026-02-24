# Environments

## Available Environments
- `sandbox`: AWS account and environment for development/testing.
- `production` (`meican1`): existing production servers.
- `prod` (`meican2`): new production servers.

## Connectivity
- `production` (`meican1`) and `prod` (`meican2`) support tunnel connectivity for selected database access.
- Some checks may require user-provided tunnel/session setup.

## Investigation Hint
- Always state the environment first in every finding.
- Avoid mixing evidence across environments in a single conclusion.

## Name Mapping Rule
- User-facing env names should prefer `sandbox`, `production`, `prod`.
- Infra/account mapping:
  - `sandbox` -> sandbox account/env
  - `production` -> `meican1`
  - `prod` -> `meican2`
