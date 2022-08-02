function y = ylddisc(sd,md,rv,price,basis) 
%YLDDISC Yield of discounted security. 
%   Y = YLDDISC(SD,MD,RV,PRICE,BASIS) finds the yield of a discounted 
%   security given the settlement date, SD, the maturity date, MD, redemption  
%   value, RV, discounted price, PRICE, and day count basis, BASIS. For BASIS,
%   0 = actual/actual (default), 1 = 30/360, 2 = actual/360, 3 = actual/365. 
%   Enter dates as serial date numbers or date strings.
% 
%   Using the following data, 
%   
%      SD = '10/14/1988'
%      MD = '03/17/1989'
%      RV = 100
%      PRICE = 96.28
%      BASIS = 2
%       
%   y = ylddisc(sd,md,rv,price,basis)
%       
%   returns y = 0.0903 or 9.03%
% 
%   See also PRBOND, YLDBOND, YLDMAT, PRDISC. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formula 1. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:53:47 $ 
 
if nargin < 5 
  basis = zeros(size(rv)); % Default day count basis 
end 
if nargin < 4 
  error(sprintf('Missing one of SD, MD, RV, and DISC data.')) 
end 
i = find(basis ~= 0 & basis ~= 1 & basis ~=2 & basis ~=3); 
if ~isempty(i) 
  error(sprintf('Invalid day count basis specified.')) 
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
 
dsm = daysdif(sd(:),md(:),basis(:));            % dsm = days from sd to md 
i = find(basis == 0);                         % b = days in a year 
if ~isempty(i);b(i) = daysact(datemnth(md(i),-12,0,0),md(i));end 
i = find(basis == 1 | basis == 2); 
if ~isempty(i);b(i) = 360*ones(size(i));end 
i = find(basis == 3); 
if ~isempty(i);b(i) = 365*ones(size(i));end 
    
y = reshape((rv(:)-price(:))./price(:).*b(:)./dsm(:),size(rv)); % Formula 1
