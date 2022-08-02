function [res, it]=schroder(func,dfunc,m,x,tol)
% Finds a multiple root of f(x) = 0 using Schroder's method.
%
% Example call: [res, it]=schroder(func,dfunc,m,x,tol)
% The user defined function func is the function f(x),
% The user defined function dfunc is df/dx.
% x is an initial starting value, tol is required accuracy.
% function has a root of multiplicity m.
% x is a starting value, tol is required accuracy.
%
it=0; x0=x;
d=feval(func,x0)/feval(dfunc,x0);
while abs(d)>tol
  x1=x0-m*d;
  it=it+1; x0=x1;
  d=feval(func,x0)/feval(dfunc,x0);
end;
res=x0;
