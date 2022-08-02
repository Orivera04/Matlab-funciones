function [Price, Tree, Sensitivities, PriceTree] = bdtengine(Instrument, InstrumentType, ...
     ZeroCurve, VolatilityCurve, CreditCurve, Accuracy, ...
     InterpMethods, Sensitivity, MaxIterations)
%BDTENGINE Black-Derman-Toy Pricing Engine for Interest Rate Derivatives
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.13 $   $Date: 2002/04/14 21:47:17 $ 

%Note that parts of this implementation are based on original work done by
%Dave Eiler.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* CHECK INPUTS **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments in
if (nargin < 9)
     error('Too few input arguments specified!')
end


OptionFlag = Instrument.OptionFlag;


%Check to see if the bond has any embedded options; if it does make sure the
%the option flag is set correctly
if (InstrumentType(1) == 'o')
     
     if (OptionFlag == 0)
          error('Bond has no embedded options but is specified as such!')
     end
          
elseif (InstrumentType(1) == 'b')
     
     if (OptionFlag == 1)
          error('Bond has embedded options but is not specified as such!')
     end
     
else
     
     error('Illegal instrument type specified!')
     
end


%Set the flags for calculation of sensitivity measures
DurationFlag = Sensitivity.DurationFlag;
ConvexityFlag = Sensitivity.ConvexityFlag;
VegaFlag = Sensitivity.VegaFlag;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Parse the instrument structure
Instrument = checkbond(Instrument);


%Unpack the input bond structure
IssueDate = Instrument.IssueDate;
Settle = Instrument.Settle;
Maturity = Instrument.Maturity;
Face = Instrument.Face;
CouponRate = Instrument.CouponRate;
Period = Instrument.Period;
Basis = Instrument.Basis;
EndMonthRule = Instrument.EndMonthRule;
IssueDate = Instrument.IssueDate;
FirstCouponDate = Instrument.FirstCouponDate;
LastCouponDate = Instrument.LastCouponDate;
StartDate = Instrument.StartDate;
if (Period==0)
  Frequency = 2;
else
  Frequency = Period;
end

CallType = Instrument.CallType;
CallStartDates = Instrument.CallStartDate;
CallExpiryDates = Instrument.CallExpiryDate;
CallStrikes = Instrument.CallStrike;

PutType = Instrument.PutType;
PutStartDates = Instrument.PutStartDate;
PutExpiryDates = Instrument.PutExpiryDate;
PutStrikes = Instrument.PutStrike;


%Unpack all input curves

%Check the zero curve
ZeroCurve = checkzerocrv(ZeroCurve, Settle, Maturity);

%Unpack the input zero curve
ZeroRates = ZeroCurve.ZeroRates;
ZeroCurveDates = ZeroCurve.CurveDates;
ZeroCompounding = ZeroCurve.Compounding;
ZeroBasis = ZeroCurve.Basis;
ZeroEndMonthRule = ZeroCurve.EndMonthRule;


%Check the volatility curve
VolatilityCurve = checkvolcrv(VolatilityCurve, Settle, Maturity);
     
%Unpack the volatility curve
VolatilityRates = VolatilityCurve.VolatilityRates;
VolatilityDates = VolatilityCurve.CurveDates;
VolatilityBasis = VolatilityCurve.Basis;
VolatilityEndMonthRule = VolatilityCurve.EndMonthRule;
VolTimeUnit = VolatilityCurve.Compounding;


%Check to see if a credit curve has been specified, if it has set a flag
%indicating this
CreditFlag = 0;
if (~isempty(CreditCurve) & isa(CreditCurve, 'struct'))
     
          CreditFlag = 1;
          
elseif (~isempty(CreditCurve) & ~isa(CreditCurve, 'struct'))
     
     error('Credit curve must be specified as a structure!')
end

if (CreditFlag)
     CreditCurve = checkcreditcrv(CreditCurve, Settle, Maturity);
     
     %Unpack the credit curve structure
     CreditRates = CreditCurve.CreditRates;
     CreditDates = CreditCurve.CurveDates;
     CreditCompounding = CreditCurve.Compounding;
     CreditBasis = CreditCurve.Basis;
     CreditEndMonthRule = CreditCurve.EndMonthRule;
else
     %Set all credit curve parameters to empty matrices
     CreditRates = [];
     CreditDates = [];
     CreditCompounding = [];
     CreditBasis = [];
     CreditEndMonthRule = [];

end


