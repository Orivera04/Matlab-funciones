function [Price, PriceTree] = capbybdt(BDTTree, varargin)
%CAPBYBDT Price caps from a BDT interest rate tree.
%
%   [Price, PriceTree] = capbybdt(BDTTree, Strike, Settle, Maturity)
%
%   [Price, PriceTree] = capbybdt(BDTTree, Strike, Settle, Maturity,...
%                                 Reset, Basis, Principal, Options)
%
% Inputs:
%   BDTTree     - Interest rate tree structure created by BDTTREE.
%   Strike    	- NINSTx1 vector of rates at which the cap is exercised, as a 
%                 decimal number. 
%   Settle    	- NINSTx1 vector of dates representing the settle date of the cap.
%   Maturity  	- NINSTx1 vector of dates representing the maturity date of the cap.
%   Reset     	- NINSTx1 vector representing the frequency of payments per year.
%                 Default is 1.
%	Basis     	- NINSTx1 vector representing the basis used when annualizing the 
%                 input forward rate tree. Default is 0 (actual/actual)
%   Principal 	- NINSTx1 vector of the notional principal amount. Default is 100.
%   Options		- Structure created with derivset containing derivatives 
%                 pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price     - NINSTx1 expected prices of the cap at time 0.
%	PriceTree - Tree structure with a vector of cap values at each node. 
%
%
% Notes: The Settle date for every cap is set to the ValuationDate of
%        the BDT Tree.  The cap argument "Settle" is ignored.
%
% See also BDTTREE, CFBYBDT, FLOORBYBDT, SWAPBYBDT

%   Author(s): M. Reyes-Kattar 03/05/2001
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.6.2.1 $  $Date: 2003/08/29 04:46:15 $

%---------------------------------------------------------
%Checking the input arguments.
%---------------------------------------------------------
if (nargin < 4)
   error('finderiv:capbybdt:InvalidInputs','You must enter BDTTree, Strike, Settle and Maturity');
end

if ~isafin(BDTTree,'BDTFwdTree')
  error('finderiv:capbybdt:InvalidTree','The first argument must be a BDT tree created by BDTTREE');
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

% Process cap instrument arguments contained in varargin
[Strike, Settle, Maturity, CapReset, Basis, Principal] = ...
   instargcap(varargin{1}, BDTTree.TimeSpec.ValuationDate, varargin{3:end});
  
% special rules: Single Settle equal to Valuation Date
CapSettle = finargdate(varargin{2});
CapSettle = CapSettle(~isnan(CapSettle));
if ~isempty(CapSettle) & any(CapSettle ~= Settle(1))
   warning('finderiv:capbybdt:IgnoredSettle','Caps are valued at BDT Tree ValuationDate rather than Settle');
end


% Extract the tree information
Compounding = BDTTree.TimeSpec.Compounding;
TreeDates = [BDTTree.TimeSpec.ValuationDate; 
             BDTTree.TimeSpec.Maturity];
