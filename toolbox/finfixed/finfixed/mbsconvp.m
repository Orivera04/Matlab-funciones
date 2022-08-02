function varargout = mbsconvp(varargin)
%MBSCONVP Convexity of mortgage pool given price.
%   Modified Convexity of mortgage pool given prices
%   and prepayment assumptions.
%
% Convexity = mbsconvp(Price, Settle, Maturity, IssueDate, ...
%       GrossRate)
%
% Convexity = mbsconvp(Price, Settle, Maturity, IssueDate, ...
%       GrossRate, CouponRate, Delay, PrepaySpeed)
%
% Convexity = mbsconvp(Price, Settle, Maturity, IssueDate, ...
%       GrossRate, CouponRate, Delay, [], PrepayMatrix)
%
% Inputs:
%        Price - NMBSx1 vector of clean price for 
%                every $100 face
%
%       Settle - NMBSx1 vector of settlement date. 
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
%    Convexity - Convexity of mortgage pool.
%
% Example:
% Price = 101;
% Settle    = datenum('15-Apr-2002');
% Maturity  = datenum('01 Jan 2030');
% IssueDate = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% Speed = 100;
% CouponRate = 0.075;;
% Delay = 14;
%
% Convexity = mbsconvp(Price, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, Speed)
%
% If you specify a PSA speed they will be "seasoned"
% with how long the debt has been outstanding, 
% or simply the loan's age.
%
% Note: This function is PSA compliant. 
%       Reference: PSA Uniform Practices, SF-49

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.6.4 $  $Date: 2004/04/06 01:08:50 $

if nargin > 9
    error('finfixed:mbsconvp:invalidMoreInputs','Too many input arguments.')
end

if nargin < 5
    error('finfixed:mbsconvp:invalidLessInputs','Need at least Price, Settle, Maturity, IssueDate, and GrossRate')  
else
    Price = varargin{1};
end

%[CFlowAmounts TFactors Factors] = mbscfamounts(varargin{2:end});
[montlyld, semiyld, CFlowAmounts TFactors] = mbsyield(varargin{1:end});

% change nan to zero
CFlowAmounts(isnan(CFlowAmounts))=0;
TFactors(isnan(TFactors))=0;

%Annualizing time
Anntime = TFactors/12;

%needed to expand yield to arrays of column => Discount matrix
NumCF = size(TFactors,2);

varargout{1} = 1./((1+semiyld/2).^2)./(-CFlowAmounts(:,1)) .* ...
  (sum([Anntime.*(Anntime+0.5).*CFlowAmounts./...
      ((1+semiyld(:,ones(NumCF,1))/2).^(2*Anntime))],2));
