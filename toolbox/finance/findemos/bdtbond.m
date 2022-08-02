function [Price, Sensitivities, DiscTree, PriceTree] = bdtbond(IBond, ZeroCurve, VolatilityCurve, Accuracy, CreditCurve, ComputeSensitivity)
%BDTBOND Black-Derman-Toy pricing of option-embedded bonds
%  Computes price and sensitivity measures of a bond with embedded
%  call or put options.  Valuation is based on the Black-Derman-Toy
%  model for pricing interest rate options given an input yield
%  curve (and possibly a credit spread) and volatility curve.
%
%  [Price, Sensitivities, DiscTree, PriceTree] = bdtbond(OptBond, ...
%    ZeroCurve, VolatilityCurve, Accuracy, CreditCurve, ComputeSensitivity)
%
%  The arguments other than Accuracy are structures.  The name of
%  the argument variable can be substituted, but the fieldnames
%  must be reproduced exactly.  The variables and the fields are
%  listed below in Variable.fieldname format.  An optional field or
%  variable may be set to the empty matrix [] to invoke defaults.
%  An optional field in a structure may also be left unspecified.
%
%  Inputs:
%    OptBond : (required) specification of the underlying bond
%    with a possible call and put option.  Fields are scalars or
%    date strings. 
%
%      Bond specification fields for the underlying bond.  See the
%      help header FTB for detailed information on bond parameters.
%
%    - OptBond.Settle : (required) Settlement date.
%    - OptBond.Maturity : (required) Maturity date.
%    - OptBond.Period : (optional) Coupon frequency.  Default is 2.
%    - OptBond.Basis : (optional) Market Basis.  Default is 0 (actual/actual).
%    - OptBond.EndMonthRule : (optional) EOM rule.  Default is 1 (in effect).
%    - OptBond.FirstCouponDate : (optional) First coupon payment if
%      the first coupon period is irregular.
%    - OptBond.LastCouponDate : (optional) Last coupon payment before
%      maturity if the last coupon period is irregular.
%    - OptBond.IssueDate : (optional) Issue date of the bond if the
%      first coupon period is irregular.
%    - OptBond.StartDate : (optional) Forward start date of the
%      security if not before Settlement.
%    - OptBond.CouponRate : (optional) Coupon payment rate.  
%    - OptBond.Face : (optional) Maturity payment of the bond.
%      Default is 100.
%
%      Option specification fields:  Fields for either a call or a
%      put may be specified.  Calls are assumed to be held by the
%      bond issuer, while puts are assumed to be held by the bond
%      holder.  A call therefore reduces the value of the bond to
%      the bond holder, while a put increases the value of the bond.
%
%    - OptBond.CallStrike : (required) call option strike price.
%    - OptBond.CallType : (optional) flag 1 (American) or 0 (European).
%      The default is an American option (CallType = 1).
%    - OptBond.CallExpiryDate : (optional) last possible date of
%      exercise for an American option, or only date for a European
%      option.  The default is the Maturity of the bond.
%    - OptBond.CallStartDate : (optional) first possible date of
%      exercise for an American option.  The default is bond Settlement.
%
%    - OptBond.PutStrike : (required) put option strike price.
%    - OptBond.PutType : (optional) flag 1 (American) or 0 (European).
%      The default is an American option (PutType = 1).
%    - OptBond.PutExpiryDate : (optional) last possible date of
%      exercise for an American option, or only date for a European
%      option.  The default is the Maturity of the bond.
%    - OptBond.PutStartDate : (optional) first possible date of
%      exercise for an American option.  The default is bond Settlement.
%
%    
%    ZeroCurve : (required) The yield curve of NCURVE (date, decimal rate)
%    pairs is interpolated to cover the time span of the bond.  Times
%    before the first curve date use the first rate, and times after 
%    the last curve date use the last rate.  
%    - ZeroCurve.CurveDates : (required) [NCURVE by 1] vector of maturity
%      dates.  Dates are date strings or serial date numbers.
%    - ZeroCurve.ZeroRates  : (required) [NCURVE by 1] vector of rates.
%
%    VolatilityCurve : (required) The curve of instantaneous 
%    volatilities of the short rates.  The curve consists of
%    NCURVE2 (date, decimal rate) pairs.  The curve will be
%    interpolated to cover the time span of the bond.  
%    - VolatilityCurve.CurveDates : (required) [NCURVE2 by 1]
%      vector of dates.
%    - VolatilityCurve.VolatilityRates : (required) [NCURVE2 by 1]
%      vector of yearly volatilities in decimal form.
%
%    Accuracy : (required) This argument is NOT a structure.  The
%    scalar value Accuracy specifies the number of steps in the
%    tree per semi-annual coupon interval.  Larger numbers yield more 
%    accurate answers, but require more time and memory.
%
%    CreditCurve : (optional) The curve of zero rate spreads arising
%    from default risk.  The curve has NCURVE3 (date, basis point)
%    pairs.  The curve will be interpolated to cover the time span
%    of the bond. 
%    - CreditCurve.CurveDates : (required) [NCURVE3 by 1] vector of
%      serial dates or date strings.
%    - CreditCurve.CreditRates : (required) [NCURVE3 by 1] vector
%      of credit spread values in basis points (not decimal rates).
%      The effective change to the zero rate is CreditRates/10000.
%
%    ComputeSensitivity : (optional)  Specify if bond sensitivity
%    measures (with and without options) are to be computed.  A
%    value of 1 in the field indicates that the measure will be
%    computed, while a value of 0 specifies the measure will
%    not be computed.  Sensitivities are found by a finite
%    difference calculation.  The default is no sensitivities: only
%    prices are returned. 
%    - ComputeSensitivity.Duration: (required) scalar 1 or 0.
%    - ComputeSensitivity.Convexity: (required) scalar 1 or 0.
%    - ComputeSensitivity.Vega: (required) scalar 1 or 0.
%
%
%  Outputs:
%    Price : value of the bond with and without the options
%    - Price.OptionFreePrice : scalar price of the bond without any
%      options.
%    - Price.OptionEmbedPrice : scalar price (value to the holder
%      of the bond) of the bond with options.
%    - Price.OptionValue : scalar value to the holder of the bond
%      of the options.
%     
%    Sensitivities
%    - Sensitivities.Duration : Sensitivity of option-free bond price
%      to parallel shifts of the yield curve.
%    - Sensitivities.EffDuration : Sensitivity of the
%      option-embedded price to shifts of the yield curve.
%    - Sensitivities.Convexity : Sensitivity of Duration to shifts
%      in the yield curve.
%    - Sensitivities.EffConvexity : Sensitivity of EffDuration to
%      shifts in the yield curve.
%    - Sensitivities.Vega : Sensitivity of the option-embedded
%      price to parallel shifts of the volatility curve.
%
%    DiscTree : recombining binomial tree of the interest rate
%    structure.  The tree covers NPERIODS times from Settlement to
%    Maturity, where there are Accuracy steps in each coupon
%    period.  The short rate at settlement and between settlement
%    and the first time is deterministic.  
%    - DiscTree.Values : [NSTATES by NPERIODS] matrix of short discount
%      factors.  The NPERIODS columns of Values correspond to successive
%      times.  The NSTATES rows correspond to states in the rate
%      process.  Unused states are masked by the value NaN.
%      Multiplication of a cash amount at time Dates(i) by the
%      discount Values(j,i) gives the price at Dates(i-1) after
%      traversing the (j,i) edge of the tree.  The short rate R(j,i)
%      prevailing at node (j,i) satisfies:
%      ( 1 + R(j,i)/Frequency)^(-(Times(j)-Times(j-1))) = Values(j,i)
%    - DiscTree.Times: [1 by NPERIODS] vector of tree node times in
%      units of coupon intervals.  (See ftbTFactors).
%      DiscTree.Dates: [1 by NPERIODS] vector of tree node times as
%      serial date numbers.
%    - DiscTree.Type : 'Short Discount'
%    - DiscTree.Frequency : The compounding frequency of the input bond.
%    - DiscTree.ErrorFlag : (0 or 1).  This is set to 1 if any
%      short rates become negative.
%
%    PriceTree : recombining binomial tree of cash amounts at tree
%    nodes.  The Price Tree is computed from the bond cash flows
%    and the option payoffs.  The clean price of the bond is the
%    Price Tree Value minus the coupon payment and the accrued interest.
%    - PriceTree.Values [NSTATES by NPERIODS] matrix of price states.
%    - PriceTree.Times: [1 by NPERIODS] vector of tree node times in
%      units of coupon intervals.  (See ftbTFactors).
%    - PriceTree.Dates: [1 by NPERIODS] vector of tree node times as
%      serial date numbers.
%    - PriceTree.AccrInt: [1 by NPERIODS] vector of accrued
%      interest payable at each time.
%    - PriceTree.Coupons: [1 by NPERIODS] vector of coupon payments
%      at each time.
%    - DiscTree.Type : 'Price'
%
% See also BDTTRANS

