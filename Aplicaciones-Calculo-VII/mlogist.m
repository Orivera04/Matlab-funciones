function y = mlogist(t)
input('De los valores del vector t y los escalares: L,yo,k');
t =input('t = ');
L = input('L = ');
yo = input('y0 = ');
k = input('k = ');
y = L*yo./(yo + (L-yo)*exp(-L*k*t));
plot(t,y);
