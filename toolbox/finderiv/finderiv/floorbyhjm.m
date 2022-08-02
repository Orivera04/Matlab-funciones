function [Price, PriceTree] = floorbyhjm(HJMTree, varargin)
%FLOORBYHJM Price a floor from an HJM interest rate tree.
%
%   [Price, PriceTree] = floorbyhjm(HJMTree, Strike, Settle, Maturity)
%
%   [Price, PriceTree] = floorbyhjm(HJMTree, Strike, Settle, Maturity,...
%                                   Reset, Basis, Principal, Options)
%
% Inputs:
%   HJMTree    - Forward rate tree structure created by HJMTREE.
%   Strike     - NINSTx1 vector of rates at which the floor is exercised, as 
%                a decimal number. 
%   Settle     - NINSTx1 vector of dates representing the settle date of the floor.
%   Maturity   - NINSTx1 vector of dates representing the maturity date of the floor.
%   Reset      - NINSTx1 vector representing the frequency of payments per year.
%                Default is 1.
%	Basis      - NINSTx1 vector representing the basis used when annualizing the 
%                input forward rate tree. Default is 0 (actual/actual)
%   Principal  - NINSTx1 vector of the notional principal amount. Default is 100.
%   Options	   - Structure created with derivset containing derivatives 
%                pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price     - NINSTx1 expected prices of the floor at time 0.
%   PriceTree - Tree structure with a vector of floor values at each node. 
%
%
% Notes: The Settle date for every floor is set to the ValuationDate of
%        the HJM Tree.  The floor argument "Settle" is ignored.
%
% See also HJMTREE, CFBYHJM, CAPBYHJM, SWAPBYHJM

%   Author(s): M. Reyes-Kattar 09/27/98
%   Copyright 1998-2003 The MathWorks, Inc.
%   $Revision: 1.21.2.2 $  $Date: 2004/04/06 01:08:31 $

%---------------------------------------------------------------------
%Checking the input arguments.
%---------------------------------------------------------------------
if (nargin < 4)
   error('finderiv:floorbyhjm:InvalidInputs','You must enter HJMTree, Strike, Settle and Maturity');
end

if ~isafin(HJMTree,'HJMFwdTree')
  error('finderiv:floorbyhjm:InvalidTree','The first argument must be an HJM tree created by HJMTREE');
end

% Extract pricing options
options = [];
if length(varargin) > 6
  options = varargin{7};
  varargin = varargin(1:6);
end

% Set default for pricing option
if(isempty(options))
    options = derivset;
end

% Extract options information
[ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options);

% Process floor instrument arguments contained in varargin
[Strike, Settle, Maturity, FloorReset, Basis, Principal] = ...
   instargfloor(varargin{1}, HJMTree.TimeSpec.ValuationDate, varargin{3:end});
  
% special rules: Single Settle equal to Valuation Date
FloorSettle = finargdate(varargin{2});
FloorSettle = FloorSettle(~isnan(FloorSettle));
if ~isempty(FloorSettle) & any(FloorSettle ~= Settle(1))
   warning('finderiv:floorbyhjm:IgnoredSettle','Floors are valued at HJM Tree ValuationDate rather than Settle');
end


% Extract the tree information
Compounding = HJMTree.TimeSpec.Compounding;
TreeDates = [HJMTree.TimeSpec.ValuationDate; 
             HJMTree.TimeSpec.Maturity];
