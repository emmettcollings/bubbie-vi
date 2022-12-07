DASM = ../dasm/dasm

all: game

game: main.s
	mkdir -p bin
	@echo "Building Bubbie the VIth, the built PRG is located at ./bin!"
	@echo "$<"
	$(DASM) $< -obin/bubbie.prg -lbin/bubbie.lst