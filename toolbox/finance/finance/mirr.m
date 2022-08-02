function r = mirr(cf,srate,rrate) 
%MIRR Modified internal rate of return. 
%   R = MIRR(CF,SRATE,RRATE) calculates the modified internal rate of return 
%   for a series of periodic cash flows.  CF is the cash flow vector, SRATE is 
%   the finance rate for negative cash flow values, and RRATE is the 
%   reinvestment rate for positive cash flow values.  If CF is entered as a  
%   matrix, each column is treated as a separate cash flow.  SRATE and RRATE 
%   can be entered as row vectors where each column corresponds to a column
%   of CF or as scalar values applying the same rate to each cash flow. 
% 
%   Suppose an initial investment of $100,000 is made. The following
%   cash flow represents the yearly income realized by the investment.
%   The finance rate is 9% and the reinvestment rate is 12%. 
%  
%                 Year 1       $20,000 
%                 Year 2      ($10,000) 
%                 Year 3       $30,000 
%                 Year 4       $38,000 
%                 Year 5       $50,000 
% 
%   To calculate the modified internal rate of return on the investment, use  
% 
%       r = mirr([-100000 20000 -10000 30000 38000 50000],.09,.12)  
% 
%       which returns r = 8.32%.   
% 
%   See also IRR, PVVAR, ANNURATE, XIRR. 
% 
%   Reference: Brealey and Myers, Principles of Corporate Finance, 
%              Chapter 5.
 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:52:44 $ 
 
if nargin < 3 
  error('Missing one of CF, SRATE, and RRATE.') 
end 
if srate < 0 | rrate < 0 
  error(sprintf('Enter values of SRATE and RRATE >= 0.')) 
end 
[rowcf,colcf] = size(cf); 
if rowcf == 1 
  cf = cf(:); 
  colcf = 1; 
end 
if colcf > 1 
  if length(srate) == 1 
    srate = srate*ones(1,colcf); 
  end 
  if length(rrate) == 1 
    rrate = rrate*ones(1,colcf); 
  end 
end 
 
for loop = 1:colcf 
  cflow = cf(:,loop); 
  % Create separate negative and positive cash flows 
  neg = find(cflow > 0); 
  pos = find(cflow < 0); 
  cfn = cflow; 
  cfp = cflow; 
  cfn(neg) = zeros(size(neg));   
  cfp(pos) = zeros(size(pos)); 
 
  pvcfn = pvvar(cfn,srate(loop));        % PV of neg and pos cash flow 
  pvcfp = pvvar([0;cfp],rrate(loop))*(1+rrate(loop))^(length(cfp(:))); 
 
  r(loop) = annurate(length(cflow)-1,0,pvcfn,pvcfp,1); % ANNURATE solves for ror 
 
end  % End for loop
