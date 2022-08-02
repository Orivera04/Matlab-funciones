function expfn(x)
% expfn compares the built-in function exp(x)
%  and a series approximation and prints
% Format expfn(x)
 
fprintf('Value of built-in exp(x) is %.2f\n',exp(x))
 
% n is arbitrary number of terms
n = 10;
fprintf('Approximate exp(x) is %.2f\n', appex(x,n))
end
 
function outval = appex(x,n)
% appex approximates e to the x power using terms up to 
%  x to the nth power
% Format appex(x,n)
 
% Initialize the running sum in the output argument
% outval to 1 (for the first term)
outval = 1;
% runprod is the factorial in the denominator
runprod = 1;
 
for i = 1:n
    runprod = runprod * i;
    outval = outval + (x^i)/runprod;
end
end
