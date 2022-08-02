function varargout = mbsnoprepay(varargin)
%MBSNOPREPAY End-of-month mortgage cash-flows.
%   The function returns amortizing cash flows and balances 
%   of NMBS funds over a specified term, with no prepayment.
%   When length of funds are not the same, MATLAB will pad
%   the shorter ones with NaNs (not-a-number).
%
% [Balance, Interest, Payment, Principal] = ....
%    mbsnoprepay(OriginalBalance, GrossRate, Term)
%
% Inputs:
%  OriginaBalance - NMBSx1 vector of Original Face 
%                   value in dollars. 
%
%      CouponRate - NMBSx1 vector of Gross Coupon Rate, 
%                   in decimal. 
%
%            Term - NMBSx1 vector of mortgage term,
%                   in months.
%
% Outputs: 
%         Balance - All end-of-month balances over 
%                   the life of the Passthrough.
%
%        Interest - All end-of-month interest payments 
%                   over the life of the Passthrough
%
%         Payment - All end-of-month payments 
%                   over the life of the Passthrough
%
%       Principal - All (scheduled) end-of-month principal 
%                   payments over the life of the 
%                   Passthrough
%
% Example:
% % Computing cash-flows and balances of a 3-month and 5-month
% % old mortgage pool with original term of 360 months:
%
% OriginalBalance = 400000000;
% CouponRate = 0.08125;
% Term = [357;355];
%
% [Balance, Interest, Payment, Principal] = ...
%     mbsnoprepay(OriginalBalance, CouponRate, Term);
%
% Note: Suppose the OriginalTerm is 360, and 
% the remaining is 355.5 months, 
% then the RemainingBalance will be 355 by 1 column vector, 
% indicating end-of-month balances in month 5 thru month 360. 
% This means also that we are past month 4 and currently in 
% month 5.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.7.6.3 $  $Date: 2004/04/06 01:08:54 $

if nargin < 3
  error('finfixed:mbsnoprepay:invalidInputs',['Not enough input, need at least OriginalBalance,', ...
          sprintf('\n'), ...
         ' GrossRate, and OriginalTerm'])
else
    OriginalBalance = varargin{1};
    if ischar(OriginalBalance)
       OriginalBalance = str2num(OriginalBalance)
    end
    
    GrossRate = varargin{2};
    if ischar(GrossRate)
        GrossRate = str2num(GrossRate)
    end
        
    OriginalTerm = varargin{3};
    if ischar(OriginalTerm)
        OriginalTerm = str2num(OriginalTerm)
    end
end

% expand the arguments into the correct number of rows.
[OriginalBalance, GrossRate, OriginalTerm] = ...
  finargsz(1, OriginalBalance(:), GrossRate(:), OriginalTerm(:));

NumMBS = length(OriginalBalance);
NumCFmax = max(OriginalTerm);

% Initialize matrix size NUmCFmax x NumMBS
Balance  = nan*zeros(NumCFmax, NumMBS);
Interest = nan*zeros(NumCFmax, NumMBS); 
Payment  = nan*zeros(NumCFmax, NumMBS); 
Principal= nan*zeros(NumCFmax, NumMBS); 

% We are making sure it is integer, floor it because avoid 
% the fractional first month with AI
OriginalTerm  = floor(OriginalTerm);

for i = 1:NumMBS    
    % All Balance
    Balance(1:OriginalTerm(i),i)   = ...
      OriginalBalance(i)*( (1+GrossRate(i)/12)^OriginalTerm(i) - ...
        (1 + GrossRate(i)/12).^[1:OriginalTerm(i)]') / ...
          ( (1+GrossRate(i)/12)^OriginalTerm(i) - 1); 
    
    % All Interest
    Interest(1:OriginalTerm(i),i)  = ...
      [OriginalBalance(i); Balance(1:OriginalTerm(i)-1, i)] * ...
        GrossRate(i)/12; 
    
    % All Payment - Gross cash flow to Passthrough holder
    Payment(1:OriginalTerm(i),i)   = ...
      OriginalBalance(i) * (GrossRate(i)/12) * ...
        ((1 + GrossRate(i)/12)^OriginalTerm(i)) / ...
          ( (1 + GrossRate(i)/12)^OriginalTerm(i) - 1);
    
    % All Principal
    Principal(1:OriginalTerm(i),i) = ...
      OriginalBalance(i) * (GrossRate(i)/12) * ...
       ( (1 + GrossRate(i)/12).^[0:OriginalTerm(i)-1]' ) / ...
         ( (1+GrossRate(i)/12)^OriginalTerm(i) - 1);
end

% Assign results to output
varargout = {Balance Interest Payment Principal};
