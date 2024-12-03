
MLCOMP ?= mlkit

SMLFILES=*.sml *.sig
.PHONY: all
all: quantum.exe

.PHONY: test
test:
	$(MAKE) -C test test

%.exe: %.mlb $(SMLFILES)
	$(MLCOMP) -output $@ $<

ex1.fut: comp_ex1.exe
	@echo 'import "futlib"' > $@
	@echo 'import "fut/lib/github.com/diku-dk/complex/complex"' >> $@
	@echo 'module C = mk_complex(f64)' >> $@
	@echo 'module mat = mk_mat(C)' >> $@
	@echo 'open mat' >> $@
	@echo '' >> $@
	./comp_ex1.exe >> $@

.PHONY: clean
clean:
	rm -rf *.exe run MLB *~ ex1.fut
	$(MAKE) -C test clean
