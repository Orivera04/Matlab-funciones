function varargout = mbsyield2speed(varargin)
%MBSYIELD2SPEED Implied PSA prepayment speed given yields.
%     Calculate PSA prepayment speed implied by pool yields 
%     and projected (user-defined) prepayment vectors.
%     The calculated PSA speed will produce the same yield, 
%     modified duration, or modified convexity depending on
%     output requested.
%
% [ImpSpdOnYld, ImpSpdOnDur, ImpSpdOnCnv] = ...
%   mbsyield2speed(Yield, Settle, Maturity, ...
%       IssueDate, GrossRate, PrepayMatrix)
%
% [ImpSpdOnYld, ImpSpdOnDur, ImpSpdOnCnv] = ...
%   mbsyield2speed(Yield, Settle, Maturity, ...
%       IssueDate, GrossRate, PrepayMatrix, CouponRate, Delay);
%
% Inputs:
%             Yield - NMBSx1 vector of mortgage yield,
%                     in decimal and monthly compounded.
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
%
% Optional Inputs:
%        CouponRate - NMBSx1 vector of Net Coupon Rate, 
%                     in decimal. 
%                     Default is equal to GrossRate. 
%              
%             Delay - NMBSx1 vector of delay in days.
%
% Outputs:
%       ImpSpdOnYld - Calculated equivalent PSA benchmark prepayment 
%                     speed for the passthrough to carry the same 
%                     yield.
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
% Yield     = 0.065;
% Settle    = datenum('01-Jan-2000');
% Maturity  = datenum('01-Jan-2030');
% IssueDate = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% PrepayMatrix = 0.005*ones(360,1);
% CouponRate = 0.075;
% Delay = 14;
%
% [ImpSpdOnYld, ImpSpdOnDur, ImpSpdOnCnv]  = ...
%    mbsyield2speed(Yield, Settle, Maturity, IssueDate, ...
%       GrossRate, PrepayMatrix, CouponRate, Delay)

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision 1.3 $  $Date: 2004/04/06 01:09:01 $

if nargin > 8
    error('finfixed:mbsyield2speed:invalidMoreInputs',['Too many input arguments.', sprintf('\n'), ... 
           'Type "help mbsyield2speed" for information.'])
end

if nargin < 6
    error('finfixed:mbsyield2speed:invalidLessInputs',['Need at least Yield, Settle, Maturity, ',... 
           sprintf('\n'), ...
           'IssueDate, GrossRate, and PrepayMatrix.'])
else
    Yield     = varargin{1};
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

% Call mbscfamounts to get the Amounts and Time 
% the cash flows occuring when own prepayment is used

[Yield, Settle, Maturity, IssueDate, GrossRate, ...
        CouponRate, Delay] = ...
    finargsz(1, Yield(:), Settle(:), Maturity(:), ...
        IssueDate(:), GrossRate(:), CouponRate(:), Delay(:));
    
% Check and Expansion of SMMREl
colSMM = size(SMMRel,2);

if colSMM ~= length(Yield)
    if colSMM == 1
      % use Tony's trick to expand into multiple columns
      SMMRel = SMMRel(:,ones(length(Yield),1));
    else
      error('finfixed:mbsyield2speed:invalidPrepayMatrix',['Size inconsistency, The number of column', sprintf('\n'),...
         'in prepayment matrix must be equal to number of passthrough']);
    end
end

% Obtain the Cashflows and their precise timing in # of months    
[CFlowAmounts dummy TFactors Factor] = mbscfamounts(Settle, Maturity, ...
   IssueDate, GrossRate, CouponRate, Delay, [], SMMRel);

% Accrued interest is the first element of CFlowAmounts
AccrInt = -CFlowAmounts(:,1);

NumCF = size(CFlowAmounts, 2);

% Calculate the clean price
PerDisc = (1+Yield(:, ones(NumCF,1))/12).^(-TFactors);

% Compute the present value of every cash flow (including accrued
% interest payment at settlement)
CFlowPVs = CFlowAmounts .* PerDisc;
CFlowPVs( isnan(CFlowPVs) ) = 0;

% Sum the present value cash flows along the rows to get the price
Price = sum(CFlowPVs,2);

P = Price + AccrInt;

semiyld = 2*((1+Yield/12).^6 - 1); % BE Yield

% change nan to zero
CFlowAmounts(isnan(CFlowAmounts))=0;
TFactors(isnan(TFactors))=0;

mduration = 1./P .* sum([((TFactors/12).*CFlowAmounts./...
        (1+semiyld(:,ones(NumCF,1))/2).^(TFactors/6))],2);

NumMBS = length(Yield);

% Initial guess is 100% of PSA benchmark
Speed0 = 100*ones(NumMBS,1);

%Annualizing time
Anntime = TFactors/12;

CFlowAmounts(:,1) = CFlowAmounts(:,1) - Price;
mconvexity = 1./((1+semiyld/2).^2)./(-CFlowAmounts(:,1)) .* ...
  (sum([Anntime.*(Anntime+0.5).*CFlowAmounts./...
      ((1+semiyld(:,ones(NumCF,1))/2).^(2*Anntime))],2));

% Solve for Speed where the 
% Price(PSASpeed) - Price = 0
% mduration(PSASpeed) - mduration = 0
% mconvexity(PSASpeed) - mconvexity = 0;
option = optimset('Display','off');

SpeedPrc = fsolve(@mbsintfun1, Speed0, option, Price*100, Settle, ...
    Maturity, IssueDate, GrossRate, CouponRate, Delay, Yield);

SpeedDur = fsolve(@mbsintfun2, Speed0, option, Price*100, Settle, ...
    Maturity, IssueDate, GrossRate, CouponRate, Delay, mduration);

SpeedCnv = fsolve(@mbsintfun3, Speed0, option, Price*100, Settle, ...
    Maturity, IssueDate, GrossRate, CouponRate, Delay, mconvexity);

varargout = {SpeedPrc; SpeedDur; SpeedCnv};


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

mduration_guessed = mbsdurp(Price, Settle, Maturity, ...
    IssueDate, GrossRate, CouponRate, Delay, Speed);

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
