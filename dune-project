(lang dune 3.16)
(name lob)
(generate_opam_files true)
(license MIT)
(authors "Adith")
(maintainers "Adith")
(source
 (github adithn875/road-to-jane-street))

(package
 (name lob)
 (synopsis "Deterministic limit order book engine in OCaml")
 (depends
  (ocaml (>= 5.1))
  (dune (>= 3.16))
  core
  ppx_jane
  (qcheck-core :with-test)
  (bisect_ppx :with-test)
  (core_bench :with-test)))
