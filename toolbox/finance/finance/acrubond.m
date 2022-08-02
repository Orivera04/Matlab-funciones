function int = acrubond(id,sd,fd,rv,cpn,per,basis)  
%ACRUBOND Accrued interest of security with periodic interest payments.  
%   INT = ACRUBOND(ID,SD,FD,RV,CPN,PER,BASIS) returns the accrued interest for  
%   a security with periodic interest payments.  This function computes the  
%   accrued interest for securities with standard, short, and long first coupon  
%   periods.  ID is the issue date, SD is the settlement date, FD is the first  
%   coupon date, RV is the par value, CPN is the coupon rate, PER is the number 
%   of periods per year (default = 2), and BASIS is the day-count basis: 
%   0 = actual/actual (default), 1 = 30/360, 2 = actual/360, 3 = actual/365.
%   Enter dates as serial date numbers or date strings. 
%       
%   For example,   
%  
%   int = acrubond('31-jan-1983', '1-mar-1993', ...  
%                            '31-jul-1983', 100, 0.1, 2, 0)  
%   
%   returns  int = 0.8011.  
%  
%   See also ACRUDISC, CFAMOUNTS, ACCRFRAC  
%   
%   Note: cfamounts or accrfrac is recommended when calculating accrued 
%         interest beyond the first period.  
  
%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
%       $Revision: 1.9 $   $Date: 2002/04/14 21:53:05 $  
  
% Checking the input arguments

if nargin < 7 
  basis = 0;
end 

if nargin < 6 
  per = 2;
end 
  
if nargin < 5  
  error('Missing one of ID, SD, FD, RV, and CPN.')  
end

% Calculate the accrued interest
CFlowAmounts = cfamounts(cpn, sd, datemnth(max(datenum(fd), datenum(sd)), 12), per, basis,[], id, fd, [], [], rv);

int = abs(CFlowAmounts(:,1));
