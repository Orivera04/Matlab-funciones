a = hilb(3);
[l u p]=lu(a)
norm(p'*l*u-a)