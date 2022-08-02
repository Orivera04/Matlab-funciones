function [Price, PriceTree, CFTree] = bondbyhjm(HJMTree, varargin)
%BONDBYHJM Price bonds from an HJM interest rate tree.
%   Dynamic programming subroutine for HJMPRICE.
%
%   [Price, PriceTree] = bondbyhjm(HJMTree, CouponRate, Settle, Maturity)
%
%   [Price, PriceTree] = bondbyhjm(HJMTree, CouponRate, Settle, Maturity, ...
%                                  Period, Basis, EndMonthRule, ...
%                                  IssueDate, FirstCouponDate, LastCouponDate, ...
%                                  StartDate, Face, Options)
%
% Inputs: Type "help instbond" or "help ftb" for a description of bond
%         arguments.   
%
%   HJMTree         - Forward rate tree structure created by HJMTREE.
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
%   Options			- Structure created with derivset, containing derivatives 
%                     pricing options. Type "help derivset" for more information.
%                     
% Outputs:
%   Price     - NINSTx1 expected prices at time 0.
%   PriceTree - Structure containing trees of vectors of instrument prices and 
%               accrued interest, and a vector of observation times for each
%               node. 
%
%               PriceTree.PBush contains the clean prices. 
%               PriceTree.AIBush contains the accrued interest.
%               PriceTree.tObs contains the observation times.
%
% Notes: The Settle date for every bond is set to the ValuationDate of
%        the HJM Tree.  The bond argument, Settle, is ignored. 
%
% See also HJMTREE, HJMPRICE, INSTBOND.

%   Author(s): J. Akao, M. Reyes-Kattar 5-Mar-1999
%   Copyright 1998-2003 The MathWorks, Inc.
%   $Revision: 1.18.2.1 $  $Date: 2003/08/29 04:46:14 $

%---------------------------------------------------------------------
% Parse input arguments
%---------------------------------------------------------------------

if ~isafin(HJMTree,'HJMFwdTree')
  error('finderiv:bondbyhjm:InvalidTree','The first argument must be an HJM tree created by HJMTREE');
end

if length(varargin) < 3,
  error('finderiv:bondbyhjm:InvalidInputs','You must pass at least three input arguments')
end

% Extract pricing options
options = [];
if length(varargin) > 11
  options = varargin{12};
  varargin = varargin(1:11);
end

% Set default for pricing option
if(isempty(options))
    options = derivset;
end

% Sanity check on 'options'
if ~isa(options,'struct')
  error('finderiv:bondbyhjm:InvalidOptions','Options must be an options structure created with DERIVSET.');
end

% Extract options information
[ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options);


% Process bond instrument arguments contained in varargin
[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
      FirstCouponDate, LastCouponDate, StartDate, Face] = ...
    instargbond(varargin{1}, HJMTree.TimeSpec.ValuationDate, varargin{3:end});
  
% Special rules: Single settlement equal to Valuation Date
BondSettle = finargdate(varargin{2});
BondSettle = BondSettle(~isnan(BondSettle));
if ~isempty(BondSettle) & any(BondSettle ~= Settle(1))
   warning('finderiv:bondbyhjm:IgnoredSettle','Bonds are valued at HJM Tree ValuationDate rather than Settle');
end


% Create cash flow matrices
[CFAmounts, CFDates, CFTimes] = cfamounts(CouponRate, Settle, Maturity, ... 
    Period, Basis, EndMonthRule, IssueDate, ... 
    FirstCouponDate, LastCouponDate, StartDate, Face);

%---------------------------------------------------------------------
% Map cash flows to every node
% TreeDates [NumLevels+1 x 1] vector of dates from valuation to maturities
% TreeTimes [NumLevels+1 x 1] vector of compounded times
%
%---------------------------------------------------------------------
TreeDates = [HJMTree.TimeSpec.ValuationDate; 
             HJMTree.TimeSpec.Maturity];
