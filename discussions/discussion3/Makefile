OCAMLBUILD = ocamlbuild
OCAMLLDFLAGS = -g
PACKS = oUnit

all: public.native student.native
	chmod +x public.native
	mv public.native public
	chmod +x student.native
	mv student.native student

public.native: disc3.ml disc3.mli public.ml
	$(OCAMLBUILD) public.native -pkgs $(PACKS)
	
student.native: disc3.ml disc3.mli student.ml
	$(OCAMLBUILD) student.native -pkgs $(PACKS)
	
clean:
	rm -f *.byte
	rm -f *.native
	rm -f *.cmi
	rm -f *.cmo
	rm -f public
	rm -f student
	$(OCAMLBUILD) -clean
