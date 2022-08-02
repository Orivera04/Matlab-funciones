function [cd,pd] = blsdelta(so,x,r,t,sig,q)  
%BLSDELTA Black-Scholes sensitivity to underlying price change.  
%   [CD,PD] = BLSDELTA(SO,X,R,T,SIG,Q) returns sensitivity in option value to  
%   change in the underlying security price.  Delta is also known as the hedge
%   ratio.  SO is the current stock price, X is the exercise price, R is the
%   risk-free interest rate, T is the time to maturity of the option in years, 
%   SIG is the standard deviation of the annualized continuously compounded 
%   rate of return of the stock (also known as the volatility), and Q is the
%   dividend rate or the foreign interest rate where applicable. The default
%   Q is 0.  CD is the delta of a call option, and PD is the delta of a put
%   option. 
%        
%   Note: 
%     This function uses normcdf, the normal cumulative distribution
%     function in the Statistics Toolbox. 
%  
%   For example, [c,p] = blsdelta(50,50,.1,.25,.3,0) returns  
%   c = 0.5955 and p = -0.4045.  
%  
%   See also BLSPRICE, BLSGAMMA, BLSTHETA, BLSRHO, BLSVEGA, BLSLAMBDA.  
%  
%   Reference: Options, Futures, and Other Derivative Securities, Hull,  
%              Chapter 13.  
  
%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:35 $  
   
if nargin < 5  
  error(sprintf('Missing one of SO, X, R, T, and SIG.'))  
end  
if any(so <= 0 | x <= 0 | r < 0 | t <=0 | sig < 0)  
  error(sprintf('Enter SO, X, and T > 0. Enter R and S >= 0.'))  
end  
if nargin < 6  
  q = zeros(size(so)); % default dividend rate  
end  
  
d1 = (log(so./x)+(r-q+sig.^2/2).*t)./(sig.*sqrt(t));
cd = exp(-q.*t).*normcdf(d1);  
pd = cd - exp(-q.*t);
