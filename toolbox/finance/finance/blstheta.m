function [ct,pt] = blstheta(so,x,r,t,sig,q) 
%BLSTHETA Black-Scholes sensitivity to time until maturity change. 
%   [CT,PT] = BLSTHETA(SO,X,R,T,SIG,Q) returns sensitivity in option value with
%   respect to time.  SO is the current stock price, X is the exercise price,
%   R is the risk-free interest rate, T is the time to maturity of the option
%   in years, SIG is the standard deviation of the annualized continuously
%   compounded rate of return of the stock (also known as volatility), and
%   Q is the dividend rate.  The default Q is 0.  CT is the theta of a call
%   option, and PT is the theta of a put option. 
%       
%   Note: 
%     This function uses normpdf, the normal probability density function 
%     and normcdf, the normal cumulative distribution function in the
%     Statistics Toolbox. 
% 
%   For example, [c,p] = blstheta(50,50,.12,.25,.3,0) returns  
%   c = -8.9630 and p = -3.1404. 
% 
%   See also BLSPRICE, BLSDELTA, BLSGAMMA, BLSRHO, BLSVEGA, BLSLAMBDA. 
% 
%   Reference: Hull, Options, Futures, and Other Derivative Securities,  
%              2nd Edition, Chapter 13. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:55:23 $ 
 
 
if nargin < 5 
  error('Missing one of SO, X, R, T, and SIG.') 
end 
if any(so <= 0 | x <= 0 | r < 0 | t <=0 | sig < 0) 
  error(sprintf('Enter SO, X, and T > 0. Enter R and S >= 0.')) 
end 
if nargin < 6 
 q = zeros(size(so)); 
end 
 
d1 = (log(so./x)+(r-q+sig.^2/2).*t)./(sig.*sqrt(t));
d2 = d1 - (sig.*sqrt(t)); 
ct = -so.*normpdf(d1).*sig.*exp(-q.*t)./(2.*sqrt(t))+... 
     q.*so.*normcdf(d1).*exp(-q.*t)-r.*x.*exp(-r.*t).*normcdf(d2); 
pt = -so.*normpdf(d1).*sig.*exp(-q.*t)./(2.*sqrt(t))-... 
     q.*so.*normcdf(-d1).*exp(-q.*t)+r.*x.*exp(-r.*t).*normcdf(-d2);
