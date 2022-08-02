function z=cbfrqnwm(n,tol)
%
% z=cbfrqnwm(n,tol)
% ~~~~~~~~~~~~~~~~~
% Cantilever beam frequencies by Newton's 
% method.  Zeros of 
%        f(z) = cos(z) + 1/cosh(z)  
% are computed.
%
% n   - Number of frequencies required
% tol - Error tolerance for terminating 
%       the iteration
% z   - Dimensionless frequencies are the 
%       squares of the roots of f(z)=0
%
% User m functions called:  none
%----------------------------------------------

if nargin ==1, tol=1.e-5; end

% Base initial estimates on the asymptotic 
% form of the frequency equation
zbegin=((1:n)-.5)'*pi; zbegin(1)=1.875; big=10;

% Start Newton iteration
while big > tol
  t=exp(-zbegin); tt=t.*t; 
  f=cos(zbegin)+2*t./(1+tt);
  fp=-sin(zbegin)-2*t.*(1-tt)./(1+tt).^2; 
  delz=-f./fp;
  z=zbegin+delz; big=max(abs(delz)); zbegin=z;
end
z=z.*z;