function varargout = mbsdurp(varargin)
%MBSDURP Macaulay and Modified duration given price and prepayment.
%   Modified duration, in unit of years, given prices of 
%   NMBS number of mortgage-pools and their prepayment vectors.
%
% [YearDuration, ModDuration] = mbsdurp(Price, Settle, ...
%     Maturity, IssueDate, GrossRate)
%
% [YearDuration, ModDuration] = mbsdurp(Price, Settle, ...
%     Maturity, IssueDate, GrossRate, ...
%       CouponRate, Delay, PrepaySpeed)
%
% [YearDuration, ModDuration] = mbsdurp(Price, Settle, ... 
%     Maturity, IssueDate, GrossRate, ...
%       CouponRate, Delay, [], PrepayMatrix)
%
% Inputs:
%             Price - NMBSx1 vector of clean price for every 
%                     $100 face of issue.
%                    
%            Settle - NMBSx1 vector of settlement date. 
%                    
%          Maturity - NMBSx1 vector of maturity date.   
%                   
%         IssueDate - NMBSx1 vector of issue date.      
%                     
%         GrossRate - NMBSx1 vector of gross coupon rate, 
%                     in decimal.
%
% Optional Inputs:
%        CouponRate - NMBSx1 vector of Net Coupon Rate, 
%                     in decimal. 
%                     Default is equal to GrossRate. 
%              
%             Delay - NMBSx1 vector of delay in days.
%   
%       PrepaySpeed - NMBSx1 vector of speed relative to 
%                     PSA standard. PSA standard is 100.
%                     Default is 0 (zero) prepayment speed.
%
%      PrepayMatrix - Customized prepayment vector. A matrix of size 
%                     [max(TermRemaining) x NMBS]. Missing values are
%                     padded with NaNs.  Each column corresponds to each
%                     MBS, and each row corresponds to each month after
%                     settlement. 
%
% Outputs:
%      YearDuration - Macaulay duration in years
%
%       ModDuration - Modified duration in years
%
% Example:
% Price = 101;
% Settle    = datenum('15-Apr-2002');
% Maturity  = datenum('01 Jan 2030');
% IssueDate = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% CouponRate = 0.075;;
% Delay = 14;
% Speed = 100;
%
% [YearDuration, ModDuration] = ...
%   mbsdurp(Price, Settle, Maturity, IssueDate, ...
%       GrossRate, CouponRate, Delay, Speed)
%
% Note: This function is PSA compliant. 
%       Reference: PSA Uniform Practices, SF-49

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.6.4 $  $Date: 2004/04/06 01:08:52 $

if nargin > 9
    error('finfixed:mbsdurp:invalidMoreInputs','Too many input arguments. Type "help mbsdurp" for information.')
end

if nargin < 5
    error('finfixed:mbsdurp:invalidLessInputs','Need at least Price, Settle, Maturity, IssueDate, and GrossRate')  
else
    Price = varargin{1};
end

%compute the yields needed to get duration
[montlyld, semiyld, CFlowAmounts, TFactors] = mbsyield(varargin{1:end});

% zero the Nans
CFlowAmounts(isnan(CFlowAmounts)) = 0;
TFactors(isnan(TFactors)) = 0;

% expand semiyld
NumCF = size(CFlowAmounts, 2);

P = -CFlowAmounts(:,1);
[Price, dummy] = finargsz(1,Price(:),P);

CFlowAmounts(:,1) = CFlowAmounts(:,1) + Price/100;

% Assign results to output
varargout{1} = 1./P .* sum([((TFactors/12).*CFlowAmounts./...
        (1+semiyld(:,ones(NumCF,1))/2).^(TFactors/6))],2);
varargout{2} = varargout{1} ./ (1+semiyld/2);
