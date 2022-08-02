function [value] = g(x,mean,stdev)

% this calculates a gaussian (normal) distribution
%    x     - input value or array
%    mean  - mean of the gaussian
%    stdev - standard deviation of the gaussian
%    value - value of the the gaussian at the input value(s)
%            if input is array, output is an array

value = (x - mean);
value = value.^2;
value = value/(stdev*stdev);
value = exp(-value/2);
