
% Script file graph2.

% Several plots of the rational function y = x/(1+x^2) 
% in the same window.

k = 0;
for n=1:3:10
   n10 = 10*n;
   x = linspace(-2,2,n10);
   y = x./(1+x.^2);
   k = k+1;
   subplot(2,2,k)
   plot(x,y,'r')
   title(sprintf('Graph %g. Plot based upon n = %g points.' ... 
      , k, n10))
   xlabel('x')
   ylabel('y')
   axis([-2,2,-.8,.8])
   grid
   pause(3);
end
