function pv = pvfix(rate,nper,p,fv,due) 
%PVFIX Present value with fixed periodic payments. 
%   P = PVFIX(RATE,NPER,P,FV,DUE) returns the present value of a series 
%   of equal payments.  RATE is the periodic interest rate, NPER is the 
%   number of periods, P is the periodic payment, FV is a payment received  
%   other than P in the last period, and DUE specifies whether the payments  
%   are made at the beginning (DUE = 1) or end (DUE = 0) of the period. 
%   The default arguments are FV = 0 and DUE = 0.   
% 
%   For example, a $200 payment is made monthly into a savings account 
%   earning 6%.  The payments are made at the end of the month for 5
%   years.  To calculate the present value of these payments, use 
%   pv = pvfix(.06/12,5*12,200,0,0) which returns pv = 10345.11. 
%      
%   See also FVFIX, FVVAR , PVVAR, PAYPER.  
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:53:32 $ 
 
if nargin < 3 
  error('Missing one of RATE, NPER, and P.') 
end 
if nargin < 5 
  due = zeros(size(p)); 
end 
if nargin < 4 
  fv = zeros(size(p)); 
end 
if any(any(due ~= 0 & due ~= 1)) 
  error(sprintf('DUE must be 0 or 1.')) 
end 
 
c = 1+rate; 
pv = (p.*(1+rate.*due).*(c.^nper-1)./rate+fv)./c.^nper;
