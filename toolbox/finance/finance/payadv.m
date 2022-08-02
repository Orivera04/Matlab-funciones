function p = payadv(rate,nper,pv,fv,adv)
%PAYADV Periodic payment given number of advance payments.
%   P = PAYADV(RATE,NPER,PV,FV,ADV) returns the periodic payment given a
%   number of advance payments.  RATE is the lending or borrowing rate per 
%   period, NPER is the number of periods in the life of the instrument,
%   PV is the present value, FV is the future value or target value to be 
%   attained after NPER periods, and ADV is the number of advance payments. 
%   If the payments are made at the beginning of the period, add 1 to ADV.
%
%   For example, the present value of a loan is $1000.00 and it will
%   be paid in full in 12 months.  The annual interest rate is 10% 
%   and 3 payments are made at closing time.  Using this data,
%   p = payadv(.1/12,12,1000,0,3) returns p = 85.94.
%
%   See also AMORTIZE, PAYPER, PAYODD.

%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:52:50 $

if nargin < 5
  error(sprintf('Missing one of PV, FV, RATE, NPER, and ADV.'))
end
if rate < 0
  error(sprintf('RATE must be >= 0.'))
end

c = 1+rate;
p = (pv+fv.*c.^(-nper))./((1-c.^(adv-nper))./rate+adv);
