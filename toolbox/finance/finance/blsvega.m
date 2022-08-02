function v = blsvega(so,x,r,t,sig,q) 
%BLSVEGA Black-Scholes sensitivity to underlying price volatility. 
%   V = BLSVEGA(SO,X,R,T,SIG,Q) returns the rate of change of the option value
%   with respect to the volatility of the underlying asset.  SO is the current
%   stock price, X is the exercise price, R is the risk-free interest rate, 
%   T is the time to maturity of the option in years, SIG is the standard 
%   deviation of the annualized continuously compounded rate of return of the
%   stock (also known as volatility), and q is the dividend rate.  
%   The default Q is 0.
%       
%   Note: This function uses normpdf, the normal probability
%         density function in the Statistics Toolbox.
% 
%   For example, v = blsvega(50,50,.12,.15,.3,0) returns v = 7.5522. 
% 
%   See also BLSPRICE, BLSDELTA, BLSGAMMA, BLSTHETA, BLSRHO, BLSLAMBDA. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:55:26 $ 
 
%       Reference: Options, Futures, and Other Derivative Securities,  
%                  Hull, Chapter 13. 
 
if nargin < 5 
  error(sprintf('Missing one of SO, X, R, T, and SIG.')) 
end 
if any(so <= 0 | x <= 0 | r < 0 | t <=0 | sig < 0) 
  error(sprintf('Enter SO, X, and T > 0. Enter R and S >= 0.')) 
end 
if nargin < 6 
   q = zeros(size(so));; % default dividend rate 
end 
 
d1 = (log(so./x)+(r-q+sig.^2/2).*t)./(sig.*sqrt(t));
v = so.*sqrt(t).*normpdf(d1).*exp(-q.*t);
