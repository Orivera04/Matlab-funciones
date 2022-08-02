% M-file (EX1_5.M) to evaluate the function 
%  y= a*exp(-1.2t) - 3.0*exp(-2t) 
% INPUT:  Coefficient a and time t
% OUTPUT: y(t) displayed
fprintf('Compute y= a*exp(-1.2*t) - 3.0*exp(-2*t) \n')
a=input('Coefficient a, a= ');
t=input('Variable t, t= ');
%
% Display results
fprintf('\n Function: y=%g*exp(-1.2*%g)-3.0*exp(-2*%g) \n',a,t,t)
y=a*exp(-1.2*t) - 3.0*exp(-2*t) 
% End M-file
