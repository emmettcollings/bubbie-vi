DASM = dasm/dasm.exe

all:
	mkdir -p bin

test%: test%.s
	make all
	mkdir -p bin/test$*
	$(DASM) test$*.s -obin/test$*/test$*.prg -lbin/test$*/test$*.lst