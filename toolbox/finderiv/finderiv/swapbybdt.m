function [Price, PriceTree, CFTree, SwapRate] = swapbybdt(BDTTree, varargin)
%SWAPBYBDT Price a vanilla swap from a BDT interest rate tree.
%
%   [Price, PriceTree, CFTree, SwapRate] = swapbybdt(BDTTree, LegRate, Settle, ...
%                                         Maturity)
%
%   [Price, PriceTree, CFTree, SwapRate] = swapbybdt(BDTTree, LegRate, Settle, ...
%                                         Maturity, LegReset, Basis,  ...
%                                         Principal, LegType, Options)
% Inputs:
%   BDTTree    - Interest rate tree structure created by BDTTREE.
%
%   LegRate    - NINSTx2 matrix, with each row defined as follows: 
%                [CouponRate Spread] or [Spread CouponRate]
%                where CouponRate is the decimal annual rate and Spread is the number 
%                of basis points over the reference rate. The first column represents
%                the receiving leg, while the second column represents the paying leg.                 
%   Settle     - NINSTx1 vector of dates representing the settle date for each swap.
%   Maturity   - NINSTx1 vector of dates representing the maturity date for each swap.
%   LegReset   - NINSTx2 matrix representing the reset frequency per year for each
%                swap. Default is [1 1].
%   Basis      - NINSTx1 vector representing the basis used when annualizing the input 
%                forward rate tree for each instrument. Default is 0 (actual/actual).
%   Principal  - NINSTx1 vector of the notional principal amounts. Default is 100.
%   LegType    - NINSTx2 matrix, with each row representing an instrument, and each
%                column indicating if the corresponding leg is fixed or floating. A 
%                value of 0 represents a floating leg, and a value of 1 represents 
%                a fixed leg. Use this matrix to define how to interpret the values
%                entered in the Matrix LegRate. Default is [1,0] for each instrument.
%   Options    - Structure created with derivset containing derivatives 
%                pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price     - NINSTx1 vector of prices for the swaps at time 0.
%   PriceTree - Tree structure with a vector of swaps' values at each node. 
%   CFTree    - Tree structure with a vector of swaps' cash flows at each node.
%   SwapRate  - NINSTx1 vector of rates applicable to the fixed leg such that 
%               the swaps' values are zero at time 0. This rate is calculated
%               and used in calculating the swaps prices when the rate specified 
%               for the fixed leg in LegRate is NaN. SwapRate is padded with
%               NaNs for those instruments in which the coupon rate is not set 
%               to NaN.
%
% Notes: The Settle date for every swap is set to the ValuationDate 
%        of the BDT Tree.  The swap argument "Settle" is ignored.
%
%        This function also calculates the SwapRate (fixed rate) so that the
%        value of the Swap is initially zero. To do this CouponRate should be
%        entered as NaN.
%
% See also BDTTREE, CFBYBDT, CAPBYBDT, FLOORBYBDT, FIXEDBYBDT, BONDBYBDT

%   Author(s): M. Reyes-Kattar 07/25/2001
%   Copyright 1998-2003 The MathWorks, Inc.
%   $Revision: 1.3.2.2 $  $                          $

%---------------------------------------------------------------------
%Checking the input arguments.
%---------------------------------------------------------------------
if ~isafin(BDTTree,'BDTFwdTree')
  error('finderiv:swapbybdt:InvalidTree','The first argument must be a BDT tree created by BDTTREE');
end

if (nargin < 4)
   error('finderiv:swapbybdt:InvalidInputs','You must enter BDTTree, LegRate, Settle and Maturity');
end

% Extract pricing options
options = [];
if length(varargin) > 7
  options = varargin{8};
  varargin = varargin(1:7);
end

% Set default for pricing option
if(isempty(options))
    options = derivset;
end

% Sanity check on 'options'
if ~isa(options,'struct')
  error('finderiv:swapbybdt:InvalidOptions','Options must be an options structure created with DERIVSET.');
end

% Extract options information
[ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options);


[LegRate, Settle, Maturity, LegReset, Basis, Principal, LegType] = ...
   instargswap(varargin{1}, BDTTree.TimeSpec.ValuationDate, varargin{3:end});

