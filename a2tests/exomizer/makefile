DASM = ../../dasm/dasm.exe
EXO = ../exomizerSrc/src/exomizer

all: exomizer

exomizer: exomizerCompression.s main.s exodecrunch.s
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $^, the built PRG is located at /bin/$@!"
	$(DASM) exomizerCompression.s -obin/$@/exomizerCompression.prg -lbin/$@/exomizerCompression.lst

crunch:
	$(EXO) sfx 0 -t 20 bin/$@/exomizerCompression.prg,0 -o bin/$@/exomizerCompressionCompressed.prg

clean:
	rm -rf bin