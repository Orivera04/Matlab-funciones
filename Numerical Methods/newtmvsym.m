function [x1,fr,it]=newtmvsym(x,f,n,tol)
% Newton’s method for solving a system of n non-linear equations
% in n variables. This version is restricted to two variables
%
% Example call: [xv,it]=newtmvsym(x,f,n,tol)
% Requires an initial approximation column vector x. tol is
% required accuracy.
% User must define functions f, the system equations
% xv is the solution vector, parameter it is number of iterations
% WARNING. The method may fail, e.g. if initial estimates are poor.
%
syms a b
xv=sym([a b]);
it=0;
fr=double(subs(f,xv,x));
while norm(fr)>tol
  Jr=double(subs(jacobian(f,xv),xv,x));
  x1=x-(Jr\fr')'; x =x1;
  fr=double(subs(f,xv,x1));
  it=it+1;
end