% P7_12.M Plot the Legendre approximation to an odd function
%  f(x)= signum(x)   [-1 1]
%
% The Legendre series is
%  fapprox(x)=  (3/2)P1 - (7/8) P3 = (45/16)x - (35/16) x^3 
%
x=[-1:.01:1];
p=[(-35/16) 0 (45/16) 0];
y=polyval(p,x);
plot(x,y)
%
% Add annotation to the graph.
%

