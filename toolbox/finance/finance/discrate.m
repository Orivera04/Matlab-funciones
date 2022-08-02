function d = discrate(sd,md,rv,price,basis) 
%DISCRATE Discount rate of security. 
%   D = DISCRATE(SD,MD,RV,PRICE,BASIS) finds the discount rate of a security
%   given the settlement date SD, the maturity date MD, par value RV, and PRICE.
%   basis is the day-count basis: 0 = actual/actual (default), 1 = 30/360, 
%   2 = actual/360, 3 = actual/365.  Enter dates as serial date numbers or
%   date strings. 
% 
%   For example,  
%   d = discrate('12-jan-1994', '25-jun-1994', 100, 97.74, 0) 
%   returns d = 0.0503 or a discount rate of 5.03%.  
% 
%   See also ACRUDISC, FVDISC, PRDISC, YLDDISC. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formula 1*. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:11 $ 
 
if nargin < 5 
  basis = 0; 
end 
if nargin < 4 
  error('Missing one of SD, MD, RV, and PRICE.') 
end 
if any(any(isstr(sd) | isstr(md))) 
  sd = datenum(sd); 
  md = datenum(md); 
end 
if length(sd) == 1 
  sd = sd*ones(size(md)); 
end 
if length(md) == 1 
  md = md*ones(size(sd)); 
end 
if length(rv) == 1 
  rv = rv*ones(size(sd)); 
end 
if length(price) == 1 
  price = price*ones(size(sd)); 
end 
if length(basis) == 1 
  basis = basis*ones(size(sd)); 
end 
if checksiz([size(sd);size(md);size(rv);size(price);size(basis)],mfilename) 
  return 
end 
 
if checkrng('sd',sd,-inf,md,'-inf','md','l','e',mfilename) 
  y = nan; 
  return 
end 
 
dsm = daysdif(sd(:),md(:),basis(:));              % Days from sd to md 
i = find(basis == 0);                           % B = Days in year 
if ~isempty(i);b(i) = daysact(datemnth(md(i),-12,0,0),md(i));end 
i = find(basis == 1 | basis == 2); 
if ~isempty(i);b(i) = 360*ones(size(i));end 
i = find(basis == 3); 
if ~isempty(i);b(i) = 365*ones(size(i));end 
d = reshape((1-price(:)./rv(:)).*(b'./dsm),size(rv));  % Formula 1*, page 45
