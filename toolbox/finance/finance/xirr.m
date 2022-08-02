function yld = xirr(cf,df,guess,maxiter) 
%XIRR  Internal rate of return for nonperiodic cash flow. 
%   YLD = XIRR(CF,DF,GUESS,MAXITER) returns the internal rate of return  
%   for a nonperiodic schedule of cash flows.  CF is the cash flow data,  
%   DF is the corresponding date data, and GUESS is an initial estimate  
%   of the expected return.  MAXITER specifies the number of
%   iterations used by Newton's method to solve for YLD.  By default,
%   guess = 0.1 and MAXITER = 50.  Include the initial investment as the
%   initial cash flow value (a negative number) in cf.  Enter dates in df
%   as serial date numbers or date strings. 
% 
%   An investment of $10,000 returns the following series of cash flows. 
%   Note that the original investment payment is included as the first 
%   cash flow value. 
% 
%              Cash Flow              Dates 
%               -10000           January 12, 1987 
%                 2500           February 14, 1988 
%                 2000           March 3, 1988 
%                 3000           June 14, 1988 
%                 4000           December 1, 1988 
% 
%   The variables CF and DF are defined as follows. 
% 
%         cf = [-10000,2500,2000,3000,4000]; 
%         df = ['01/12/1987'
%               '02/14/1988'
%               '03/03/1988'
%               '06/14/1988'
%               '12/01/1988'];
%  
%   The internal rate of return is yld = xirr(cf,df) or yld = 0.1006 
%   which is 10.06%. 
% 
%   See also IRR, MIRR, PVVAR. 
% 
%   Reference: Sharpe and Alexander, Investments, 4th edition, page 463. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.10 $   $Date: 2002/04/14 21:53:41 $ 
  
 
if nargin < 2 
  error(sprintf('Missing one of CF and DF data.')) 
end 
if nargin < 3 
  yld = .1;                            % Default initial estimate of yield 
else 
  yld = guess; 
end 
if nargin < 4 
  maxiter = 50;                      % Default maximum iterations 
end 
 
if isstr(df) 
  df = datenum(df); 
  df = reshape(df,size(cf)); 
end 
[rowcf,colcf] = size(cf); 
[rowdf,coldf] = size(df); 
if rowcf ~= rowdf | colcf ~= coldf 
  error(sprintf('CF and DF must have same dimensions.')) 
end 
if rowcf == 1                               % If inputs are row vectors, 
  cf = cf(:);                               % flip them. 
  df = df(:); 
  colcf = 1; 
end 
if colcf > 1 
  if length(yld) == 1 
    yld = yld*ones(1,colcf); 
  end 
  if length(maxiter) == 1 
    maxiter = maxiter*ones(1,colcf); 
  end 
end 
 
for loop = 1:colcf 
 
n = length(df(:,loop));                          % Number of cash flows  
f = floor(yearfrac(df(1,loop),df(n,loop)));      % Number of years in cash flow 
if f == 0 
  f = 1; 
end 
% Convert df to fractions 
tf = f*(df(:,loop)-df(1,loop))/(datemnth(df(1,loop),12*f,0,0)-df(1,loop)); 
f = 2;                                        % Initialize loop parameters 
k = 1; 
 
while abs(f) > 1e-6                           % Newton's method 
  f = sum(cf(:,loop)./(1+yld(loop)).^tf);       % Cash flow polynomial 
  fp = sum(-cf(:,loop)./((1+yld(loop)).^tf).*tf/(1+yld(loop)));%(CF poly)' 
  if fp == 0 
    disp(char(7)) 
    fprintf('Unable to find internal rate of return.') 
    yld(loop) = nan; 
    break; 
  end 
  del = -f/fp; 
  yld(loop) = yld(loop)+del; 
  k = k+1;                                      % Increment iteration count 
  if k == maxiter+1 
    disp(char(7)) 
    fprintf(['Number of maximum iterations reached.\n',... 
                   'Please increase MAXITER or use different GUESS.\n']) 
    yld(loop) = nan; 
    break; 
  end 
end 
 
end  % End for loop
