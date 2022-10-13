DASM 	= ~aycock/599.82/bin/dasm
TESTS	= drawLine.prg initScreen.prg colors.prg hScroll.prg

%.prg: 
	$(DASM) $< -o$@ -l$*.lst
	cp $@ ~/www/lkajsdf$@
	chmod 644 ~/www/lkajsdf$@
	echo https://pages.cpsc.ucalgary.ca/~emmett.collings1/lkajsdf$@

all: $(BASICTESTS) $(TESTS)

clean: 
	rm -rf *.lst *.prg

drawLine.prg: test_drawLine.s
initScreen.prg: test_initScreen.s
colors.prg: test_colors.s
hScroll.prg: test_hscroll.s
