function AccrInt = cdai(varargin)
%CDAI Accrued Interest of Certificate of Deposits (CD).
%   Rates are based on basis that can be optionally defined.
%
% AccrInt = cdai(CouponRate, Settle, Maturity, IssueDate)
% AccrInt = cdai(CouponRate, Settle, Maturity, IssueDate, Basis)
%
% Inputs:
%         Rate - NCDx1 vector of coupon rate in decimal form.
%
%       Settle - NCDx1 vector of Settlement date.
%
%     Maturity - NCDx1 vector of Maturity date.
%
%    IssueDate - NCDx1 vector of Issue date of the CD.
%
% Optional Inputs:
%        Basis - NCDx1 vector of Accrual basis. 
%                0 - actual/actual
%                1 - 30/360 
%                2 - actual/360  (default)
%                3 - actual/365
%
% Outputs:
%      AccrInt - NCDx1 vector of Accrued Interest per $100 face value.
%
% Example:
%   Rate       = 0.05;
%   Settle     = datenum('02-Jan-2002');
%   Maturity   = datenum('31-Mar-2002');
%   IssueDate  = datenum('01-Oct-2001');
%
%   AccrInt = cdai(Rate, Settle, Maturity, IssueDate)


%  Author(s): K. Lui 1/2004
%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.8.6.4 $   $Date: 2004/04/06 01:08:42 $

% Input arguments check
if (nargin < 4)
    error('finfixed:cdai:invalidInputs',...
        'Incorrect number of inputs.');

else
    CouponRate = varargin{1}(:);
    Settle     = datenum(varargin{2});
    Maturity   = datenum(varargin{3});
    IssueDate  = datenum(varargin{4});    
end

if nargin < 5 || isempty(varargin{5})
    Basis = 2;
else
    Basis = varargin{5}(:);
    if any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3)
        error('finfixed:cdai:invalidBasis',...
            'Invalid day count basis.');
    end    
end

[CouponRate, Settle, Maturity, IssueDate, Basis] = ...
    finargsz(1, CouponRate, Settle, Maturity, IssueDate, Basis);

% making sure that IssueDate <= Settle <= Maturity    
if any(IssueDate > Settle)
    error('finfixed:cdai:invalidIssueDate',...
        'IssueDate must be less than or equal to Settle.');
end

if any(Settle > Maturity)
    error('finfixed:cdai:invalidSettleDate',...
        'Settle must be less than or equal to Maturity.');
end

Tis = yearfrac(IssueDate, Settle, Basis);

% Tis: Time from Issue to Settle
AccrInt = 100 * CouponRate .* Tis;


% [EOF]
