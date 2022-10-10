DASM 	= ~aycock/599.82/bin/dasm
BASICTESTS	= tempTest.prg writeMem.prg writeString.prg
TESTS	=  testTitleScreen.prg testMemory.prg test3.prg

%.prg: 
	$(DASM) $< -o$@ -l$*.lst
	cp $@ ~/www/lkajsdf$@
	chmod 644 ~/www/lkajsdf$@
	echo https://pages.cpsc.ucalgary.ca/~emmett.collings1/lkajsdf$@

all: $(BASICTESTS) $(TESTS)

clean: 
	rm -rf *.lst *.prg

tempTest.prg: tempTest.s
writeMem.prg: test_writeMem.s
writeString.prg: test_writeString.s
testTitleScreen.prg: testTitleScreen.s
testMemory.prg: testMemory.s
test3.prg: test3.s

