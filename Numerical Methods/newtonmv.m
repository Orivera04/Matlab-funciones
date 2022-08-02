function [xv,it]=newtonmv(x,f,jf,n,tol)
% Newton's method for solving a system of n non-linear equations in n variables.
%
% Example call: [xv,it]=newtonmv(x,f,jf,n,tol)
% Requires an initial approximation column vector x. tol is required accuracy.
% User must define functions f (system equations) and jf (partial derivatives)
% For example of these functions, see page 112.
% xv is the solution vector, parameter it is number of iterations taken.
% WARNING. The method may fail, for example if initial estimates are poor.
%
it=0; xv=x;
fr=feval(f,xv);
while norm(fr)>tol
  Jr=feval(jf,xv);
  xv1=xv-Jr\fr; xv =xv1;
  fr=feval(f,xv);
  it=it+1;
end;
