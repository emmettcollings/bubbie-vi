DASM 	= ~aycock/599.82/bin/dasm
TESTS	= drawLine.prg drawScreen.prg colors.prg

%.prg: 
	$(DASM) $< -o$@ -l$*.lst
	cp $@ ~/www/lkajsdf$@
	chmod 644 ~/www/lkajsdf$@
	echo https://pages.cpsc.ucalgary.ca/~emmett.collings1/lkajsdf$@

all: $(BASICTESTS) $(TESTS)

clean: 
	rm -rf *.lst *.prg

drawLine.prg: test_drawLine.s
drawScreen.prg: test_drawScreen.s
colors.prg: test_colors.s
