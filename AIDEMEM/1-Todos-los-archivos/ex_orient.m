x = linspace(eps,1,500);
plot(x, x.*sin(1./x));
orient('landscape')
print -deps2 trace2.eps
orient('portrait')
print -deps2 trace1.eps
