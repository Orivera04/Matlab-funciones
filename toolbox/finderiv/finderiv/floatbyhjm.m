function [Price, PriceTree, CFTree] = floatbyhjm(HJMTree, varargin)
%FLOATBYHJM Price floating rate notes from an HJM interest rate tree.
%
%
%   [Price, PriceTree] = floatbyhjm(HJMTree, Spread, Settle, Maturity)
%
%   [Price, PriceTree] = floatbyhjm(HJMTree, Spread, Settle, Maturity,...
%                                   Reset, Basis, Principal, Options)
%
% Inputs:
%   HJMTree    - Forward rate tree structure created by HJMTREE.
%   Spread     - NINSTx1 Number of basis points over the reference rate. 
%   Settle     - NINSTx1 vector of dates representing the settle date of the floating rate note.
%   Maturity   - NINSTx1 vector of dates representing the maturity date of the floating rate note.
%   Reset      - NINSTx1 vector representing the frequency of payments per year. 
%                Default is 1.
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
%               PriceTree.PBush contains the clean prices. 
%               PriceTree.AIBush contains the accrued interest.
%               PriceTree.tObs contains the observation times.
%
%
% Notes: The Settle date for every floating rate note is set to the ValuationDate 
%        of the HJM Tree. The floating rate note argument "Settle" is ignored.
%
% See also HJMTREE, CFBYHJM, CAPBYHJM, SWAPBYHJM, FLOORBYHJM, FIXEDBYHJM, BONDBYHJM

%   Author(s): M. Reyes-Kattar 04/27/99
%   Copyright 1998-2003 The MathWorks, Inc.
%   $Revision: 1.22.2.2 $  $Date: 2004/04/06 01:08:29 $

% Check input arguments.

if ~isafin(HJMTree,'HJMFwdTree')
  error('finderiv:floatbyhjm:InvalidTree','The first argument must be an HJM tree created by HJMTREE');
end

if (nargin < 4)
   error('finderiv:floatbyhjm:InvalidInputs','You must enter HJMTree, Spread, Settle and Maturity');
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
  error('finderiv:floatbyhjm:InvalidOptions','Options must be an options structure created with DERIVSET.');
end

% Extract options information
[ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options);


% --------------------------------------------------------
% Argument validation and expansion
% --------------------------------------------------------
[Spread, Settle, Maturity, FloatReset, Basis, Principal] = ...
   instargfloat(varargin{1}, HJMTree.TimeSpec.ValuationDate, varargin{3:end});

% ---------------------------------------------------------
% Special Rule: 
% For now we require that all notes settle on the Valuation 
% Date.
% ---------------------------------------------------------
FloatSettle = finargdate(varargin{2});
FloatSettle = FloatSettle(~isnan(FloatSettle));
if ~isempty(FloatSettle) & any(FloatSettle ~= Settle(1))
   warning('finderiv:floatbyhjm:IgnoredSettle','Floating rate notes are valued at HJM Tree ValuationDate rather than Settle');
end

