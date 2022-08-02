function [xp,sp] = expan(X,tp,p);
% expan    Performs a fast exponential analysis on the POT dataset stored in array X
%          
% INPUT:    
%       X: array or scalar values with POT data (peaks over threshold)
%       tp:  time period over which the data is collected
%       p: probability for which quantile has to be calculated
% OUTPUT: 
%       xp: quantile value corresponding to exceedance probability p
%       sp: uncertainty in quantile value expressed as 1 standard deviation
%       Figure, showing the POT data, exponential fit, and uncertainty
%       bounds by crosses around the extrapolation to the p-value
% EXAMPLE:
%       Dataset e, generated from an exponential distribution with scale 1: 
%       for i=1:10, e(i)=2-log(rand(1)); end
%       Assume the data are the peaks above 2 (meters) measured during 100 years
%       Perform exponential analysis for the 10^-4 quantile with:
%       expan(e,100,10^(-4))

% Author: P.H.A.J.M. van Gelder
% eMail: p.vangelder@ct.tudelft.nl
% Website: http://www.hydraulicengineering.tudelft.nl/public/gelder/homepg.htm
% $Revision: 1.0 $ $Date: 2004/08/28 $ 
%
% ***********************************************************************

n=length(X);
l=mean(X-min(X));
ratio=n/tp;
xp=min(X)-l*log(p/ratio);
sp=-log(p/ratio)*l/sqrt(n);
xx=[min(X):(xp-min(X))/10:xp+3*sp];
Fx=1-exp(-(xx-min(X))/l);

semilogy(sort(X),ratio*(1-([1:n]-0.3)/(n+0.4)),'o',xx,ratio*(1-Fx),[min(X),xp+3*sp],[p,p],[xp-sp,xp+sp],[p,p],'x');
xlabel('X')
title('POT data, exponential fit, and quantile uncertainty (1 std)')
ylabel('Frequency')
grid