%Unpack the interpolation methods structure
ZeroInterpMethod = InterpMethods.ZeroInterp;
CreditInterpMethod = InterpMethods.CreditInterp;
VolatilityInterpMethod = InterpMethods.VolatilityInterp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the time mapping of the tree and curves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create the tree time structure to fit the bond and option time structure.
[InterpTimes, CoupCFlows, AccrCFlows, InterpDates, ... 
     CouponTFactors] = mapbondtotree(Instrument, Accuracy);
    

%Construct padded vectors of the same size as interp times which contain the
%call and put strike prices in the appropriate locations
[CallCFlows, PutCFlows] = cfoption(Instrument, InterpDates);


%Use linear interpolation to find discount factors corresponding to every
%time step based on the initial input zero curve
[DiscRates, DiscTFactors, ZeroRates, ZeroTFactors] = dfinterp(ZeroCurve, ...
     InterpTimes, Settle, ZeroInterpMethod);

%Linearly interpolate to find volatility rates corresponding to each
%time step of the tree
[InterpVolRates, VolatilityTFactors] = volinterp(VolatilityRates, ...
     VolatilityDates, InterpTimes, Settle, VolatilityBasis, ...
     VolatilityEndMonthRule, VolatilityInterpMethod);

%If a credit curve has been specified, find the risk-adjusted discount 
%factors
if (CreditFlag)
     
     [RiskyDiscRates, RiskyDiscTFactors, CreditRates, CreditTFactors,...
          CreditCurveDates] = df2risk(DiscRates, DiscTFactors,...
          CreditCurve, CreditInterpMethod, CreditCompounding, CreditBasis, ...
          CreditEndMonthRule);
     
     %Construct a credit curve in the form of an numeric matrix; this is
     %necessary only to speed model performance
     CreditCurve = [CreditRates CreditTFactors];
else
     
     RiskyDiscRates = DiscRates;
end

%Calculate the forward probability of default curve
FwdProbDefault = dfltprob(DiscRates, RiskyDiscRates);


%---------------------------------------------------------------------
%Calculate the option-free price of the underlying bond using the
%the risk adjusted discount curve
%---------------------------------------------------------------------
OptionFreePrice = disc2price(Instrument, RiskyDiscRates, DiscTFactors);

%---------------------------------------------------------------------
% Build the Tree     
%---------------------------------------------------------------------

% The Tree lives at 2:NumInterpTimes because the first zero
% rate is deterministic.
NumInterpTimes = length(InterpTimes);
TreeTimes = diff(InterpTimes);

%Build a vector of "true" prices from the interpolated discount curve
BasePriceProcess = DiscRates(2:NumInterpTimes);

%Build the volatility process from the interpolated volatility
%rates (under the BDT model a downward jump in yield (upward 
%jump in price) is related to an upward jump in yield (downward jump
%in price) by this process)

% Scale volatility time to input units
VolTimes = TreeTimes*2/VolTimeUnit;

VolatilityProcess = exp(2.0 .* sqrt (VolTimes) .* ... 
    InterpVolRates(2:NumInterpTimes) );

%Construct calibrated trees of simulated future short interest rates
[DiscTree, TreeErrorFlag] = mkdisctree(TreeTimes, ...
     BasePriceProcess, VolatilityProcess, MaxIterations);

%Check the status of the tree error flag, if the trees are okay, then
%proceed with valuation of the bond
if  (TreeErrorFlag == 0 | TreeErrorFlag == 2)
     %Get the value of the option-embedded bond
     [OptionEmbedPrice, OptionEmbedTree] = proptbond(Instrument, ... 
         DiscTree, FwdProbDefault, ...
         CoupCFlows, AccrCFlows, CallCFlows, PutCFlows);
     
elseif (TreeErrorFlag == 1)
     %Return NaN value for the price of the option-embedded bond
     OptionEmbedPrice = nan;
     
     %Throw a warning and return
     warning('Unable to construct positive short rate tree due to model parameters!')

     DiscTree(DiscTree==0) = NaN;
     NTree = size(DiscTree,1);
     NTimes = length(InterpTimes);
     FullDiscTree = NaN*ones(NTree,NTimes);
     FullDiscTree(1,1) = 1;
     FullDiscTree(:,2:end) = DiscTree;
     
     Tree.Values = FullDiscTree;
     Tree.Times = InterpTimes';
     Tree.Dates = InterpDates';
     Tree.ErrorFlag = TreeErrorFlag;
     Tree.Type = 'Short Discount';
     Tree.Frequency = Frequency;

     Price = [];
     Sensitivities = [];
     PriceTree = [];
     
     return
end
     
%---------------------------------------------------------------------
% Calculate sensitivities using finite difference method
%---------------------------------------------------------------------

