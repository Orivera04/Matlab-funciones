function [d,md] = cfdur(cf,yld) 
%CFDUR  Cash flow duration and modified duration. 
%   [D,MD] = CFDUR(CF,YLD) calculates the duration D and modified duration 
%   (volatility) MD of a cash flow given the cash flow, CF, and the periodic  
%   yield, YLD.  
% 
%   For example, nine payments of $2.50 and a final payment of $102.50 with
%   a yield of 2.5% returns a duration of 8.97 periods and a modified duration
%   of 8.75 periods. 
% 
%   See also BONDCONV, BONDDUR, CFCONV. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:54:56 $ 
 
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
d = pv;md = pv; 
m = length(cf(:,1)); 
fac = (1:m)'; 
for loop = 1:colcf 
  rates = (ones(m,1)*(1+yld(loop))).^fac;           % Compound the yield 
  pv(loop) = pvvar([0;cf(:,loop)],yld(loop));       % find the net present value 
  d(loop) = sum(cf(:,loop)./(rates).*fac)/pv(loop); % duration 
  md(loop) = d(loop)/(1+yld(loop));                 % modified duration 
end
