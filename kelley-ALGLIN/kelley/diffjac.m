
function [l, u] =diffjac(x, f, f0)
% compute a forward difference Jacobian f'(x), return lu factors
%
% uses dirder.m to compute the columns
%
% C. T. Kelley, November 25, 1993
%
% This code comes with no guarantee or warranty of any kind.
%
%
% inputs:
%         x, f = point and function
%		  f0   = f(x), preevaluated
%
n=length(x);
for j=1:n
    zz=zeros(n,1);
    zz(j)=1;
    jac(:,j)=dirder(x,zz,f,f0);
end
[l, u] = lu(jac);
