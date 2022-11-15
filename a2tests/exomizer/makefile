DASM = ../../dasm/dasm.exe
EXO = ./exomizer

all: exomizer

exomizer: exomizerCompression.s main.s exodecrunch.s
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $^, the built PRG is located at /bin/$@!"
	$(DASM) exomizerCompression.s -obin/$@/exomizerCompression.prg -lbin/$@/exomizerCompression.lst
	$(EXO) sfx 0x1101 -t 20 -n bin/$@/exomizerCompression.prg -o bin/$@/exomizerCompressionCompressed.prg 
	mkdir -p ../bin/$@
	mv bin/$@/exomizerCompression.lst ../bin/$@/exomizerCompression.lst 
	mv bin/$@/exomizerCompression.prg ../bin/$@/exomizerCompression.prg 
	mv bin/$@/exomizerCompressionCompressed.prg ../bin/$@/exomizerCompressionCompressed.prg

clean:
	rm -rf bin