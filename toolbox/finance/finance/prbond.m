function [p,ai] = prbond(sd,md,rv,cpn,yld,per,basis) 
%PRBOND  Price of security with regular periodic interest payments. 
%   [P,AI] = PRBOND(SD,MD,RV,CPN,YLD,PER,BASIS) returns the price P and
%   accrued interest AI of a security with regular periodic interest payments.
%   SD is the settlement date, MD is the maturity date, RV is the par value,
%   CPN is the coupon rate, YLD is the yield, per is the number of coupon
%   periods per year (default = 2), and BASIS is the day-count basis:
%   0 = actual/actual (default), 1 = 30/360, 2 = actual/360, 3 = actual/365.
%   Enter dates as serial date numbers or date strings.  This function also
%   applies to zero-coupon bonds or pure discount securities by letting CPN = 0. 
% 
%   Using the following data, 
%   
%       SD = '02/01/1960'
%       MD = '01/01/1990'
%       RV = 1000
%       CPN = 0.08
%       YLD = 0.06
%       PER = 2
%       BASIS = 0
%       
%   [p,ai] = prbond(sd,md,rv,cpn,yld,per,basis)
%    
%   returns p = 1276.39 and ai = 6.81.
% 
%   See also YLDBOND, PRMAT, PRDISC. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formulas 6, 7. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.7 $ $Date: 2002/04/14 21:52:35 $ 
 
if nargin < 7 
  basis = 0; % Default day count is actual/actual 
end 
if nargin < 6 
  per = 2;   % Default number of periods is 2 
end 
if nargin < 5 
  error(sprintf('Missing one of SD, MD, RV, CPN, and YLD.')) 
end 
if any(any(basis ~= 0 & basis ~= 1 & basis ~= 2 & basis ~= 3)) 
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
if checksiz([size(sd);size(md);size(rv);size(cpn);size(yld);... 
             size(per);size(basis)],mfilename) 
  return 
end


p = zeros(size(sd)); 
ai = p; 
for i = 1:length(p(:)); 
 
if checkrng(str2mat('sd','md','cpn','yld','per'),... 
            [sd(i),md(i),cpn(i),yld(i),per(i)],... 
            [-inf sd(i) 0 0 0],[md(i) inf inf inf inf],... 
            str2mat('-inf','sd','0','0','0'),... 
            str2mat('md','inf','inf','inf','inf'),['l';'e';'e';'e';'l'],... 
            ['e';'l';'l';'l';'l'],mfilename) 
  return 
end 
if checktyp('per',per(i),'int',mfilename);return;end 

end

[p , ai] = bndprice(yld,cpn,sd,md,per,basis,[],[],[],[],[],rv);
 
