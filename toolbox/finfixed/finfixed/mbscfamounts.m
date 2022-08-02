function varargout = mbscfamounts(varargin)
%   MBSCFAMOUNTS Cash flow and time mapping  for mortgage-pool.
%      CashFlows amounts and timing for NMBS number of mortgage
%      pools given pool specification and prepayment vectors.
%
%     [CFlowAmounts, CFlowDates, TFactors, Factors] = ...
%       mbscfamounts(Settle, Maturity, IssueDate, GrossRate)
%
%     [CFlowAmounts, CFlowDates, TFactors, Factors] = ...
%       mbscfamounts(Settle, Maturity, IssueDate, GrossRate, ...
%       CouponRate, Delay, PrepaySpeed)
%
%     [CFlowAmounts, CFlowDates, TFactors, Factors] = ...
%       mbscfamounts(Settle, Maturity, IssueDate, GrossRate, ...
%       CouponRate, Delay, [], PrepayMatrix)
%
%     [CFlowAmounts, CFlowDates, TFactors, Factors] = ...
%       mbscfamounts(Settle, Maturity, IssueDate, GrossRate, ...
%       CouponRate, Delay, [], PrepayMatrix, Period)
%
%   Inputs:
%           Settle - NMBSx1 vector of Settlement Date.
%
%         Maturity - NMBSx1 vector of Maturity Date.
%
%        IssueDate - NMBSx1 vector of Issue Date.
%
%        GrossRate - NMBSx1 vector of Gross Coupon Rate,
%                    in decimal.
%  
%   Optional Inputs:
%       CouponRate - NMBSx1 vector of Net Coupon Rate,
%                    in decimal. Default is equal to GrossRate.
%
%            Delay - NMBSx1 vector of payment delay in days.
%                    Default is 0 (no delay).
%
%      PrepaySpeed - NMBSx1 vector of speed relative to
%                    PSA standard. PSA standard is 100.
%                    Default is 0 (zero) prepayment speed.
%
%     PrepayMatrix - Customized prepayment vector. A matrix of size
%                    [max(TermRemaining) x NMBS]. Missing values are padded
%                    with NaNs.  Each column corresponds to each MBS, and each
%                    row corresponds to each month after settlement.
%
%           Period - Coupons payments per year; default is 12 (monthly).
%                    1 - annual payments
%                    2 - semi-annual payments
%                    3 - three times per year
%                    4 - quarterly payments
%                    6 - bi-monthly payments
%                   12 - monthly payments (default) 
%   
%   Outputs:
%     CFlowAmounts - Cash flows, start from end of first monthly
%                    period and end at the last monthly period
%                    (Maturity).
%
%       CFlowDates - Dates when cash flows occur, including
%                    Settlement, where possible negative (accrued
%                    interest) payments occur
%
%         TFactors - The time in months from Settle corresponding
%                    to each cash flow.
%
%          Factors - The mortgage factor, which indicates fraction
%                    of balance still outstanding at the end of
%                    the month.
%
%   Example:
%      Settle     = datenum('17-Apr-2002');
%      Maturity   = datenum('01-Jan-2030');
%      IssueDate  = datenum('01-Jan-2000');
%      GrossRate  = 0.08125;
%      CouponRate = 0.075;
%      Delay      = 14;
%      Speed      = 100;
%
%      [CFlowAmounts, CFlowDates, TFactors, Factors] = mbscfamounts( ...
%                Settle, Maturity, IssueDate, GrossRate, CouponRate, ...
%                Delay, Speed);
%
%    Note: This function is PSA compliant.
%          Reference: PSA Uniform Practices, SF-4

%    Author(s): K. Lui, 3/2004;
%    Copyright 2002-2004 The MathWorks, Inc.
%    $Revision 1.3 $  $Date: 2004/04/06 01:08:49 $

if nargin > 9
    error('finfixed:mbscfamounts:invalidMoreInputs',...
        sprintf(['Too many input arguments. ', ...
        'Type "help mbscfamounts" for information.']));
