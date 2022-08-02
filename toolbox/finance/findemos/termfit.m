function [ZeroRates, CurveDates, BootZeros, BootDates, BreakDates] = termfit(...
    Smooth, Bonds, Prices, Settle, OutputCompounding, OutputBasis, ...
    CurveDates, BreakDates)
%TERMFIT Fitted smoothed zero curve from coupon bond prices.
%
%   [ZeroRates, CurveDates, BootZeros, BootDates, BreakDates] = termfit(...
%      Smoothing, Bonds, Prices, Settle, ...
%      OutputCompounding, OutputBasis, CurveDates, BreakDates)
%
%   Summary: 
%     TERMFIT fits a smooth curve to the interest term structure implied by the
%     market prices of a collection of bonds.  The fitted term structure does not
%     price the bonds exactly, but rather assumes some noise in the market prices.
%     The parameter SMOOTHING controls the tradeoff between the smoothness of the
%     forward curve and the error in pricing the input bonds.
% 
%   Inputs: 
%     Smoothing - scalar value, 0 <= Smoothing <= 1, indicating how much smoothing
%     to use.  Smoothing = 0 results in the least error in pricing the bonds.
%     Smoothing = 1 results in the straightest fit.
%
%     Bonds - the portfolio of coupon bonds from which the zero curve will be 
%       derived; specifically, an NxM matrix of bond parameters where each row of
%       the matrix corresponds to an individual bond and each column corresponds
%       to a particular parameter; the required columns (parameters) for this
%       matrix are:
%         Maturity - (Column 1) the maturity for each bond in the  portfolio in
%           serial date number form
%         CouponRate - (Column 2) the coupon rate for each bond in the portfolio
%           in decimal form
%         Optional columns (parameters) are:
%           Face - (Column 3) face value of each bond in the portfolio;
%             the default is $100
%           Period - (Column 4) the number of coupon payments per year in integer
%             form; possible values are 1, 2 (default), 3, 4, 6, 12
%           Basis - (Column 5) values specifying the basis for each bond in the
%             portfolio; possible values are:
%             1) Basis = 0 - actual/actual(default)
%             2) Basis = 1 - 30/360
%             3) Basis = 2 - actual/360
%             4) Basis = 3 - actual/365
%           EndMonthRule - (Column 6) value specifying whether or no the
%             "end of month rule" is in effect for each bond contained in the
%             portfolio; possible values are:
%             1) EndMonthRule = 1 (default) - rule is in effect for the bond
%                (meaning that a security which pays coupon interest on the
%                last day of the month will always make a payment on the last
%                day of the month)
%             2) EndMonthRule = 0 - rule is NOT in effect for the bond
%
%     Prices -  Nx1 column vector containing price values for each bond in the
%       portfolio represented by the Bonds matrix
%
%     Settle - scalar value representing time zero in derivation of the zero curve;
%       normally this is also the settlement date for the bonds in the portfolio
%
%     OutputCompounding - scalar value representing the period by which the output
%       zero rates will be compounded; the default value is semi-annual (i.e. "2")
%       compounding 
%
%     OutputBasis - scalar value representing the basis used to map cash flow dates
%       to years in determining the output zero rates; possible values are:
%       1) Basis = 0 - actual/actual(default)
%       2) Basis = 1 - 30/360
%       3) Basis = 2 - actual/360
%       4) Basis = 3 - actual/365
%
%     CurveDates -  NumOut x 1 column vector of serial dates at which to report the
%       fitted zero rates.  The default is the set of dates on which any bond in 
%       the portfolio has a cash flow.
%
%     BreakDates -  NumBreaks x 1 column vector of dates between settlement and the
%       longest bond maturity.  The instantaneous forward curve is piecewise cubic
%       in the intervals between BreakDates.  The settlement date and the last
%       maturity date are automatically included in the set of breaks if they are
%       not in BreakDates.
%
%   Outputs: 
%     ZeroRates - NumOut x 1 vector containing the values for the fitted zero rates
%       for each point along the investment horizon defined by a maturity date
%     CurveDates - NumOut x 1 vector containing the maturity date for each zero rate 
%       along the investment horizon (from time T = Settle to time T = maturity of
%       the longest dated bond in the source portfolio) 
%     BootZeros - NumBootx1 vector containing bootstrapped zero rates at the bond
%       maturities which price the input portfolio correctly.  The BootZeros curve
%       is not smoothed at all.  See ZBTPRICE for the description of the
%       bootstrapping method.
%     BootDates - NumBoot x 1 vector containing the maturity dates for the
%       bootstrapped zero curve.
%     BreakDates -  Vector of breaks which were used to construct the spline
%       representation of the forward curve.
%
%   Notes: 
%     TERMFIT fits a smoothed cubic spline to the forward rate curve.  Getting a 
%     good curve depends on a judicious choice of SMOOTHING and the breakpoints
%     between cubic sections.  Experimentation is in order to set the parameters
%     for a particular data set.
%         
%     The curve-fitting model embodied in this program is that described by Mark
%     Fisher, Douglas Nychka and David Zervos in Finance and Economics Discussion
%     Series Working Paper # 95-1, published by the Division of Research and
%     Statistics, Division of Monetary Affairs, Federal Reserve Board, 
%     Washington, D.C.
%
%     This function requires the Spline Toolbox.  
%
%   See also ZBTPRICE, ZBTYIELD, ZERO2FWD, FWD2ZERO, ZERO2DISC, DISC2ZERO,
%            ZERO2PYLD PYLD2ZERO.

