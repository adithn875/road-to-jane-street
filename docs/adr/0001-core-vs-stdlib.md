# ADR-0001: Core for the engine, Stdlib for the verified kernel

Status: accepted

## Context
The engine benefits from Core's containers, ppx tooling, and idioms.
Cameleer verifies only a restricted OCaml subset and cannot handle Core.

## Decision
Use Core in all engine, validator, journal, sim, and CLI code.
Write `src/kernel/` in plain Stdlib OCaml so it stays verifiable.

## Consequences
Kernel functions are re-exported into the engine via thin wrappers.
