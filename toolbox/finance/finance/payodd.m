function p = payodd(rate,nper,pv,fv,dys)
%PAYODD Payment of annuity with odd first period.
%   P = PAYODD(RATE,NPER,PV,FV,DYS) returns the payment for an annuity with
%   with an odd first period. RATE is the periodic interest rate, NPER is 
%   the number of periods, PV is the present value, FV is the future value,
%   and DYS is the actual number of days until the first payment is made.  
%
%   For example, a 2 year loan for $4000 has an annual interest rate of 11%.
%   The first payment will be made in 36 days.  To find the monthly payment, 
%   p = payodd(.11/12,24,4000,0,36) returns p = 186.77. 
%
%   See also AMORTIZE, PAYADV, PAYPER.

%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:52:53 $

if nargin < 5
  error(sprintf('Missing one of RATE, NPER, PV, FV and DYS.'))
end
if length(nper) == 1
  nper = nper*ones(size(rate));
end
if length(pv) == 1
  pv = pv*ones(size(rate));
end
if length(fv) == 1
  fv = fv*ones(size(rate));
end
if length(dys) == 1
  dys = dys*ones(size(rate));
end
if (size(rate) == size(nper) & size(nper) == size(pv) & size(pv) == size(fv) ...
    & size(fv) == size(dys))

  p = zeros(size(rate));
  i = find(dys < 30); % Begin mode (short period)
  if ~isempty(i)
    num(i) = pv(i).*(1+rate(i).*dys(i)/30)+fv(i).*(rate(i)+1).^(-nper(i));
    den(i) = (1+rate(i)).*((1-(1+rate(i)).^(-nper(i)))./rate(i));
    p(i) = num(i)./den(i);
  end
  i = find(dys >= 30); % End mode (long period)
  if ~isempty(i)
    p(i) = payper(rate(i),nper(i),pv(i),fv(i),0) + ...
           payper(rate(i),nper(i),rate(i).*rem(dys(i)/30,1).*pv(i),0,0);
  end
else
  error('Dimensions of inputs are inconsistent.')
end
