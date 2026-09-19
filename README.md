# lob

A deterministic limit order book and matching engine in OCaml 5, defended by
types, expect tests, property tests, differential fuzzing, and formal specs.

Status: M0 (foundations). See `docs/` for the spec, invariants, and ADRs.

## Build and test
    opam switch create . 5.3.0
    opam install . --deps-only --with-test
    dune build && dune runtest
