function cx = cfconv(cf,yld) 
%CFCONV Cash flow convexity. 
%   CX = CFCONV(CF,YLD) calculates the convexity C of a cash flow 
%   given the cash flow, CF, and the periodic yield, YLD. 
% 
%   For example, nine payments of $2.50 and a final payment of $102.50  
%   with a yield of 2.5% returns a convexity of 90.45 periods.   
% 
%   See also BONDCONV, BONDDUR, CFDUR. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:55:38 $ 
 
if nargin < 2 
  error('Missing one of CF and YLD.') 
end 
[rowcf,colcf] = size(cf); 
if rowcf == 1 
  cf = cf(:); 
  colcf = 1; 
end 
if colcf > 1 
  if length(yld) == 1 
    yld = yld*ones(1,colcf); 
  end 
end 
 
pv = zeros(1,colcf); 
cx = pv; 
m = length(cf(:,1)); 
fac = (1:m)'; 
for loop = 1:colcf 
  rates = (ones(m,1)*(1+yld(loop))).^fac;                % Compound the yield 
  pv(loop) = pvvar([0;cf(:,loop)],yld(loop));      % find the net present value 
  cx(loop) = sum(cf(:,loop)./(rates).*fac.*(fac+1))/((1+yld(loop))^2*pv(loop)); 
end
