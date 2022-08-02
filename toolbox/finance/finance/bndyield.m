function [Yield, Iterations] = bndyield(varargin)
%BNDYIELD Yield to maturity for a fixed income security.
%   Given NumBonds bonds with SIA date parameters and clean prices,
%   this function returns the yields to maturity.
%         
%   Yield = bndyield(Price, CouponRate, Settle, Maturity)
%
%   Yield = bndyield(Price, CouponRate, Settle, Maturity, Period,
%      Basis, EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate,
%      StartDate, Face)
%
%
%   Inputs: All required inputs must be NUMBONDSx1 or 1xNUMBONDS conforming 
%     vectors or scalar arguments. All optional arguments must be either 
%     NUMBONDSx1 or 1xNUMBONDS conforming vectors, scalars, or empty matrices.
%     Optional inputs can also be passed as empty matrices or omitted at 
%     the end of the argument list.  The value NaN in any optional input
%     invokes the default value for that entry.  Date arguments can be serial 
%     date numbers or date strings.  For SIA bond argument descriptions,
%     type "help ftb".  For a detailed  description of a particular argument,
%     for example Settle, type "help ftbSettle". 
%
%     Price (required) - Clean price
%     CouponRate (required) - Coupon rate in decimal form
%     Settle (required) - Settlement date
%     Maturity (required) - Maturity date
%
%   Optional Inputs:
%     Period - Coupons payments per year; default is 2
%     Basis - Day-count basis; default is 0 (actual/actual) 
%     EndMonthRule - End-of-month rule; default is 1 (in effect)
%     IssueDate - Bond issue date
%     FirstCouponDate - Irregular or normal first coupon date
%     LastCouponDate - Irregular or normal last coupon date
%     StartDate - Forward starting date of payments (Input ignored in 2.0)
%     Face - Face value of the bond; default is 100
%
%   Output: NumBonds by 1 vector
%     Yield - Yield to maturity with semi-annual compounding. 
%
%   Note:
%      The Price and Yield are related by the formula:
%      Price + Accrued Interest = sum( Cash Flow*(1+Yield/2)^(-Time) )
%      where the sum is over the bond's cash flows and corresponding
%      times in units of semi-annual coupon periods.
%
%   See also BNDPRICE, CFAMOUNTS.

%   Author(s): C. Bassignani, 04-25-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.13 $   $Date: 2002/04/14 21:57:29 $

% Checking input arguments 
if (nargin < 4) 
     error('You must enter Price, CouponRate, Settle, and Maturity');
end 

% Make sure Price is in column vector form
Price = varargin{1}; 
Price = Price(:);

% Scale up the arguments and set defaults
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,...
      LastCouponDate, StartDate, Face] = instargbond(varargin{2:end});

% The scalar expansion done inside instargbond may not be 
% correct since it doesn't consider "Price". Make another
% scalar expansion to make sure sizes are appropriate.
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,...
      LastCouponDate, StartDate, Face, Price] = finargsz(1, CouponRate, Settle, Maturity, Period,...
   Basis, EndMonthRule, IssueDate, FirstCouponDate,LastCouponDate, StartDate, Face, Price);

NumBonds = length(Price);

% Use semi-anual compounding frequency for yields
Frequency = 2*ones(NumBonds,1);

%----------------------------------------------------------------------
% Call cfamounts for bond cash flows, accrued interest, and time factors
%
% Put the price in CFlowAmounts so that it carries all the cash
% flow information for every bond.  Price is negative because you pay
% price and accrued interest.
%
% The first and maturity coupon payments may be irregular
%
% Intermediate coupons exist:
% row of CFlowAmounts: -P-AI, Cpn1,  Cpn, ....  Cpn, CpnM + Face
% row of TFactors:       0    Tc1,   Tc2, ....  Tck,     Tm
%
% Only one payment at maturity
% row of CFlowAmounts: -P-AI, Cpn + Face
% row of TFactors:       0       Tm
%----------------------------------------------------------------------
[CFlowAmounts, CFlowDates, TFactors] = cfamounts(CouponRate, ...
    Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
    FirstCouponDate, LastCouponDate, StartDate, Face);

CFlowAmounts(:,1) = CFlowAmounts(:,1) - Price;

