DASM = dasm/dasm.exe

all:
	mkdir -p bin

test%: test%.s
	make all
	mkdir -p bin/test$*
	$(DASM) test$*.s -obin/test$*.prg -lbin/test$*.lst