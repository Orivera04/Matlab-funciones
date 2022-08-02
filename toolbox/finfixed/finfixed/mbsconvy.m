function varargout = mbsconvy(varargin)
%MBSCONVY Convexity of passthrough given yield.
%   Modified Convexity of NMBS number of mortgage pool 
%   given bond-equivalent yields and prepayment assumptions.
%
% Convexity = mbsconvy(Yield, Settle, Maturity, ...
%   IssueDate, GrossRate)
%
% Convexity = mbsconvy(Yield, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, PrepaySpeed)
%
% Convexity = mbsconvy(Yield, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, [], PrepayMatrix)
%
% Inputs:
%        Yield - NMBSx1 vector of semi-annual 
%                (bond-equivalent) yield in decimal. 
%
%       Settle - NMBSx1 vector of Settlement Date.
%
%     Maturity - NMBSx1 vector of Maturity Date.
%                
%    IssueDate - NMBSx1 vector of Issue Date.
%         
%    GrossRate - NMBSx1 vector of Gross Coupon Rate,
%                in decimal. 
%
% Optional Inputs:
%   CouponRate  - NMBSx1 vector of Net Coupon Rate, 
%                 in decimal. 
%                 Default is equal to GrossRate. 
%              
%        Delay  - NMBSx1 vector of delay in days.
%   
%  PrepaySpeed  - NMBSx1 vector of speed relative to 
%                 PSA standard. PSA standard is 100.
%                 Default is 0 (zero) prepayment speed.
%
%  PrepayMatrix - Customized prepayment vector. A matrix of size 
%                 [max(TermRemaining) x NMBS]. Missing values are padded
%                 with NaNs.  Each column corresponds to each MBS, and each
%                 row corresponds to each month after settlement. 
%
% Outputs:
%    Convexity - Convexity of mortgage pool
%
% Example: 
% Yield = 0.07125;
% Settle    = datenum('15-Apr-2002');
% Maturity  = datenum('01 Jan 2030');
% IssueDate = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% CouponRate = 0.075;;
% Delay = 14;
% Speed = 100;
%
% Convexity = mbsconvy(Yield, Settle, Maturity, IssueDate, GrossRate, ... 
%      CouponRate, Delay, Speed)
%
% Note: This function is PSA compliant. 
%       Reference: PSA Uniform Practices, SF-49

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.6.4 $  $Date: 2004/04/06 01:08:51 $

if nargin > 9
    error('finfixed:mbsconvy:invalidMoreInputs','Too many input arguments.')
end

if nargin <5
    error('finfixed:mbsconvy:invalidLessInputs','Need at least Yield, Settle, Maturity, IssueDate, and GrossRate')    
else
    Yield = varargin{1};
end

%Get the cash flows
[CFlowAmounts dummy TFactors Factors] = mbscfamounts(varargin{2:end});

CFlowAmounts(isnan(CFlowAmounts)) = 0;
TFactors(isnan(TFactors)) = 0;

% Calculate Theoretical price
% Accrued interest is the first element of CFlowAmounts
AccrInt = -CFlowAmounts(:,1);

%expand the Yield correctly
[Yield, dummy] = finargsz(1,Yield(:), CFlowAmounts(:,1));

NumCF = size(CFlowAmounts,2);

% Calculate the clean price
PerDisc = (1+Yield(:,ones(NumCF,1))/2).^(-TFactors/6);

Price = sum([CFlowAmounts .* PerDisc],2);

% Annualized time
Anntime = TFactors/12;
P = (Price + AccrInt);

varargout{1} = 1./((1+Yield/2).^2) ./ P .* ... 
    (sum([Anntime.*(Anntime+0.5).*CFlowAmounts./...
        ((1+Yield(:,ones(NumCF,1))/2).^(2*Anntime))],2));
