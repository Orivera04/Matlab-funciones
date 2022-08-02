function yld = yldoddl(sd,md,lcd,rv,price,cpn,per,basis,maxiter) 
%YLDODDL Yield with odd last period. 
%   YLD = YLDODDL(SD,MD,LCD,RV,PRICE,CPN,PER,BASIS,MAXITER)  
%   returns the yield of a security with odd last period.  SD is the
%   settlement date, MD is the maturity date, LCD is the last coupon date,
%   RV is the par value, PRICE is the security price, CPN is the coupon
%   rate, PER is the number of coupon periods per year (default = 2), and
%   BASIS is the day-count basis: 0 = actual/actual (default), 1 = 30/360,
%   2 = actual/360, 3 = actual/365.  MAXITER specifies the number of
%   iterations used by Newton's method to solve for YLD.  By default,
%   MAXITER = 50.  Enter dates as serial date numbers or date strings.
% 
%   Using the following data,
%  
%      SD = '02/07/1993'
%      MD = '06/15/1993'
%      LCD = '10/15/1992'
%      RV = 100
%      PRICE = 99.878
%      CPN = 0.0375
%      PER = 2
%      BASIS = 1
%       
%   yld = yldoddl(sd,md,lcd,rv,price,cpn,per,basis)
%       
%   returns yld = 0.0405 or 4.05%.
% 
%   See also YLDODDF, YLDBOND, YLDODDFL, PRODDL. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formulas 10, 12, 14, 15. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.8 $   $Date: 2002/04/14 21:53:59 $ 
 
if nargin < 9 
  maxiter = 50; 
end 
if nargin < 8 
  basis = 0; 
end 
if nargin < 7  
  per = 2; 
end 
if nargin < 6 
  error('Missing one of SD, MD, LCD, RV, PRICE, and CPN.') 
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
if length(price) == 1 
  price = price*ones(size(sd)); 
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
if length(maxiter) == 1 
  maxiter = maxiter*ones(size(sd)); 
end 
if any(any(basis ~= 0 & basis ~= 1 & basis ~= 2 & basis ~= 3)) 
  error(sprintf('Invalid day count basis specified.')) 
end 
if checksiz([size(sd);size(md);size(lcd);size(rv);size(price);size(cpn);... 
             size(per);size(basis);size(maxiter)],mfilename) 
  return 
end 
 
yld = zeros(size(sd)); 
for i = 1:length(sd(:)) 
 
if checkrng(str2mat('lcd','cpn','per'),[lcd(i),cpn(i),per(i)],[-inf 0 0],... 
            [md(i) inf inf],str2mat('sd','0','0'),... 
            str2mat('md','inf','inf'),['l';'e';'l'],... 
            ['e';'l';'l'],mfilename) 
  return 
end 
if checktyp('per',per(i),'int',mfilename);return;end 

end                  % End for loop

yld  =  bndyield(price,cpn,sd,md,per,basis,[],[],[],lcd,[],rv);