TreeTimes = [HJMTree.tObs'; HJMTree.CFlowT{end}];

% change semiannual time factors to compounded times
[dummy, F] = date2time([],[], HJMTree.TimeSpec.Compounding);
CFTimes = CFTimes*F/2;

% ----------------------------------------------------------
% Set all parameters to a single time line
[AllCF, AllDates, AllTimes, AllInd] = cfport(CFAmounts, CFDates, CFTimes);

% Extract branch averaging information applicable for all but the last level
NumBranch = HJMTree.VolSpec.NumBranch;
PBranch = HJMTree.VolSpec.PBranch;

% ----------------------------------------------------------
% If the tree doesn't cover all the CF times, we may need to generate
% a new one so that all CFs fall in a tree node
% ----------------------------------------------------------
if (~all(ismember(AllTimes, TreeTimes)))
    
    if(ConstRate)
        if(ShowWarnings)
            warning('finderiv:bondbyhjm:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:bondbybdt:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
        end        
        
        if(ShowDiagnostics)  
            DiagMsg = sprintf('\nBuilding new tree with %d levels.\nLast node will have %d states.\n',...
                (length(AllDates)-1), NumBranch ^ (length(AllDates)-2));
            disp(DiagMsg);
        end
        
        TimeSpecNew  = hjmtimespec(HJMTree.TimeSpec.ValuationDate, AllDates(2:end), ...
            HJMTree.RateSpec.Compounding);
        HJMTreeOri   = HJMTree;
        TreeTimesOri = TreeTimes;
        HJMTree = hjmtree(HJMTreeOri.VolSpec, HJMTreeOri.RateSpec, TimeSpecNew);
        
        % Redefine tree paramenters
        TreeDates   = [HJMTree.TimeSpec.ValuationDate; HJMTree.TimeSpec.Maturity];
        TreeTimes   = [HJMTree.tObs'; HJMTree.CFlowT{end}];
    end
end


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

[AllCF, IsTreeDate, AllDates, AllTimes, AllInd,PriceObsInd, RateObsInd, DiscFrac] = hjmtreetime(...
    CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes);

[NumInst,NumCFs] = size(AllCF);

%---------------------------------------------------------------------
% Make a set of valuation adjustments which are not actually cash flows
% You don't get a coupon if you value on a coupon date
% You do pay accrued interest if you value off of a coupon date
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

AllCF(:,1) = 0; % Accrued interests are taken care of later
AllAdjustments = -AllCF; 
AllAdjustments(FaceInd) = AllAdjustments(FaceInd) + Face; % include face 

% You only need the adjustments at the tree dates
Adjustments = AllAdjustments(:,IsTreeDate);


%---------------------------------------------------------------------
% Make a new price tree including final times
%---------------------------------------------------------------------
FwdTree = HJMTree.FwdTree;
[NumLevels, NumChild, NumPos, NumStates] = bushshape(FwdTree);

% make a new structure with the final times on the end (NumLevels+1)
NumPLevels = NumLevels+1;
NumPChild  = [NumChild(1:end-1), 1, 0];
NumPStates = [NumStates, NumStates(end)];

PriceBush = mkbush(NumPLevels, NumPChild, ...
   NumInst*ones(1,NumPLevels), 0, 0);

% --------------------------------------------------------------------
% The Cash Flow Tree has the same structure as the price bush of the
% HJM tree
% --------------------------------------------------------------------
CFBush = PriceBush;

%---------------------------------------------------------------------
% Dynamic programming to determine the price
% iCF   [1...NumCFs] : place in the cash flow times
% jpObs [1...NT]   : place in the price tree observations
% jrObs [1...NT-1] : place in the rate tree observations
%---------------------------------------------------------------------
% Create an expansion vector over the instruments
Iones = ones(NumInst,1);

% Zero out the last values to begin
PriceBush{end}(:) = 0;

for iCF = NumCFs:-1:1,
  jpObs = PriceObsInd(iCF);
  jrObs = RateObsInd(iCF);
  
  % Perform a discounting step to take future value to present value
  % You are discounting from AllTimes(iCF+1) to AllTimes(iCF)
  % FwdTree{jrObs}(1,:) is the spot rate discount applicable for this interval
  % RateStates is the discount factor cut down for the CF interval
  % RateStates [1 x NumPStates(jrObs)]
  % jrObs < jpObs only at the last level.  NumStates is the same at the
  % last and second-to-last levels of the price tree.
  if iCF<NumCFs
    RateStates = ( 1 ./ FwdTree{jrObs}(1,:) ).^DiscFrac(iCF);
    PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) .* RateStates(Iones,:);
  end

  % Add the cash flow at this time to the present value of the future
  PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) + ...
      AllCF(:, iCF* ones(1,NumPStates(jpObs)) );    
  
  % Perform the valuation and option invocation
  % CleanPrice = PriceBush{jpObs}(:,:) - AllAdjustments(:,iCF*ones)
  % Call/Put limits
  if(IsTreeDate(iCF) & iCF>1)
      if (NumPChild(jpObs-1)==NumBranch)     
          % accumulate the average value at the next time
          PriceBush{jpObs-1}(:,:) = 0;
          for kB = 1:NumBranch
              PriceBush{jpObs-1}(:,:) = PriceBush{jpObs-1}(:,:) + PBranch(kB) * ...
                  PriceBush{jpObs}(:,:,kB);
          end          
      elseif (NumPChild(jpObs-1)==1)
          % single branch case at the end of the tree
          PriceBush{jpObs-1}(:,:) = PriceBush{jpObs}(:,:);
      end
  end
end

%Calculate accrued interest
AIBush = findaccint(PriceBush, TreeDates, CouponRate, Maturity, ... 
    					 Period, Basis, EndMonthRule, IssueDate, ... 
                         FirstCouponDate, LastCouponDate, StartDate, Face);

Price = PriceBush{1}(:) - AIBush{1}(:);

if nargout<2
  return
end

% Build the CashFLow tree.
for iVal = 1:NumLevels+1  
  CFBush{iVal}(:,:) = -Adjustments(:, iVal*ones(1, NumPStates(iVal)));
end


% ------------------------------------------------------------------
% Adjust the prices to reflect valuation on tree dates. Calculate
% clean price by substracting accrued interests
% ------------------------------------------------------------------
for iVal = 1:NumPLevels
  PriceBush{iVal}(:,:) = PriceBush{iVal}(:,:) - CFBush{iVal}(:,:) - ...
      AIBush{iVal}(:,:);
end

                     

% Build output structures
PriceTree = classfin('HJMPriceTree');
PriceTree.tObs = TreeTimes';
PriceTree.PBush = PriceBush;
PriceTree.AIBush = AIBush;

CFTree = classfin('HJMCFTree');
CFTree.tObs = TreeTimes';
CFTree.CFBush = CFBush;

return


function AIBush = findaccint(PriceBush, TreeDates, CouponRate, Maturity, ... 
    					 Period, Basis, EndMonthRule, IssueDate, ... 
                         FirstCouponDate, LastCouponDate, StartDate, Face);

% Obtain basic shape information off the price bush
[NumLevels, NumChild, NumPos, NumStates] = bushshape(PriceBush);

% Create an accrued interest bush
AIBush = mkbush(NumLevels, NumChild, NumPos, 0, 0);

% Zero-coupon bonds will have a Period of zero. Substitute for
% 2 for calculation. This won't have any effect since the coupon
% rate is zero.
Period(Period==0)=2;

NumInst   = length(Maturity);

for iLevel=1:NumLevels
    
    % Identify active instruments
    ActiveMask = Maturity > TreeDates(iLevel);
    if(any(ActiveMask));       
        
        NumActiveInst = sum(ActiveMask);
        
        % This TreeDate becomes the settle of the "pretend coupon"
        Settle     = TreeDates(iLevel)*ones(NumActiveInst,1);
        
        % Nominal coupon payment
        NomCoupon  = (Face(ActiveMask) .* CouponRate(ActiveMask)) ./ Period(ActiveMask);
        
        % Accrued interest for active bonds
        AccInt = NomCoupon .* accrfrac( Settle, Maturity(ActiveMask), Period(ActiveMask), ...
            Basis(ActiveMask), EndMonthRule(ActiveMask), IssueDate(ActiveMask),...
            FirstCouponDate(ActiveMask), LastCouponDate(ActiveMask), ...
            StartDate(ActiveMask), Face(ActiveMask));
        
        AIAmounts = zeros(NumInst, 1);
        AIAmounts(ActiveMask) =  AccInt;
        
        % All bonds have similar accrued interest accross the states of this tree level
        AIBush{iLevel}(:,:) = repmat(AIAmounts, 1, NumStates(iLevel));        
    end
end