TreeTimes = [BDTTree.tObs'; BDTTree.CFlowT{end}];

% -------------------------------------------------------------------
% Find cash flow matrix and cash flow dates. The cash flows (CFAmounts) 
% obtained here won't be used. We use this call the BDTtreetime to find
% the dates and times in which cash flows occur.
% --------------------------------------------------------------------
[CFAmounts, CFDates, CFTimes] = cfamounts(1, Settle, Maturity, CapReset, Basis);

% ----------------------------------------------------------
% Change semiannual time factors to compounded times. 
% CFAmounts assumes that the time factors are semiannual, 
% which is not necessarily the case in the tree. We here 
% find the actual CFTimes base on the compounding dictated 
% by the BDTTree.
% ----------------------------------------------------------
[dummy, F] = date2time([],[], Compounding);
CFTimes = (CFTimes * F) / 2;

% ----------------------------------------------------------
% Set all parameters to a single time line
[AllCF, AllDates, AllTimes, AllInd] = cfport(CFAmounts, CFDates, CFTimes);


% ----------------------------------------------------------
% If the tree doesn't cover all the CF times, we may need to generate
% a new one so that all CFs fall in a tree node
% ----------------------------------------------------------
if (~all(ismember(AllTimes, TreeTimes)))
    
    if(ConstRate)
        if(ShowWarnings)
            warning('finderiv:capbybdt:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:capbybdt:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
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


%---------------------------------------------------------------------
% Map cash flows to every node 
% TreeDates [NumLevels+1 x 1] vector of dates from valuation to maturities
% TreeTimes [NumLevels+1 x 1] vector of compounded times
%--------------------------------------------------------------------
% Get the map of cash flows on tree nodes
[AllCF, IsTreeDate, AllDates, AllTimes, AllInd, PriceObsInd, RateObsInd, DiscFrac] = bdttreetime(...
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
FwdTree = BDTTree.FwdTree;
[NumLevels, NumPos] = treeshape(FwdTree);

% make a new structure with the final times on the end (NumLevels+1)
PTree = mktree(NumLevels+1, NumInst, 0, 1);
NumPStates = [1:NumLevels NumLevels];

% --------------------------------------------------------------------
% Create an adjustment tree to hold the cash flows at each of the
% nodes. This is subtracted from the price bush at the end, to that
% each node of PTree represents the present value (at that node)
% of the cash flows occuring in future nodes.
% PTree is full of zeroes at this point:
% --------------------------------------------------------------------
Adjustments = PTree;

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
        RateStates = ( 1 ./ FwdTree{jrObs} ).^DiscFrac(iCF);
        PTree{jpObs}(:,:) = PTree{jpObs}(:,:) .* RateStates(Iones,:);
    end
    
    % Only some of the instruments are active. Out of those, the only caplet
    % node in which there is cash flows is the last one.
    ActiveNodeMask = CFT(:,iCF);
    
    if(any(ActiveNodeMask) & iCF > 1)            
        if(IsTreeDate(iCF))
            BCFs = zeros(size(PTree{jpObs}));
        else
            BCFs = zeros(size(PTree{min(jpObs+1, length(PTree))}));                  
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
        BCFs(ActiveNodeMask,:) = FindCF(BDTTree, AllTimes(iCF), ...
            PrevResetTime(ActiveNodeMask), Strike(ActiveNodeMask), ...
            Principal(ActiveNodeMask), CapReset(ActiveNodeMask));       
                
        if(IsTreeDate(iCF))
            PTree{jpObs}(:,:) = PTree{jpObs}(:,:) + BCFs(:,:);
            Adjustments{jpObs}(:,:) = BCFs(:,:);
        else
			if(AllTimes(iCF)>TreeTimes(end-1))
				% CF date after last rate tree node
				PTree{jpObs}(:,:) = PTree{jpObs}(:,:) + BCFs(:,:);
			else
				PTree{jpObs}(:,:) = PTree{jpObs}(:,:) + ...
                    	(BCFs(:,1:end-1) + BCFs(:,2:end))/2;
			end
        end            
    end        
    
    % If you are on a tree date, average down to start the next state level
    if IsTreeDate(iCF) & (iCF>1) 
		if (jpObs~=jrObs)
			% single branch case at the end of the tree
			PTree{jpObs-1}(:,:) = PTree{jpObs-1}(:,:) + PTree{jpObs}(:,:);
		else
			% accumulate the average value at the next time
			PTree{jpObs-1}(:,:) = PTree{jpObs-1}(:,:) + ...
				(PTree{jpObs}(:,1:end-1)+PTree{jpObs}(:,2:end))/2;
		end  
    end   
end

Price = PTree{1};

% Take out the adjustments from the PTree
for k=1:length(PTree)
   PTree{k}(:, :) = PTree{k}(:, :) - Adjustments{k}(:,:);
end


PriceTree = classfin('BDTPriceTree');
PriceTree.tObs = TreeTimes';
PriceTree.PTree = PTree;
return


function CF = FindCF(BDTTree, EndTime, StartTimes, Strike, Principal, CapReset)
	NumInst = size(Principal, 1);
    Compounding = BDTTree.RateSpec.Compounding;
    
    Rates = [];
    for iInst=1:NumInst
        InstRates = findeffrates(BDTTree, StartTimes(iInst), EndTime);
        if(Compounding ~= CapReset(iInst))
            RS = intenvset('Compounding', Compounding, ...
                			'StartTime', StartTimes(iInst), ...
                			'EndTimes',  EndTime, ...
                			'Rates', InstRates);
            RS = intenvset(RS, 'Compounding', CapReset(iInst));
            InstRates = intenvget(RS, 'Rates');
        end
        
        Rates = [Rates; max(InstRates - Strike(iInst), 0)];        
    end    
    CF = (Principal * ones(1, size(Rates,2))) .* Rates ./ (CapReset * ones(1, size(Rates,2)));
return
