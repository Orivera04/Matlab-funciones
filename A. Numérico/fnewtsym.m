function [res, it]=fnewtsym(func,x0,tol)
% Finds a root of f(x) = 0 using Newton’s method
% using the symbolic toolbox
%
% Example call: [res, it]=fnewtsym(func,x,tol)
% The user defined function func is the function f(x) which must
% be defined as a symbolic function.
% x is an initial starting value, tol is required accuracy.
%
it=0; syms dfunc x
% Now perform the symbolic differentiation:
dfunc=diff(func);
d=double(subs(func,x,x0)/subs(dfunc,x,x0))
while abs(d)>tol
  x1=x0-d;
  it=it+1; x0=x1;
  d=double(subs(func,x,x0)/subs(dfunc,x,x0))
end;
res=x0;