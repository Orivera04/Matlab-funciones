function p = prdisc(sd,md,rv,disc,basis) 
%PRDISC Price of discounted security. 
%   P = PRDISC(SD,MD,RV,DISC,BASIS) returns the price of a discounted security
%   given the settlement date SD, the maturity date MD, redemption value RV,
%   discount rate DISC, and day-count basis.  For BASIS, 0 = actual/actual 
%   (default), 1 = 30/360, 2 = actual/360, 3 =a ctual/365.  Enter dates as
%   serial date numbers or date strings. 
% 
%   Using the following data, 
%   
%       SD = '10/14/1988'
%       MD = '03/17/1989'
%       RV = 100
%       disc = 0.087
%       basis = 2
%       
%   p = prdisc(sd,md,rv,disc,basis)
%       
%   returns p = 96.28
% 
%   See also PRBOND, PRMAT, YLDDISC. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formula 2. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:53:14 $ 
 
if nargin < 5 
  basis = zeros(size(rv)); % Default day count basis 
end 
if nargin < 4 
  error(sprintf('Missing one of SD, MD, RV, and DISC.')) 
end 
i = find(basis ~= 0 & basis ~= 1 & basis ~=2 & basis ~=3); 
if ~isempty(i) 
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
if length(disc) == 1 
  disc = disc*ones(size(sd)); 
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
 
dsm = daysdif(sd(:),md(:),basis(:));        % dms - days from sd to md  
i = find(basis == 0);                        % b = days in a year 
if ~isempty(i);b(i) = daysact(datemnth(md(i),-12,0,0),md(i));end 
i = find(basis == 1 | basis == 2); 
if ~isempty(i);b(i) = 360*ones(size(i));end 
i = find(basis == 3); 
if ~isempty(i);b(i) = 365*ones(size(i));end 
    
p = reshape(rv(:)-(disc(:).*rv(:).*dsm(:)./b(:)),size(rv)); % Formula 2
