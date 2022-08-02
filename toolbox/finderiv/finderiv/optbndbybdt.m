function [Price, PriceTree] = optbndbybdt(BDTTree, varargin)
%OPTBNDBYBDT Price options on bonds by a BDT interest rate tree.
%   Dynamic programming subroutine for BDTPRICE.
%
%   [Price, PriceTree] = optbndbybdt(BDTTree, ... 
%                           OptSpec, Strike, ExerciseDates, AmericanOpt, ...
%                           CouponRate, Settle, Maturity)
%
%   [Price, PriceTree] = optbndbybdt(BDTTree, ... 
%                           OptSpec, Strike, ExerciseDates, AmericanOpt, ...
%                           CouponRate, Settle, Maturity, ...
%                           Period, Basis, EndMonthRule, ...
%                           IssueDate, FirstCouponDate, LastCouponDate, ...
%                           StartDate, Face, Options)
%
% Inputs: Type "help instoptbnd" for a description of option contract
%   arguments, and type "help instbond" or "help ftb" for a description
%   of bond arguments.   
%
%   BDTTree         - Interest rate tree structure created by BDTTREE.
%
%   OptSpec         - NINSTx1 Cell array of strings 'call' or 'put'.
%   Strike          - NINST x NSTRIKES Strike price values.
%   ExerciseDates   - NINST x NSTRIKES or NINST x 2 Exercise dates.
%   AmericanOpt     - NINST x 1 flags 0(European/Bermuda) or 1(American).
%
%   CouponRate      - NINSTx1 Decimal annual rate.
%   Settle          - NINSTx1 Settlement date. 
%   Maturity        - NINSTx1 Maturity date.
%   Period          - NINSTx1 Coupons per year. Default is 2.
%   Basis           - NINSTx1 Day-count basis.  Default is 0 (actual/actual).
%   EndMonthRule    - NINSTx1 End-of-month rule.  Default is 1 (in effect).
%   IssueDate       - NINSTx1 Bond issue date.
%   FirstCouponDate - NINSTx1 Irregular first coupon date.
%   LastCouponDate  - NINSTx1 Irregular last coupon date.
%   StartDate       - NINSTx1 (Input ignored)
%   Face            - NINSTx1 Face value.  Default is 100.
%   Options			- Structure created with derivset containing derivatives 
%                     pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price     - NINSTx1 expected prices at time 0
%   PriceTree - Tree structure with a vector of instrument prices at each
%               node. 
%
% Notes: The Settle date for every bond is set to the ValuationDate of
%   the BDT Tree.  The bond argument, Settle, is ignored.
%
% See also BDTTREE, BDTPRICE, INSTBOND.
%

%   Author(s): M. Reyes-Kattar 02/05/2001
%   Copyright 1998-2003 The MathWorks, Inc.
%   $Revision: 1.6.2.2 $  $Date: 2004/04/06 01:08:33 $

%---------------------------------------------------------------------
% Parse input aruguments
%---------------------------------------------------------------------

if length(varargin) < 7,
	error('finderiv:optbndbybdt:InvalidInputs','You must pass at least seven instrument input arguments')
end

if ~isafin(BDTTree,'BDTFwdTree')
	error('finderiv:optbndbybdt:InvalidTree','The first argument must be a BDT tree created by BDTTREE');
end

% Extract pricing options
options = [];
if length(varargin) > 15
	options = varargin{16};
	varargin = varargin(1:15);
end

% Set default for pricing option
if(isempty(options))
	options = derivset;
end

% Extract options information
[ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options);

% Process bond instrument arguments contained in varargin
% Settlement is 6th argument
[OptSpec, Strike, ExerciseDates, AmericanOpt, ...
		CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
		FirstCouponDate, LastCouponDate, StartDate, Face] = ...
	instargoptbnd(varargin{1:5}, ...
	BDTTree.TimeSpec.ValuationDate, ...
	varargin{7:end});

