function [w,pcterr]=findieig(n)
% [w,pcterr]=findieig(n)
% ~~~~~~~~~~~~~~~~~~~~~
% This function determines eigenvalues of
% y''(x)+w^2*y(x)=0, y(0)=y(1)=0
% The solution uses an n point finite
% difference approximation
if nargin==0, n=100; end
a=2*eye(n,n)-diag(ones(n-1,1),1)...
  -diag(ones(n-1,1),-1);
w=(n+1)*sqrt(sort(eig(a))); we=pi*(1:n)';
pcterr=100*(w-we)./we; 