% ---------------------------------------------------------
% Extract the branch information from the HJMTree.
% ---------------------------------------------------------
NumBranch = HJMTree.VolSpec.NumBranch;
PBranch     = HJMTree.VolSpec.PBranch;
Compounding = HJMTree.TimeSpec.Compounding;
TreeDates   = [HJMTree.TimeSpec.ValuationDate; HJMTree.TimeSpec.Maturity];
TreeTimes   = [HJMTree.tObs'; HJMTree.CFlowT{end}];


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
% by the HJMTree.
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
HJMTreeOri = [];
if (~all(ismember(AllTimes, TreeTimes)))
    
    if(ConstRate)
        if(ShowWarnings)
            warning('finderiv:floatbyhjm:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:floatbyhjm:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
        end        
        
        if(ShowDiagnostics)  
            DiagMsg = sprintf('\nBuilding new tree with %d time steps.\nLast node will have %d states.\n',...
                (length(AllDates)-1), NumBranch ^ (length(AllDates)-2));
            disp(DiagMsg);
        end
        
        TimeSpecNew  = hjmtimespec(HJMTree.TimeSpec.ValuationDate, AllDates(2:end), ...
            HJMTree.RateSpec.Compounding);
        HJMTreeOri = HJMTree;
		TreeTimesOri = TreeTimes;
        HJMTree = hjmtree(HJMTreeOri.VolSpec, HJMTreeOri.RateSpec, TimeSpecNew);
        
        % Redefine tree paramenters
        TreeDates   = [HJMTree.TimeSpec.ValuationDate; HJMTree.TimeSpec.Maturity];
        TreeTimes   = [HJMTree.tObs'; HJMTree.CFlowT{end}];    
    end
end


% ----------------------------------------------------------
% Make sure that the tree rates cover the lifetime of all 
% notes.
% ----------------------------------------------------------
CFPeriod = F ./ FloatReset;
LastCFTime = max(CFTimes, [], 2);
% The last cash flow we can calculate occurs exactly one
% reset period after the last node of the tree (which
% is at TreeTimes(end-1)).
% if any(LastCFTime > (TreeTimes(end-1) + CFPeriod))
%    error('HJM tree must define interest structure during the life of all notes')
% end

%---------------------------------------------------------------------
% Map cash flows of the note to the same time scale as the tree's.
% TreeDates [NumLevels+1 x 1] vector of dates from valuation to maturities
% TreeTimes [NumLevels+1 x 1] vector of compounded times
%--------------------------------------------------------------------
[AllCF, IsTreeDate, AllDates, AllTimes, AllInd, PriceObsInd, RateObsInd, DiscFrac] = ...
   hjmtreetime(CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes);

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
FwdTree = HJMTree.FwdTree;
[NumLevels, NumChild, NumPos, NumStates] = bushshape(FwdTree);

% --------------------------------------------------------------------
% Make a new structure with the final times on the end (NumLevels+1).
% This is what hjmprice expects us to return: a price tree with one
% more level than the FwdTree. If there are no cash flows in the
% last node, simply place zeros there.
% --------------------------------------------------------------------
NumPLevels = NumLevels+1;
NumPChild = [NumChild(1:end-1), 1, 0];
NumPStates = [NumStates, NumStates(end)];

PriceBush = mkbush(NumPLevels, NumPChild, ...
   NumInst*ones(1,NumPLevels), [], 0);


% ---------------------------------------------------------
% Initialize an Adjustment tree to zero. This tree holds
% the cash flows which occur on tree nodes. Once we have calculated
% the price of the note, we subtract these cash flows from 
% the price tree so that each note reflects the present 
% (to that node) value of all future cash flows.
% ----------------------------------------------------------
CFBush = PriceBush;

% Create bush for cash flows responsible for accrued interests
AIBush = PriceBush;

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
        RateStates = ( 1 ./ FwdTree{jrObs}(1,:) ).^DiscFrac(iCF);
        PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) .* RateStates(Iones,:);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Find the index into CFTimes to the previous reset
    % for each instrument
    PrevResetTime = 0*Iones;
    cftIndex = find(CFTimes == AllTimes(iCF));
    [row, cftIndex] = ind2sub(size(CFTimes), cftIndex);
    [row, ISort] = sort(row); cftIndex = cftIndex(ISort);
    cftIndex = cftIndex-1;
    if(any(CFT(:,iCF)))
        PrevResetTime(CFT(:,iCF)) = CFTimes(sub2ind(size(CFTimes), row, cftIndex));
    end            
    %%%%%%%%%%%%%%%%%%%%%%%%        
    
    % Find the cash flows for this node.
    CFs = FindCF(jpObs, iCF, NumPStates, PrevResetTime, ...
        HJMTree, NumInst, Spread, FloatReset, Principal, CFT, ...
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
        PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) + CFTot;     
        % Adjustment for this tree node
        CFBush{jpObs}(:,:) = CFs;
    else
        % Cash flow fell between tree nodes. bring it back to the
        % observation node.
        CF = zeros(size(PriceBush{min(jpObs+1, length(PriceBush))}));
        CF(:,:)  = CFTot;
        
        if(NumPChild(jpObs)<=1)
            PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) + CF(:,:);
        else
            for iBranch=1:NumBranch
                PriceBush{jpObs}(:,:) = PriceBush{jpObs}(:,:) + ...
                    PBranch(iBranch) * CF(:,:,iBranch);            
            end
        end
    end
    
    
    if(IsTreeDate(iCF) & iCF > 1)
        if (NumPChild(jpObs-1)==1)        
            % single branch case at the end of the tree. Just copy the value
            % to the previous node
            PriceBush{jpObs-1}(:,:) = PriceBush{jpObs}(:,:);
        else
            % Pass it directly to the previous node, when we are on a tree node
            for iBranch=1:NumBranch
                PriceBush{jpObs-1}(:,:) = PriceBush{jpObs-1}(:,:) + ...
                    PBranch(iBranch) * PriceBush{jpObs}(:,:,iBranch);
            end
        end % if (NumPChild(jpObs-1)==1)    
    end % if(IsTreeNode(iCF)& iCF > 1)  
end % for iCF = NumCFs:-1:1

% Find accrued interest
AIBush = findaccint(PriceBush, AIBush, PBranch, TreeDates, Settle, Maturity, FloatReset, Basis);

% The total price is in the first node of the tree   
Price = PriceBush{1} - AIBush{1};   

if(nargout < 2)
    return
end

% Substract the adjustments from all nodes in the
% price tree to obtain the price at each node date.
for iLevel=1:NumPLevels
   PriceBush{iLevel}(:,:) = PriceBush{iLevel}(:,:) - CFBush{iLevel}(:,:) - ...
       AIBush{iLevel}(:,:);
end


% Build output structures and return results
PriceTree = classfin('HJMPriceTree');
PriceTree.tObs = TreeTimes';
PriceTree.PBush = PriceBush;
PriceTree.AIBush = AIBush;

CFTree = classfin('HJMCFTree');
CFTree.tObs = TreeTimes';
CFTree.CFBush = CFBush;

return

%---------% END OF FLOATBYHJM %---------------%

% ---------------------------------------------------------
% Calculate the cash flow at a CF step. 
% Find the rate at the previous reset date of the instrument. This
% can be calculated using the spot rates surrounding the previous
% reset date. The easiest case is one in which the previous reset
% date falls on a tree date.
% ---------------------------------------------------------
function CFs = FindCF(jpObs, iCF, NumPStates, PrevResetTime, ...
     HJMTree, NumInst, Spread, FloatReset, Principal, CFT, ...
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
        Rates = findeffrates(HJMTree, StartTime, EndTime);
        RS = intenvset('Compounding', HJMTree.RateSpec.Compounding, ...
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



function AIBush = findaccint(PriceBush, AIBushIn, PBranch, TreeDates, Settle, Maturity, FloatReset, Basis)

% Obtain basic shape information off the price bush
[NumLevels, NumChild, NumPos, NumStates] = bushshape(PriceBush);

% Create an accrued interest bush
AIBush = mkbush(NumLevels, NumChild, NumPos, 0, 0);

NumInst   = length(Maturity);

for iLevel=1:(length(AIBush)-1)
    
    % Identify active instruments
    ActiveMask = Maturity > TreeDates(iLevel);
    if(any(ActiveMask));       
        
        NumActiveInst = sum(ActiveMask);        
        
        % Num of bonds is NumStates(iLevel+1) * NumInst
        CF = AIBushIn{iLevel+1}(ActiveMask, :);
        CF = CF(:);
        
        SettleEx     = TreeDates(iLevel)*ones(NumActiveInst*NumStates(iLevel+1),1);
        
        MaturityEx   = repmat(Maturity(ActiveMask)  , NumStates(iLevel+1),1);    
        FloatResetEx = repmat(FloatReset(ActiveMask), NumStates(iLevel+1),1);    
        BasisEx      = repmat(Basis(ActiveMask)     , NumStates(iLevel+1),1);
        
        AccInt = CF .* accrfrac( SettleEx, MaturityEx, FloatResetEx, BasisEx, ...
            [], [], [], [], [], CF);
        
        AIAmounts = zeros(size(AIBush{iLevel+1}));
        AIAmounts(ActiveMask,:) =  reshape(AccInt, NumActiveInst, NumStates(iLevel+1));
        
        for iBranch = 1:NumChild(iLevel)
            AIBush{iLevel}(:,:) = AIBush{iLevel}(:,:) + PBranch(iBranch) * AIAmounts(:,:,iBranch);    
        end
    end
end