% special rules: Single settlement equal to Valuation Date
BondSettle = finargdate(varargin{6});
BondSettle = BondSettle(~isnan(BondSettle));
if ~isempty(BondSettle) & any(BondSettle ~= Settle(1))
	warning('finderiv:optbndbybdt:IgnoredSettle','OptBonds are valued at BDT Tree ValuationDate rather than Settle');
end

%---------------------------------------------------------------------
% create cash flow matrices
%---------------------------------------------------------------------
[CFAmounts, CFDates, CFTimes] = cfamounts(CouponRate, Settle, Maturity, ... 
	Period, Basis, EndMonthRule, IssueDate, ... 
	FirstCouponDate, LastCouponDate, StartDate, Face);

[NumInst] = size(CFAmounts,1);

%---------------------------------------------------------------------
% create strike schedules
%---------------------------------------------------------------------
AmericanInd = find(AmericanOpt);
EuropeanInd = find(~AmericanOpt);

% American Option create the schedule from the coupon dates
if ~isempty(AmericanInd)
	ExerciseA = CFDates(AmericanInd,:);
	ND = size(CFDates,2);
	
	% no dates before Settle
	ExerciseA( ExerciseA < Settle(1) ) = NaN;
	
	% no dates before First exercise opportunity
	ExerciseA( ExerciseA < ExerciseDates(AmericanInd,ones(1,ND)) ) = NaN;
	
	% no dates after last exercise opportunity
	ExerciseA( ExerciseA > ExerciseDates(AmericanInd,2*ones(1,ND)) ) = NaN;
	
	% use the strike value across all the exercise dates
	StrikeA = Strike(AmericanInd,ones(1,ND));
	StrikeA(isnan(ExerciseA)) = NaN;
	
else
	StrikeA = [];
	ExerciseA = [];
end

% European/Bermudan option
if ~isempty(EuropeanInd)
	StrikeE = Strike(EuropeanInd,:);
	ExerciseE = ExerciseDates(EuropeanInd,:);
	
	% no dates before Settle
	ExerciseE( ExerciseE < Settle(1) ) = NaN;
else
	StrikeE = [];
	ExerciseE = [];
end

% Catenate the American and European sets and then reorder
SchedStrike = finargcat(1, StrikeE, StrikeA);
SchedDates  = finargcat(1, ExerciseE, ExerciseA);

SchedStrike([EuropeanInd; AmericanInd],:) = SchedStrike;
SchedDates([EuropeanInd; AmericanInd],:) = SchedDates;

% Pack and remove trailing NaN's
% The schedules could be empty
[SchedStrike] = finargpack(1, SchedStrike);
[SchedDates]  = finargpack(1, SchedDates);

% Create time factors for the strikes
SchedTimes = NaN*ones(size(SchedDates));
SchedTimes(~isnan(SchedDates)) = date2time(BDTTree.TimeSpec.ValuationDate, ...
	SchedDates(~isnan(SchedDates)), ...
	BDTTree.TimeSpec.Compounding);

% Mark instruments as either call or put
% Default is call
InstPut  = strcmpi(OptSpec,'put');
InstCall = ~InstPut;

%---------------------------------------------------------------------
% Map cash flows to every node
% TreeDates [NumLevels+1 x 1] vector of dates from valuation to maturities
% TreeTimes [NumLevels+1 x 1] vector of compounded times
%
%---------------------------------------------------------------------
TreeDates = [BDTTree.TimeSpec.ValuationDate; 
	BDTTree.TimeSpec.Maturity];
