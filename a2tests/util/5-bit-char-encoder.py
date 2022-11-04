# not that good at python this can be massively improved
# would prefer this to write to a binary file that we can just incbin
b = '00001'
u = '10100'
i = '01000'
e = '00100'
spc = '11111'
t = '10011'
h = '00111'
v = '10101'

n = '01101'
o = '01110'
g = '00110'
m = '01100'
r = '10001'
y = '11000'

titleString = b + u + b + b + i + e + spc + t + h + e + spc + v + i
teamString = n + o + t + spc + e + n + o + u + g + h + spc + m + e + m + o + r + y
print(titleString)
print(teamString)

string = titleString + teamString + '00'

chunks = [string[i:i+8] for i in range(0, len(string), 8)]
print(chunks)
for byte in chunks:
    print(hex(int(byte, base=2)))