end

if nargin < 4
    error('finfixed:mbscfamounts:invalidLessInputs',...
        'Need at least Settle, Maturity, IssueDate, and GrossRate')
else
    Settle    = datenum(varargin{1});
    Maturity  = datenum(varargin{2});
    IssueDate = datenum(varargin{3});
    GrossRate = varargin{4}(:);
    if any(IssueDate > Settle)
        error('finfixed:mbscfamounts:invalidSettle',...
            sprintf(['Settle must be at, or after IssueDate.',...
            'Settle before IssueDate is unsupported \nat this time.']));
    end
end

if nargin <5 || isempty(varargin{5})
    CouponRate = GrossRate;
else
    CouponRate = varargin{5};
end

if nargin <6 || isempty(varargin{6})
    Delay = 0;
else
    Delay = varargin{6};
end

if nargin <8 || isempty(varargin{8});
    customized = 0;
else
    customized = 1;
end

if nargin <9 || isempty(varargin{9});
    period = 12;
else
    period = varargin{9};
end

% check that not both prepayment matrix and benchmark is empty
if (nargin <8 || isempty(varargin{8}))&&(nargin <7 ||isempty(varargin{7}))
    error('finfixed:mbscfamounts:invalidPrepayMatrix',...
        sprintf(['Please supply a prepayment(SMM) ',...
        'matrix when you do not use \nbenchmarked prepayment.']));
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                         %
% TIME processing of customized and benchmarked           %
% cases are unfortunately, parallel. This is because      %
% the type of parameters on these two cases are           %
% different, i.e. when it is customized, no input         %
% related to benchmark can be given                       %
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if customized == 0

    if nargin < 7 || isempty(varargin{7})
        Speed = 0;
    else
        Speed = varargin{7};
    end

    [Settle, Maturity, IssueDate, GrossRate, CouponRate, Delay, Speed] = ...
        finargsz(1,Settle(:), Maturity(:), IssueDate(:), GrossRate(:), ...
        CouponRate(:), Delay(:), Speed(:));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                       %
    %   TIME Processing                     %
    %   IssueDate is the anchor of time,    %
    %   which obliges Maturity to be of the %
    %   same date as IssueDate              %
    %                                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vec_Issue = datevec(IssueDate);
    vec_Maturity = datevec(Maturity);

    if any(vec_Issue(:,3)-vec_Maturity(:,3))
        warning(['The Issue date is different from Maturity.',...
            'At this time MATLAB \ndoes not handle ''odd''',...
            'coupon for MBS. MATLAB has now changed the ',...
            'Maturity \ndate to be equal to Issue date.']);
        vec_Maturity(:,3) = vec_Issue(:,3);
        Maturity = datenum(vec_Maturity);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Building CashFlow dates to be in-sync vs. IssueDate     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CFlowDates = cfdates(Settle, Maturity, period, 4, 1, IssueDate);
    % append the Settlement date, too.
    CFlowDates = [Settle, CFlowDates];

    for i = 1:2
        if i == 1
            NumCouponsRemaining(:,i) = ...
                cpncount(IssueDate, Maturity, period, 4, 1, IssueDate);
        else
            NumCouponsRemaining(:,i) = ...
                cpncount(Settle, Maturity, period, 4, 1, IssueDate);
        end
    end

