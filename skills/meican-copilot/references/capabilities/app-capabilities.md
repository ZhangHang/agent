# App Capabilities

## Purpose
Maintain per-app feature boundaries and ownership.

## Seed Entries
- `planet`: customer-level tool permissions and platform management APIs.
- `dapi-be`: external developer-facing gateway APIs with sign/rate/auth requirements.
- `nation-client/client`: client/mealplan/core internal capabilities.

## Update Rule
For every new feature, add:
1. Owner app/service.
2. Main caller/callee.
3. Business scenario.
4. Key API path.
