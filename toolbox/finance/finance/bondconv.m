function [pc,yc] = bondconv(sd,md,rv,cpn,yld,per,basis) 
%BONDCONV Convexity. 
%   [PC,YC] = BONDCONV(SD,MD,RV,CPN,YLD,PER,BASIS) returns the convexity for a
%   security in periods pc and years yc.  SD is the settlement date, MD is the
%   maturity date, RV is the par value, CPN is the coupon rate, YLD is the
%   yield, PER is the number of periods per year (default =2), and BASIS is the
%   day-count basis: 0 = actual/actual (default), 1 = 30/360, 2 = actual/360,
%   3 = actual/365. Enter dates as serial date numbers or date strings.
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
%   [pc,yc] = bondconv('12/1/1994','1/1/2000',100,0.05,0.0434,2,0)
%       
%   returns pc = 92.13 periods and yc = 23.03 years.
% 
%   See also BONDDUR, CFCONV, CFDUR, BNDCONVY. 
% 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.8 $   $Date: 2002/04/14 21:55:32 $ 
 
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

[yc,pc] = bndconvy(yld, cpn,sd, md, per, basis, [], [],[], [], [], rv);