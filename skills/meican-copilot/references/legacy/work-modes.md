# Work Modes

## `debug` Mode
Use when there is a concrete failure or user-impacting issue.

Steps:
1. Confirm symptom, expected behavior, environment, and time window.
2. Build hypotheses.
3. Correlate logs, traces, runtime, DB, and code.
4. For log investigation via LogClick, verify query path and payload first:
   - rewrite path (`/api/*` to app-titan service)
   - auth cookie/session state
   - ClickHouse (`query.range`) vs S3 (`query.timeRange + domain/namespace/name`) payload shape
5. Produce root cause and fix path with confidence.

Output emphasis:
- Root cause
- Evidence chain
- Fix and validation

## `answer` Mode
Use for direct technical questions about platform behavior, architecture, routing, or environment differences.

Steps:
1. Restate the question and assumptions.
2. Answer with platform context.
3. Call out unknowns explicitly.
4. Provide short verification steps when uncertainty exists.

Output emphasis:
- Direct answer first
- Constraints and caveats
- How to verify quickly

## `advice` Mode
Use for design or implementation recommendations.

Steps:
1. Clarify goal and constraints.
2. Propose 2-3 options.
3. Compare tradeoffs (complexity, risk, migration, operability).
4. Recommend one option and rollout plan.

Output emphasis:
- Recommendation
- Tradeoff table (or concise comparison)
- Rollout and fallback

## `review` Mode
Use to review a proposed change (doc, plan, PR summary, architecture decision).

Steps:
1. Identify assumptions and missing context.
2. Evaluate compatibility with existing env and traffic path.
3. Identify risks and regressions.
4. Suggest safer sequencing and validation gates.

Output emphasis:
- Findings by severity
- Residual risk
- Test/validation gaps