TreeTimes = [HJMTree.tObs'; HJMTree.CFlowT{end}];

% -------------------------------------------------------------------
% Find cash flow matrix and cash flow dates. The cash flows (CFAmounts) 
% obtained here won't be used. We use this call the hjmtreetime to find
% the dates and times in which cash flows occur.
% --------------------------------------------------------------------
[CFAmounts, CFDates, CFTimes] = cfamounts(1, Settle, Maturity, FloorReset, Basis);

% ----------------------------------------------------------
% Change semiannual time factors to compounded times. 
% CFAmounts assumes that the time factors are semiannual, 
% which is not necessarily the case in the tree. We here 
% find the actual CFTimes base on the compounding dictated 
% by the HJMTree.
% ----------------------------------------------------------
[dummy, F] = date2time([],[], Compounding);
CFTimes = (CFTimes * F) / 2;

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
            warning('finderiv:floorbybhjm:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:floorbyhjm:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
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
% Map cash flows to every node 
% TreeDates [NumLevels+1 x 1] vector of dates from valuation to maturities
% TreeTimes [NumLevels+1 x 1] vector of compounded times
%--------------------------------------------------------------------
% Get the map of cash flows on tree nodes
[AllCF, IsTreeDate, AllDates, AllTimes, AllInd, PriceObsInd, RateObsInd, DiscFrac] = hjmtreetime(...
    CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes);
 
 
% ---------------------------------------------------------------------
% Build an array of 1's and 0's indicating where the CFs occur.
% ----------------------------------------------------------------------
CFT = AllCF>0;

% ----------------------------------------------------------
% Find the last CF index for each instrument. 
% ----------------------------------------------------------
[dummy, LastNodes] = max(cumsum(CFT,2), [], 2);

	
% Number of instruments & total number of cash flow dates
[NumInst, NumCFs] = size(AllCF);


% Convert Strike to Fwd Strike
FStrike = 1 ./ rate2disc(Compounding, Strike, 1);


% Extract tree information for the creation of the price tree
FwdTree = HJMTree.FwdTree;
[NumLevels, NumChild, NumPos, NumStates] = bushshape(FwdTree);

% --------------------------------------------------------------------
% Make a new structure with the final times on the end (NumLevels+1).
% This is what hjmprice expects us to return: a price tree with one
% more level than the FwdTree. If there are no cash flows in the
% last node, simply place zeros there.
% --------------------------------------------------------------------
NumPChild = [NumChild(1:end-1), 1, 0];
NumPStates = [NumStates, NumStates(end)];
PriceBush = mkbush(NumLevels+1, NumPChild, ...
   NumInst*ones(1,NumLevels+1), [], 0);

% --------------------------------------------------------------------
% Create an adjustment tree to hold the cash flows at each of the
% nodes. This is subtracted from the price bush at the end, to that
% each node of PriceBush represents the present value (at that node)
% of the cash flows occuring in future nodes.
% PriceBush is full of zeroes at this point:
% --------------------------------------------------------------------
Adjustments = PriceBush;

% Create an expansion vector over the instruments
Iones = ones(NumInst,1);

%---------------------------------------------------------------------
% Dynamic programming to determine the price
% iCF   [1...NumCFs] : place in the cash flow times
% jpObs [1...NT]   : place in the price tree observations
% jrObs [1...NT-1] : place in the rate tree observations
%---------------------------------------------------------------------
% For each cash flow
for iCF = NumCFs:-1:1,
    jpObs = PriceObsInd(iCF);
    jrObs = RateObsInd(iCF);
    
    
    % --------------------------------------------------------------------
    % Perform a discounting step to take future value to present value
    % You are discounting from AllTimes(iCF+1) to AllTimes(iCF)
    % FwdTree{jrObs}(1,:) is the spot rate discount applicable for this interval
    % RateStates is the discount factor cut down for the CF interval
    % RateStates [1 x NumPStates(jrObs)]
    % jrObs < jpObs only at the last level.  NumStates is the same at the
    % last and second-to-last levels of the price tree.
    % --------------------------------------------------------------------
    if iCF<NumCFs
        RateStates = ( 1 ./ FwdTree{jrObs}(1,:) ).^DiscFrac(iCF);
        PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) .* RateStates(Iones,:);
    end
    
    % Only some of the instruments are active. Out of those, the only floorlet
    % node in which there is cash flows is the last one.
    ActiveNodeMask = CFT(:,iCF);
    
    if(any(ActiveNodeMask) & iCF > 1)            
        if(IsTreeDate(iCF))
            BCFs = zeros(size(PriceBush{jpObs}));
        else
            BCFs = zeros(size(PriceBush{min(jpObs+1, length(PriceBush))}));                  
        end
        
        % Find the index into CFTimes to the previous reset
        % for each instrument
        PrevResetTime = NaN*ones(size(ActiveNodeMask));
        cftIndex = find(abs(CFTimes - AllTimes(iCF))<eps);
	[row, cftIndex] = ind2sub(size(CFTimes), cftIndex);
        [row, ISort] = sort(row); cftIndex = cftIndex(ISort);
        cftIndex = cftIndex-1;
        PrevResetTime(ActiveNodeMask) = CFTimes(sub2ind(size(CFTimes), row, cftIndex));
        
        % For the caplets at their last node, find the cash flow using
        % the last node equation:
        BCFs(ActiveNodeMask,:) = FindCF(HJMTree, AllTimes(iCF), ...
            PrevResetTime(ActiveNodeMask), Strike(ActiveNodeMask), ...
            Principal(ActiveNodeMask), FloorReset(ActiveNodeMask));               
        
        if(IsTreeDate(iCF))
            PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) + BCFs(:,:);
            Adjustments{jpObs}(:,:) = BCFs(:,:);
        else
            for iBranch=1:NumPChild(jpObs)        
                PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) + ...
                    PBranch(iBranch) * BCFs(:, :, iBranch);
            end
        end            
    end        
    
    % If you are on a tree date, average down to start the next state level
    if IsTreeDate(iCF) & (iCF>1) 
        if (NumPChild(jpObs-1)==NumBranch)
            % average over NumBranch children      
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

Price = PriceBush{1};

% Take out the adjustments from the PriceBush
for k=1:length(PriceBush)
   PriceBush{k}(:, :) = PriceBush{k}(:, :) - Adjustments{k}(:,:);
end


PriceTree = classfin('HJMPriceTree');
PriceTree.tObs = TreeTimes';
PriceTree.PBush = PriceBush;
return


function CF = FindCF(HJMTree, EndTime, StartTimes, Strike, Principal, FloorReset)
	NumInst = size(Principal, 1);
    Compounding = HJMTree.RateSpec.Compounding;
    
    Rates = [];
    for iInst=1:NumInst
        InstRates = findeffrates(HJMTree, StartTimes(iInst), EndTime);
        if(Compounding ~= FloorReset(iInst))
            RS = intenvset('Compounding', Compounding, ...
                			'StartTime', StartTimes(iInst), ...
                			'EndTimes',  EndTime, ...
                			'Rates', InstRates);
            RS = intenvset(RS, 'Compounding', FloorReset(iInst));
            InstRates = intenvget(RS, 'Rates');
        end
        
        Rates = [Rates; max(Strike(iInst) - InstRates, 0)];        
    end    
    CF = (Principal * ones(1, size(Rates,2))) .* Rates ./ (FloorReset * ones(1, size(Rates,2)));
return
