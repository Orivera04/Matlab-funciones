function rv = fvdisc(sd,md,price,disc,basis) 
%FVDISC Future value of discounted security. 
%   RV = FVDISC(SD,MD,PRICE,DISC,BASIS) finds the amount received at
%   maturity RV for a fully vested security given the settlement date SD,
%   the maturity date MD, present value PRICE, discount rate DISC,
%   and day-count basis BASIS.  For BASIS, 0 = actual/actual (default),
%   1 = 30/360, 2 = actual/360, 3 = actual/365.
%   Enter dates as serial date numbers or date strings. 
% 
%   Using the following data, 
% 
%   SD = '02/15/1991' 
%   MD = '05/15/1991' 
%   PRICE = 100 
%   DISC = .0575 
%   BASIS = 2 
% 
%   $101.44 is returned at maturity of the security. 
% 
%   See also ACRUDISC, PRDISC, YLDDISC. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:20 $ 
 
if nargin < 5 
   basis = zeros(size(price)); 
end 
if nargin < 4 
  error(sprintf('Missing one of SD, MD, PRICE, and DISC.')) 
end 
if any(any(isstr(sd) | isstr(md))) 
  sd = datenum(sd); 
  md = datenum(md); 
end 
if length(sd) == 1 
  sd = sd*ones(size(md)); 
end 
pad = ones(size(sd)); 
if length(md) == 1 
  md = md*pad; 
end 
if length(price) == 1 
  price = price*pad; 
end 
if length(disc) == 1 
  disc = disc*pad; 
end 
if length(basis) == 1 
  basis = basis*pad; 
end 
if checksiz([size(sd);size(md);size(price);size(disc);size(basis)],mfilename) 
  return 
end 
rl = length(sd(:)); 
tmp = inf; 
infpad = tmp(ones(1,rl),1); 
z = zeros(rl,1); 
if checkrng(str2mat('sd','disc'),[sd(:),disc(:)],[-infpad z],[md(:) infpad],... 
            str2mat('-inf','0'),str2mat('md','inf'),['l';'e'],... 
            ['e';'l'],mfilename) 
  return 
end 
 
dsm = daysdif(sd(:),md(:),basis(:));      % dms - days from sd to md  
i = find(basis == 0);                      % b = days in a year 
if ~isempty(i);b(i) = daysact(datemnth(md(i),-12,0,0),md(i));end 
i = find(basis == 1 | basis == 2); 
if ~isempty(i);b(i) = 360*ones(size(i));end 
i = find(basis == 3); 
if ~isempty(i);b(i) = 365*ones(size(i));end 
    
rv = reshape(price(:)./(1-disc(:).*dsm(:)./b(:)),size(price));% Formulas 1 and 2
