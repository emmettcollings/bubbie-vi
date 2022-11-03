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

clean:
	rm -rf bin
	rm -rf *.lst *.prg