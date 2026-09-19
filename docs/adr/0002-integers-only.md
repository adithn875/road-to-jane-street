# ADR-0002: Integer-only prices and quantities

Status: accepted

## Context
Floating point causes rounding errors and non-determinism in matching.

## Decision
Prices are integer ticks, quantities are integer lots. Abstract types with
smart constructors. Notional (price * qty) is bounded at the validator so
63-bit ints never overflow.

## Consequences
All display and conversion to decimals happens outside the engine.
