
MLCOMP ?= mlkit

SMLFILES=*.sml *.sig
.PHONY: all
all: quantum.exe

.PHONY: test
test:
	$(MAKE) -C test test

quantum.exe: quantum.mlb $(SMLFILES)
	$(MLCOMP) -output $@ $<

.PHONY: clean
clean:
	rm -rf *.exe run MLB *~
	$(MAKE) -C test clean
