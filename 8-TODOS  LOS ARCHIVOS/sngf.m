function y=sngf(x,x0,n)
% y=sngf(x,x0,n) 
% ~~~~~~~~~~~~~~
%
% This function computes the singularity
% function defined by 
%    y=<x-x0>^n for n=0,1,2,...
%
% User m functions required: none
%----------------------------------------------

if nargin < 3, n=0; end
x=x(:); nx=length(x); x0=x0(:)'; n0=length(x0); 
x=x(:,ones(1,n0)); x0=x0(ones(nx,1),:); d=x-x0; 
s=(d>=zeros(size(d))); v=d.*s;
if n==0 
  y=s;
else 
  y=v; 
  for j=1:n-1; y=y.*v; end
end