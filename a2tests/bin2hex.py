import binascii

with open('title.bin', 'rb') as f:
    hexdata = f.read().hex()


hexlist = list(map(''.join, zip(hexdata[::2], hexdata[1::2])))

print(hexlist[0:22])
print(hexlist[23:45])

