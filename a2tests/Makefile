DASM 	= ~aycock/599.82/bin/dasm

%.prg: 
	$(DASM) $< -o$@ -l$*.lst
	cp $@ ~/www/asdwf$@
	chmod 644 ~/www/asdwf$@
	echo https://pages.cpsc.ucalgary.ca/~emmett.collings1/asdwf$@

all: ogtest.prg betterogtest.prg ds1.prg

clean: 
	rm -rf *.lst *.prg
	rm -rf ~/www/*.prg

ogtest.prg: originalTitleScreen.s
betterogtest.prg: betterOGTitle.s
ds1.prg: data-specific-1.s

