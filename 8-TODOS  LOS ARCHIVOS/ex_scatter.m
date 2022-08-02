x = fix((rand(1,40)-0.5)*200);
y = fix((rand(1,40)-0.5)*200);
n = 5*sqrt(x.*x+y.*y);
z = n*63/max(n);
colormap(gray)
scatter(x,y,n,z, '*')
axis off