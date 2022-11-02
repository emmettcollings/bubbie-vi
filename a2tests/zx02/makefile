DASM = ../../dasm/dasm.exe

all: zx02

zx02: zx02Compression.s
	rm -rf bin/$@
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $^, the built PRG is located at /bin/$@!"
	$(DASM) zx02Compression.s -obin/$@/zx02Compression.prg -lbin/$@/zx02Compression.lst

clean:
	rm -rf bin