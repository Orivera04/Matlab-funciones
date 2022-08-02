%(MM0901.m plot)
x = linspace(0,10,100); % create data
y = sin(x); % compute sine
z = (y>=0).*y; % set negative values of sin(x) to zero
z = z + 0.5*(y<0); % where sin(x) is negative add 1/2
z = (x<=8).*z; % set values past x=8 to zero
plot(x,z)
xlabel('x'), ylabel('z=f(x)'),
title('Figure 9.1: A Discontinuous Signal')
