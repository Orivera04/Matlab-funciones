function varargout = mbsdury(varargin)
%MBSDURY Macaulay and Modified duration given yield to maturity.
%   Modified duration, in unit of years, given bond-equivalent 
%   yields and prepayment vectors of NMBS mortgage pools.
%
% [YearDuration, ModDuration] = mbsdury(Yield, Settle, Maturity, ...
%   IssueDate, GrossRate)
%
% [YearDuration, ModDuration] = mbsdury(Yield, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, PrepaySpeed)
%
% [YearDuration, ModDuration] = mbsdury(Yield, Settle, Maturity, ...
%   IssueDate, GrossRate, CouponRate, Delay, [], PrepayMatrix)
%
% Inputs:
%             Yield - NMBSx1 vector of mortgage yield
%                     (monthly compounded) yield in decimal. 
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
%        CouponRate  - NMBSx1 vector of Net Coupon Rate, 
%                      in decimal. 
%                      Default is equal to GrossRate. 
%              
%             Delay  - NMBSx1 vector of delay in days.
%   
%       PrepaySpeed  - NMBSx1 vector of speed relative to 
%                      PSA standard. PSA standard is 100.
%                      Default is 0 (zero) prepayment speed.
%
%       PrepayMatrix - Customized prepayment vector. A matrix of size 
%                      [max(TermRemaining) x NMBS]. Missing values are
%                      padded with NaNs.  Each column corresponds to each
%                      MBS, and each row corresponds to each month after
%                      settlement. 
%
% Outputs:
%      YearDuration  - Macaulay duration in years
%
%       ModDuration  - Modified duration in years
%
% Example:
% Yield =  0.07298413;
% Settle    = datenum('15-Apr-2002');
% Maturity  = datenum('01 Jan 2030');
% IssueDate = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% CouponRate = 0.075;;
% Delay = 14;
% Speed = 100;
% 
% [YearDuration, ModDuration] = mbsdury(Yield, Settle, Maturity, ...
%       IssueDate, GrossRate, CouponRate, Delay, Speed)
%
% Note: This function is PSA compliant. 
%       Reference: PSA Uniform Practices, SF-49

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.6.4 $  $Date: 2004/04/06 01:08:53 $

if nargin > 9
    error('finfixed:mbsdury:invalidMoreInputs','Too many input arguments. Type "help mbsdury" for information.')
end

if nargin <5
    error('finfixed:mbsdury:invalidLessInputs','Need at least Yield, Settle, Maturity, IssueDate, and GrossRate')    
else
    Yield = varargin{1};
end


% mbsprice still gets the monthly/mortgage yield, so this line is good.
[Price, AccrInt, CFlowAmounts, TFactors] = mbsprice(varargin{1:end});

% expand Yield to correct size
[Yield, dummy] = finargsz(1,Yield(:), Price);

% because duration is measured with bond-equivalent, or semi-annual yield
% translate the monthly yield to semi annual
Yield = 2*( (1+Yield/12).^6 - 1 );

% Denominator is Cash Price
P = (Price + AccrInt)/100;
NumCF = size(CFlowAmounts,2);

% zero the Nans
CFlowAmounts(isnan(CFlowAmounts)) = 0;
TFactors(isnan(TFactors)) = 0;

varargout{1} = 1./P .* sum([((TFactors/12).*CFlowAmounts./...
        (1+Yield(:,ones(NumCF,1))/2).^(TFactors/6))],2);
varargout{2} = varargout{1}  ./ (1+Yield/2);
