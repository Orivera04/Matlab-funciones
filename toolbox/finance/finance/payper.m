function p = payper(rate,nper,pv,fv,due)
%PAYPER Periodic payment of loan or annuity.
%   P = PAYPER(RATE,NPER,PV,FV,DUE) returns the periodic payment of a loan
%   or an annuity.  RATE is the periodic interest rate, NPER is the number 
%   of payment periods, PV is the present value, FV is the future value or
%   remaining balance after NPER, and DUE specifies whether the payments 
%   are made at the beginning (DUE = 1) or end (DUE = 0) of the period.
%   By default, FV = 0 and DUE = 0.
%
%   For example, the payment for a 3 year loan of $9000 with an 
%   annual interest rate of 11.75% is calculated with 
%   p = payper(.1175/12,36,9000,0,0) which returns p = 297.86.  
%
%   See also AMORTIZE, PAYADV, PAYODD, FVFIX, PVFIX .     

%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:52:47 $

% Set default inputs if necessary
if nargin < 5
  due = 0;
end
if nargin < 4
  fv = 0;
end
if nargin < 3
  error('Missing one of RATE, NPER, and PV.')
end
sz = [size(rate);size(nper);size(pv);size(fv);size(due)];
if length(rate) == 1
  rate = rate*ones(max(sz(:,1)),max(sz(:,2)));
end
if length(nper) == 1
  nper = nper*ones(max(sz(:,1)),max(sz(:,2)));
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
if checksiz([size(rate);size(nper);size(pv);size(fv);size(due)],mfilename)
  return
end
if any(any(due ~= 0 & due ~= 1))
  error(sprintf('DUE must be 0 or 1.'))
end

p = zeros(size(rate));
c = 1+rate;
i = find(due==0);
if ~isempty(i)
  p(i) = (fv(i)+pv(i).*c(i).^nper(i)) .* (-rate(i)) ./ (1-c(i).^nper(i));
end
i = find(due==1);
if ~isempty(i)
  p(i) = (fv(i)+pv(i).*c(i).^nper(i)) ./ ...
         (c(i).^nper(i)+(1-c(i).^nper(i))./(-rate(i))-1);
end