%   Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $   $Date: 2002/04/14 21:47:08 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parse and test inputs
if (nargin < 2)
     error('You must enter at least the parameters for the bond and a zero curve!');
end

if (isempty(ZeroCurve))
     error('Zero curve not specified!')
end

if (nargin < 3)
     VolatilityCurve = [];
end

if (nargin < 4)
     Accuracy = 4;
end

if (nargin < 5)
     CreditCurve = []; 
end


%Parse the sensitivity choice vector
if ((nargin < 6) | isempty(ComputeSensitivity))
     SensitivityMeasures = [0 0 0];
else
     if isstruct(ComputeSensitivity)
          SensitivityMeasures = [ComputeSensitivity.Duration, ...
                                 ComputeSensitivity.Convexity, ...
                                 ComputeSensitivity.Vega];
     else                  
          SensitivityMeasures = ComputeSensitivity;
     end
end
              

if ( any(size(SensitivityMeasures) ~= [1, 3]) | ...
     (any(SensitivityMeasures ~= 0 & SensitivityMeasures ~= 1)))
     error('Invalid choices for sensitivities specified!')
end

sz = size(SensitivityMeasures);

Ind = any(any(SensitivityMeasures ~= 0 & SensitivityMeasures ~= 1));

if ((sz(1, 1) ~= 1) | (sz(1, 2) ~= 3))
     
     error('Sensitivity measures must be specified as a 1x3 matrix!')
     
