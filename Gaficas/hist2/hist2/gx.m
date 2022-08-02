function [chisq] = gx(par)
global x;
global y;
global sigma;

% this calculates a gaussian (normal) distribution
%    x     - input value or array
%    mean  - mean of the gaussian
%    stdev - standard deviation of the gaussian
%    value - value of the the gaussian at the input value(s)
%            if input is array, output is an array

mean  = par(1);
stdev = par(2);
amp   = par(3);
fx = g(x,mean,stdev);
fx = amp * fx;

ind=find(y>0);
chisq = sum((y(ind) - fx(ind)).^2 ./ (sigma(ind)).^2);
