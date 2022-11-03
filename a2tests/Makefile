DASM 	= ~aycock/599.82/bin/dasm

%.prg: 
	$(DASM) $< -o$@ -l$*.lst
	cp $@ ~/www/asdwf$@
	chmod 644 ~/www/asdwf$@
	echo https://pages.cpsc.ucalgary.ca/~emmett.collings1/asdwf$@

all: ogtest.prg ds5b.prg

clean: 
	rm -rf *.lst *.prg
	rm -rf ~/www/*.prg

ogtest.prg: originalTitleScreen.s
ds5b.prg: 5-bit-char.s

