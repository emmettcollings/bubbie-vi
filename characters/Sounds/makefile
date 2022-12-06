DASM = ~aycock/599.82/bin/dasm

SRCS = $(wildcard *.s)
PROGS = $(patsubst %.s,%,$(SRCS))

all: $(PROGS)

%: %.s
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $<, the built PRG is located at /bin/$@!"
	$(DASM) $< -obin/$@/$@.prg -lbin/$@/$@.lst

clean:
	rm -rf bin