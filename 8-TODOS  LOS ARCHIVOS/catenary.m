[t,a] = meshgrid(linspace(-1,1),.2:.1:.5);
y = a.*cosh(t./a);
plot(t',y')