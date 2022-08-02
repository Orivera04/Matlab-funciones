function us = payuni(cf,rate)
%PAYUNI Uniform payment equal to varying cash flow.
%   US = PAYUNI(CF,RATE) returns the uniform series value, US, of
%   a cash flow, CF, given the periodic interest rate, RATE.  Include  
%   the initial investment as the initial cash flow value.
%
%   Suppose an initial investment of $10,000 is made.  The following 
%   cash flow represents the yearly income realized by the investment.
%   The annual discount rate is 8%.
%
%               Year 1       $2000
%               Year 2       $1500
%               Year 3       $3000
%               Year 4       $3800
%               Year 5       $5000
%
%   To calculate the uniform series value, use
%   us = payuni([-10000 2000 1500 3000 3800 5000],.08) 
%   which returns us = 429.63.  
%
%   See also PVFIX, FVFIX, IRR, PVVAR, FVVAR.

%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:53:11 $

if nargin < 2
  error('Missing one of CF and RATE.')
end
[rowcf,colcf] = size(cf);
if rowcf == 1
  cf = cf(:);
  colcf = 1;
end
if colcf > 1
  if length(rate) == 1
    rate = rate*ones(1,colcf);
  end
end

pv = zeros(1,colcf);
for loop = 1:colcf
  len = length(cf(:,loop));
  n = (1:len)';
  pv(loop) = pvvar(cf(:,loop),rate(loop));                      %Present val
  us(loop) = pv(loop)*rate(loop)/(1-(1+rate(loop))^(-(len-1))); %Uniform series
end  
