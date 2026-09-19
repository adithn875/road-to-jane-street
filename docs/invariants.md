# Invariants Catalog

Status: living document. Every invariant has an ID and a named enforcement
mechanism. A row with no automated enforcement is a bug in this document.

Legend for the Status column: `todo`, `wip`, `done`.

| ID | Invariant | Enforced by | Status |
|----|-----------|-------------|--------|
| INV-1 | All resting order quantities > 0 | Abstract `Qty.t` (type) + property test | todo |
| INV-2 | All trade quantities > 0 | Type + property test | todo |
| INV-3 | Bid levels strictly descending, ask levels strictly ascending by price | `Map` structure + property test on the exported view | todo |
| INV-4 | No empty price levels exist in the book | Property test after every command | todo |
| INV-5 | Within a level, orders are ordered by sequence number | Property test | todo |
| INV-6 | Book is never crossed: best_bid < best_ask after every completed command | Property test + runtime assertion | todo |
| INV-7 | Each trade reduces maker and taker quantity by exactly `trade.qty` | Conservation property | todo |
| INV-8 | Global conservation: accepted qty = resting qty + traded qty (counted once) + cancelled qty + rejected-remainder qty | Property test over random streams; runtime check in CI builds | todo |
| INV-9 | Trade price equals the maker's limit price | Property test | todo |
| INV-10 | Price-time priority: for each trade, no better-priced or earlier same-price resting order was skipped (except by STP) | Model-based oracle test | todo |
| INV-11 | No self-trade within the same account | Property test | todo |
| INV-12 | Order-id index and price-level queues are consistent (each indexed id appears exactly once, and vice versa) | Property test + runtime check | todo |
| INV-13 | Determinism: replaying the same command stream yields identical events and final state hash | Replay test on every fuzzed stream | todo |
| INV-14 | Sequence numbers are gap-free and increasing | Journal reader check | todo |
| INV-15 | FOK and post-only rejections leave the book byte-identical | Property test (state hash before = after) | todo |
| INV-16 | Fast engine is equivalent to the reference engine (same events, same final book) | Differential fuzzing | todo |
| INV-17 | Verified-kernel functions satisfy their Gospel specs | Cameleer / Why3 proofs | todo |

## Verified vs tested (fill in as milestones complete)

| Area | Verified (proved) | Tested (properties / fuzzing) |
|------|-------------------|-------------------------------|
| Kernel arithmetic (fills, overflow check) | todo | todo |
| Sorted insert / queue removal | todo | todo |
| Matching engine | not attempted | todo |