%Calculate duration
Duration = nan;
EffDuration = nan;

if (DurationFlag | ConvexityFlag)
     
     %Set the amount of the shift in yield to 5 basis points
     %BaseUpShift = 5 ./ 10000;
     BaseUpShift = 5 ./ 10000;
     
     UpYieldShift = BaseUpShift .* ones(size(ZeroRates));
     
     %Shift the yield curve
     UpZeroRates = ZeroRates + UpYieldShift;
     
     UpZeroCurve = [UpZeroRates ZeroCurveDates ZeroTFactors];

     [UpDiscRates, DiscTFactors] = dfinterp(UpZeroCurve, InterpTimes, ...
          Settle, ZeroInterpMethod, ZeroCompounding, ZeroBasis, ...
          ZeroEndMonthRule);

     if (CreditFlag)
     
           UpRiskyDiscRates = df2risk(UpDiscRates, DiscTFactors,...
                CreditCurve, CreditInterpMethod, CreditCompounding, ...
                CreditBasis, CreditEndMonthRule);
     else
     
          UpRiskyDiscRates = UpDiscRates;
     end
     
     %Calculate the option-free price of the bond
     UpOptionFreePrice = disc2price(Instrument, UpRiskyDiscRates, ...
          DiscTFactors);
     
     %Build tree and find option-embedded price if necessary
     if (OptionFlag)
     
          UpFwdProbDefault = dfltprob(UpDiscRates, UpRiskyDiscRates);

          UpBasePriceProcess = UpDiscRates(2 : NumInterpTimes);

          %Construct calibrated trees of simulated future short interest
          %rates
          [UpDiscTree, UpTreeErrorFlag] = ...
               mkdisctree(TreeTimes, UpBasePriceProcess, ...
               VolatilityProcess, MaxIterations);
                    
          %Check the status of the tree error flag, if the trees are okay, 
          %then proceed with valuation of the bond
          if  (UpTreeErrorFlag == 0 | UpTreeErrorFlag == 2)
               %Get the value of the option-embedded bond
               UpOptionEmbedPrice = proptbond(Instrument, ... 
                   UpDiscTree, UpFwdProbDefault, ...
                   CoupCFlows, AccrCFlows, CallCFlows, PutCFlows);

          elseif (UpTreeErrorFlag == 1)
               %Return NaN value for the price of the option-embedded bond
               UpOptionEmbedPrice = nan;
          
               %Throw a warning and return
               warning('Unable to construct short rate tree after upward shift in yield curve due to model parameters!')
          
          end
     else
          
          UpOptionEmbedPrice = nan;
     end
     
     %Calculate duration based on the option-embedded price
     EffDuration = ( (OptionEmbedPrice - UpOptionEmbedPrice) ./ ...
         OptionEmbedPrice ) ./ BaseUpShift;
          
     %Calculate duration based on the option free price
     Duration = ( (OptionFreePrice - UpOptionFreePrice) ./ ...
         OptionFreePrice ) ./ BaseUpShift;
     
end

%Calculate convexity
Convexity = nan;
EffConvexity = nan;

