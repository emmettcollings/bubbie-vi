DASM 	= ~aycock/599.82/bin/dasm
TESTS	= testTitleScreen.prg testMemory.prg

%.prg: 
	$(DASM) $< -o$@ -l$*.lst
	cp $@ ~/www/lkajsdf$@.prg
	chmod 644 ~/www/lkajsdf$@.prg
	echo https://pages.cpsc.ucalgary.ca/~emmett.collings1/lkajsdf$@.prg

all: $(TESTS)

clean: 
	rm -rf *.lst *.prg

testTitleScreen.prg: testTitleScreen.s
testMemory.prg: testMemory.s

