function [Price, PriceTree, CFTree] = floatbybdt(BDTTree, varargin)
%FLOATBYBDT Price floating rate notes from a BDT interest rate tree.
%
%
%   [Price, PriceTree] = floatbybdt(BDTTree, Spread, Settle, Maturity)
%
%   [Price, PriceTree] = floatbybdt(BDTTree, Spread, Settle, Maturity,...
%                                   Reset, Basis, Principal, Options)
%
% Inputs:
%   BDTTree    - Interest rate tree structure created by BDTTREE.
%   Spread     - NINSTx1 Number of basis points over the reference rate. 
%   Settle     - NINSTx1 vector of dates representing the settle date of the floating rate note.
%   Maturity   - NINSTx1 vector of dates representing the maturity date of the floating rate note.
%   Reset      - NINSTx1 vector representing the frequency of payments per year. Default is 1.
%   Basis      - NINSTx1 vector representing the basis used when annualizing the input 
%                forward rate tree. Default is 0 (actual/actual).
%   Principal  - NINSTx1 vector of the notional principal amount. Default is 100.
%   Options    - Structure created with derivset containing derivatives 
%                pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price     - NINSTx1 expected prices at time 0.
%   PriceTree - Structure containing trees of vectors of instrument prices and 
%               accrued interest, and a vector of observation times for each
%               node. 
%
%               PriceTree.PTree contains the clean prices. 
%               PriceTree.AITree contains the accrued interest.
%               PriceTree.tObs contains the observation times.
%
%
% Notes: The Settle date for every floating rate note is set to the ValuationDate 
%        of the BDT Tree. The floating rate note argument "Settle" is ignored.
%
%
% See also BDTTREE, CFBYBDT, CAPBYBDT, SWAPBYBDT, FLOORBYBDT, FIXEDBYBDT, BONDBYBDT

%   Author(s): M. Reyes-Kattar 03/22/2001
%   Copyright 1998-2003 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $  $Date: 2004/04/06 01:08:28 $

% Check input arguments.

if ~isafin(BDTTree,'BDTFwdTree')
  error('finderiv:floatbybdt:InvalidTree','The first argument must be a BDT tree created by BDTTREE');
end

if (nargin < 4)
   error('finderiv:floatbybdt:InvalidInputs','You must enter BDTTree, Spread, Settle and Maturity');
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

% Sanity check on 'options'
if ~isa(options,'struct')
  error('finderiv:floatbybdt:InvalidOptions','Options must be an options structure created with DERIVSET.');
end

% Extract options information
[ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options);


% --------------------------------------------------------
% Argument validation and expansion
% --------------------------------------------------------
[Spread, Settle, Maturity, FloatReset, Basis, Principal] = ...
   instargfloat(varargin{1}, BDTTree.TimeSpec.ValuationDate, varargin{3:end});

% ---------------------------------------------------------
% Special Rule: 
% For now we require that all notes settle on the Valuation 
% Date.
% ---------------------------------------------------------
FloatSettle = finargdate(varargin{2});
FloatSettle = FloatSettle(~isnan(FloatSettle));
if ~isempty(FloatSettle) & any(FloatSettle ~= Settle(1))
   warning('finderiv:floatbybdt:IgnoredSettle','Floating rate notes are valued at BDT Tree ValuationDate rather than Settle');
