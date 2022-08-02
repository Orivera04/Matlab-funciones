function y=raterp(a,b,x)
%
% y=raterp(a,b,x) 
% ~~~~~~~~~~~~~~~
% This function interpolates using coefficients
% from function ratcof.
%
% a,b - polynomial coefficients from function 
%       ratcof
% x   - argument at which function is evaluated
% y   - computed rational function values
%
%----------------------------------------------

a=flipud(a(:)); b=flipud(b(:));
y=polyval(a,x)./(1+x.*polyval(b,x));