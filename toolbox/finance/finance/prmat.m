function [p,ai] = prmat(sd,md,id,rv,cpn,yld,basis) 
%PRMAT  Price with interest at maturity. 
%   [P,AI] = PRMAT(SD,MD,ID,RV,CPN,YLD,BASIS) returns the price p and accrued
%   interest AI of a security that pays interest at maturity.  SD is the
%   settlement date, MD is the maturity date, ID is the issue date, RV is 
%   the par value, CPN is the coupon rate, YLD is the annual yield, and BASIS
%   is the day-count basis: 0 = actual/actual (default), 1 = 30/360,
%   2 = actual/360, 3 = actual/365.  Enter dates as serial date numbers or
%   date strings.  This function also applies to zero-coupon bonds or pure
%   discount securities by letting CPN = 0. 
% 
%   Using the following data, 
% 
%       SD = '02/07/1992'
%       MD = '04/13/1992'
%       id = '10/11/1991'
%       RV = 100
%       CPN = 0.0608
%       YLD = 0.0608
%       BASIS = 1
%       
%   [p,ai] = prmat(sd,md,id,rv,cpn,yld,basis)
%       
%   returns p = 99.98 and ai = 1.96
% 
%   See also YLDMAT, PRBOND, PRDISC. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formula 4. 
  
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.7 $   $Date: 2002/04/14 21:53:17 $ 
 
if nargin < 7 
  basis = zeros(size(rv)); 
end 
if nargin < 6 
  error(sprintf('Missing one of SD, MD, ID, RV, CPN, and YLD.')) 
end 
i = find(basis ~= 0 & basis ~= 1 & basis ~=2 & basis ~=3); 
if ~isempty(i) 
  error(sprintf('Invalid day count basis specified.')) 
end 
if any(any(isstr(sd) | isstr(md) | isstr(id))) 
  sd = datenum(sd); 
  md = datenum(md); 
  id = datenum(id); 
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
if length(id) == 1 
  id = id*ones(size(sd)); 
end 
if length(basis) == 1 
  basis = basis*ones(size(sd)); 
end 
if checksiz([size(sd);size(md);size(rv);size(cpn);size(yld);... 
             size(id);size(basis)],mfilename) 
  return 
end 
 
rl = length(sd(:)); 
tmp = inf; 
infpad = tmp(ones(1,rl),1); 
z = zeros(rl,1); 
if checkrng(str2mat('sd','md','cpn','yld'),[sd(:),md(:),cpn(:),yld(:)],... 
            [id(:) sd(:) z z],... 
            [md(:) infpad infpad infpad],str2mat('id','sd','0','0'),... 
            str2mat('md','inf','inf','inf'),['l';'e';'e';'e'],... 
            ['e';'l';'l';'l'],mfilename) 
  return 
end 
 
a = daysdif(id(:),sd(:),basis(:));                   % Days between id and sd 
dim = daysdif(id(:),md(:),basis(:));                 % Days between id and md 
dsm = daysdif(sd(:),md(:),basis(:));                 % Days between sd and md 
i = find(basis == 0);                                 % b = days in year 
if ~isempty(i);b(i) = daysact(datemnth(sd(i),-12,0,0),sd(i));end 
i = find(basis == 1 | basis == 2); 
if ~isempty(i);b(i) = 360*ones(size(i));end 
i = find(basis == 3); 
if ~isempty(i);b(i) = 365*ones(size(i));end 
 
b = b(:); 
ai = reshape(a./b.*cpn(:).*rv(:),size(rv));           % accrued interest 
p = reshape((rv(:)+(dim./b.*cpn(:).*rv(:)))./(1+(dsm./b.*yld(:)))-ai(:),... 
             size(rv));                               % Formula 4