% Special rules: Single settlement equal to Valuation Date
SwapSettle = finargdate(varargin{2});
SwapSettle = SwapSettle(~isnan(SwapSettle));
if ~isempty(SwapSettle) & any(SwapSettle ~= Settle(1))
   warning('finderiv:swapbybdt:IgnoredSettle','Swaps are valued at BDT Tree ValuationDate rather than Settle');
end


% -------------------------------------------------------------
% Separate floating notes from fixed notes:
% -------------------------------------------------------------
[NumInst, NumCols] = size(LegType);

floatInd = find(LegType == 0);
fixedInd = find(LegType == 1);

FloatEntered = ~isnan(floatInd);
FixedEntered = ~isnan(fixedInd);

floatRowInd = mod(floatInd-1, NumInst)+1;
fixedRowInd = mod(fixedInd-1, NumInst)+1;

Spreads = LegRate(floatInd);
FixedRates  = LegRate(fixedInd);

FloatResets = LegReset(floatInd);
FixedResets = LegReset(fixedInd);

FloatMaturity = Maturity(floatRowInd);
FixedMaturity = Maturity(fixedRowInd);

FloatBasis = Basis(floatRowInd);
FixedBasis = Basis(fixedRowInd);

FloatPrincipal = Principal(floatRowInd);
FixedPrincipal = Principal(fixedRowInd);



