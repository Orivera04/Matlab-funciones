function [d,m] = bonddur(sd,md,rv,cpn,yld,per,basis) 
%BONDDUR Macaulay and modified durations. 
%   [D,M] =  BONDDUR(SD,MD,RV,CPN,YLD,PER,BASIS) finds the Macaulay duration d
%   and modified duration m in years for a security with periodic interest
%   payments.  SD is the settlement date, MD is the maturity date, CPN is the
%   coupon rate, YLD is the yield, PER is the number of periods per year
%   (default = 2), and BASIS is the day-count basis: 0 = actual/actual (default),
%   1 = 30/360, 2 = actual/360, 3 = actual/365.  Enter dates as serial date
%   numbers or date strings.
%       
%   For example, given this data:
%       
%       settlement date 01-Dec-1994
%       maturity date 01-Jan-2000
%       par value $100.00
%       coupon rate 5%
%       yield 4.34%
%       periods semi-annual
%       basis actual/actual
%       
%   [d,m] = bonddur('12/1/1994','1/1/2000',100,0.05,0.0434,2,0)
%       
%   returns a Macaulay duration d = 4.4720 years and a modified
%   duration m = 4.3770 years. 
% 
%   See also BONDCONV, CFDUR, CFCONV, BNDDURY.
% 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.9 $   $Date: 2002/04/14 21:55:35 $ 
 
 % Checking the input arguments
 
if nargin < 7 
  basis = 0;
end 

if nargin < 6 
  per = 2;
end 

if nargin < 5 
  error('Missing one of SD, MD, RV, CPN, and YLD.') 
end 

% Calculate the Macaulay and modified durations
[m, d] = bnddury(yld, cpn,sd, md, per, basis, [], [],[], [], [], rv);