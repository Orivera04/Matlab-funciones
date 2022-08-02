function varargout = mbsprice2speed(varargin)
%MBSPRICE2SPEED Implied PSA prepayment speed given price.
%     Calculate PSA prepayment speed implied by pool prices 
%     and projected (user-defined) prepayment vectors.
%     The calculated PSA speed will produce the same price, 
%     modified duration, or modified convexity depending on
%     output requested.
%
% [ImpSpdOnPrc, ImpSpdOnDur, ImpSpdOnCnv] = ...
%   mbsprice2speed(Price, Settle, Maturity, ...
%       IssueDate, GrossRate, PrepayMatrix)
%
% [ImpSpdOnPrc, ImpSpdOnDur, ImpSpdOnCnv] = ...
%   mbsprice2speed(Price, Settle, Maturity, ...
%       IssueDate, GrossRate, PrepayMatrix, CouponRate, Delay);
%
% Inputs:
%             Price - NMBSx1 vector of clean price for every $100 
%                     face of bond issue.
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
%      PrepayMatrix - Customized prepayment vector. A matrix of size 
%                     [max(TermRemaining) x NMBS]. Missing values are
%                     padded with NaNs.  Each column corresponds to each
%                     MBS, and each row corresponds to each month after
%                     settlement. 
%
% Optional Inputs:
%        CouponRate - NMBSx1 vector of Net Coupon Rate, 
%                     in decimal. 
%                     Default is equal to GrossRate. 
%              
%             Delay - NMBSx1 vector of delay in days.
%
% Outputs:
%       ImpSpdOnPrc - Calculated equivalent PSA benchmark prepayment 
%                     speed for the passthrough to carry the same 
%                     Price
%
%       ImpSpdOnDur - Calculated equivalent PSA benchmark prepayment 
%                     speed for the passthrough to carry the same 
%                     modified duration.
%
%       ImpSpdOnCnv - Calculated equivalent PSA benchmark prepayment 
%                     speed for the passthrough to carry the same 
%                     modified convexity.
%
% Example:
% Price     = 101;
% Settle    = datenum('01-Jan-2000');
% Maturity  = datenum('01-Jan-2030');
% IssueDate = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% PrepayMatrix = 0.005*ones(360,1);
% CouponRate = 0.075;
% Delay = 14;
%
% [ImpSpdOnPrc, ImpSpdOnDur, ImpSpdOnCnv] = ...
%   mbsprice2speed(Price, Settle, Maturity, ...
%      IssueDate, GrossRate, PrepayMatrix, CouponRate, Delay)
%
% Note: This function is PSA compliant. 
%       Reference: PSA Uniform Practices, SF-49

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision 1.3 $  $Date: 2004/04/06 01:08:57 $

if nargin > 8
    error('finfixed:mbsprice2speed:invalidMoreInputs','Too many input arguments. Type "help mbsprice2speed" for information.')
end

if nargin < 6
  error('finfixed:mbsprice2speed:invalidLessInputs','Need at least Price, Settle, Maturity, IssueDate, GrossRate, and PrepayMatrix')
else
    Price     = varargin{1};
    Settle    = datenum(varargin{2});
    Maturity  = datenum(varargin{3});
    IssueDate = datenum(varargin{4});
    GrossRate = varargin{5}(:);
    SMMRel = varargin{6};    
end

if nargin <7 | isempty(varargin{7})
    CouponRate = GrossRate;
else
    CouponRate = varargin{7}(:);
end

if nargin <8 | isempty(varargin{8})
    Delay = 0;
else
    Delay = varargin{8}(:);
end

% Call mbscfamounts to get the Amounts and Time the 
% cash flows occuring when own prepayment is used
[Price, Settle, Maturity, IssueDate, GrossRate, ...
        CouponRate, Delay] = ...
    finargsz(1,Price(:), Settle(:), Maturity(:), ...
        IssueDate(:), GrossRate(:), CouponRate(:), Delay(:));

% Check and Expansion of SMMREl
colSMM = size(SMMRel,2);

if colSMM ~= length(Price)
    if colSMM == 1
        % use Tony's trick to expand into multiple columns
        SMMRel = SMMRel(:,ones(length(Price),1));
    else
        error('finfixed:mbsprice2speed:invalidPrepayMatrix',['Size inconsistency, The number of column', sprintf('\n'),...
              'in prepayment matrix must be equal to number of passthrough']);
    end
