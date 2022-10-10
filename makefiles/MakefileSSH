DASM 	= ~aycock/599.82/bin/dasm

%.prg: 
	$(DASM) $< -o$@ -l$*.lst
	cp $@ ~/www/gameName.prg
	chmod 644 ~/www/gameName.prg
	echo https://pages.cpsc.ucalgary.ca/~emmett.collings1/gameName.prg

all: test.prg

test.prg: test.s

