function [cr,pr] = blsrho(so,x,r,t,sig,q) 
%BLSRHO Black-Scholes sensitivity to interest rate change. 
%   [CR,PR]= BLSRHO(SO,X,R,T,SIG,Q) returns the rate of change in value of
%   securities with respect to interest rates.  SO is the current security
%   price, X is the exercise or strike price, R is the interest rate, T is
%   the time until maturity expressed in years, SIG is the volatility (standard
%   deviation), and Q is the dividend rate.  The default Q is 0.  CR is the
%   call option rho and PR is the put option rho.
%       
%   Note: This function uses normcdf, the normal cumulative
%         distribution function in the Statistics Toolbox. 
% 
%   For example, [c,p] = blsrho(50,50,.12,.25,.3,0) returns 
%   c = 6.6686 and p = -5.4619. 
% 
%   See also BLSPRICE, BLSDELTA, BLSGAMMA, BLSTHETA, BLSVEGA, BLSLAMBDA. 
% 
%   Reference: Hull, Options, Futures, and Other Derivative Securities, 2nd
%              edition, Chapter 13. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:55:20 $ 
 
 
if nargin < 5 
  error(sprintf('Missing one of SO, X, R, T, and SIG.')) 
end 
[m,n] = size(so); 
if nargin < 6 
  q = zeros(m,n);   % default dividend rate 
end 
if any(so <= 0 | x <= 0 | r < 0 | t <=0 | sig < 0) 
  error(sprintf('Enter SO, X, and T > 0. Enter R and S >= 0.')) 
end 
 
d1 = (log(so./x)+(r-q+sig.^2/2).*t)./(sig.*sqrt(t));
d2 = d1 - (sig.*sqrt(t)); 
disfac = x.*t.*exp(-r.*t); 
cr = disfac.*normcdf(d2); 
pr = -disfac.*normcdf(-d2);
