#! /bin/sh
source ./ocaml_version.sh
dune exec bin/interface.bc -- $@
