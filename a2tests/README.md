# Original Title Screen

**File: bin/originalTitleScreen/originalTitleScreen.prg  (404 bytes)**

**Compression Ratio: N/A**

Our original title screen test program's total size was 404B. Our input data was
34B, which consisted of 3 strings that were written to screen memory.

# Exomizer 3

**File: bin/exomizer/exomizerCompressionCompressed.prg (435 bytes)**

**Compression Ratio: 0.93**

TODO: Write.

# 5 bit char representation (data specific)

**File: bin/5-bit-char/5-bit-char.prg (149 bytes)**

**Compression Ratio: 2.71**

The idea behind this is that we notice that we only use alphabetical characters
and spaces in our title screen. Since that is a total of 27 options, we can
encode each character using 5 bits.  Luckily for us, the VIC-20 charset encodes
the alphabetic characters with $01-1f so we can represent these by just passing
in raw bits without having to input a lookup table as well, leading to lots of
saved input space.

Since `SPACE` is mapped to $20, we have to shift everything down by 1 so we can
cover all letters + `SPACE` ($00 is @ which we don't need so we can just ignore
it) efficiently with a simple increment on a 5 bit value. For some examples the
bit string representation of `B` is `00001`, `SPACE` is `11111` and `U` is
`10100`.

The end result is we have 5 bit chunks that directly correspond to letters'
screen codes - 1, saving 3 bits off of every character. Additionally, since we
are doing data specific compression we know exactly where the memory locations
we are writing to are located, allowing us to skip a bunch of needless spaces
between relevant data and instead store smaller strings.

The main hurdle is reading 5 bit chunks from a contiguous stream of bytes in
RAM. This was accomplished by using a buffer to hold incoming bytes combined
with ASLs to extract individual bits and using carries to track when to refresh
the buffer with new data.

Overall, the code compression ratio with respect to our original title screen
test is 149/404 = .369 and our data compression is 23/34 = .676. It is worth
mentioning that a fair amount of code improvements are due to rectifying some
assembly coding inefficiencies that were made due to our relative unfamiliarity
with 6502 the time of writing for our initial title screen.


# 4-bit lookup table representation (data specific)

For this algorithm notice that there are 16 unique characters for our title screen, so we can represent each character using 4 bits. We can use a lookup table to map the 4 bit values to the VIC-20 charset values. The end result is we have 4-bit chunks that directly correspond to the desired characters' screen codes, saving 4 bits off of every character.

Since each byte is 8 bits, we can effectively fit 2 4-bit chunks in a single byte, which is exactly what we do; the top and bottom nibble of each stored information byte is an individual lookup address into our lookup table, which stores the character byte that is written to screen memory.

For example, the first byte of screen data is $3d, which is 0011 1101 in binary. The top nibble is 0011, which is the lookup address for the letter `B`, and the bottom nibble is 1101, which is the lookup address for the letter `U`.  Thus, $3d will be written to screen memory as `BU`.

Since we're dealing with 4-bit values, this method is naturally more intuitive to understand and implement (for a computer scientist) than the 5-bit method.
