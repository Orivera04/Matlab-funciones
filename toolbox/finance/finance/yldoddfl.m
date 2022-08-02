function yld = yldoddfl(sd,md,id,fd,lcd,rv,price,cpn,per,basis,maxiter) 
%YLDODDFL Yield with odd first and last periods and settlement in first period. 
%   YLD = YLDODDFL(SD,MD,ID,FD,LCD,RV,PRICE,CPN,PER,BASIS,MAXITER) returns the
%   yield of a security with odd first and last periods and the settlement
%   date in the first period.  SD is the settlement date, MD is the
%   maturity date, ID is the issue date, FD is the first coupon date, LCD
%   is the last coupon date, RV is the par value, PRICE is the security
%   price, CPN is the coupon rate, PER is the number of coupon periods per
%   year (default = 2), and BASIS is the day-count basis: 0 =
%   actual/actual (default), 1 = 30/360, 2 = actual/360, 3 = actual/365.
%   MAXITER specifies the number of iterations used by Newton's method
%   to solve for YLD.  By default, MAXITER = 50.  Enter dates as serial
%   date numbers or date strings.
% 
%   Using the following data, 
%   
%         SD = '03/15/1993'
%         MD = '03/01/2020'
%         ID = '03/01/1993'
%         FD = '07/01/1993'
%         LCD = '01/01/2020'
%         RV = 100
%         PRICE = 95.71
%         CPN = 0.04
%         PER = 2
%         BASIS = 1
%       
%   yld = yldoddfl(sd,md,id,fd,lcd,rv,price,cpn,per,basis)
%       
%   returns yld = 0.0427 or 4.27%.
% 
%   See also YLDODDF, YLDODDL, YLDBOND, PRODDFL. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formulas 16, 17, 18, 19. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.9 $   $Date: 2002/04/14 21:54:02 $ 
 
if nargin < 11 
  maxiter = 50; 
end 
if nargin < 10 
  basis = 0; 
end 
if nargin < 9 
  per = 2; 
end 
if nargin < 8 
  error('Missing one of SD, MD, ID, FD, LCD, RV, CPN, and YLD.') 
end 
if any(any(isstr(sd) | isstr(md) | isstr(id) | isstr(fd) | isstr(lcd))) 
  sd = datenum(sd); 
  md = datenum(md); 
  id = datenum(id); 
  fd = datenum(fd); 
  lcd = datenum(lcd); 
end 
if length(sd) == 1 
  sd = sd*ones(size(md)); 
end 
if length(md) == 1 
  md = md*ones(size(sd)); 
end 
if length(id) == 1 
  id = id*ones(size(sd)); 
end 
if length(fd) == 1 
  fd = fd*ones(size(sd)); 
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
if checksiz([size(sd);size(md);size(id);size(fd);size(lcd);size(rv);size(price);size(cpn);size(per);size(basis);size(maxiter)],mfilename) 
  return 
end 
 
yld = zeros(size(sd)); 
for i = 1:length(sd(:)) 
 
d = []; 
if checkrng(str2mat('sd','lcd','cpn','per'),[sd(i),lcd(i),cpn(i),per(i)],... 
            [id(i) fd(i) 0 0],[fd(i) md(i) inf inf],... 
            str2mat('id','fd','0','0'),... 
            str2mat('fd','md','inf','inf'),['e';'e';'e';'l'],... 
            ['e';'e';'l';'l'],mfilename) 
  return 
end 
if checktyp('per',per(i),'int',mfilename);return;end 

end   % end for loop

yld = bndyield(price,cpn,sd,md,per,basis,[],id,fd,lcd,[],rv);