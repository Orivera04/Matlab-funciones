subplot(2,2,1)
[x y] = meshgrid(-3:0.2:3);
z = peaks(x,y);
meshz(z),grid off
