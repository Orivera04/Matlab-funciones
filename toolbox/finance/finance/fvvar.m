function fv = fvvar(cf,rate,df) 
%FVVAR  Future value of varying cash flow. 
%   FV = FVVAR(CF,RATE,DF) returns the future value, FV, of a varying 
%   cash flow payments, CF, given the periodic interest rate, RATE.   
%   FV is the future value of the cash flow.  Include the initial 
%   investment as the initial cash flow value.  For non-periodic  
%   cash flows, DF is the vector dates at which the cash flows occur. 
% 
%   Suppose an initial investment of $10,000 is made.  The following  
%   cash flow represents the yearly income realized by the investment. 
%   The annual discount rate is 8%. 
% 
%                 Year 1       $2000 
%                 Year 2       $1500 
%                 Year 3       $3000 
%                 Year 4       $3800 
%                 Year 5       $5000 
% 
%   To calculate the future value of this periodic cash flow, use  
%   fv = fvvar([-10000 2000 1500 3000 3800 5000],.08)  
%   which returns fv = 2722.10.   
% 
%   An investment of $10,000 returns the following series of cash flows. 
%   Note that the original investment payment is included as the first 
%   cash flow value. 
% 
%                Cash Flow            Dates 
%                 -10000           January 12, 1987 
%                   2500           February 14, 1988 
%                   2000           March 3, 1988 
%                   3000           June 14, 1988 
%                   4000           December 1, 1988 
% 
%   The variables CF and DF are defined as follows and the discount rate is 9%.  
% 
%   cf = [-10000,2500,2000,3000,4000]; 
%          df = ['01/12/1987'
%                '02/14/1988'
%                '03/03/1988'
%                '06/14/1988'
%                '12/01/1988'];
% 
%   The future value of the cash flow is fv = fvvar(cf,.09,df) or pv = 167.28. 
%     
%   See also PVFIX, FVFIX, IRR, PVVAR, PAYUNI. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.7 $   $Date: 2002/04/14 21:56:29 $ 
 
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
fv = pv; 
for loop = 1:colcf 
 
  if nargin == 3                             % Non-periodic cash flow 
    n = length(df(:,loop));                                % Length of date 
    f = floor(yearfrac(df(1,loop),df(n,loop)));% # of years from df(1) to df(n) 
    if f == 0; 
      f = 1; 
    end 
    % Fractional date numbers 
    tf = f*(df(:,loop)-df(1,loop))/(datemnth(df(1,loop),12*f,0,0)-df(1,loop));  
    tf = tf(1:n); 
    pv(loop) = sum(cf(:,loop)./(1+rate(loop)).^tf(:));   % Present value 
    fv(loop) = pv(loop)*(1+rate(loop))^max(tf(:));       % Future value 
  else                                                   % Periodic cash flow 
    len = length(cf(:,loop)); 
    pv(loop) = pvvar(cf(:,loop),rate(loop)); 
    fv(loop) = pv(loop)*(1+rate(loop))^(len-1); 
  end 
 
end % End for loop
