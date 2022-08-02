function varargout = cdprice(varargin)
%CDPRICE Price of CD given its yield.
%   Price of CD (interest-bearing paper) given its simple-yield.
%
% [Price, AccrInt] = ...
%    cdprice(Yield, CouponRate, Settle, Maturity, IssueDate)
%
% [Price, AccrInt] = ...
%    cdprice(Yield, CouponRate, Settle, Maturity, IssueDate, Basis)
%
% Inputs:
%       Yield - NCDx1 vector of simple yields to maturity, 
%               over the basis denominator.
%
%        Rate - NCDx1 vector of coupon rates in decimal form.
%
%      Settle - NCDx1 vector of Settlement dates.
%
%    Maturity - NCDx1 vector of Maturity dates.
%
%   IssueDate - NCDx1 vector of Issue dates of the CD.
%
% Optional Inputs:
%       Basis - NCDx1 vector of Accrual basis. 
%               0 - actual/actual
%               1 - 30/360 (SIA Compliant)
%               2 - actual/360 (default)
%               3 - actual/365
%           
% Outputs:
%  Price      - NCDx1 vector of clean prices of the CD 
%               per $100 face value. 
%
%  AccruedInt - NCDx1 vector of accrued-interest payable at settlement 
%               per $100 face value.
%
% Example:
%   Yield      = 0.0525;
%   Rate       = 0.05;
%   Settle     = datenum('02-Jan-2002');
%   Maturity   = datenum('31-Mar-2002');
%   IssueDate  = datenum('01-Oct-2001');
%   
%   Price = cdprice(Yield, Rate, Settle, Maturity, IssueDate)
%
%   Author(s): K. Lui 1/2004
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.8.6.4 $   $Date: 2004/04/06 01:08:43 $

%% Input arguments check
if (nargin < 5)
    error('finfixed:cdprice:invalidInputs','Incorrect number of inputs.');

else
    Yield = varargin{1}(:);
    CouponRate = varargin{2}(:);
    Settle     = datenum(varargin{3});
    Maturity   = datenum(varargin{4});
    IssueDate  = datenum(varargin{5});
end

if nargin < 6 || isempty(varargin{6})
    Basis = 2;
else
    Basis = varargin{6}(:);    
    if any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3)
        error('finfixed:cdprice:invalidBasis',...
            'Invalid day count basis.');
    end
end

% expand size to conform to other inputs
[Yield, CouponRate, Settle, Maturity, IssueDate, Basis] = ...
  finargsz(1, Yield, CouponRate, Settle, Maturity, IssueDate, Basis);

% making sure that IssueDate <= Settle <= Maturity    
if any(IssueDate > Settle)
    error('finfixed:cdprice:invalidIssueDate',...
        'IssueDate must be less than or equal to Settle.');
end

if any(Settle > Maturity)
    error('finfixed:cdprice:invalidSettleDate',...
        'Settle must be less than or equal to Maturity.');
end    

Tis = yearfrac(IssueDate, Settle, Basis);
Tim = yearfrac(IssueDate, Maturity, Basis);
Tsm = yearfrac(Settle, Maturity, Basis);

AccrInt = CouponRate .* Tis;

Price = 100*((1 + CouponRate .* Tim ) ./ (1 + Yield .* Tsm) - AccrInt);

varargout = {Price;100*AccrInt};

% {EOF]
