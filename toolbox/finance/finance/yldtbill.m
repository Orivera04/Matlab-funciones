function y = yldtbill(sd,md,rv,price) 
%YLDTBILL Yield of treasury bill. 
%   Y = YLDTBILL(SD,MD,RV,PRICE) returns the yield for a Treasury bill. 
%   SD is the settlement date, MD is the maturity date, RV is the par value,
%   and PRICE is the price of the Treasury bill.  Enter the settlement and
%   maturity dates as serial date numbers or date strings. 
% 
%   For example, the settlement date of a treasury bill is February 10, 1992,
%   the maturity date is August 6, 1992, the redemption value is $1000,
%   and the price is $981.36.  The annual equivalent yield is  
% 
%   y = yldtbill('2/10/1992', '8/6/1992', 1000, 981.36)
%   or y = 0.0384 or 3.84%.
% 
%   See also BEYTBILL, PRTBILL. 
% 
%   Reference: Bodie, Kane, and Marcus, Investments, pages 41-43. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:47 $ 
 
 
if nargin < 4 
  error(sprintf('Missing one of SD, MD, RV, and PRICE.')) 
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
if checksiz([size(sd);size(md);size(rv);size(price)],mfilename) 
  return 
end 
 
if checkrng('sd',sd,-inf,md,'-inf','md','l','e',mfilename) 
  y = nan; 
  return 
end 
 
y = 360./daysact(sd,md).*(rv./price-1);
