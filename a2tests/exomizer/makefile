DASM = ../../dasm/dasm.exe

all: exomizer

exomizer: exomizerCompression.s main.s exodecrunch.s
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $^, the built PRG is located at /bin/$@!"
	$(DASM) exomizerCompression.s -obin/$@/exomizerCompression.prg -lbin/$@/exomizerCompression.lst

clean:
	rm -rf bin