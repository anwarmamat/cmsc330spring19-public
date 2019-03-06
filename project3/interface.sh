#! /bin/sh
OCAMLPATH=dep dune exec bin/interface.bc -- $@
