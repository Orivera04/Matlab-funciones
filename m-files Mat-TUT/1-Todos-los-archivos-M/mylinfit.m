function [m,b] = mylinfit(x,y)
% mylinfit implements a least squares regression for a 
%  straight line of the form y = mx+b
% Format: mylinfit(x,y)
 
n = length(x);  % Assume y has same length
 
numerator = n * sum(x .* y) - sum(x)*sum(y);
denom = n * sum(x .^ 2) - (sum(x))^2;
m = numerator/denom;
 
b = mean(y) - m*mean(x);
end
