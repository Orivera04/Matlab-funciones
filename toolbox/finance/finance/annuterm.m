function nper = annuterm(rate,p,pv,fv,due)  
%ANNUTERM Number of periods to obtain value.  
%   NPER = ANNUTERM(RATE,P,PV,FV,DUE) calculates the number of periods needed   
%   to obtain a future value.  RATE is the periodic interest rate, P is the  
%   periodic payment, PV is the present value, FV is the future value, and DUE  
%   specifies whether the payments are made at the beginning (due = 1) or   
%   end (due = 0) of the period.  The default values are fv = 0 and due = 0.
%   To calculate the number of periods needed to pay off a loan, enter the 
%   payment or the present value as a negative value.   
%  
%   For example, a savings account has a starting balance of $1500.  $200 is    
%   added at the end of each month and the account pays 9% interest, compounded   
%   monthly.  How many years will it take to save $5,000?  Using the command       
%  
%        nper = annuterm(.09/12,200,1500,5000,0)  
%         
%   returns nper = 15.68 which is 15.68 months or 1.31 years.   
%   To calculate the number of periods needed to pay off a loan, enter the 
%   payment or the present value as a negative value.  
%  
%   See also PVFIX, FVFIX, ANNURATE, AMORTIZE.  
  
%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
%       $Revision: 1.6 $   $Date: 2002/04/14 21:52:56 $  
  
if nargin < 3  
  error(sprintf('Missing one of RATE, P, and PV.'))  
end  
if nargin < 5  
  due = zeros(size(p)); % Payments made at end of period  
end   
if nargin < 4  
  fv = zeros(size(p)); % Default present initial value is 0.  
end   
sz = [size(rate);size(p);size(pv);size(fv);size(due)];  
if length(rate) == 1  
  rate = rate*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if length(p) == 1  
  p = p*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if length(pv) == 1  
  pv = pv*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if length(fv) == 1  
  fv = fv*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if length(due) == 1  
  due = due*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if checksiz([size(rate);size(p);size(pv);size(fv);size(due)],mfilename)  
  return  
end  
if any(any(due ~= 0 & due ~= 1))  
  error(sprintf('DUE must be 0 or 1.'))  
end  
if ~all(rate >= 0)  
  error(sprintf('Enter RATE >= 0.'))  
end  
  
c = 1+rate;  
nper = zeros(size(p));  
i = find(due == 0);  
if ~isempty(i)  
  nper(i) = (log((fv(i)-fv(i).*c(i)-p(i))./(pv(i)-pv(i).*...  
             c(i)-p(i))))./log(c(i));  
end  
i = find(due == 1);  
if ~isempty(i)  
  nper(i) = (log((fv(i)-fv(i).*c(i)-p(i).*c(i))...  
            ./(pv(i)-pv(i).*c(i)-p(i).*c(i))))./log(c(i));  
end
