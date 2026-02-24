# Proto Strategy

## Default Rule
Define new protobuf APIs in central repository:
- `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`

## Why
From repository goal and workflow:
- centralized management
- better cross-proto references and linting
- unified compile/tag flow
- easier API reuse and governance

## Version and Change Rules
- Treat proto as API contract.
- Version intentionally and avoid breaking changes without migration path.
- Add comments for message/rpc/fields.
- Prefer business-oriented API design, not internal implementation leaks.
- Review proto before implementation.

## Exception Patterns
Legacy or specialized projects may keep standalone proto repos:
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-proto`

Use this when:
- legacy constraints exist
- grpc-gateway/openapi generation needs custom independent lifecycle

## gRPC Gateway Guidance
For grpc-gateway projects, standalone proto can be acceptable if:
- lifecycle is independent
- custom gateway/openapi behavior is required
- dependencies on central proto are still explicit and versioned

## Build/Release Practice
- Prefer CI-based compile/tag flow from proto repo process.
- Avoid ad-hoc local release tags that interfere with formal versioning.

## Decision Matrix
Choose central proto (`api-center/protobufs`) when:
- new business capability
- cross-team reuse expected
- long-term stable API

Choose standalone proto when:
- legacy project constraint
- isolated gateway-specific evolution
- temporary migration phase with clear convergence plan
