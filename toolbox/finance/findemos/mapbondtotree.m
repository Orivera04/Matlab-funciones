function [InterpTimes, CoupCFlows, AccrCFlows, InterpDates, CouponTFactors] = mapbondtotree(InputBond, Accuracy)
% MAPBONDTOTREE creates the time structure for a tree based option
% pricing model from bond parameters.  Places approximatly Accuracy
% tree steps for each regular coupon period length.  The settlement
% time is padded onto the vectors, but excluded from the tree.
%
% InterpDates : [1 by Ntree+1] Dates of nodes (rounded to days)
% InterpTimes : [1 by Ntree+1] Times to settlement of nodes in units of
% coupon periods.
%
% CoupCFlows : [1 by Ntree+1] coupon cash flows of the bond at each
% time in InterpTimes including the accrued interest at settlement
% (InterpTimes = 0)
% 
% AccrCFlows : [1 by Ntree+1] accrued interest payable at every
% node for pricing contingent claims
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98
%        J. Akao        05-10-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.8 $   $Date: 2002/04/14 21:47:20 $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of input arguments
if (nargin < 1)
     error('You must enter at least the input bond structure!')
end

%Parse accuracy
if (nargin < 2)
     Accuracy = 2;
end

if (nargin > 2)
     error('Too many input arguments specified!')
end

%Make sure that accuracy is a scalar value
if (length(Accuracy) ~= 1)
     error('Accuracy must be a scalar argument!') 
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check the input bond structure
InputBond = checkbond(InputBond);


%Unpack the input bond structure
IssueDate = InputBond.IssueDate;
Settle = InputBond.Settle;
Maturity = InputBond.Maturity;
Period = InputBond.Period;
Basis = InputBond.Basis;
EndMonthRule = InputBond.EndMonthRule;
IssueDate = InputBond.IssueDate;
FirstCouponDate = InputBond.FirstCouponDate;
LastCouponDate = InputBond.LastCouponDate;
StartDate = InputBond.StartDate;
CouponRate = InputBond.CouponRate;

CallStartDate = InputBond.CallStartDate;
CallExpiryDate = InputBond.CallExpiryDate;
PutStartDate = InputBond.PutStartDate;
PutExpiryDate = InputBond.PutExpiryDate;

%Calculate the time factors corresponding to the cash flow dates of the
%bond including padding at Settlement

[CFlowAmounts, CFlowDates, CFTFactors] = cfamounts(CouponRate, ... 
    Settle, Maturity, Period, Basis, EndMonthRule, ...
    IssueDate, FirstCouponDate, LastCouponDate, StartDate);

% The tree should include nodes at any bond cash flow dates, as
% well as starting and expiry dates for the options
ExtraDates = setdiff( [CallStartDate, CallExpiryDate,
  PutStartDate, PutExpiryDate], CFlowDates );

if ~isempty(ExtraDates)
  % The time factors could be adjusted to sync with Issue/First/Last,
  % but ignore the ording issues for now
  % ExtraTFactors = tmfactor(Settle, ExtraDates, Period, Basis, EndMonthRule);
  ExtraTFactors = tmfactor(Settle, ExtraDates)';

  % Sort and merge the dates and time factors, remembering which
  % correspond to bond cash flows.
  AllTFactors = [CFTFactors, ExtraTFactors];
  AllDates    = [CFlowDates, ExtraDates];
  
  % sort in the time factors  TFactors = AllTFactors(FromInd);
  [TFactors, FromInd] = sort(AllTFactors);
  Dates = AllDates(FromInd);
  
  % reconstruct where in TFactors the cash flow dates live
  % TFactors(CFInTF) = AllTFactors
  [Dummy, CFInTF] = sort(FromInd);
  CFInTF = CFInTF(1:length(CFTFactors));
else
  TFactors = CFTFactors;
  Dates = CFlowDates;
  CFInTF = (1:length(CFTFactors))';
end
  
% compute the tree times
[InterpTimes, CFIndex, InterpDates] = ...
    mktreetimes(TFactors, Accuracy, Dates);

% map in the bond cash flows but subtract face from maturity and
% don't include the accrued interest at settlement
CFlowAmounts(end) = CFlowAmounts(end) - InputBond.Face;
CFlowAmounts(1) = 0;
CoupCFlows = zeros(size(InterpTimes));
CoupCFlows(CFIndex(CFInTF)) = CFlowAmounts(:)';

% Computing the accrued interest is complicated for odd periods, so
% just call ACCRFRAC here.  There will be fractional day errors from the
% rounding of the nodes to days.
AccrFrac = accrfrac(InterpDates, Maturity, Period, Basis, ...
    EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, ...
    StartDate);
Frequency = Period; Frequency(Frequency==0) = 2;
NominalCoupon = InputBond.Face * CouponRate / Frequency;
AccrCFlows = NominalCoupon * AccrFrac;

% maintain support CouponTFactors for now (JHA)
CouponTFactors = TFactors(2:end);

