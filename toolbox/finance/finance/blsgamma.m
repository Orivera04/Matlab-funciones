function g = blsgamma(so,x,r,t,sig,q) 
%BLSGAMMA Black-Scholes sensitivity to underlying delta change. 
%   G = BLSGAMMA(SO,X,R,T,SIG) returns sensitivity of delta to change in the
%   underlying security price.  SO is the current stock price, X is the exercise
%   price, R is the risk-free interest rate, T is the time to maturity of the
%   option in years, SIG is the standard deviation of the annualized 
%   continuously compounded rate of return of the stock (also known as the
%   volatility), and Q is the dividend rate.  The default Q is 0.
%       
%   Note: 
%     This function uses normpdf, the normal probability density function 
%     in the Statistics Toolbox.
% 
%   For example, g = blsgamma(50,50,.12,.25,.3,0) returns g = 0.0512. 
% 
%   See also BLSPRICE, BLSDELTA, BLSTHETA, BLSRHO, BLSVEGA, BLSLAMBDA.
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:55:11 $ 
 
%       Reference: Options, Futures, and Other Derivative Securities,  
%                  Hull, Chapter 13. 
 
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
g = (normpdf(d1).*exp(-q.*t))./(so.*sig.*sqrt(t));
