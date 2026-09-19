# Matching Specification

Status: living document. Every rule has an ID. Every rule must have at least one
named `ppx_expect` test before milestone M2 is complete. If code and this spec
disagree, the spec wins until an ADR says otherwise.

## 1. Scope

Single instrument, single-threaded deterministic matching core.
Integer prices (ticks) and quantities (lots) only. See ADR-0002.

## 2. Domain types (target API)

```ocaml
module Side : sig type t = Buy | Sell end

module Price : sig
  type t                                  (* ticks, > 0 *)
  val of_ticks : int -> t option
  val to_ticks : t -> int
end

module Qty : sig
  type t                                  (* lots, > 0 *)
  val of_lots : int -> t option
  val to_lots : t -> int
  val sub : t -> t -> t option            (* None if result would be <= 0 *)
end

type order_kind =
  | Limit of { price : Price.t; tif : [ `GTC | `IOC | `FOK ]; post_only : bool }
  | Market

type new_order = {
  id : Order_id.t;
  account : Account_id.t;
  side : Side.t;
  qty : Qty.t;
  kind : order_kind;
}

type command =
  | New of new_order
  | Cancel of { order_id : Order_id.t }
  | Replace of { order_id : Order_id.t; new_qty : Qty.t option; new_price : Price.t option }

type reject_reason =
  | Duplicate_order_id | Unknown_order | Invalid_tick | Invalid_lot
  | Qty_out_of_range | Price_outside_band | Notional_too_large
  | Would_cross_post_only | Fok_not_fully_fillable | Self_trade_prevented
  | No_liquidity_market

type event =
  | Accepted of { seq : int; order_id : Order_id.t }
  | Rejected of { seq : int; order_id : Order_id.t; reason : reject_reason }
  | Trade of { seq : int; taker : Order_id.t; maker : Order_id.t;
               price : Price.t; qty : Qty.t; aggressor : Side.t }
  | Cancelled of { seq : int; order_id : Order_id.t; remaining : Qty.t;
                   cause : [ `User | `IOC_remainder | `STP ] }
  | Replaced of { seq : int; order_id : Order_id.t; new_qty : Qty.t;
                  new_price : Price.t; lost_priority : bool }
  | Book_delta of { seq : int; side : Side.t; price : Price.t; new_total_qty : int }

val apply : Book.t -> seq:int -> command -> Book.t * event list
```

## 3. Matching rules

| ID   | Requirement | Test |
|------|-------------|------|
| M-1  | Price priority: an incoming buy matches the lowest-priced asks first; an incoming sell matches the highest-priced bids first | todo |
| M-2  | Time priority: within a price level, orders fill in strictly increasing arrival sequence | todo |
| M-3  | Trade price is the resting (maker) order's price, never the aggressor's limit | todo |
| M-4  | A limit buy at price p may match asks with price <= p; a limit sell at p may match bids >= p | todo |
| M-5  | Partial fills: a resting order partially filled keeps its queue position and reduced quantity | todo |
| M-6  | GTC: the unfilled remainder rests in the book | todo |
| M-7  | IOC: the unfilled remainder is cancelled immediately (`Cancelled` with cause `IOC_remainder`) | todo |
| M-8  | FOK: if the full quantity cannot be filled immediately at acceptable prices, reject with no trades and no book change | todo |
| M-9  | Market: matches at any price until filled or the opposite side is empty; never rests; remainder cancelled | todo |
| M-10 | Post-only: if it would match on entry, reject (`Would_cross_post_only`); otherwise rest | todo |
| M-11 | Cancel: removes the order and emits `Cancelled`; unknown id gives `Rejected Unknown_order` | todo |
| M-12 | Replace: decreasing qty at the same price keeps priority; changing price or increasing qty loses priority (re-queued at the back with a fresh sequence number) | todo |
| M-13 | Self-trade prevention: an incoming order never trades against a resting order of the same account. Configurable mode: `Cancel_newest` (default), `Cancel_oldest`, `Cancel_both`, `Decrement`. Every mode emits explicit `Cancelled` events with cause `STP` | todo |
| M-14 | Atomicity: each command produces a complete, consistent event list; the book only changes if the command completes | todo |
| M-15 | Event order within one command: `Accepted`, then `Trade`*, then optional `Cancelled` (remainder), then `Book_delta`* | todo |
| M-16 | Sequence numbers are strictly increasing and gap-free in the journal | todo |

## 4. Validation (pre-trade gate)

| ID  | Requirement |
|-----|-------------|
| V-1 | Price must be a multiple of tick size (`Invalid_tick`) |
| V-2 | Price must be within the configured band around the reference price (`Price_outside_band`) |
| V-3 | Qty must be a multiple of lot size (`Invalid_lot`) and within `[min_qty, max_qty]` (`Qty_out_of_range`) |
| V-4 | `price * qty <= max_notional` (`Notional_too_large`); protects against 63-bit integer overflow |
| V-5 | Order ids are unique for the lifetime of the session (`Duplicate_order_id`) |

## 5. Data structure requirements

- Reference book: `Map` from price to a FIFO queue of resting orders, one map per
  side, plus a `Map` from order id to (side, price) for cancel. Insert, best-price
  lookup, and cancel must each be at most O(log n). A list-of-levels design is
  rejected because cancel and insert are O(n).
- Fast book (milestone M6): mutable price levels with intrusive queues and a hash
  index. Target O(1) amortized cancel and best-price access. Must be behaviorally
  identical to the reference book (invariant INV-16).

## 6. Open decisions (resolve via ADRs)

1. STP default mode (proposed: `Cancel_newest`)
2. Timestamp source: sequence number only, or sequence plus injected logical clock
3. Journal format: sexp or JSONL first, binary later
