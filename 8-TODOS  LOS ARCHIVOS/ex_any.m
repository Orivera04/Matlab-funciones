x = [ 0 1 2 3 4]
xx = [x; [0 3 0 2 1]]
a = any(x)
b = any(xx) % identique à b = any(xx,1)
c = any(xx,2)
d = any(any(xx(:, 2:4)))
e = any(any(xx(:, [2,4,5])))