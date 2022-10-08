DASM = dasm/dasm.exe

test1: test1.s
	$(DASM) test1.s -obin/test1.prg -lbin/test1.lst