if (ConvexityFlag)
     
     DwnYieldShift =  - UpYieldShift;
     
     %Shift the yield curve
     DwnZeroRates = ZeroRates + DwnYieldShift;
     
     DwnZeroCurve = [DwnZeroRates ZeroCurveDates ZeroTFactors];

     %Use linear interpolation to find discount factors     
     [DwnDiscRates, DiscTFactors] = dfinterp(DwnZeroCurve, InterpTimes, ...
          Settle, ZeroInterpMethod, ZeroCompounding, ZeroBasis,...
          ZeroEndMonthRule);

     %If a credit curve has been specified, find the risk-adjusted discount
     %factors
     if (CreditFlag)
     
           DwnRiskyDiscRates = df2risk(DwnDiscRates, DiscTFactors,...
                CreditCurve, CreditInterpMethod, CreditCompounding, ...
                CreditBasis, CreditEndMonthRule);
     else
     
          DwnRiskyDiscRates = DwnDiscRates;
     end
     
     %Calculate the option-free price of the bond
     DwnOptionFreePrice = disc2price(Instrument, DwnRiskyDiscRates, ...
          DiscTFactors);
     
     %Build tree and find option-embedded price if necessary
     if (OptionFlag)
     
          DwnFwdProbDefault = dfltprob(DwnDiscRates, DwnRiskyDiscRates);

          DwnBasePriceProcess = DwnDiscRates(2 : NumInterpTimes);

          %Construct calibrated trees of simulated future short interest
          %rates
          [DwnDiscTree, DwnTreeErrorFlag] = ...
               mkdisctree(TreeTimes, DwnBasePriceProcess, ...
               VolatilityProcess, MaxIterations);

          %Check the status of the tree error flag, if the trees are okay, 
          %then proceed with valuation of the bond
          if  (DwnTreeErrorFlag == 0 | DwnTreeErrorFlag == 2)
               %Get the value of the option-embedded bond
               DwnOptionEmbedPrice = proptbond(Instrument, ... 
                   DwnDiscTree, DwnFwdProbDefault, ...
                   CoupCFlows, AccrCFlows, CallCFlows, PutCFlows);
           
          elseif (DwnTreeErrorFlag == 1)
               %Return NaN value for the price of the option-embedded bond
               DwnOptionEmbedPrice = nan;
          
               %Throw a warning and return
               warning('Unable to construct short rate tree after downward shift in yield curve due to model parameters!')
          
          end
          
     else
          
          DwnOptionEmbedPrice = nan;
     end
     
     %Calculate convexity based on the option free price
     Convexity = ( ( (UpOptionFreePrice - (2 .* OptionFreePrice) +...
         DwnOptionFreePrice) ) ./ ( BaseUpShift .^ 2 ) ) ./...
         OptionFreePrice;
     
     %Calculate convexity based on the option-embedded price
     EffConvexity = ( ( (UpOptionEmbedPrice - (2 .* OptionEmbedPrice) +...
         DwnOptionEmbedPrice) ) ./ ( BaseUpShift .^ 2 ) ) ./...
         OptionEmbedPrice;
     
end


%Calculate vega
Vega = nan;
if ((OptionFlag) & (VegaFlag))
     
     %Shift the volatility curve upward
     UpInterpVolRates = InterpVolRates + BaseUpShift;

     UpVolatilityProcess = exp(2.0 .* sqrt (VolTimes) .* ... 
         UpInterpVolRates(2:NumInterpTimes));     

     %Construct calibrated trees of simulated future short interest rates
     [UpVDiscTree, UpVTreeErrorFlag] = mkdisctree(TreeTimes, ...
          BasePriceProcess, UpVolatilityProcess, MaxIterations);

     %Check the status of the tree error flag, if the trees are okay, then
     %proceed with valuation of the bond
     if  (UpVTreeErrorFlag == 0)
          %Get the value of the option-embedded bond
          UpVOptionEmbedPrice = proptbond(Instrument, ... 
              UpVDiscTree, FwdProbDefault, ...
              CoupCFlows, AccrCFlows, CallCFlows, PutCFlows);
           
     elseif (UpVTreeErrorFlag == 1)
          
          %Throw a warning and return
          warning('Unable to construct short rate tree after upward volatility shift due to model parameters!')
          UpVOptionEmbedPrice = NaN;
     end
     
     %Calculate vega
     Vega = ( (OptionEmbedPrice - UpVOptionEmbedPrice) ./ ...
          OptionEmbedPrice ) ./ BaseUpShift;
end

%---------------------------------------------------------------------
%Build all output constructs
%---------------------------------------------------------------------
Price.OptionFreePrice = OptionFreePrice;
Price.OptionEmbedPrice = OptionEmbedPrice;
Price.OptionValue = OptionEmbedPrice - OptionFreePrice;

% Embed the standard BDT discount tree in a structure which
% contains the settlement time
DiscTree(DiscTree==0) = NaN;
NTree = size(DiscTree,1);
NTimes = length(InterpTimes);
FullDiscTree = NaN*ones(NTree,NTimes);
FullDiscTree(1,1) = 1;
FullDiscTree(:,2:end) = DiscTree;

Sensitivities.Duration = Duration;
Sensitivities.EffDuration = EffDuration;
Sensitivities.Convexity = Convexity;
Sensitivities.EffConvexity = EffConvexity;
Sensitivities.Convexity = Convexity;
Sensitivities.Vega = Vega;

Tree.Values = FullDiscTree;
Tree.Times = InterpTimes';
Tree.Dates = InterpDates';
Tree.ErrorFlag = TreeErrorFlag;
Tree.Type = 'Short Discount';
Tree.Frequency = Frequency;

PriceTree.Values = OptionEmbedTree;
PriceTree.Times = InterpTimes';
PriceTree.Dates = InterpDates';
PriceTree.ErrorFlag = 0;
PriceTree.AccrInt = AccrCFlows';
PriceTree.Coupons = CoupCFlows';
PriceTree.Type = 'Price';
