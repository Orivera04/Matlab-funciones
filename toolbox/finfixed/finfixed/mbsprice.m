function varargout = mbsprice(varargin)
%MBSPRICE Passthrough price given its mortgage yield.
%   Theoretical prices of NMBS number of mortgage-pool 
%   given their yields and prepayment assumptions.
%
% [Price, AccrInt] = mbsprice(Yield, Settle, Maturity, IssueDate, ...
%     GrossRate)
%
% [Price, AccrInt] = mbsprice(Yield, Settle, Maturity, IssueDate, ...
%     GrossRate, CouponRate, Delay, PrepaySpeed)
%
% [Price, AccrInt] = mbsprice(Yield, Settle, Maturity, IssueDate, ...
%     GrossRate, CouponRate, Delay, [], PrepayMatrix)
%
% Inputs:
%             Yield - NMBSx1 vector of Mortgage yield in decimal 
%                     (compounded monthly or 12 times annually)
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
%             Price - Clean Price for every $100 face value of securities.
%
%           AccrInt - Accrued Interest of the mortgage backed securities.
%
% Example:
% Yield = 0.0725;
% Settle     = datenum('15-Apr-2002');
% Maturity   = datenum('01 Jan 2030');
% IssueDate  = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% CouponRate = 0.075;
% Delay = 14;
% Speed = 100;
%
% [Price AccrInt] = mbsprice(Yield, Settle, Maturity, IssueDate, GrossRate, ...
%                       CouponRate, Delay, Speed)
%
% Note: This function is PSA compliant. 
%       Reference: PSA Uniform Practices, SF-49

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.6.4 $  $Date: 2004/04/06 01:08:55 $

if nargin > 9
    error('finfixed:mbsprice:invalidMoreInputs','Too many input arguments. Type "help mbsyield" for information.')
end

if nargin < 5
    error('finfixed:mbsprice:invalidLessInputs','Need at least Settle, Maturity, IssueDate, and GrossRate')
else
    Yield     = varargin{1};
    Settle    = datenum(varargin{2});
    Maturity  = datenum(varargin{3});
    IssueDate = datenum(varargin{4});
    GrossRate = varargin{5}(:);
    if any(IssueDate > Settle)
        error('finfixed:mbsprice:invalidSettle',['Settle must be at, or after IssueDate.', sprintf('\n'),...
              'Settle before IssueDate is unsupported at this time']);
    end    
end

if nargin <6 | isempty(varargin{6})
    CouponRate = GrossRate;
else
    CouponRate = varargin{6}(:);
end

if nargin <7 | isempty(varargin{7})
    Delay = 0;
else
    Delay = varargin{7}(:);
end

if nargin == 9;
    customized = 1;
else
    customized = 0;
end

if customized == 1
    if ~isempty(varargin{8})
        error('finfixed:mbsprice:invalidPrepaySpeed',['Cannot use benchmark when supplying ', sprintf('\n') ...
               'customized prepayment CPR - Put ', sprintf('\n') ...
               'empty matrices ([]) for 8th input arguments'])
    end
        
    % check that prepayment is supplied and not empty.
    if isempty(varargin{9})
        error('finfixed:mbsprice:invalidPrepayMatrix',['Please supply a prepayment (SMM)', sprintf('\n') ...
              'matrix when you do not use benchmarked prepayment'])
    else
        SMMRel = varargin{9};
    end
    
   % Call mbscfamounts to get the Amounts and 
   % Time the cash flows occuring when own prepayment is used
   [Yield, Settle, Maturity, IssueDate, GrossRate, ...
           CouponRate, Delay] = ...
         finargsz(1,Yield(:), Settle(:), Maturity(:), ...
           IssueDate(:), GrossRate(:), CouponRate(:), Delay(:));
   
   [CFlowAmounts dummy TFactors] = mbscfamounts(Settle, Maturity, IssueDate, ...
         GrossRate, CouponRate, Delay, [], SMMRel);
     
 else
        
    if nargin < 8 | isempty(varargin{8})
        Speed = 0;
    else
        Speed = varargin{8};
    end
    
    % Expansion of scalar into vector when necessary
    [Yield, Settle, Maturity, IssueDate, GrossRate, ...
         CouponRate, Delay, Speed] = ...
       finargsz(1,Yield(:), Settle(:), Maturity(:), ...
         IssueDate(:), GrossRate(:), CouponRate(:), Delay(:), Speed(:));
    
    % Call mbscfamounts to get the Amounts and Time the 
    % cash flows occuring when std benchmark used   
    [CFlowAmounts dummy TFactors] = mbscfamounts(Settle, Maturity, IssueDate, ...
        GrossRate, CouponRate, Delay, Speed);
 end

% Accrued interest is the first element of CFlowAmounts
AccrInt = -CFlowAmounts(:,1);

NumCF = size(CFlowAmounts, 2);

% Calculate the clean price
PerDisc = (1+Yield(:, ones(NumCF,1))/12).^(-TFactors);

% Compute the present value of every cash flow (including accrued
% interest payment at settlement)
CFlowPVs = CFlowAmounts .* PerDisc;
CFlowPVs( isnan(CFlowPVs) ) = 0;

% Sum the present value cash flows horizontally to get the clean price
Price = sum(CFlowPVs,2);

varargout = {100*Price, 100*AccrInt, CFlowAmounts, TFactors};
