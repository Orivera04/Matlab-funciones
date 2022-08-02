function [lc,lp] = blslambda(so,x,r,t,sig,q)  
%BLSLAMBDA Black-Scholes elasticity.  
%   [LC,LP] = BLSLAMBDA(SO,X,R,T,SIG,Q) returns the elasticity of an option. 
%   Elasticity (the leverage of an option position) measures the percent change 
%   in an option price per one percent change in the underlying stock price.  
%   SO is the current stock price, X is the exercise price, R is the risk-free
%   interest rate, T is the time to maturity of the option in years, SIG is the   
%   standard deviation of the annualized continuously compounded rate of return 
%   of the stock (also known as the volatility), and Q is the dividend rate.
%   The default Q is 0.  LC is the call option elasticity or leverage factor 
%   and LP is the put option elasticity or leverage factor. 
%        
%   Note: 
%     This function uses normcdf, the normal cumulative distribution  
%     function in the Statistics Toolbox.  
%  
%   For example, [c,p] = blslambda(50,50,.12,.25,.3) returns    
%   c = 8.1274 and p = -8.6466.  
%  
%   See also BLSPRICE, BLSDELTA, BLSGAMMA, BLSRHO, BLSTHETA, BLSVEGA.  
%  
%   Reference: Advanced Options Trading, Daigler, Chapter 4  
  
%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
%       $Revision: 1.7 $   $Date: 2002/04/14 21:55:14 $  
  
if nargin < 5  
  error(sprintf('Missing one of SO, X, R, T, and SIG.'))  
end  
if any(so <= 0 | x <= 0 | r < 0 | t <=0 | sig < 0)  
  error(sprintf('Enter SO, X, and T > 0. Enter R and S >= 0.'))  
end  
if nargin < 6  
  q = zeros(size(so));  
end  
  
d1 = (log(so./x)+(r-q+sig.^2/2).*t)./(sig.*sqrt(t));
[c,p] = blsprice(so,x,r,t,sig,q);  
tmp = nan;  
lc = zeros(size(so));  
lp = lc;  
nic = find(abs(c) < 1e-14);  % Eliminates spikes caused by round off error  
nip = find(abs(p) < 1e-14);  % Eliminates spikes caused by round off error  
gic = find(abs(c) >= 1e-14); % Points that are not spikes  
gip = find(abs(p) >= 1e-14); % Points that are not spikes  
lc(gic) = so(gic)./c(gic).*normcdf(d1(gic));  
if (normcdf(d1(gip))-1) < 1e-6  
  lp(gip) = so(gip)./p(gip).*(-normcdf(-d1(gip)));  
else  
  lp(gip) = so(gip)./p(gip).*(normcdf(d1(gip))-1);  
end  
lc(nic) = tmp(ones(size(nic)));  
lp(nip) = tmp(ones(size(nip)));
