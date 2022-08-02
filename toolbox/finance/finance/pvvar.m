function pv = pvvar(cf,rate,df) 
%PVVAR  Present value of varying cash flow. 
%   PV = PVVAR(CF,RATE,DF) returns the net present value, PV, of a cash 
%   flow, CF, given the periodic interest rate, RATE.  Include the   
%   initial investment as the initial cash flow value.   
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
%   To calculate the net present value of the periodic cash flow, use 
%   pv = pvvar([-10000 2000 1500 3000 3800 5000],.08)  
%   which returns pv = 1715.39. 
% 
%   An investment of $10,000 returns the following series of cash flows. 
%   Note that the original investment payment is included as the first 
%   cash flow value. 
% 
%            Cash Flow            Dates 
%              -10000           January 12, 1987 
%                2500           February 14, 1988 
%                2000           March 3, 1988 
%                3000           June 14, 1988 
%                4000           December 1, 1988 
% 
%   The variables CF and DF are defined as follows and the discount rate is 9%. 
% 
%         cf = [-10000,2500,2000,3000,4000]; 
%         df = ['01/12/1987'
%               '02/14/1988'
%               '03/03/1988'
%               '06/14/1988'
%               '12/01/1988'];
% 
%   The net present value of the cash flow is pv = pvvar(cf,.09,df) or 
%   pv = 142.16. 
% 
%   See also PVFIX, FVVAR, IRR, FVVAR, PAYUNI. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:53:35 $ 
 
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
   
if nargin == 3 
  if isstr(df), df = datenum(df);end 
  if checksiz([size(cf);size(df)],mfilename);return;end 
  df = reshape(df,size(cf)); 
end 
 
pv = zeros(1,colcf); 
for loop = 1:colcf 
  if nargin < 3 
    tf = 0:length(cf(:,loop))-1; 
  else 
    if isstr(df) 
      df = datenum(df); 
    end 
    n = length(df(:,loop));                                 % Length of date 
    f = floor(yearfrac(df(1,loop),df(n,loop)));%Number years from df(1) to df(n) 
    if f == 0; 
      f = 1; 
    end 
    tf = f*(df(:,loop)-df(1,loop))/(datemnth(df(1,loop),12*f,0,0)-df(1,loop)); 
    tf = tf(1:n); 
  end 
  pv(loop) = sum(cf(:,loop)./(1+rate(loop)).^tf(:));             % Present value 
 
end  % End for loop
