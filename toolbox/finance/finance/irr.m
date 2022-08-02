function r = irr(cf) 
%IRR   Internal rate of return. 
%   R = IRR(CF) calculates the internal rate of return for a series of 
%   periodic cash flows.  CF is the cash flow vector.  The first entry 
%   in CF is the initial investment.  If CF is entered as a matrix, 
%   each column of CF is treated as a separate cash flow. 
% 
%   Suppose an initial investment of $100,000 is made.  The following  
%   cash flow represents the yearly income realized by the investment. 
%  
%                  Year 1       $10,000 
%                  Year 2       $20,000 
%                  Year 3       $30,000 
%                  Year 4       $40,000 
%                  Year 5       $50,000 
% 
%   To calculate the internal rate of return on the investment, use 
%   r = irr([-100000 10000 20000 30000 40000 50000]) which returns r = 12%.  
%   If the cash flow payments were monthly, the resulting rate of 
%   return would be multiplied by 12 for the annual rate of return. 
% 
%   See also MIRR, XIRR.  
% 
%   Reference: Brealey and Myers.  Principles of Corporate Finance.
%              Chapter 5. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.8 $   $Date: 2002/04/14 21:53:53 $ 
 
if nargin < 1 
  error(sprintf('Missing CF.')) 
end 
 
[rowcf,colcf] = size(cf); 
if rowcf == 1 
  cf = cf(:); 
  colcf = 1; 
end 
 
for loop = 1:colcf 
  coeff = roots(fliplr(cf(:,loop)'));  % Find coeff's of cash flow polynomial 
  i = find(abs(imag(coeff)) < eps);    % Index of real coeff's 
  realcoeff = coeff(i);                % Real coeff's 
  rates = (1-realcoeff)./realcoeff;    % Solves for rates of return 
  rtmp = rates(find(rates > 0 & ...
	                 abs(imag(rates)) < 1e-6));  % Find rates that make sense
  if isempty(rtmp) 
    r(loop) = nan; 
  else 
    r(loop) = rtmp; 
  end 
end
