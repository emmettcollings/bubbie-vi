DASM = ../../dasm/dasm.exe
ZX02 = ./zx02

all: zx

zx: 
	rm -rf bin/$@
	mkdir -p bin
	mkdir -p bin/$@
	@echo "Building $@ using $^, the built PRG is located at /bin/$@!"
	$(ZX02) -f test.bin data.zx02
	$(DASM) zx02.s -obin/$@/zx02Compression.prg -lbin/$@/zx02Compression.lst

clean:
	rm -rf bin