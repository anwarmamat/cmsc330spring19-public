#! /bin/sh
. ./ocaml_version.sh
dune exec bin/interface.bc -- $@
