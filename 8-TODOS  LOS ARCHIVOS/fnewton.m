function [res, it]=fnewton(func,dfunc,x,tol)
% Finds a root of f(x) = 0 using Newton's method.
%
% Example call: [res, it]=fnewton(func,dfunc,x,tol)
% The user defined function func is the function f(x),
% The user defined function dfunc is df/dx.
% x is an initial starting value, tol is required accuracy.
%
it=0; x0=x;
d=feval(func,x0)/feval(dfunc,x0);
while abs(d)>tol 
  x1=x0-d;
  it=it+1;
  x0=x1;
  d=feval(func,x0)/feval(dfunc,x0);
end;
res=x0;
