function varargout = mbswal(varargin)
%MBSWAL Weighted Average Life of mortgage pool.
%   Computes weighted average life of mortgage pool,
%   in unit of years.
%
% WAL = mbswal(Settle, Maturity, IssueDate, ... 
%       GrossRate)
%
% WAL = mbswal(Settle, Maturity, IssueDate, ... 
%       GrossRate, CouponRate, Delay, PrepaySpeed)
%
% WAL = mbswal(Settle, Maturity, IssueDate, ...
%       GrossRate, CouponRate, Delay, [], PrepayMatrix)
%
% Inputs:
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
%              WAL - Weighted Average Life of MBS, 
%                    in number of years.
%
% Example:
% Settle    = datenum('15-Apr-2002');
% Maturity  = datenum('01 Jan 2030');
% IssueDate = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% CouponRate = 0.075;
% Delay = 14;
% Speed = 100;
%
% WAL = mbswal(Settle, Maturity, IssueDate, GrossRate, ...
%   CouponRate, Delay, Speed)
%
% Note: This function is PSA compliant. 
%       Reference: PSA Uniform Practices, SF-49

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.7.6.4 $  $Date: 2004/04/06 01:08:58 $

if nargin<4
    error('finfixed:mbsconvy:invalidMoreInputs',...
        'Not enough input arguments');
end

% Compute the Cash flow, Time Factors, and mortgage factors 
[CFlowAmounts dummy TFactors Factors] = ...
    mbscfamounts(varargin{1:end});

% compute the decline in balance at end of period
% and assign zeros to the "appending nans"
deltaF = diff(Factors,1,2);
deltaF(isnan(deltaF)) = 0;

% assign zeros to appending nans.
TFactors(isnan(TFactors)) = 0;

% Assign results to output
varargout{1} = 1/12 * sum([deltaF .* TFactors(:,2:end)],2) ./ ...
    sum(deltaF(:,2:end),2);
