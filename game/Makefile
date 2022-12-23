DASM = ../dasm/dasm.exe

all: game

game: main.s titleScreen.s game.s inputBuffer.s
	mkdir -p bin
	@echo "Building Bubbie the VIth, the built PRG is located at ./bin!"
	@echo "$<"
	$(DASM) $< -obin/bubbie.prg -lbin/bubbie.lst