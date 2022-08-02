function [y,n] = beytbill(sd,md,disc)  
%BEYTBILL Bond equivalent yield for treasury bill.  
%   Y = BEYTBILL(SD,MD,DISC) returns the bond equivalent yield for a Treasury
%   bill. SD is the settlement date, MD is the maturity date, and DISC is the
%   discount rate. Enter the settlement and maturity dates as serial date
%   numbers or date strings.  The number of days to maturity is typically
%   quoted as md - sd - 1.  NaN (Not-a-Number) is returned for all cases in 
%   which negative prices are implied by the discount rate DISC and the number
%   of days between settlement and maturity.
%  
%   For example, the settlement date of a Treasury bill is February 10, 1992,
%   the maturity date is August 6, 1992, and the discount rate is 3.77%.  
%   Computing the bond equivalent yield:  
%         
%        y = beytbill('2/10/1992', '8/6/1992', 0.0377)  
%     
%        returns y = 0.0389
%  
%   See also PRTBILL, YLDTBILL.  
%

%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
%       $Revision: 1.9 $   $Date: 2002/04/14 21:52:59 $  
  
% The bond equivalent yield satisfies one of two formulas, depending on the
% number of days, n, left to maturity.  Compute n as md - sd - 1.
% Given Price P, Face F, and yield to maturity y:
% Case 1: n <= 182
%   P = F * 1/( 1 + y/2 * (2*n/365) )
% Case 2: 182 < n <= 365
%   P = F * 1/( 1 + y/2 ) * 1/( 1 + y/2 *(2*n/365 - 1) )
%
% See Stigum & Robinson, "Money Market & Bond Calculations", Irwin
% Pages 104-105 and P = F( 1 - disc*n/360 )
  
if nargin < 3  
  error(sprintf('Missing one of SD, MD, and DISC.'))  
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
if length(disc) == 1  
  disc = disc*ones(size(sd));  
end  
if checksiz([size(sd);size(md);size(disc)],mfilename)  
  y = nan;  
  return  
end  
tmp = inf;  
infpad = tmp(ones(1,length(sd(:))),1);  
if checkrng(['sd  ';'disc'],[sd(:),disc(:)],[-infpad,zeros(size(sd(:)))],...  
            [md(:),infpad],['-inf';'0   '],['md ';'inf'],['l';'e'],...  
            ['e';'l'],mfilename)  
  y = nan;  
  return  
end  
              
% Find actual days between settlement and maturity and subtract 1
n      = daysact(sd , md) - 1;

% Build masks for the two cases
Case1 = ( n <= 182 );
Case2 = ~ Case1;

y = zeros(size(n));

% Compute Case1
y(Case1) = 365*disc(Case1)./( 360 - disc(Case1).*n(Case1) );

% Compute Case2 with intermediaries price, and t = n/365
price  = 1 - ( disc(Case2).*n(Case2)/360 );
t = n(Case2)/365;

y(Case2) = ( -2*t + 2*sqrt( t.^2 - (2*t - 1).*(1 - 1./price) ) ) ./ ...
    ( 2*t - 1 );