TreeTimes = [BDTTree.tObs'; BDTTree.CFlowT{end}];

% change semiannual time factors to compounded times
[dummy, F] = date2time([],[], BDTTree.TimeSpec.Compounding);
CFTimes = CFTimes*F/2;

% Make a matrix with the cash flows in the first NumInst rows and the
% strike information in the second NumInst rows.
InstValues = finargcat(1, CFAmounts, SchedStrike);
InstDates  = finargcat(1, CFDates,   SchedDates);
InstTimes  = finargcat(1, CFTimes,   SchedTimes);


% ----------------------------------------------------------
% If the tree doesn't cover all the CF times, we may need to generate
% a new one so that all CFs fall in a tree node
% ----------------------------------------------------------
AllTimes = InstTimes(:)';
AllTimes = sort(unique(AllTimes(~isnan(AllTimes))));

AllDates = InstDates(:)';
AllDates = sort(unique(AllDates(~isnan(AllDates))));

if (~all(ismember(AllTimes, TreeTimes)))
	
	if(ConstRate)
		if(ShowWarnings)
			warning('finderiv:optbndbybdt:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
		end    	    
	else        
		if(ShowWarnings)
			warning('finderiv:optbndbybdt:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
		end
		
		if(ShowDiagnostics)  
			DiagMsg = sprintf('\nBuilding new tree with %d levels.\nLast node will have %d states.\n',...
				length(AllDates)-1, length(AllDates)-1);
			disp(DiagMsg);
		end
      
		
		TimeSpecNew  = bdttimespec(BDTTree.TimeSpec.ValuationDate, AllDates(2:end), ...
			BDTTree.RateSpec.Compounding);
		BDTTreeOri   = BDTTree;
		TreeTimesOri = TreeTimes;
		BDTTree = bdttree(BDTTreeOri.VolSpec, BDTTreeOri.RateSpec, TimeSpecNew);
		
		% Redefine tree paramenters
		TreeDates   = [BDTTree.TimeSpec.ValuationDate; BDTTree.TimeSpec.Maturity];
		TreeTimes   = [BDTTree.tObs'; BDTTree.CFlowT{end}];
	end
end

% Get the map of cash flows on tree nodes
[AllCF, IsTreeDate, AllDates, AllTimes, AllInd] = bdttreetime(...
	InstValues, InstDates, InstTimes, TreeDates, TreeTimes);

% split the strike and cash flow information
AllStrike = AllCF(NumInst+1:end,:);
AllCF = AllCF(1:NumInst,:);
[NumCFs] = size(AllCF,2);

AllInd = AllInd(1:NumInst,:);

% Adjust the null strike value for a call to Inf and a put to -Inf
AllStrike( InstCall(:,ones(1,NumCFs)) & (AllStrike==0) ) = Inf;
AllStrike(  InstPut(:,ones(1,NumCFs)) & (AllStrike==0) ) = -Inf;

%---------------------------------------------------------------------
% Make a set of valuation adjustments which are not actually cash flows
% You don't get a coupon if you value on a coupon date
% You do pay accrued interest if you value off of a coupon date
%
% Principal may or may not be valued and actually paid on a floating rate
% note, cap, or floor
%
%   TreeCF - NINST x NLEVELS+1 matrix of cash flows on tree nodes and
%     rate maturities.
%---------------------------------------------------------------------

% Find the face locations in AllCF
% AllCF(FaceInd) = Face + last coupon
FaceCol = max(AllInd,[],2);
FaceRow = (1:NumInst)';
FaceInd = FaceRow + NumInst*(FaceCol-1);

% Deal with Principal for a cap, floor, or floater
% We want rate multipliers to compute the cash flows
% AllCF(FaceInd) = AllCF(FaceInd) - Principal

AllAdjustments = -AllCF; 
AllAdjustments(:,1) = 0; % include accrued interest at time 0
AllAdjustments(FaceInd) = AllAdjustments(FaceInd) + Face; % include face 

% Deal with accrued interest on tree dates between coupons

% You only need the adjustments at the tree dates
Adjustments = AllAdjustments(:,IsTreeDate);

% Crunch down the cash flows to the tree dates for now (JHA)
% CFs = AllCF(:,IsTreeDate);
% if any(any( AllCF(:,~IsTreeDate)~=0 ))
%   warning('Some Cash Flows were Truncated')
% end

%---------------------------------------------------------------------
% Map all the cash flows to their proper places in the tree
% PriceObsInd [1 x NT] cash flow events belong to this price observation 
% RateObsInd  [1 x NT] cash flow events use this spot rate observation
% 
% DiscFrac [1 x NT-1] power fraction of the RateObsInd discount to use between
%                     this time and the following time.  The sum of the
%                     DiscFrac values over a tree interval is 1.  At each cf
%                     timestep you use Disc.^DiscFrac(iObs) so that the product
%                     of cf timesteps over a tree interval is Disc.
%---------------------------------------------------------------------
PriceObsInd = cumsum(IsTreeDate);
RateObsInd = min(PriceObsInd, length(TreeTimes)-1);

dtRate = diff(AllTimes(IsTreeDate))'; % lengths of intervals for each rate obs
dtRate = dtRate(RateObsInd(1:end-1)); % find this for every cf interval
dtAll  = diff(AllTimes'); % row lengths of intervals between cf events

DiscFrac = (dtAll./dtRate);

%---------------------------------------------------------------------
% make a new price tree including final times
%---------------------------------------------------------------------
FwdTree = BDTTree.FwdTree;
[NumLevels, NumPos] = treeshape(FwdTree);

% make a new structure with the final times on the end (NumLevels+1)
PTree = mktree(NumLevels+1, NumInst, 0, 1);
NumPStates = [1:NumLevels NumLevels];

%---------------------------------------------------------------------
% Dynamic programming to determine the price
% iCF   [1...NumCFs] : place in the cash flow times
% jpObs [1...NT]   : place in the price tree observations
% jrObs [1...NT-1] : place in the rate tree observations
%---------------------------------------------------------------------
% create an expansion vector over the instruments
Iones = ones(NumInst,1);


% allocate memory now for the exercise payoffs
ExPayoff = PTree;

% Create a placeholder for bond prices and bond price plus cash flows at cash flow dates
BondPriceStates = zeros(1,NumCFs);
BondPriceStates(IsTreeDate) = NumPStates;

% Fill the rest of the states
CumInd = cumsum(IsTreeDate);
BondPriceStates(~IsTreeDate) = 2*CumInd(~IsTreeDate);
% Truncate at NumPStates(end)
PrevToLastCFT = find(IsTreeDate); PrevToLastCFT=PrevToLastCFT(end-1);
BondPriceStates(PrevToLastCFT:end)=NumPStates(end);

BndPricesCF = cell(1,NumCFs);
for i=1:NumCFs
	BndPricesCF{i} = zeros(NumInst, BondPriceStates(i));
end


BndPrices = BndPricesCF;

for iCF = NumCFs:-1:1,
	jpObs = PriceObsInd(iCF);
	jrObs = RateObsInd(iCF);
	
	% perform a discounting step to take future value to present value
	% You are discounting from AllTimes(iCF+1) to AllTimes(iCF)
	% FwdTree{jrObs}(1,:) is the spot rate discount applicable for this interval
	% RateStates is the discount factor cut down for the CF interval
	% RateStates [1 x NumPStates(jrObs)]
	% jrObs < jpObs only at the last level.  NumStates is the same at the
	% last and second-to-last levels of the price tree.
	if iCF<NumCFs
		RateStates = ( 1 ./ FwdTree{jrObs}).^DiscFrac(iCF);
		PTree{jpObs}(:,:) = PTree{jpObs}(:,:) .* RateStates(Iones,:);
		
		if(~IsTreeDate(iCF) & CFTimes(iCF) < TreeTimes(end-1))
			RateStates = ones(2,1) * RateStates;
			RateStates = RateStates(:)';
			BndPricesCF{iCF} = BndPricesCF{iCF} .* RateStates(Iones,:);
		else
			BndPricesCF{iCF} = BndPricesCF{iCF} .* RateStates(Iones,:);
		end
	end
	
	% Save Price before adding new cash flow. This represents the present (at time
	% TreeDate(iCF) ) of all future cash flow.
	BndPrices{iCF}(:,:) = BndPricesCF{iCF}(:,:);
	
	% (Bond) Add the cash flow at this time to the present value of the future
	BndPricesCF{iCF}(:,:) = BndPricesCF{iCF}(:,:) + ...
		AllCF(:, iCF* ones(1,BondPriceStates(iCF)) );
	
	if(iCF > 1)
		if(BondPriceStates(iCF-1) == BondPriceStates(iCF))
			% Last two nodes or between nodes. Just add the cash flows
			BndPricesCF{iCF-1}(:,:) = BndPricesCF{iCF}(:,:);
		elseif (BondPriceStates(iCF-1) == BondPriceStates(iCF)-1)
			% Just reached a node (at iCF-1) from another (at iCF).
			% Combine the cash flows.
			BndPricesCF{iCF-1}(:,:) = (BndPricesCF{iCF}(:,1:end-1) + BndPricesCF{iCF}(:,2:end))/2;
		elseif (2*BondPriceStates(iCF-1) == BondPriceStates(iCF))
			% Just reached a node (at iCF-1) from in-between nodes			
			UpInd = 1:2:BondPriceStates(iCF);
			DownInd = 2:2:BondPriceStates(iCF);
			BndPricesCF{iCF-1}(:,:) = (BndPricesCF{iCF}(:,UpInd) + BndPricesCF{iCF}(:,DownInd))/2;
		elseif (BondPriceStates(iCF-1) == 2*(BondPriceStates(iCF)-1))
			% Getting to in-between nodes from nodes
			Ind = ones(2,1) * [2:max(0, BondPriceStates(iCF)-1)];
			Ind = [1;Ind(:);BondPriceStates(iCF)];
			BndPricesCF{iCF-1}(:,:) = BndPricesCF{iCF}(:,Ind);
		else
			error('Internal error') % This should never occur
		end
	end
	
	% Set the bond price at iCF at the previous tree node
	if(BondPriceStates(iCF)==NumPStates(jpObs))
		Prices = BndPricesCF{iCF}(:,:);
	elseif (BondPriceStates(iCF)==NumPStates(jpObs)+1)
		Prices = (BndPricesCF{iCF}(:,1:end-1)+BndPricesCF{iCF}(:,1:end-1))/2;
	elseif (BondPriceStates(iCF)==NumPStates(jpObs)*2)
		% Just reached a node (at iCF-1) from in-between nodes			
		UpInd = 1:2:BondPriceStates(iCF);
		DownInd = 2:2:BondPriceStates(iCF);
		Prices = (BndPricesCF{iCF}(:,UpInd) + BndPricesCF{iCF}(:,DownInd))/2;		
	else
		error('Internal Error')  % This should never occur
	end
	
		
	% The bond clean price is the present value of payments + AllAdjustments
	% Store the exercise payoff in ExPayoff
	AdjStrike = AllStrike(:,iCF) - AllAdjustments(:,iCF);
	
	% The call payoff for exercise is the the max( cleanprice - strike , 0 )
	ExPayoff{jpObs}(InstCall,:) = max( 0, ...
		Prices(InstCall,:) - ...
		AdjStrike(InstCall,ones(1,NumPStates(jrObs))));
	
	% The put payoff for exercise is the the max( strike - cleanprice , 0 )
	ExPayoff{jpObs}(InstPut,:) = max( 0, ...
		-Prices(InstPut,:) + ...
		AdjStrike(InstPut,ones(1,NumPStates(jrObs))));
	
	% Make an exercise choice: either hold option for PV or exercise for payoff
	PTree{jpObs}(:,:) = max( PTree{jpObs}(:,:) , ...
		ExPayoff{jpObs}(:,:) );

	
	% if you are on a tree date, average down to start the next state level
	if IsTreeDate(iCF) & (iCF>1)      
		if (jpObs~=jrObs)
			% single branch case at the end of the tree
			PTree{jpObs-1}(:) = PTree{jpObs}(:);
		else
			% accumulate the average value at the next time
			PTree{jpObs-1}(:,:) = PTree{jpObs-1}(:,:) + ...
				(PTree{jpObs}(:,1:end-1)+PTree{jpObs}(:,2:end))/2;			
		end
	end
end

Price = PTree{1}(:);

if nargout<2
	return
end

PriceTree = classfin('BDTPriceTree');
PriceTree.tObs = TreeTimes';
PriceTree.PTree = PTree;

return
