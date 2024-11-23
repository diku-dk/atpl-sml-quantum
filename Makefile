SMLPKG = smlpkg

.PHONY: test
test: lib
	$(MAKE) -C src test

.PHONY: clean
clean:
	rm -rf *~
	$(MAKE) -C src clean

.PHONY: realclean
realclean:
	$(MAKE) clean
	rm -rf lib

lib:
	$(SMLPKG) sync
