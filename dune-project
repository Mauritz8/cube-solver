(lang dune 3.15)

(name cube-solver)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name cube-solver)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
   ocaml
   dune
   dream
   lwt_ppx
   ppx_yojson_conv
   (alcotest :with-test))
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
