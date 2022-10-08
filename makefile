DASM = dasm/dasm.exe

all:
	echo "Compiling... (Will implement this later)"

test%: test%.s
	mkdir -p bin
	mkdir -p bin/test$*
	$(DASM) test$*.s -obin/test$*/test$*.prg -lbin/test$*/test$*.lst