else

    if ~isempty(varargin{7})
        error('finfixed:mbscfamounts:invalidPrepaySpeed',...
            sprintf(['Cannot use benchmark when supplying ',...
            'customized prepayment CPR - Put ',...
            '\nempty matrices, [], for 7th input arguments.']));
    end

    % check that prepayment is supplied and not empty.
    if isempty(varargin{8})
        error('finfixed:mbscfamounts:invalidPrepayMatrix',...
            sprintf(['Please supply a prepayment(SMM) ',...
            'matrix when you do not use \nbenchmarked prepayment.']));
    else
        SMMRel = varargin{8};
    end

    [Settle, Maturity, IssueDate, GrossRate, CouponRate, Delay] = ...
        finargsz(1,Settle(:), Maturity(:), IssueDate(:), GrossRate(:), ...
        CouponRate(:), Delay(:));

    % TIME processing
    vec_Issue = datevec(IssueDate);
    vec_Maturity = datevec(Maturity);

    if any(vec_Issue(:,3)-vec_Maturity(:,3))
        warning(sprintf(['The Issue date is different from Maturity.',...
            'At this time MATLAB does not \nhandle ''odd''',...
            'coupon for MBS. MATLAB has now changed the',...
            'Maturity date to be equal \nto Issue date.']));
        vec_Maturity(:,3) = vec_Issue(:,3);
        Maturity = datenum(vec_Maturity);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Building CashFlow dates to be in-sync vs. IssueDate     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CFlowDates = cfdates(Settle, Maturity, period, 4, 1, IssueDate);
    % append the Settlement date, too.
    CFlowDates = [Settle, CFlowDates];

    for i = 1:2
        if i == 1
            NumCouponsRemaining(:,i) = ...
                cpncount(IssueDate, Maturity, period, 4, 1, IssueDate);
        else
            NumCouponsRemaining(:,i) = ...
                cpncount(Settle, Maturity, period, 4, 1, IssueDate);
        end
    end

    % check the size
    if any(size(SMMRel) ~= [max(NumCouponsRemaining(:,2)), length(Settle)])
        error('finfixed:mbscfamounts:invalidSizeCustomPrepayMatrix',...
            sprintf('Size of customized SMM must be max(TermRemaining) x NumMBS.'));
    end

end

if any(NumCouponsRemaining(:,1) > 360)
    error('finfixed:mbscfamounts:invalidMortgageTerm',...
        sprintf(['Mortgage term is more than 360 months and is' ...
        'unsupported at this time.']));
end

% days to next payment - NOT coupon
NumDaysNext  = ...
    cpndaysn(Settle, Maturity, period, 1, 1, IssueDate);

delayInPeriod = (Delay./(360/period))./period;
FracPerNext = (NumDaysNext./(360/period) - 1)./period;

NumMBS = length(Settle);
NumCFs = max(NumCouponsRemaining(:,2))+1;

TFactors = zeros(NumMBS, NumCFs);
TFactors(:,:) = nan;
CFlowAmounts = TFactors;

for idx = 1:NumMBS
    % Build Time Factors based on CPY
    TFactors(idx,1:NumCouponsRemaining(idx,2)+1) = ...
        [0,(1:(NumCFs-1))./period + FracPerNext(idx) + delayInPeriod(idx)];
    
    % Convert to monthly time factors
    TFactors(idx,:) = TFactors(idx,:).*12;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
% CASHFLOW construction process                %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Accrued Interest is found by finding how many days
% it is since last coupon divided by days in period, or alternatively
% how many days to next coupon divided by the days in a period.

AccrInt = (1 - NumDaysNext/(360/period)).*CouponRate./period;

% Different way of expanding, and building SMM matrix
% for customized and benchmarked cases:

if customized == 1

    [Factors, Payment, Principal, Interest, Prepayment] = ...
        mbspassthrough(1, GrossRate, NumCouponsRemaining(:,1), ...
        NumCouponsRemaining(:,2), [], SMMRel);
else
    [Factors, Payment, Principal, Interest, Prepayment] = ...
        mbspassthrough(1, GrossRate, NumCouponsRemaining(:,1), ...
        NumCouponsRemaining(:,2), Speed);
end

for i = 1:NumMBS
    CFlowAmounts(i,:) = [-AccrInt(i) , ...
        (Principal(:,i)+Prepayment(:,i)+ ...
        Interest(:,i)*CouponRate(i)/GrossRate(i))'];
end

corrected_maturity = Maturity;

varargout = {CFlowAmounts, CFlowDates, TFactors, ...
    [ones(length(Settle),1) , Factors'], corrected_maturity, ...
    Payment, Principal, Prepayment, Interest};

% [EOF]
