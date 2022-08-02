a= -5:5
b = 3
c=mod(a,b)
a == floor(a./b)*b+c
d=rem(a,b)
a == fix(a./b)*b+d
e = sign(a)