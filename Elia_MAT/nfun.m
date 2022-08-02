function a = nfun (b)

m = [1 2;3 4];
a=nfun1(b);

function a = nfun1 (b)
global m
a=m*b

