# Proto Strategy

## Default Rule
Use central proto repository for new APIs:
- `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`

## Exceptions
Standalone proto repos are acceptable when:
1. Legacy constraints require independent lifecycle.
2. grpc-gateway customization requires separate generation/release flow.

Examples:
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-proto`
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`

## Compatibility Rules
1. Treat proto as public contract.
2. Avoid breaking changes without migration plan.
3. Keep method options and comments explicit.
4. Verify generated artifacts in CI.