%   Author(s): D. Eiler, 02-12-97, J. Akao 12/01/97
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.9.2.2 $   $Date: 2004/04/06 01:07:06 $

if nargin < 4
   error('You must enter at least Smooth, Bonds, Prices, and Settle')
end

if Smooth < 0 | Smooth > 1
   error('Smooth must be >= 0 and <= 1.');
end

NumCols = size(Bonds,2);
if NumCols < 2
   error('Bonds must contain at least Maturity and Coupon rate columns');
end
if NumCols > 6
   error('Bonds has too many columns');
end

NumBonds = size(Bonds, 1);
Col = ones(NumBonds, 1);
DefaultCols = [100*Col 2*Col 0*Col 1*Col];

Bonds = [Bonds DefaultCols(:, (NumCols - 1):4)];

Prices = Prices(:);

if (nargin < 5), OutputCompounding = 2; end

if ~any(OutputCompounding==[-1 1 2 3 4 6 12])
  error('Invalid Outputcompounding specified');
end

if (nargin < 6), OutputBasis = 0; end

% check Curvedates (nargin == 7) after the cash flow dates are known

if (nargin < 8 | isempty(BreakDates) )
  BreakMonths = [0 6 12 36 60 120 240 300 360];
  BreakDates = datemnth(Settle*ones(size(BreakMonths)), BreakMonths, ...
    zeros(size(BreakMonths)), OutputBasis);
end
  
%-------------------------------------------------------------------------
% Sort the bonds by maturity
[Temp, DateInd] = sort(Bonds(:, 1));
Bonds = Bonds(DateInd, :);
Prices = Prices(DateInd);

%Get parameters from Bonds matrix
Maturity = Bonds(:, 1);
CouponRate = Bonds(:, 2);
Face = Bonds(:, 3);
Period = Bonds(:, 4);
Basis = Bonds(:, 5);
EndMonthRule = Bonds(:, 6);

% Rescale the bonds by dividing by face value.
Prices = Prices./Face;
Face(:) = 1;
Bonds(:,3) = Face;

%-------------------------------------------------------------------------
% Accrued interest (fraction of a coupon payment)
AccPerFrac = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule);
AccruedInt = AccPerFrac .* Face.*CouponRate./Period;

% Dirty Price (Price + AccruedInt) (present value of cash flows)
DP = Prices + AccruedInt;

%-------------------------------------------------------------------------
% Get all the cash flows and dates of the bond portfolio
% CFBondDate(i,j) = cash flow from ith bond on CashFlowDates(j).
[CFBondDate, CashFlowDates] = mapcflows(Bonds, Settle);
NumCashFlows = length(CashFlowDates);

% Map the cash flow dates to times in the output basis
CashFlowYears = yearfrac(Settle, CashFlowDates, OutputBasis);

%-------------------------------------------------------------------------
% The forward rate curve F(t) is represented by a natural spline
%   with breaks at t = BreakYears.
% The forward rate curve is integrated to form RT(t) = int_0^t F(s) ds
%   RT(0) = 0.  If rates were constant at r, RT(t) would equal r*t;
% The discount at time t is Disc(t) = exp( - RT(t) )

% Use cubic splines
SplineOrder = 4;

% Make Settle and the last maturity the first and last breaks for the spline
BreakDates = BreakDates(:);
BreakDates = BreakDates( (Settle < BreakDates) & ...
    (BreakDates < Maturity(end) ) );
