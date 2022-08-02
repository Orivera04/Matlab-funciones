function [CleanPrice, AccruedInterest] = disc2price(IBond, RiskAdjDiscRates, ...
     DiscTFactors, InterpMethod)
%DISC2PRICE Exact Price of a Bond Given a Discount Curve
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:47:38 $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the input bond structure
IBond = checkbond(IBond);


%Unpack the input bond structure
IssueDate = IBond.IssueDate;
Settle = IBond.Settle;
Maturity = IBond.Maturity;
Face = IBond.Face;
CouponRate = IBond.CouponRate;
Period = IBond.Period;
Basis = IBond.Basis;
EndMonthRule = IBond.EndMonthRule;
IssueDate = IBond.IssueDate;
FirstCouponDate = IBond.FirstCouponDate;
LastCouponDate = IBond.LastCouponDate;
StartDate = IBond.StartDate;


if (nargin < 4)
     InterpMethod = 'linear';
end

if (nargin < 3)
     error('Too few input arguments specified!')
end


%Make sure that the vector of discount factors and the vector of time
%factors have the same number of elements
NumDiscRates = length(RiskAdjDiscRates);

NumDiscTFactors = length(DiscTFactors);

if (NumDiscRates ~= NumDiscTFactors)
     error('DiscRates and DiscTFactors must contain the same number of elements!')
end


%Parse the interpolation method specified
InterpMethod  = lower(InterpMethod);

if (~any(strcmp(InterpMethod, 'nearest') | strcmp(InterpMethod, 'linear')...
          | strcmp(InterpMethod, 'spline') | strcmp(InterpMethod, 'cubic')))
     error('Invalid interpolation method specified!')
end


RiskAdjDiscRates = RiskAdjDiscRates(:);
DiscTFactors = DiscTFactors(:);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%               ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Get the cash flows for the bond and the time factors corresponding to each
%cash flow

[BondCashFlows, Temp, TFactors] = cfamounts(CouponRate, Settle, Maturity,...
     Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,...
     LastCouponDate, StartDate, Face);


%Get the accrued interest amount from the first element in the cash flow vector
AccruedInterest = -BondCashFlows(:, 1);


%Make sure that the discount time factors at least span the maturity of
%the bond, if they don't append the needed time factor onto the vector
TFactors = TFactors(:);
if (DiscTFactors(1, 1) > TFactors(1, 1))
     
     DiscTFactors = [TFactors(1, 1); DiscTFactors];
     RiskAdjDiscRates = [RiskAdjDiscRates(1, 1); ...
               RiskAdjDiscRates];
     
end


%Remove the first discount time factor if it is 0
if (DiscTFactors(1, 1) == 0)
     DiscTFactors = DiscTFactors(2 : end, 1);
     RiskAdjDiscRates = RiskAdjDiscRates(2 : end, 1);
     TFactors = TFactors(2 : end, 1);
end


%Convert discount factors to periodic rates for interpolation  
ZeroRates = -log(RiskAdjDiscRates) ./ (DiscTFactors ./ 2);


[UDiscTFactors, UniqueInd] = unique(DiscTFactors);
UZeroRates = ZeroRates(UniqueInd);


%Interpolate the make sure that we have a discount factor for each of 
%the bond's cash flows
WorkingTFactors = TFactors;

InterpZeroRates = interp1(UDiscTFactors, UZeroRates, WorkingTFactors,...
     InterpMethod);


%Convert back to discount factors
WorkingDiscRates = exp(-InterpZeroRates .* (WorkingTFactors ./ 2));

if (WorkingDiscRates(1, 1) ~= 1)
     WorkingDiscRates = [1; WorkingDiscRates];
     WorkingTFactors = [0; WorkingTFactors];
end


%Calculate the option free price for the underlying bond
CleanPrice = dot(BondCashFlows, WorkingDiscRates);


