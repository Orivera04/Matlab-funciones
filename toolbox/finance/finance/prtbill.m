function p = prtbill(sd,md,rv,disc) 
%PRTBILL Price of treasury bill. 
%   P = PRTBILL(SD,MD,RV,DISC) returns the price for a Treasury bill. 
%   SD is the settlement date, MD is the maturity date, RV is the redemption
%   value and DISC is the discount rate. Enter the settlement and maturity
%   dates as serial date numbers or date strings. 
% 
%   For example, the settlement date of a treasury bill is February 10, 1992, 
%   the maturity date is August 6, 1992, the discount rate is 3.77%, and the  
%   redemption value is $1000.  The treasury bill price is  
%   p = prtbill('2/10/1992', '8/6/1992', 1000, 0.0377) 
%   or p = 981.36.  
%  
%   See also BEYTBILL, YLDTBILL. 
% 
%   Reference: Bodie, Kane, and Marcus, Investments, pages 41-43. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:53:29 $ 
 
 
if nargin < 4 
  error(sprintf('Missing one of SD, MD, RV, and DISC.')) 
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
if length(disc) == 1 
  disc = disc*ones(size(sd)); 
end 
if checksiz([size(sd);size(md);size(rv);size(disc)],mfilename) 
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
 
p = rv.*(1-disc.*daysact(sd,md)./360);  % Formula 2.2
