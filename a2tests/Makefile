DASM = ../dasm/dasm.exe

EXO = ./exomizer/exomizer

SRCS = $(wildcard *.s)
PROGS = $(patsubst %.s,%,$(SRCS))

all: $(PROGS)
	$(MAKE) -C exomizer

%: %.s
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $<, the built PRG is located at /bin/$@!"
	$(DASM) $< -obin/$@/$@.prg -lbin/$@/$@.lst

exomizer:
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $^, the built PRG is located at /bin/$@!"
	$(DASM) ./exomizer/exomizerCompression.s -obin/$@/exomizerCompression.prg -lbin/$@/exomizerCompression.lst
	$(EXO) sfx 0x1101 -t 20 -n bin/$@/exomizerCompression.prg -o bin/$@/exomizerCompressionCompressed.prg 

clean:
	rm -rf bin
	rm -rf *.lst *.prg