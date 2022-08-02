function f = fvfix2(rate,nper,p,pv,due) 
%FVFIX  Future value with fixed periodic payments. 
%   F = FVFIX(RATE,NPER,P,PV,DUE) returns the future value of a series of  
%   equal payments.  RATE is the periodic interest rate, NPER is the number 
%   of periods, P is the periodic payment, PV is the initial value, and DUE
%   specifies whether the payments are made at the beginning (DUE = 1)  
%   or end (DUE = 0) of the period.  By default, DUE = 0 and PV = 0. 
% 
%   For example, a savings account has a starting balance of $1500.   
%   $200 is added at the end of each month for 10 years and the 
%   account pays 9% interest compounded monthly.  Using this data,
%   f = fvfix(.09/12,12*10,200,1500,0) 
%   returns f = 42379.89. 
% 
%   See also PVFIX, PVVAR, FVVAR. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2003 The MathWorks, Inc.
%       $Revision: 1.6.2.2 $   $Date: 2004/04/06 01:06:53 $ 


if nargin < 3 
  error('Finance:fvfix:NotEnoughInputs', ...
  sprintf('Missing one of RATE, NPER, and P.')) 
end 
if nargin < 4 
  pv = zeros(size(p)); % Default present initial value is 0. 
end  
if nargin < 5 
  due = zeros(size(p)); % Payments made at end of period 
end  
if any(any(due ~= 0 & due ~= 1)) 
  error('Finance:fvfix:InvalidDue', ...
  sprintf('DUE must be 0 or 1.')) 
end 
if length(nper) == 1             % Resize inputs to match rate if necessary 
  nper = nper*ones(size(rate)); 
end 
if length(p) == 1 
  p = p*ones(size(rate)); 
end 
if length(pv) == 1 
  pv = pv*ones(size(rate)); 
end 
if length(due) == 1 
  due = due*ones(size(rate)); 
end 
if length(rate) == 1 
  rate = rate*ones(size(nper)); 
end 
 
if (size(rate) == size(nper) & size(nper) == size(p) & size(p) == size(pv) &... 
   size(pv) == size(due)) 
 
  f = zeros(size(p)); 
  c = 1+rate; 
  i = find(due == 0); 
  if ~isempty(i) 
    f(i) = pv(i).*c(i).^nper(i)+p(i).*(1-c(i).^nper(i))./(1-c(i)); 
  end 
  i = find(due == 1); 
  if ~isempty(i) 
    f(i) = (pv(i)+p(i)).*c(i).^nper(i)+p(i).*(1-c(i).^nper(i))./(1-c(i))-p(i); 
  end 
else 
  error('Finance:fvfix:InvalidDimensions', ...
  'Dimensions of inputs are inconsistent.') 
end


% [EOF]