BreakDates = [Settle; BreakDates; Maturity(end)];

% Map the breaks in BreakDates to times in the output basis
BreakYears = yearfrac(Settle, BreakDates, OutputBasis);

% F(t) and RT(t) are formed from a basis of B-splines.  
% The vector, beta, contains the coefficients of each B-spline.
% The breaks are taken as a row vector
SplineKnots = augknt(BreakYears', SplineOrder);
NumBSplines = length(SplineKnots) - SplineOrder;

% Create the B-Spline collocation matrix, F_i(t), i=1:NumBSplines, t=CashFlowYears
% FwdSplineBasis: structure of NumBSplines basis functions for F
FwdSplineBasis = spmak(SplineKnots, eye(NumBSplines)); 

% Evaluate every integrated basis function at each cash flow date
% RTBasisVals [NumCashFlows by NumBSplines]
% RT [NumCashFlows by 1] = RTBasisVals * Beta [NumBSplines by 1]
RTBasisVals = fnval( fnint(FwdSplineBasis), CashFlowYears')';

% Build the matrix, H, the integral of the squared second derivative of the B-Splines
% This is not a linear functional JHA 11/29/97
H = makeh(SplineKnots, SplineOrder);

% Build the matrix B2P [NumBonds by NumBSplines ] mapping beta to price space
B2P = CFBondDate*RTBasisVals;

%-------------------------------------------------------------------------
% Fit the Zeroboot model to bond prices to get starting zero rates as basis
% for the starting guess for Beta. 
if nargout > 3
   BootInd = [1:NumBonds];
else
   BootNum = 10;
   BootInd = unique(floor(linspace(1, NumBonds, BootNum)));
end

% bootstrap to the subset of bonds
BootComp = Bonds(1,4);
[BootZeros, BootDates] = zbtprice(...
    Bonds(BootInd,:), Prices(BootInd), Settle, BootComp, OutputBasis);
BootYears = yearfrac(Settle, BootDates, OutputBasis);

% linearly interpolate rates to the cash flows.  Use the first
% rate for all cash flows before the first zero maturity
ZeroRates = interp1([0;BootYears], ...
    [BootZeros(1);BootZeros], CashFlowYears);

% transform the zero rates to a guess for RT (continuous comp)
% exp(-RT) = (1+Z/f)^(-T*f), f=BootComp
RTGuess = BootComp*log(1 + ZeroRates/BootComp).* CashFlowYears;

%-------------------------------------------------------------------------
% Set starting values for Beta
% Least squares fit to RTBasisVals*Beta0 = RTGuess 
Beta0 = RTBasisVals \ RTGuess;

%-------------------------------------------------------------------------
% Main Non-Linear Least-Squares loop, on Beta.

% This algorithm looses touch with the data if Smooth = 1
% Set Smooth nearly 1 to fit a straight line F(t)
Smooth = min(Smooth, 1-100*NumBSplines*eps);

% 1/Maximum condition number of NumBSplines solve in the inner loop
RelDropTol = 10*eps*NumBSplines;

% Beta iteration parameters
ErrorTol = 1.0e-4;
IterationMax = 1000;

PriceError = inf;
BetaChange = inf;
IterationCount = 0;
while (BetaChange > ErrorTol) & (IterationCount <= IterationMax)
   
  % Current RT and discount curves
  RT = RTBasisVals*Beta0;
  Disc = exp(-RT);
  
  % Present value of the cash flows
  PVCF = CFBondDate * Disc;

  % Build the matrix, dPI, as in the Fed. Paper 
  dPI = - PVCF(:, ones(1,NumBSplines)).* B2P;

  X = dPI; % Rename, to match the Fed. paper.
   
  % Revise the estimate of Beta.
  Y = DP - PVCF + X*Beta0;

  % Do a least squares fit to the equation:
  %( (1-Smooth)*X'*X + Smooth*H )*Beta = (1-Smooth)*X'*Y
  % matrix is NumBSplines by NumBSplines so SVD is not too slow
  [U,SigmaM,V] = svd( (1-Smooth)*X'*X + Smooth*H );
  Sigma = diag(SigmaM);
  Sigma( abs(Sigma) < RelDropTol*Sigma(1) ) = Inf;
  Beta = V*diag(1./Sigma)*U'* ( (1-Smooth)*X'*Y );

  % Calculate the change in the norm of Beta
  BetaChange = norm(Beta-Beta0)/norm(Beta0);
   
  % Update iteration 
  Beta0 = Beta;
  IterationCount = IterationCount + 1;
end

if IterationCount >= IterationMax
   warning('Maximum iteration reached.');
end

%-------------------------------------------------------------------------

% Spline structure form of the forward curve
FWDSpline = spmak( SplineKnots , Beta' );

%-------------------------------------------------------------------------
% Evaluate the spline at output times

if ( (nargin < 7) | isempty(CurveDates) ),
  CurveDates = CashFlowDates;
  CurveYears = CashFlowYears;
else
  CurveYears = yearfrac(Settle, CurveDates(:), OutputBasis);
end
  
% Discounts at CurveYears
RT = fnval( fnint(FWDSpline), CurveYears')';
Disc = exp(-RT);

ZeroRates = disc2zero(Disc, CurveDates(:), Settle, ...
    OutputCompounding, OutputBasis);

% End of function, TERMFIT


function H = makeh(Knots, Order)
% MAKEH Builds the matrix H. 
%       H = MAKEH(Knots, Order) returns in H, the integral of the squared
%       second derivative of the B-Splines.
%
%		Notes: This is a utility function of TERMFIT and is not intended 
%                to be called by itself in this form.

%   Author(s) : D. Eiler, 09-30-96

NumIntervals = 100;
NumKnots = length(Knots);

Interval = (Knots(NumKnots)-Knots(1))/NumIntervals;
IntDates = Knots(1):Interval:Knots(NumKnots);

Spline = spmak(Knots, eye(length(Knots)-Order));
D2Spline = fnder(Spline, 2);
D2SplineMat = fnval(D2Spline, IntDates)';

NumBSplines = size(D2SplineMat, 2);
NumIntDates = length(IntDates);

H = zeros(NumBSplines, NumBSplines);

for i = 1:NumIntDates
   H = H + D2SplineMat(i, :)'*D2SplineMat(i, :);
end

H = H*Interval;

% end of function makeH


function [CFBondDate, AllDates, IndexByBond] = mapcflows(Bonds, Settle)
% MAPCFLOWS Vector of all cash flows of a bond portfolio and a matrix
% of cash flows by bond and date.
% [CFBondDate, AllDates, IndexbyBond] = mapcflows(Bonds, Settle)
% AllDates : list of all dates that have any cash flow in the portfolio
% CFBondDate : ith row contains the cash flows on DateSet from the ith bond 
%

% J. Akao 11/29/97

% Map the bond cash flows to the set of all cash flow dates.
[IndexByBond, AllDates] = mapcfdates(Bonds, Settle);
NumCFbyBond = sum(~isnan(IndexByBond),2);

% Find the magnitude of the cash flows
% CouponPayment = Face*CouponRate/CouponPeriod
Face = Bonds(:,3);
CouponPayment = Face.*Bonds(:,2)./Bonds(:,4);

% Create a matrix of cash flows
NumBonds = size(IndexByBond,1);
NumDates = length(AllDates);
CFBondDate = zeros(NumBonds, NumDates);
for i=1:NumBonds,
  % Add the coupon payments
  CFBondDate( i, IndexByBond(i,1:NumCFbyBond(i)) ) = ...
      CFBondDate( i, IndexByBond(i,1:NumCFbyBond(i)) ) + ...
      CouponPayment(i);

  % Add the bond Face
  CFBondDate( i, IndexByBond(i,NumCFbyBond(i)) ) = ...
      CFBondDate( i, IndexByBond(i,NumCFbyBond(i)) ) + ...
      Face(i);
end
  
% end of function MAPCFLOWS

function [IndexByBond, AllDates] = mapcfdates(Bonds, Settle)
%MAPCFDATES Vector of all cash flow dates of a bond portfolio.  
% [IndexByBond, AllDates] = mapcfdates(Bonds, Settle)
% 

% J. Akao 11/29/97

if (size(Bonds, 2) < 6)
   error('Bonds matrix must have 6 columns!');
end

% Cash flow dates for each bond in the portfolio
% The i'th row is a list of dates (padded by NaN's) for the i'th bond
DateMat = cfdates(Settle, Bonds(:, 1), Bonds(:, 4), Bonds(:, 5), Bonds(:, 6));
DateMask = ~isnan(DateMat); % mask for date entries in DateMat

[AllDates, I, IndexList] = unique(DateMat(DateMask));

%Change IndexList from a vector of all dates to a matrix by bond
IndexByBond = NaN*ones(size(DateMat));
IndexByBond(DateMask) = IndexList;

%end of the MAPCFDATES subroutine

