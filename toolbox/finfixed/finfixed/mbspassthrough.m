function varargout = mbspassthrough(varargin)
%MBSPASSTHROUGH Cash flows of Passthrough securities.
%     Balances, Principal (scheduled and unscheduled),
%     and Interest payments of NMBS number of  
%     mortgage pool. If standard (PSA) prepayment is
%     is specified, "aging" will be applied to standard 
%     prepayment vector. Aging will be the same amount 
%     as age of pool (OriginalTerm minus TermRemaining).
%                   
% [Balance, Payment, Principal, Interest, Prepayment] = ... 
%   mbspassthrough(OriginalBalance, GrossRate, OriginalTerm)
%
% [Balance, Payment, Principal, Interest, Prepayment] = ... 
%   mbspassthrough(OriginalBalance, GrossRate, OriginalTerm, ... 
%               TermRemaining, PrepaySpeed)
%
% [Balance, Payment, Principal, Interest, Prepayment] = ... 
%   mbspassthrough(OriginalBalance, GrossRate, OriginalTerm, ... 
%               TermRemaining, [], PrepayMatrix)
%
% Inputs:
%  OriginalBalance - NMBSx1 vector of starting balance value 
%                    in dollars. This is the balance at the 
%                    beginning of each TermRemaining.
%
%        GrossRate - NMBSx1 vector of Gross Coupon Rate,
%                    in decimal.
%
%     OriginalTerm - NMBSx1 vector of Term of the mortgage,
%                    in months.
%
% Optional Inputs:
%    TermRemaining - NMBSx1 vector of number of FULL-TERM 
%                    between Settlement to Maturity.
%                    FULL means not including fractional 
%                    first term (if there is one).
%                    Default is set to OriginalTerm.
%
%      PrepaySpeed - NMBSx1 vector of speed relative to 
%                    PSA standard. PSA standard is 100.
%                    Default is 0 (zero) prepayment speed.
%
%     PrepayMatrix - Customized prepayment vector. A matrix of size 
%                    [max(TermRemaining) x NMBS]. Missing values are
%                    padded with NaNs.  Each column corresponds to each
%                    MBS, and each row corresponds to each month after
%                    settlement. 

%
% Outputs:
%          Balance - Balance of principal at end of month.
%
%          Payment - Total monthly payment.
%
%        Principal - Principal portion of the payment.
%
%         Interest - Interest portion of the payment.
%
%       Prepayment - Unscheduled payment of principal.
%
% Example:
% % Computing a cash flow and balances of a 3-month old mortgage
% % pool with original term of 360 months, assuming 100 PSA prepayment:
%
% OriginalBalance = 100000;
% GrossRate = 0.08125;
% OriginalTerm = 360;
% TermRemaining = 357;
% PrepaySpeed = 100;
%
% [Balance, Payment, Principal, Interest, Prepayment] = ... 
%    mbspassthrough(OriginalBalance, GrossRate, OriginalTerm, ...
%         TermRemaining, PrepaySpeed);

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.4.6.3 $  $Date: 2003/10/23 12:15:19 $
if nargin < 3
    error('finfixed:mbspassthrough:invalidInputs',['Not enough input argument, need at least OriginalBalance,' ...
            'GrossRate, and OriginalTerm']);
else
    StartingBalance = varargin{1};
    GrossRate = varargin{2};
    OriginalTerm = varargin{3};
end

if nargin < 4 | isempty(varargin{4})
    TermRemaining = OriginalTerm;
else
    TermRemaining = varargin{4};
    if TermRemaining > OriginalTerm
      error('finfixed:mbspassthrough:invalidTermRemaining','TermRemaining must be less than or equal to OriginalTerm')
    end
end

if nargin == 6
    customized = 1;
else
    customized = 0;
end

% Different way of expanding, and building SMM matrix for 
% customized and benchmarked cases:

