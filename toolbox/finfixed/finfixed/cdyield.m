function Yield = cdyield(varargin)
%CDYIELD Simple yield to maturity of CD (Certificate of Deposit).
%   Simple yield of NCD number of CD (interest-bearing paper) 
%   given its clean price.
%           
% Yield = cdyield(Price, CouponRate, Settle, ...
%           Maturity, IssueDate)
%
% Yield = cdyield(Price, CouponRate, Settle, ...
%           Maturity, IssueDate, Basis)
%
% Inputs:
%        Price - NCDx1 Clean Price of CD per $100 notional.
%
%   CouponRate - NCDx1 vector of coupon rate in decimal.
%
%       Settle - NCDx1 vector of Settlement date
%
%     Maturity - NCDx1 vector of Maturity date
%
%    IssueDate - NCDx1 vector of Issue date
%
% Optional Inputs:
%        Basis - NCDx1 vector of accrual basis. 
%                Default is 2 (act/360).
%       
%   Possible values are:
%          1) Basis = 0 - actual/actual
%          2) Basis = 1 - 30/360 (SIA compliant) (default)
%          3) Basis = 2 - actual/360  
%          4) Basis = 3 - actual/365
%           
% Outputs:
%        Yield - NCDx1 vector of simple Yield to maturity of CD.
%
% Example:
%   Price      = 101.125;
%   CouponRate = 0.05;
%   Settle     = datenum('02-Jan-2002');
%   Maturity   = datenum('31-Mar-2002');
%   IssueDate  = datenum('01-Oct-2001');
%
%   Yield = cdyield(Price, CouponRate, Settle, Maturity, IssueDate)
%
%   Author(s): K. Lui 1/2004
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.9.6.4 $   $Date: 2004/04/06 01:08:44 $

% Input arguments check
if (nargin < 5)
    error('finfixed:cdyield:invalidInputs','Incorrect number of inputs.');

else
    Price  = varargin{1}(:);
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
        error('finfixed:cdyield:invalidBasis','Invalid day count basis.');
    end    
end

% size check
[Price, CouponRate, Settle, Maturity, IssueDate, Basis] = ...
    finargsz(1, Price, CouponRate, Settle, Maturity, ...
        IssueDate, Basis);
    
% making sure that IssueDate <= Settle <= Maturity    
if any(IssueDate > Settle)
    error('finfixed:cdyield:invalidIssueDate',...
        'IssueDate must be less than or equal to Settle');
end

if any(Settle > Maturity)
    error('finfixed:cdyield:invalidSettleDate',...
        'Settle must be less than or equal to Maturity');
end    

Tis = yearfrac(IssueDate, Settle, Basis);
Tim = yearfrac(IssueDate, Maturity, Basis);
Tsm = yearfrac(Settle, Maturity, Basis);

AccrInt = CouponRate .* Tis;

B = Price/100 + AccrInt;

Yield = ( (1 + CouponRate .* Tim) ./ B  - 1 ) .* (1/Tsm);

% [EOF]
