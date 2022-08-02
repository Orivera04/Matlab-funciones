cx = '1010101010101010'; cy = '1111111100000000'; 
x =  bin2dec(cx), y =  bin2dec(cy)
a =  dec2bin(bitand(x, y))
o =  dec2bin(bitor (x, y))
b =  bitget(y, 5:10)