elseif (isempty(Ind))
     
     error('Sensitivity measures must be specified as a vector of ones and zeros!')
end


%Parse accuracy
if (nargin < 4)
     Accuracy = 2;
end

if (isempty(Accuracy))
     Accuracy = 2;
end


%Set the number of iterations to be used in iterative calculations
MaxIterations = 50;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%             ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Parse the input bond structure
IBond = checkbond(IBond);

%Make sure that accuracy is a scalar value
if (max(size(Accuracy)) == 1)
     %Make sure that accuracy is a positive integer
     if ((Accuracy < 0) | (mod(Accuracy, 1) ~= 0))        
          error('Accuracy must be a positive integer!')
     %Check to see if the combination of accuracy and coupon frequency
     %will create an abrnormally large number of time steps in the tree
     elseif ((Accuracy .* IBond.Period) > 100)
          warning('Excessive high values for model accuracy will limit performance!')
     end
else 
     error('Accuracy must be a scalar argument!') 
end

%Set flages for all sensitivities requested
Sensitivity.DurationFlag = 0;
if (SensitivityMeasures(1, 1) == 1)
     Sensitivity.DurationFlag = 1;
end

Sensitivity.ConvexityFlag = 0;
if (SensitivityMeasures(1, 2) == 1)
     Sensitivity.ConvexityFlag = 1;
end

Sensitivity.VegaFlag = 0;
if (SensitivityMeasures(1, 3) == 1)
     Sensitivity.VegaFlag = 1;
end


%Set all interpolation method specifications
InterpMethods.ZeroInterp = 'linear';
InterpMethods.CreditInterp = 'linear';
InterpMethods.VolatilityInterp = 'linear';


if (IBond.OptionFlag == 1)
     InstrumentType = 'optionbond';
end

if (IBond.OptionFlag == 0)
     InstrumentType = 'bond';
end


%Call the BDTENGINE function
[Price, DiscTree, Sensitivities, PriceTree] = bdtengine(IBond, InstrumentType, ...
     ZeroCurve, VolatilityCurve, CreditCurve, Accuracy, InterpMethods,...
     Sensitivity, MaxIterations);