end    
    
% Obtain the Cashflows and their precise timing in # of months    
[CFlowAmounts dummy TFactor Factor] = mbscfamounts(Settle, Maturity, IssueDate, ...
    GrossRate, CouponRate, Delay, [], SMMRel);

% Provde initial guess of discount == Par yield
x0 = 1./(1+CouponRate/12);

% Subtract clean/quoted Price into the accrued 
% interest to get NPV = 0
CFlowAmounts(:,1) = CFlowAmounts(:,1) - Price/100;

[NumMBS, NumCF] = size(CFlowAmounts);

option1 = optimset('Display','off');
X = fsolve(@mbsintfun0, x0, option1, CFlowAmounts, TFactor, NumCF);

mbsyld = ( 1./X - 1 ).*12; % Mortgage Yield
semiyld = 2*((1+mbsyld/12).^6 - 1); % BE Yield

%Annualizing time
Anntime = TFactor/12;

mconvexity = 1./((1+semiyld/2).^2)./(-CFlowAmounts(:,1)) .* ...
  (sum([Anntime.*(Anntime+0.5).*CFlowAmounts./...
      ((1+semiyld(:,ones(NumCF,1))/2).^(2*Anntime))],2));

% Calculate duration take the clean price out again 
% once yield is done computed.
P = -CFlowAmounts(:,1);

CFlowAmounts(:,1) = CFlowAmounts(:,1) + Price/100;
mduration = 1./P .* ...
    sum([((TFactor/12).*CFlowAmounts./...
        (1+semiyld(:,ones(NumCF,1))/2).^(TFactor/6))],2);

% Initial guess is 100% of PSA benchmark
Speed0 = 100*ones(NumMBS,1);

% Solve for Speed where the 
% mduration_PSA(Speed) - mduration = 0

option = optimset('Display','off');

SpeedPrc = fsolve(@mbsintfun1, Speed0, option, Price, Settle, ...
    Maturity, IssueDate, GrossRate, CouponRate, Delay, mbsyld);

SpeedDur = fsolve(@mbsintfun2, Speed0, option, Price, Settle, ...
    Maturity, IssueDate, GrossRate, CouponRate, Delay, mduration);

SpeedCnv = fsolve(@mbsintfun3, Speed0, option, Price, Settle, ...
    Maturity, IssueDate, GrossRate, CouponRate, Delay, mconvexity);

varargout = {SpeedPrc; SpeedDur; SpeedCnv};

function y = mbsintfun0(x,CF,TF,b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                %
% Internal subfunction to compute discounts      %
% and thus yield to maturity                     %
%                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dcf = CF .* x(:, ones(b,1)).^TF;
dcf(isnan(dcf))= 0;
y = sum(dcf,2);

function y = mbsintfun1(Speed, Price, Settle, Maturity, ...
    IssueDate, GrossRate, CouponRate, Delay, Yield) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% Internal subfunction to compute Speed                  %
% This will be iteratively solved such that              %
% Price_guessed == Price of passthrough                  %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Price_guessed = mbsprice(Yield, Settle, Maturity, ...
    IssueDate, GrossRate, CouponRate, Delay, Speed);

y = Price_guessed - Price;


function y = mbsintfun2(Speed, Price, Settle, Maturity, ...
    IssueDate, GrossRate, CouponRate, Delay, mduration)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% Internal subfunction to compute Speed                  %
% This will be iteratively solved such that              %
% mduration_guessed == mduration of passthrough          %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The unknown is speed (remember, the model is PSA)
[mduration_guessed] = mbsdurp(Price, Settle, Maturity, IssueDate, GrossRate, ...
    CouponRate, Delay, Speed);

y = mduration_guessed - mduration;


function y = mbsintfun3(Speed, Price, Settle, Maturity, ...
    IssueDate, GrossRate, CouponRate, Delay, mconvexity) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
% Internal subfunction to compute Speed                  %
% This will be iteratively solved such that              %
% mduration_guessed == mduration of passthrough          %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mconvexity_guessed = mbsconvp(Price, Settle, Maturity, ...
    IssueDate, GrossRate, CouponRate, Delay, Speed);

y = mconvexity_guessed - mconvexity;
