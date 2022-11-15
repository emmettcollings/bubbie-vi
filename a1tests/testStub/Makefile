DASM 	= ~aycock/599.82/bin/dasm
TESTS	= tempTest.prg 

%.prg: 
	$(DASM) $< -o$@ -l$*.lst
	cp $@ ~/www/lkajsdf$@
	chmod 644 ~/www/lkajsdf$@
	echo https://pages.cpsc.ucalgary.ca/~emmett.collings1/lkajsdf$@

all: $(BASICTESTS) $(TESTS)

clean: 
	rm -rf *.lst *.prg

tempTest.prg: tempTest.s

