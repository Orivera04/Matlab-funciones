x = linspace(0,4*pi);
y = sin(x);
yy = exp(-x.*x);
plotyy(x,y,x,yy,@plot,@semilogy)