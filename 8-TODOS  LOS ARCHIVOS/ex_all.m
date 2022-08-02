x = [ 0 1 2 3 4]
xx = [x; [4 3 0 2 1]]
a = all(x)
b = all(xx) % identique à b = all(xx,1)
c = all(xx,2)
d = all(all(xx(:, 2:4)))
e = all(all(xx(:, [2,4,5])))
