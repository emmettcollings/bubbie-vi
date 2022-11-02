DASM = ../../dasm/dasm.exe
EXO = ../exomizerSrc/src/exomizer

all: exomizer

exomizer: exomizerCompression.s main.s exodecrunch.s
	rm -rf bin/$@
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $^, the built PRG is located at /bin/$@!"
	$(DASM) exomizerCompression.s -obin/$@/exomizerCompression.prg -lbin/$@/exomizerCompression.lst
	$(EXO) sfx 0x1101 -t 20 -n bin/$@/exomizerCompression.prg -o bin/$@/exomizerCompressionCompressed.prg 

compress:
	$(EXO) sfx 0,0xffff -t 20 bin/exomizer/exomizerCompression.prg -o bin/exomizer/exomizerCompressionCompressed.prg

clean:
	rm -rf bin