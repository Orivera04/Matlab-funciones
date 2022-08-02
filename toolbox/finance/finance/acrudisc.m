function int = acrudisc(sd,md,rv,disc,per,basis)   
%ACRUDISC Accrued interest of discount security paying at maturity.   
%   INT = ACRUDISC(SD,MD,RV,DISC,PER,BASIS) returns the accrued interest of a   
%   discount security paid at maturity.  SD is the settlement date, MD is the   
%   maturity date, RV is the par value of the security, DISC is the discount   
%   rate of the security, PER is the number of coupon periods per year   
%   (default =2), and BASIS is the day-count basis: 
%   0 = actual/actual (default), 1 = 30/360, 2 = actual/360, 3 = actual/365.   
%   Enter dates as serial date numbers or date strings.   
%   
%   For example,    
%   
%   int = acrudisc('05/01/1992','07/15/1992',100, 0.1, 2, 0)   
%   
%   returns int = 2.0604.   
%   
%   See also ACRUBOND, YLDDISC, PRDISC, YLDMAT, PRMAT.   
%   
%   Reference: SIA Standard Securities Calculation Methods,   
%              Volumes I-II, 3rd Edition.   Formula D   
   
%       Author(s): C.F. Garvin, 2-23-95   
%       Copyright 1995-2002 The MathWorks, Inc.    
%       $Revision: 1.6 $   $Date: 2002/04/14 21:53:08 $   
   
if nargin < 4   
  error('Missing one of SD, MD, RV, and DISC.')   
end   
if nargin < 5   
  per = 2*ones(size(rv));   
end   
if nargin < 6   
  basis = zeros(size(rv));   
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
if length(per) == 1   
  per = per*ones(size(sd));   
end   
if length(basis) == 1   
  basis = basis*ones(size(sd));   
end   
if checksiz([size(sd);size(md);size(rv);size(disc);size(basis)],mfilename)   
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
   
a = reshape(daysdif(sd(:),md(:),basis(:)),size(rv));  % days from sd to md   
e = zeros(size(rv));                                   % days in coupon period   
i = find(basis == 0);   
l = length(i);   
if ~isempty(i)   
  e(i) = daysact(datemnth(md(i),-6*ones(l,1),zeros(l,1),zeros(l,1)),md(i));   
end   
i = find(basis == 1 | basis == 2);   
if ~isempty(i);e(i) = 360*ones(length(i),1)./per(i);end
i = find(basis == 3);   
if ~isempty(i);e(i) = 365*ones(length(i),1)./per(i);end   
   
int = a./e.*disc./per.*rv;                           % Formula D
