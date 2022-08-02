function [prinp,intp,bal,p] = amortize(rate,nper,pv,fv,due)  
%AMORTIZE Amortization.  
%   [PRINP,INTP,BAL,P] = AMORTIZE(RATE,NPER,PV,FV,DUE) returns the principal   
%   and interest portions of a loan paid by a periodic payment and computes 
%   the remaining balance of the original loan amount and the periodic payment. 
%   RATE is the periodic interest rate charged, NPER is number of payment 
%   periods, PV is the present value of the loan, FV is the future value of the  
%   loan, and DUE specifies whether the payments are made at the beginning 
%   (due = 1) or end (due = 0) of the period.  By default, fv = 0 and due = 0. 
%   prinp is a vector of the principal paid in each period, intp is a vector 
%   of the interest paid in each period, bal is the remaining balance of the  
%   loan in each payment period, and p is the periodic payment calculated by  
%   the payment function.  The outputs prinp, intp, and bal are 1-by-nper  
%   vectors and p is a scalar value.  
% 
%   For example, find the values for a $500 loan paid in six installments at an  
%   annual interest rate of 9%:  
%         
%       [prinp, intp, bal, p] = amortize(0.09/6, 6, 500)  
%         
%       returns  
%         
%       prinp = [80.26 81.47 82.69 83.93 85.19 86.47]  
%       intp  = [7.50 6.30 5.07 3.83 2.57 1.30]  
%       bal   = [419.74 338.27 255.58 171.65 86.47 0.00]  
%       p     = 87.76  
%    
%   See also PAYPER, PAYADV, PAYODD, ANNUTERM, ANNURATE.  
  
%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
%       $Revision: 1.7 $   $Date: 2002/04/14 21:54:59 $  
  
if nargin < 5  
  due = 0; % Default time of payment  
end   
if nargin < 4  
  fv = 0; % Default future value  
end  
if nargin < 3  
  error(sprintf('Missing one of RATE, NPER, and PV.'))  
end  
if rate < 0  
  error(sprintf('RATE must be >= 0.'))  
end  
  
p = payper(rate,nper,pv,fv,due);                   % Calculate monthly payment  
  
% Function only takes one set of scalar inputs at a time  
% due to possible different 1:nper lengths and fact that outputs are vectors.  
c = 1+rate;
n = 0:nper;
if due == 0                                         % End of month payment
  AllBal = pv*c.^n-p*(1-c.^n)/(1-c);                % Compute remaining balance  
  intp = abs(AllBal(1:end-1)*rate);                 % Compute interest paid  
  bal = AllBal(2:end);
else                                                % Beginning of month payment  
  AllBal = pv*c.^n-p*(1-c.^(n+1))/(1-c);            % Compute remaining balance
  intp = [0 abs(AllBal(1:end-2)*rate)];             % Compute interest paid
  bal = AllBal(1:end-1);
end  
prinp = abs(p)-intp;                                % Compute principal paid