% ---------------------------------------------------------
% Extract the branch information from the BDTTree.
% ---------------------------------------------------------
Compounding = BDTTree.TimeSpec.Compounding;
TreeDates   = [BDTTree.TimeSpec.ValuationDate; BDTTree.TimeSpec.Maturity];
TreeTimes   = [BDTTree.tObs'; BDTTree.CFlowT{end}];


% ---------------------------------------------------------
% Generate the cash flow matrices. While the cash flows
% obtained here are invalid (they assume a constant rate)
% we use this function to obtain the dates and times of
% the cash flows.
% ----------------------------------------------------------
[CFAmounts, CFDates, CFTimes] = cfamounts(1, repmat(Settle, 2, 1), ...
    [FloatMaturity;FixedMaturity], [FloatResets;FixedResets], [FloatBasis;FixedBasis]);

% ----------------------------------------------------------
% Change semiannual time factors to compounded times. 
% CFAmounts assumes that the time factors are semiannual, 
% which is not necessarily the case in the tree. We here 
% find the actual CFTimes base on the compounding dictated 
% by the BDTTree.
% ----------------------------------------------------------
[dummy, F] = date2time([],[], Compounding);
CFTimes = CFTimes*F/2;

% ----------------------------------------------------------
% Set all parameters to a single time line
[AllCF, AllDates, AllTimes, AllInd] = cfport(CFAmounts, CFDates, CFTimes);


% ----------------------------------------------------------
% If the tree doesn't cover all the CF times, we need to generate
% a new one so that all CFs fall in a tree node
% ----------------------------------------------------------
BDTTreeOri = [];
if (~all(ismember(AllTimes, TreeTimes)))
    
    if(ConstRate)
        if(ShowWarnings)
            warning('finderiv:swapybdt:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:swapbybdt:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
        end
        
        AllDates = union(AllDates, TreeDates);
        
        if(ShowDiagnostics)
            NumBranch = BDTTree.VolSpec.NumBranch;
            DiagMsg = sprintf('\nBuilding new tree with %d levels.\nLast node will have %d states.\n',...
                length(AllDates)-1, length(AllDates)-1);
            disp(DiagMsg);
        end
        
        TimeSpecNew  = bdttimespec(BDTTree.TimeSpec.ValuationDate, AllDates(2:end), ...
            BDTTree.RateSpec.Compounding);
        BDTTreeOri = BDTTree;
		TreeTimesOri = TreeTimes;
        BDTTree = bdttree(BDTTreeOri.VolSpec, BDTTreeOri.RateSpec, TimeSpecNew);
        
        % Redefine tree paramenters
        TreeDates   = [BDTTree.TimeSpec.ValuationDate; BDTTree.TimeSpec.Maturity];
        TreeTimes   = [BDTTree.tObs'; BDTTree.CFlowT{end}];    
    end
end


% -------------------------------------------------------------
% If any of the coupon rates is a NaN, we need to calculate the
% coupon rates. Find their location for later processing
SRFixedInd = [];
if any(isnan(FixedRates))
	% SRFixedInd = index into fixedInd where the fixed leg of a "swap-rate swap" is located
	% SRFloatInd = index into floatInd where the float leg of a "swap-rate swap" is located
   [SRFixedInd, SRFloatInd] = findSwapRateInds(LegRate, LegType, floatInd, fixedInd);
end

% --------------------------------------------------------------
% Find Cash Flow and prices for each one of the instruments
% --------------------------------------------------------------
if(FloatEntered)
	[FloatPrice, FloatBDTPriceTree, FloatCashFlowTree] = floatbybdt(BDTTree, Spreads, Settle,...
                      FloatMaturity, FloatResets, FloatBasis, FloatPrincipal);
end

% --------------------------------------------------------------
% If any of the fixed legs were set to NaN, we must calculate the
% corresponding SwapRate
if any(isnan(FixedRates))
	FixedRates(SRFixedInd) = findswaprates(BDTTree.RateSpec, FloatPrice(SRFloatInd), Settle(SRFixedInd),...
        FixedPrincipal(SRFixedInd), FixedMaturity(SRFixedInd), FixedResets(SRFixedInd), ...
        FixedBasis(SRFixedInd));       
end

if(FixedEntered)
	[FixedPrice, FixedBDTPriceTree, FixedCashFlowTree] = fixedbybdt(BDTTree, FixedRates, Settle,...
   						FixedMaturity, FixedResets, FixedBasis, FixedPrincipal);
end
                  

% --------------------------------------------------------------
% Build the SwapTree, which will have the same structure as the 
% PriceTrees of either the float or the fixed, but with NumInst
% as the NumPos.
% --------------------------------------------------------------
if(FixedEntered)
    [NumLevels, NumPos, IsPriceTree] = treeshape(FixedBDTPriceTree.PTree);
else
    [NumLevels, NumPos, IsPriceTree] = treeshape(FloatBDTPriceTree.PTree);
end
PTree = mktree(NumLevels, [NumPos], NaN, IsPriceTree);

% --------------------------------------------------------------
% The cash flow tree has the same structure as the PriceTree
% --------------------------------------------------------------
BDTCFTree = PTree;

% --------------------------------------------------------------
% Walk through each level assembling the swap, and taking into 
% consideration the direction of the cash flows:
% --------------------------------------------------------------
IFloat = 1:length(floatInd);
IFixed = 1:length(fixedInd);

[floatRows, floatCols] = ind2sub([NumInst, NumCols], floatInd);
[fixedRows, fixedCols] = ind2sub([NumInst, NumCols], fixedInd);

if(FloatEntered)
    FloatPTree  = FloatBDTPriceTree.PTree;
    FloatAITree = FloatBDTPriceTree.AITree;
    FloatCFTree = FloatCashFlowTree.CFTree;
end

if(FixedEntered)
    FixedPTree  = FixedBDTPriceTree.PTree;
    FixedAITree = FixedBDTPriceTree.AITree;
    FixedCFTree = FixedCashFlowTree.CFTree;
end

for iLevel = 1:NumLevels
   LVals = zeros(size(PTree{iLevel}));
   RVals = LVals;
   
   % -----------------------------------------------------------------
   % floatCols = 1 for the instruments in the left  column of LegRate
   % floatCols = 2 for the instruments in the right column of LegRate
   % -----------------------------------------------------------------
   if(FloatEntered)
       LVals(floatRows(floatCols == 1),:) = FloatPTree{iLevel}(IFloat(floatCols==1),:) + ...
           									FloatAITree{iLevel}(IFloat(floatCols==1),:);
       RVals(floatRows(floatCols == 2),:) = FloatPTree{iLevel}(IFloat(floatCols==2),:) + ...
                                            FloatAITree{iLevel}(IFloat(floatCols==2),:);
   end
   
   if(FixedEntered)
       LVals(fixedRows(fixedCols == 1),:) = FixedPTree{iLevel}(IFixed(fixedCols==1),:) + ...
                                            FixedAITree{iLevel}(IFixed(fixedCols==1),:);
       RVals(fixedRows(fixedCols == 2),:) = FixedPTree{iLevel}(IFixed(fixedCols==2),:) + ...
                                            FixedAITree{iLevel}(IFixed(fixedCols==2),:);
   end
   
   PTree{iLevel} =  LVals - RVals;
   
   % -----------------------------------------------------------------
   % Now do the same for the cash flows
   % -----------------------------------------------------------------
   if(FloatEntered)
       LVals(floatRows(floatCols == 1),:) = FloatCFTree{iLevel}(IFloat(floatCols==1),:);
       RVals(floatRows(floatCols == 2),:) = FloatCFTree{iLevel}(IFloat(floatCols==2),:);
   end
   
   if(FixedEntered)
       LVals(fixedRows(fixedCols == 1),:) = FixedCFTree{iLevel}(IFixed(fixedCols==1),:);      
       RVals(fixedRows(fixedCols == 2),:) = FixedCFTree{iLevel}(IFixed(fixedCols==2),:);
   end
   
   BDTCFTree{iLevel} =  LVals - RVals;
end


% --------------------------------------------------------
% Find the Price of each swap
% --------------------------------------------------------
Price =  PTree{1};


% --------------------------------------------------------
% Build the BDTPriceTree & BDTCFTree
% --------------------------------------------------------
PriceTree = classfin('BDTPriceTree');
PriceTree.tObs = [BDTTree.tObs BDTTree.CFlowT{end}];
PriceTree.PTree = PTree;

CFTree = classfin('BDTCFTree');
CFTree.tObs = [BDTTree.tObs BDTTree.CFlowT{end}];
CFTree.CFTree = BDTCFTree;


% --------------------------------------------------------
% If requested, return the SwapRate where applicable
% --------------------------------------------------------
if nargout > 3
   SwapRate = NaN*ones(NumInst, 1);
   SwapRate(SRFixedInd) = FixedRates(SRFixedInd);
end


% =========== END SWAPBYBDT =========================


% ---------------------------------------------------------
% Aux fcn to find the location of the instruments needed to
% calculate the SwapRates
function [SRFixedInd, SRFloatInd] = findSwapRateInds(LegRate, LegType, floatInd, fixedInd)   
NumInst = size(LegRate,1);
% ---------------------------------------------------------
% If any of the coupon rates was entered as NaN, we must
% substitute it by the corresponding swap rate.
% ---------------------------------------------------------
[SwapRateRowInd, SwapRateColInd] = find(isnan(LegRate));
SwapRateInd = (SwapRateColInd-1)*NumInst+SwapRateRowInd;
   
% ---------------------------------------------------------
% Only Fixed Rate notes can have a NaN for their rates
% ---------------------------------------------------------
if(~all(LegType(SwapRateInd) == ones(size(SwapRateInd))))
   error('finderiv:swapbybdt:InvalidInputs','Only a fixed leg is allowed to use NaN as its rate');
end
   
% ---------------------------------------------------------
% Make sure that they're either float/fixed of fixed/float swaps
% ---------------------------------------------------------
if(any(diff(LegType(SwapRateRowInd,:), 1, 2))==0)
   error('finderiv:swapbybdt:InvalidInputs','Swap rates can only be calculated for vanilla swaps.')
end
   
% ---------------------------------------------------------
% Find the indexes of the corresponding floats and fixed
% ---------------------------------------------------------
SwapRateRowMask = zeros(size(LegRate));
SwapRateRowMask(SwapRateRowInd,:) = 1;
   
SwapRateFloatInd = find(SwapRateRowMask & (LegType==0));
SwapRateFixedInd = find(SwapRateRowMask & (LegType==1));
   
% --------------------------------------------------------
% SwapRateFloatInd hold the indexes of the float legs of the
% swap needed to find the swap rates. floatInd hold the indexes
% of all floats. We now find the positions within floatInd where
% the elements of SwapRateFloatInd are.
% --------------------------------------------------------
[SRFInd, FInd] = finargsz('all', SwapRateFloatInd, floatInd');
EQMask = (SRFInd == FInd);
SRFloatInd = find(sum(EQMask,1));
   
% ---------------------------------------------------------
% Same as above, but for the fixed leg
% ---------------------------------------------------------
[SRFInd, FInd] = finargsz('all', SwapRateFixedInd, fixedInd');
EQMask = (SRFInd == FInd);
SRFixedInd = find(sum(EQMask,1));
return
