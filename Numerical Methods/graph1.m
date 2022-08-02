
% Script file graph1.

% Graph of the rational function y = x/(1+x^2).

for n=1:2:5
   n10 = 10*n;
   x = linspace(-2,2,n10);
   y = x./(1+x.^2);
   plot(x,y,'r')
   title(sprintf('Graph %g.  Plot based upon n = %g points.' ... 
   , (n+1)/2, n10))
   axis([-2,2,-.8,.8])
   xlabel('x')
   ylabel('y')
   grid
   pause(3)
end
