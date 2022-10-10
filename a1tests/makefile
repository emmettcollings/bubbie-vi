DASM = dasm/dasm.exe

all:
	echo "Compiling... (Will implement this later to compile all the files)"

test%: test%.s
	mkdir -p bin
	mkdir -p bin/test$*
	$(DASM) test$*.s -obin/test$*/test$*.prg -lbin/test$*/test$*.lst

%: %.s
	mkdir -p bin
	$(DASM) $*.s -obin/$*.prg -lbin/$*.lst