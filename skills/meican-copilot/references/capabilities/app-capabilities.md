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

## Update Rule
For every new feature, add:
1. Owner app/service.
2. Main caller/callee.
3. Business scenario.
4. Key API path.
