DASM = dasm/dasm.exe

test1: test1.s
	$(DASM) test1.s -f3 -l test1.lst -o test1.bin