end

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
[CFAmounts, CFDates, CFTimes] = cfamounts(1, Settle, Maturity, FloatReset, Basis);

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
            warning('finderiv:floatbybdt:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:floatbybdt:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
        end        
        
        if(ShowDiagnostics)  
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


% ----------------------------------------------------------
% Make sure that the tree rates cover the lifetime of all 
% notes.
% ----------------------------------------------------------
CFPeriod = F ./ FloatReset;
LastCFTime = max(CFTimes, [], 2);


%---------------------------------------------------------------------
% Map cash flows of the note to the same time scale as the tree's.
% TreeDates [NumLevels+1 x 1] vector of dates from valuation to maturities
% TreeTimes [NumLevels+1 x 1] vector of compounded times
%--------------------------------------------------------------------
[AllCF, IsTreeDate, AllDates, AllTimes, AllInd, PriceObsInd, RateObsInd, DiscFrac] = ...
   bdttreetime(CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes);

% ---------------------------------------------------------------------
% Build an array of 1's and 0's indicating where the CFs occur.
% ----------------------------------------------------------------------
CFT = AllCF>0;
            
% Number of instruments & total number of cash flow dates
[NumInst, NumCFs] = size(AllCF);

% ----------------------------------------------------------
% Find the last node for each instrument. 
% ----------------------------------------------------------
[dummy, LastNodes] = max(cumsum(CFT,2), [], 2);


%---------------------------------------------------------------------
% Make a tree to hold prices. Include final times
%---------------------------------------------------------------------
FwdTree = BDTTree.FwdTree;
[NumLevels, NumPos] = treeshape(FwdTree);

% make a new structure with the final times on the end (NumLevels+1)
PTree = mktree(NumLevels+1, NumInst, 0, 1);
NumPStates = [1:NumLevels NumLevels];


% ---------------------------------------------------------
% Initialize an Adjustment tree to zero. This tree holds
% the cash flows which occur on tree nodes. Once we have calculated
% the price of the note, we subtract these cash flows from 
% the price tree so that each note reflects the present 
% (to that node) value of all future cash flows.
% ----------------------------------------------------------
CFBush = PTree;

% Create bush for cash flows responsible for accrued interests
AIBush = PTree;

% Create an expansion vector over the instruments
Iones = ones(NumInst,1);



% ----------------------------------------------------------
% Build the price tree. As we step through the cash flow for
% each note, we calculate the spot rate of the previous cash
% flow time, and use that rate to calculate the cash flow in
% the current time. We then add this cash flow to the node of
% the tree to the left of this spot, and finally we discount
% the amount in the node (to bring it to its present value).
% ----------------------------------------------------------
for iCF = NumCFs:-1:1,
    jpObs = PriceObsInd(iCF);
    jrObs = RateObsInd(iCF);
    
    if(iCF<NumCFs)     
        % Bring the accumulated value on the node to the present value
        % of the node. We do that with all nodes but the last one.
        RateStates = ( 1 ./ FwdTree{jrObs}).^DiscFrac(iCF);
        PTree{jpObs}(:,:) = PTree{jpObs}(:,:) .* RateStates(Iones,:);        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Find the index into CFTimes to the previous reset
    % for each instrument
    PrevResetTime = 0*Iones;
    cftIndex = find(abs(CFTimes - AllTimes(iCF))<=eps);
    [row, cftIndex] = ind2sub(size(CFTimes), cftIndex);
    [row, ISort] = sort(row); cftIndex = cftIndex(ISort);
    cftIndex = cftIndex-1;
    if(any(CFT(:,iCF)))
        PrevResetTime(CFT(:,iCF)) = CFTimes(sub2ind(size(CFTimes), row, cftIndex));
    end            
    %%%%%%%%%%%%%%%%%%%%%%%%        
    
    % Find the cash flows for this node.
    CFs = FindCF(jpObs, iCF, NumPStates, PrevResetTime, ...
        BDTTree, NumInst, Spread, FloatReset, Principal, CFT, ...
        TreeTimes, AllTimes, Compounding);
    
    % Save the CF if it follows a tree date
    if(iCF > 1 & IsTreeDate(iCF-1))
        if ~IsTreeDate(iCF)
            AIBush{jrObs+1}(:,:) = CFs;
        else
            AIBush{jrObs+1}(:,:) = 0;
        end
    end
    
    % If in the last node for any note, Add its principal
    PPal = Principal .* (LastNodes == iCF);
    PPal = PPal*ones(1,size(CFs,2));
    CFTot = CFs + PPal; 
    
    if(IsTreeDate(iCF))
        PTree{jpObs}(:,:) = PTree{jpObs}(:,:) + CFTot;     
        % Adjustment for this tree node
        CFBush{jpObs}(:,:) = CFs;
    else
        % Cash flow fell between tree nodes. bring it back to the
        % observation node.
        CF = zeros(size(PTree{min(jpObs+1, length(PTree))}));
        CF(:,:)  = CFTot;
        
        if(AllTimes(iCF)>TreeTimes(end-1))
            PTree{jpObs}(:,:) = PTree{jpObs}(:,:) + CF(:,:);
        else
            PTree{jpObs}(:,:) = PTree{jpObs}(:,:) + ...
                   ( CF(:,1:end-1) + CF(:,2:end) )/2;          
        end
    end
    
    
    if(IsTreeDate(iCF) & iCF>1)
		if (jpObs~=jrObs)
			% single branch case at the end of the tree
			PTree{jpObs-1}(:,:) = PTree{jpObs}(:,:);
		else
			% accumulate the average value at the next time
			PTree{jpObs-1}(:,:) = (PTree{jpObs}(:,1:end-1)+PTree{jpObs}(:,2:end))/2;
		end
	end  
end % for iCF = NumCFs:-1:1

% Find accrued interest
AIBush = findaccint(PTree, AIBush, TreeDates, Settle, Maturity, FloatReset, Basis);

% The total price is in the first node of the tree   
Price = PTree{1} - AIBush{1};   

if(nargout < 2)
    return
end

% Substract the adjustments from all nodes in the
% price tree to obtain the price at each node date.
for iLevel=1:length(PTree)
   PTree{iLevel}(:,:) = PTree{iLevel}(:,:) - CFBush{iLevel}(:,:) - ...
       AIBush{iLevel}(:,:);
end


% Build output structures and return results
PriceTree = classfin('BDTPriceTree');
PriceTree.tObs = TreeTimes';
PriceTree.PTree = PTree;
PriceTree.AITree = AIBush;

CFTree = classfin('BDTCFTree');
CFTree.tObs = TreeTimes';
CFTree.CFTree = CFBush;

return

%---------% END OF FLOATBYBDT %---------------%

% ---------------------------------------------------------
% Calculate the cash flow at a CF step. 
% Find the rate at the previous reset date of the instrument. This
% can be calculated using the spot rates surrounding the previous
% reset date. The easiest case is one in which the previous reset
% date falls on a tree date.
% ---------------------------------------------------------
function CFs = FindCF(jpObs, iCF, NumPStates, PrevResetTime, ...
     BDTTree, NumInst, Spread, FloatReset, Principal, CFT, ...
     TreeTimes, AllTimes, Compounding)
  
AllTimes = AllTimes(:)';
     
% If there are no cash flows, just return a vector of zeros
if(~any(CFT(:, iCF)))
   CFs = zeros(NumInst, NumPStates(jpObs));
   return;
end


AllRates = [];
for iInst=1:NumInst   
    % Calculate the spots only if there is a CF for the instrument:    
    if(ismember(AllTimes(iCF), TreeTimes))
        iObs = jpObs;
    else
        iObs = jpObs+1;
    end
    Rates = zeros(1, NumPStates(min(iObs, length(NumPStates))));
    
    if(CFT(iInst, iCF))
        StartTime = PrevResetTime(iInst);
        EndTime   = AllTimes(iCF);
        Rates = findeffrates(BDTTree, StartTime, EndTime);
        RS = intenvset('Compounding', BDTTree.RateSpec.Compounding, ...
            'StartTimes', StartTime, 'EndTimes', EndTime, ...
            'Rates', Rates);
        RS = intenvset(RS, 'Compounding', FloatReset(iInst));
        Rates = intenvget(RS, 'Rates');      
    end
    
    AllRates = [AllRates; Rates(:)'];
end % for iInst=1:NumInst
  
PPal = (Principal .* CFT(:, iCF)) * ones(1,size(AllRates,2));
AllRates = AllRates ./ (FloatReset * ones(1, size(AllRates,2)));
CFs = (AllRates + (Spread/10000 * ones(1,size(AllRates,2)))) .* PPal;
return



function AIBush = findaccint(PTree, AIBushIn, TreeDates, Settle, Maturity, FloatReset, Basis)

% Obtain basic shape information off the price bush
[NumLevels, NumPos] = treeshape(PTree);

% Create an accrued interest bush
% make a new structure with the final times on the end (NumLevels+1)
AIBush = mktree(NumLevels, NumPos, 0, 1);

NumInst   = length(Maturity);

for iLevel=1:(length(AIBush)-1)
    
    % Identify active instruments
    ActiveMask = Maturity > TreeDates(iLevel);
    if(any(ActiveMask));       
        
        NumActiveInst = sum(ActiveMask);        
        
        % Num of bonds is NumStates(iLevel+1) * NumInst
        CF = AIBushIn{iLevel+1}(ActiveMask, :);
		NStates = size(CF,2);
        CF = CF(:);
        
        SettleEx     = TreeDates(iLevel)*ones(NumActiveInst*NStates,1);
        
        MaturityEx   = repmat(Maturity(ActiveMask)  , NStates,1);    
        FloatResetEx = repmat(FloatReset(ActiveMask), NStates,1);    
        BasisEx      = repmat(Basis(ActiveMask)     , NStates,1);
        
        AccInt = CF .* accrfrac( SettleEx, MaturityEx, FloatResetEx, BasisEx, ...
            [], [], [], [], [], CF);
        
        AIAmounts = zeros(size(AIBush{iLevel+1}));
        AIAmounts(ActiveMask,:) =  reshape(AccInt, NumActiveInst, NStates);
        
		if(iLevel == length(AIBush)-1)
			AIBush{iLevel}(:,:) = AIBush{iLevel}(:,:) + AIAmounts;
		else
       	 	AIBush{iLevel}(:,:) = AIBush{iLevel}(:,:) + ...
				(AIAmounts(:,1:end-1)+AIAmounts(:,2:end))/2;    
		end
        
    end
end


