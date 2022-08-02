a = [ 1 2 3;  0 -4 5;  0 0 6]
x = a'*a
r = chol(x)
rr = r'*r
a = [ 1 2 3;  0 -4 5;  0 0 0]
x = a'*a
[r p] = chol(x)
rr = r'*r