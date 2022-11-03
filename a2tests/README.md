# Original Title Screen

**File:** bin/originalTitleScreen/originalTitleScreen.prg  (404 bytes)

**Compression Ratio:** N/A

Our original title screen test program's total size was 404B. Our input data was
34B, which consisted of 3 strings that were written to screen memory.

# Exomizer 3

**File:** bin/exomizer/exomizerCompressionCompressed.prg (435 bytes)

**Compression Ratio:** 0.93

Exomizer 3 was pretty straightforward in regard to the implementation within our code. It took a bit of time to get functional properly, due to mistakes regarding the jump address, so the compression wasn't occurring properly.

As explained above, Exomizer 3 was straightforward to implement. All that was required to get it up and running, was copying the two files for Exomizer's decrunchers and importing the `main.s` file into our title screen code. After that, all we needed to do was compile the title screen like before, and then we'd run `exomizer` (the compressor) in VIC-20 mode with a jump address of `0x1101`. It'd take in our previously built prg file (Which contained our original code, plus the decruncher's code), and produce a new compressed prg.

Finally, moving on to if it's an efficient compression method or not. Exomizer 3 had a compression ratio of 0.93. So, we saw an increase in size, which isn't what you'd want of a compression method. However, this could be due to the fact that our input data was so small. If we were to compress a larger file, we'd likely see a better compression ratio. However, it still does not appear to be the best compression method.

# Byte repetition encoding (data general)

**File:** bin/RLE_General/RLE_General.prg (330 bytes)

**Compression Ratio:** 1.22

This is a simple compression algorithm that efficiently stores repeated bytes.  For all repeated consecutive bytes (including runs of 1), the byte to be repeated is stored followed by the length of that byte sequence.  For example, if the character `B` is written to the screen twice (like in the word 'BUBBIE') that would be stored as the consecutive bytes $02, $02.  If the character `B` is written to the screen once, that would be stored as the consecutive bytes $02, $01.  Since we are writing directly to screen memory, we use the character code for the character to be written.

We also have a special case for the length code $00, which is the end of the string.  If we encounter a $00 as the length of a byte sequence, we immediately stop reading the data.


# 5-bit char representation (data specific)

**File:** bin/5-bit-char/5-bit-char.prg (149 bytes)

**Compression Ratio:** 2.71

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

**File:** bin/RLE_DataSpec1/RLE_DataSpec1.prg (148 bytes)

**Compression Ratio:** 2.73

For this algorithm notice that there are 16 unique characters for our title screen, so we can represent each character using 4 bits. We can use a lookup table to map the 4 bit values to the VIC-20 charset values. The end result is we have 4-bit chunks that directly correspond to the desired characters' screen codes, saving 4 bits off of every character.

Since each byte is 8 bits, we can effectively fit 2 4-bit chunks in a single byte, which is exactly what we do; the top and bottom nibble of each stored information byte is an individual lookup address into our lookup table, which stores the character byte that is written to screen memory.

Our lookup table is hand crafted for our specific data, and thus stores the screen codes for the characters ` 02beghimnortuvy` in that order

For example, the first byte of screen data is $3d, which is 0011 1101 in binary. The top nibble is 0011, which is the lookup address for the letter `B`, and the bottom nibble is 1101, which is the lookup address for the letter `U`.  Thus, $3d will be written to screen memory as `BU`.

Since we're dealing with 4-bit values (power of 2, woo!), this method is naturally intuitive to understand and implement (for a computer scientist).