if customized == 1    
    
    if ~isempty(varargin{5})
      error('finfixed:mbspassthrough:invalidPrepaySpeed',['Cannot use benchmark when supplying customized', sprintf('\n'),... 
             'prepayment CPR - Put empty matrices ([]) for', sprintf('\n'), ...
             '5th input arguments'])
    end
    
    % size checks
    [StartingBalance, GrossRate, OriginalTerm, TermRemaining] = ...
        finargsz(1,StartingBalance(:), GrossRate(:), OriginalTerm(:), ...
            TermRemaining(:));
    
    % check that prepayment is supplied and not empty.
    if isempty(varargin{6})
      error('finfixed:mbspassthrough:invalidPrepayMatrix',['Please supply a prepayment (SMM) matrix when',sprintf('\n'),... 
             'you do not use benchmarked prepayment'])
    else
      SMMRel = varargin{6};
    end
    
    % check the size
    if any(size(SMMRel) ~= [max(TermRemaining), length(StartingBalance)])
      error('finfixed:mbspassthrough:invalidSizeCustomPrepayMatrix','finfixed:mbspassthrough:invalidSizeCustomPrepayMatrix','Size of customized SMM must be max(OriginalTerm) x NumMBS')
    end    
    
    % BeginTerm is the age of the passthrough, 
    % rounded up to nearest integer to skip the fractional first period.      
    BeginTerm = OriginalTerm - TermRemaining + 1;
    
    % TermRemaining is rounded to the nearest lower integer
    TermRemaining = floor(TermRemaining);
    
    %Get the cash flows with no prepayment
    [Balance, Interest, Payment, Principal] = ...
        mbsnoprepay(StartingBalance, GrossRate, TermRemaining);    
        
else
           
    if nargin < 5 | isempty(varargin{5})
        Speed = 0;
    else
        Speed = varargin{5}(:);
    end
    
    % size checks
    [StartingBalance, GrossRate, OriginalTerm, TermRemaining, Speed] = ...
        finargsz(1,StartingBalance(:), GrossRate(:), OriginalTerm(:), ...
            TermRemaining(:), Speed(:));
    
    % compute benchmark prepayment vectors    
    [dummy SMM] = psaspeed2rate(Speed);        
 
    % BeginTerm is the age of the passthrough, 
    % rounded up to nearest integer to skip the fractional first period.      
    BeginTerm = OriginalTerm - TermRemaining + 1;
    
    % TermRemaining is rounded to the nearest lower integer
    TermRemaining = floor(TermRemaining);
    
    %Get the cash flows with no prepayment
    [Balance, Interest, Payment, Principal] = ...
        mbsnoprepay(StartingBalance, GrossRate, TermRemaining);
    
    NumMBS   = length(StartingBalance);
    NumMonth = size(Balance,1);
    
    %Generate Cumulative Prepayment matrix
    Qs = zeros(NumMonth, NumMBS);
    Qs(:,:) = nan;
    SMMRel = zeros(NumMonth, NumMBS);
    SMMRel(:,:) = nan;
    
    % Fill up the prepayment matrix, one column at a time:
    % Now, notice again that SMM is     
    for i = 1:NumMBS
        SMMRel(1:TermRemaining(i), i) = ...
            SMM(BeginTerm(i):OriginalTerm(i), i);  
    end    
end

oneminSMM = 1 - SMMRel;
Qs = cumprod(oneminSMM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                            %
%   Now we adjust the cash flows given the prepayment spec.  %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% All Principal Balance remaining
Balance = Balance .* Qs;

Qs(2:end,:) = Qs(1:end-1,:);
Qs(1,:) = 1;

% Total payments
Payment = Payment .* Qs;

% Scheduled (Principal) Amortization
Principal = Principal .* Qs;

% Interest portion
Interest  = Interest .* Qs;

% Unscheduled/Prepaid Principal
Prepayment = ...
 ( [StartingBalance';Balance(1:end-1,:)] - Principal ) .* SMMRel;

% Assign results to output
varargout = {Balance Payment Principal Interest Prepayment};
