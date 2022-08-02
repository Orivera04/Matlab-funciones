
function [] = testnder(h, n)

% Test file for the function numder. The initial step size is h and 
% the number of iterations is n. Function to be tested is
% f(x) = exp(-x^2).

format long
disp('        x               numder               exact')
disp(sprintf('\n  _____________________________________________________'))
s = [];
for x=.1:.1:1
   s1 = numder('exp2', x, h, n);
   s2 = derexp2(x);
   disp(sprintf('%1.14f   %1.14f   %1.14f',x,s1,s2))
end


function y = derexp2(x)

% First order derivative of f(x) = exp(-x^2).

y = -2*x.*exp(-x.^2);