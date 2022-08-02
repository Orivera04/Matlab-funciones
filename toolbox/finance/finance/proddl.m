function [p,ai] = proddl(sd,md,lcd,rv,cpn,yld,per,basis) 
%PRODDL Price with odd last period. 
%   [P,AI] = PRODDL(SD,MD,LCD,RV,CPN,YLD,PER,BASIS) returns the price P and 
%   accrued interest AI of a security with odd last period.  SD is the
%   settlement date, MD is the maturity date, LCD is the last coupon date, 
%   RV is the par value, CPN is the coupon rate, YLD is the yield, PER is
%   the number of coupon periods per year (default = 2), and BASIS is the
%   day-count basis: 0 = actual/actual (default), 1 = 30/360, 2 = actual/360,
%   3 = actual/365.  Enter dates as serial date numbers or date strings. 
% 
%   Using the following data,
% 
%       SD = '02/07/1993'
%       MD = '08/01/1993'
%       LCD = '02/04/1993'
%       RV = 100
%       CPN = 0.0650
%       YLD = 0.0535
%       PER = 2
%       BASIS = 1
%       
%   [p,ai] = proddl(sd,md,lcd,rv,cpn,yld,per,basis)
%       
%   returns p = 100.54 and ai = 0.05.
% 
%   See also PRODDF, PRODDFL, PRBOND, YLDODDL. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formulas 11, 13, 14, 15. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.7 $   $Date: 2002/04/14 21:53:26 $ 
 
if nargin < 8 
  basis = 0; 
end 
if nargin < 7  
  per = 2; 
end 
if nargin < 6 
  error('Missing one of SD, MD, LCD, RV, CPN, and YLD.') 
end 
if any(any(isstr(sd) | isstr(md) | isstr(lcd))) 
  sd = datenum(sd); 
  md = datenum(md); 
  lcd = datenum(lcd); 
end 
if length(sd) == 1 
  sd = sd*ones(size(md)); 
end 
if length(md) == 1 
  md = md*ones(size(sd)); 
end 
if length(lcd) == 1 
  lcd = lcd*ones(size(sd)); 
end 
if length(rv) == 1 
  rv = rv*ones(size(sd)); 
end 
if length(yld) == 1 
  yld = yld*ones(size(sd)); 
end 
if length(cpn) == 1 
  cpn = cpn*ones(size(sd)); 
end 
if length(per) == 1 
  per = per*ones(size(sd)); 
end 
if length(basis) == 1 
  basis = basis*ones(size(sd)); 
end 
if any(any(basis ~= 0 & basis ~= 1 & basis ~= 2 & basis ~= 3)) 
  error(sprintf('Invalid day count basis specified.')) 
end 
if checksiz([size(sd);size(md);size(lcd);size(rv);size(yld);size(cpn);... 
             size(per);size(basis)],mfilename) 
  return 
end 
 
p = zeros(size(sd)); 
for i = 1:length(sd(:)); 
 
if checkrng(str2mat('lcd','cpn','yld','per','sd'),... 
            [lcd(i),cpn(i),yld(i),per(i),sd(i)],[-inf 0 0 0 -inf],... 
            [md(i) inf inf inf md(i)],str2mat('-inf','0','0','0','-inf'),... 
            str2mat('md','inf','inf','inf','md'),['l';'e';'e';'l';'l'],... 
            ['e';'l';'l';'l';'e'],mfilename) 
  return 
end 
if checktyp('per',per(i),'int',mfilename);return;end 
 
end  % End for loop

[p,ai] = bndprice(yld,cpn,sd,md,per,basis,[],[],[],lcd,[],rv);