% CFlowAmounts and TFactors now carry all the important information
% Rows of CFlowAmounts are padded with NaN values after cash flows end

% Count the number of cash flow entries in each bond
NumCFs = sum(~isnan(CFlowAmounts), 2);

%----------------------------------------------------------------------
% Solve for the periodic discount which makes the present value of
% the cash flow set equal to zero.
%
% PerDisc     : Periodic discount rate 1/( 1 + Yield/Frequency )
% PV          : Present Value of Cash flows
% 
% PV = CFSettle + CFCoupon1 * PerDisc^(TFCoupon1) +
%                 CFCoupon2 * PerDisc^(TFCoupon1) + 
%                 CFCoupon3 * PerDisc^(TFCoupon3) + ...
%                 CFCouponK * PerDisc^(TFCouponK) + 
%      CFMaturity * PerDisc^(TFMaturity)
%
% Variables for each bond
%
% C = [ CFSettle, CFCoupon1, CFCoupon2, ..., CFCouponK, CFMaturity ]
% T = [    0    , TFCoupon1, TFCoupon2, ..., TFCouponK, TFMaturity ]
% X = PerDisc
%
% Newton-Raphson Iteration Variables
% PV     : Present Value of cash flows
% dPVdX  : Derivative of PV with respect to X
% DeltaX : Change in approximate discount in current step
%
% TolXAbs  : stop when change becomes smaller than TolXAbs
% TolXRel  : stop when change/X becomes smaller than TolXRel
% TolPRel  : stop when PV/max(C) becomes smaller than TolPRel
% 
%----------------------------------------------------------------------

% Start out with NaN
PerDisc = NaN*ones(NumBonds,1);
Iterations = NaN*ones(NumBonds,1);

% Initial Guess for the discount based on Yield = Coupon Rate
% Allow backup initial Guesses
XGuess = ones(NumBonds,3);

CouponRate(isnan(CouponRate)) = 0;
XGuess(:,1) = 1./( 1 + CouponRate./Frequency );

% Second guess for very high yields
% Insure X^max(T) > 100*eps
TFactors(isnan(TFactors)) = 0;
XGuess(:,2) = max(100*eps, (100*eps).^( 1./max(TFactors,[],2) ));

% Third guess for very low yields
XGuess(:,3) = 1;

NumStarts = size(XGuess,2);

for i=1:NumBonds,
  
  % Get the vectors of cash flows and times for this bond
  C = CFlowAmounts( i, 1:NumCFs(i) );
  T =     TFactors( i, 1:NumCFs(i) );
  
  % Stopping parameters
  CMax = max(abs(C));
  TolPRel = 1e-12;
  TolXRel = 1e-12;
  TolXAbs = 1e-12;
  MaxIterations = 50;
  
  % Try different initial guesses if the first fail to converge
  for jStart = 1:NumStarts,
    
    % Initial values
    X = XGuess(i,jStart);
    k = 1;
    
    XAbs = Inf;
    XRel = Inf;
    PRel = Inf;
    % Enforce all stopping conditions (not any)
    while( ( XAbs > TolXAbs ) | ...
           ( XRel > TolXRel ) | ...
           ( PRel > TolPRel ) )
      
      % compute guess update

      PV    = sum( C .* (X.^T) );
      dPVdX = sum( C .* (X.^(T-1)) .* T );
      
      DeltaX = -PV/dPVdX;
      
      if ( ~isreal(DeltaX) | k > MaxIterations )
        % exit the iteration with failure
        X = NaN;
        break;
      end

      % update the iteration
      X = X + DeltaX;
      k = k + 1;
      
      % convergence criteria
      XAbs = abs(DeltaX);
      XRel = abs(DeltaX/X);
      PRel = abs(PV/CMax);

    end % end of Newton-Raphson Iteration
    
    if ~isnan(X)
      % don't start again if an answer was found
      break;
    end
    
  end % loop back and try another starting guess
    
  % assign result to PerDisc
  PerDisc( i ) = X;
  Iterations( i ) = k - 1;

end % end of loop over bonds
    
%----------------------------------------------------------------------
% Compute Yield from the periodic discount factors
%----------------------------------------------------------------------
Yield = ( 1./PerDisc - 1 ).*Frequency;

