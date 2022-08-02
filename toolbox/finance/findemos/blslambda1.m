function [lc,lp] = blslambda1(so,x,r,t,sig,q)  
%BLSLAMBDA Black-Scholes elasticity.  

%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.5 $   $Date: 2002/04/14 21:44:19 $ 

% Changed blslambda due to vectorizing problem
% Modified by Greg Portmann (1997)


if nargin < 5  
  error(sprintf('Missing one of SO, X, R, T, and SIG.'))  
end  
if any(so <= 0 | x <= 0 | r < 0 | t <=0 | sig < 0)  
  error(sprintf('Enter SO, X, and T > 0. Enter R and S >= 0.'))  
end  
if nargin < 6  
  q = zeros(size(so));  
end  
  

[cprice, pprice] = blsprice(so,x,r,t,sig,q);  
[cdelta, pdelta] = blsdelta(so,x,r,t,sig,q);  
lc = so.*cdelta./cprice;
lp = so.*pdelta./pprice;

