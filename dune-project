(lang dune 3.0)
(name ppx_odoc_of_gospel)
(generate_opam_files true)

(source (github n-osborne/ppx_odoc_of_gospel))

(package
  (name ppx_odoc_of_gospel)
  (synopsis "Ppx rewriter for showing gospel specifications in documentation")
  (authors "Nicolas Osborne")
  (maintainers "Nicolas Osborne <nicolas.osborne@tarides.com>")
  (description "Ppx rewriter for showing gospel specifications in documentation. It turns Gospel attributes into documentation ones.")
  (depends
    ppxlib
    fmt
    gospel)
  )
