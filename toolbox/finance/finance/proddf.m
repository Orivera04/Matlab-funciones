function [p,ai] = proddf(sd,md,id,fd,rv,cpn,yld,per,basis) 
%PRODDF Price with odd first period. 
%   [P,AI] = PRODDF(SD,MD,ID,FD,RV,CPN,YLD,PER,BASIS) returns the price P 
%   and accrued interest AI of a security with an odd first period and the
%   settlement date in the first period.  SD is the settlement date, MD is
%   the maturity date, ID is the issue date, FD is the first coupon date,
%   RV is the par value, CPN is the coupon rate, YLD is the yield, PER is 
%   the number of coupon periods per year (default = 2), and BASIS is the
%   day-count basis: 0 = actual/actual (default), 1 = 30/360, 2 = actual/360,
%   3 = actual/365.  Enter dates as serial date numbers or date strings. 
% 
%   Using the following data,  
% 
%      SD = '11/11/1992'
%      MD = '03/01/2005'
%      ID = '10/15/1992'
%      FD = '03/01/1993'
%      RV = 100
%      CPN = 0.0785
%      YLD = 0.0625
%      PER = 2
%      BASIS = 0
%       
%   [p,ai] = proddf(sd,md,id,fd,rv,cpn,yld,per,basis)
%       
%   returns p = 113.60 and ai = 0.59
% 
%   See also PRODDFL, PRODDL, PRBOND, YLDODDF. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formulas 8, 9. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.7 $   $Date: 2002/04/14 21:53:20 $ 
 
if nargin < 9 
  basis = 0; 
end 
if nargin < 8  
  per = 2; 
end 
if nargin < 7 
  error('Missing one of SD, MD, ID, FD, RV, CPN, YLD, PER, and BASIS.') 
end 
if any(any(basis ~= 0 & basis ~= 1 & basis ~= 2 & basis ~= 3)) 
  error(sprintf('Invalid day count basis specified.')) 
end 
if any(any(isstr(sd) | isstr(md) | isstr(id) | isstr(fd))) 
  sd = datenum(sd); 
  md = datenum(md); 
  id = datenum(id); 
  fd = datenum(fd); 
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
if length(rv) == 1 
  rv = rv*ones(size(sd)); 
end 
if length(cpn) == 1 
  cpn = cpn*ones(size(sd)); 
end 
if length(yld) == 1 
  yld = yld*ones(size(sd)); 
end 
if length(per) == 1 
  per = per*ones(size(sd)); 
end 
if length(basis) == 1 
  basis = basis*ones(size(sd)); 
end 
if checksiz([size(sd);size(md);size(id);size(fd);size(rv);size(cpn);... 
             size(yld);size(per);size(basis)],mfilename) 
  return 
end 
 
p = zeros(size(sd)); 
ai = p; 
for i = 1:length(sd(:)); 
 
if checkrng(str2mat('sd','md','cpn','yld','per'),... 
            [sd(i),md(i),cpn(i),yld(i),per(i)],... 
            [id(i) fd(i) 0 0 0],[fd(i) inf inf inf inf],... 
            str2mat('id','fd','0','0','0'),... 
            str2mat('fd','inf','inf','inf','inf'),['e';'e';'e';'e';'l'],... 
            ['e';'l';'l';'l';'l'],mfilename) 
  return 
end 
if checktyp('per',per(i),'int',mfilename);return;end

end  % End for loop

[p,ai] = bndprice(yld,cpn,sd,md,per,basis,[],id,fd,[],[],rv);
