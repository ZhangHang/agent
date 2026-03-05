# App Capabilities

## Purpose
Maintain per-app feature boundaries and ownership.

## Seed Entries
- `planet`: customer-level tool permissions and platform management APIs.
- `dapi-be`: external developer-facing gateway APIs with sign/rate/auth requirements.
- `dapi-adapter`: adapter layer for developer-facing integrations and compatibility glue.
- `nation-client/client`: client/mealplan/core internal capabilities.
- `nation-client/area`: area and region-related nation-client capabilities.
- `payment-adapter`: payment-facing adapter and integration boundary in be-meican-app domain.

## API Surface Pattern (Common)
- `admin service`
  - For management-side calls (mainly from `planet`).
  - Requires `meta` with operator/admin user info.
- `biz service`
  - For to-C client traffic (usually via dedicated BFF).
  - Requires `meta` with end-user info.
- `internal service`
  - For service-to-service internal calls.

## Update Rule
For every new feature, add:
1. Owner app/service.
2. Main caller/callee.
3. Business scenario.
4. Key API path.
