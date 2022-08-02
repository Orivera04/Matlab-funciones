function [Price, PriceTree] = cfbybdt(BDTTree, varargin)
%CFBYBDT Price cash flows from a BDT interest rate tree.
%        Dynamic programming subroutine for BDTPRICE.
%
%   [Price, PriceTree] = cfbybdt(BDTTree, CFlowAmounts, CFlowDates, Settle)
%
%   [Price, PriceTree] = cfbybdt(BDTTree, CFlowAmounts, CFlowDates, Settle, Basis, Options)
%
% Inputs: Type "help instcf" for a description of cash flow arguments.
%
%   BDTTree      - Interest rate tree structure created by BDTTREE.
%
%   CFlowAmounts - NINSTxMOSTCFS matrix of cash flow amounts. Each row
%                  is a list of cash flow values for one instrument.  
%                  If an instrument has fewer than MOSTCFS cash flows, the 
%                  end of the row should be padded with NaN's.
%
%   CFlowDates   - NINSTxMOSTCFS matrix of cash flow dates. Each entry
%                  contains the serial date of the corresponding cash flow 
%                  in CFlowAmounts. If an instrument has fewer than MOSTCFS 
%                  cash flows, the end of the row should be padded with NaN's.
%
%   Settle       - Settlement date on which the cash flows are priced.
%
% Optional Inputs:
%   Basis        - Day-count basis.  Default is 0 (actual/actual).
%
%   Options		 - Structure created with derivset containing derivatives 
%                  pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price        - NINSTx1 expected prices at time 0.
%   PriceTree    - Tree structure with a vector of instrument prices at each
%                  node. 
%
%
% Note: The Settle date for every cash flow is set to the ValuationDate of
%       the BDT Tree. The cash flow argument, Settle, is ignored.
%
% See also BDTTREE, BDTPRICE, INSTCF, CFAMOUNTS.
%

%   Author(s): M. Reyes-Kattar 30-Mar-2001
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.4.2.1 $  $Date: 2003/08/29 04:46:17 $

%---------------------------------------------------------------------
% Parse input arguments
%---------------------------------------------------------------------
if ~isafin(BDTTree,'BDTFwdTree')
  error('finderiv:cfbybdt:InvalidTree','The first argument must be a BDT tree created by BDTTREE');
end

% Extract pricing options
options = [];
if length(varargin) > 4
  options = varargin{5};
  varargin = varargin(1:4);
end

% Set default for pricing option
if(isempty(options))
    options = derivset;
end

% Extract options information
[ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options);

% parse standard CashFlow arguments
[CFAmounts, CFDates, Settle, Basis] = instargcf(varargin{:});

% Special rules: Single settlement equal to Valuation Date
Settle = Settle(~isnan(Settle));
if (~isempty(Settle) & (any(Settle ~= Settle(1)) | Settle(1) ~= BDTTree.TimeSpec.ValuationDate))
   Settle = BDTTree.TimeSpec.ValuationDate;
   warning('finderiv:cfbybdt:IgnoredSettle','Cash Flows are valued at BDT Tree ValuationDate rather than Settle');
end


% Find semmi-annual TFactors for CFDates
CFTimes = CFDates;
for iInst = 1:size(CFDates,1)
   CFTimes(iInst, ~isnan(CFTimes(iInst,:))) = ...
      date2time(Settle(1), CFDates(iInst,~isnan(CFTimes(iInst,:))), 2, Basis(iInst))';
end

% change semiannual time factors to compounded times (JHA)?
[dummy, F] = date2time([],[], BDTTree.TimeSpec.Compounding);
CFTimes = CFTimes*F/2;

% Find single vector containing all the cash flow times
AllTimes = CFTimes(:)';
AllTimes = unique(AllTimes(~isnan(AllTimes)));

AllDates = CFDates(:)';
AllDates = unique(AllDates(~isnan(AllDates)));


%---------------------------------------------------------------------
% Map cash flows to every node
% TreeDates [NumLevels+1 x 1] vector of dates from valuation to maturities
% TreeTimes [NumLevels+1 x 1] vector of compounded times
%
%---------------------------------------------------------------------
TreeDates = [BDTTree.TimeSpec.ValuationDate; 
             BDTTree.TimeSpec.Maturity];
TreeTimes = [0; BDTTree.CFlowT{1}];

% ----------------------------------------------------------
% If the tree doesn't cover all the CF times, we may need to generate
% a new one so that all CFs fall in a tree node
% ----------------------------------------------------------
BDTTreeOri = [];
if (~all(ismember(AllTimes, TreeTimes)))
    
    if(ConstRate)
        if(ShowWarnings)
            warning('finderiv:cfbybdt:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:cfbybdt:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
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

[AllCF, IsTreeDate, AllDates, AllTimes, AllInd,PriceObsInd, RateObsInd, DiscFrac] = bdttreetime(...
    CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes);

[NumInst,NumCFs] = size(AllCF);


% Extract tree information for the creation of the price tree
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

% Create an expansion vector over the instruments
Iones = ones(NumInst,1);

% Zero out the last values to begin
PTree{end}(:) = 0;

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
    RateStates = ( 1 ./ FwdTree{jrObs} ).^DiscFrac(iCF);
    PTree{jpObs}(:,:) = PTree{jpObs}(:,:) .* RateStates(Iones,:);
  end

  % Add the cash flow at this time to the present value of the future
  PTree{jpObs}(:,:) = PTree{jpObs}(:,:) + ...
      AllCF(:, iCF* ones(1,NumPStates(jpObs)) );
  
  % If you are on a tree date, average down to start the next state level
  if IsTreeDate(iCF) & (iCF>1) 
    if (AllTimes(iCF)<=TreeTimes(end-1))

	  % average over NumBranch children      
      PTree{jpObs-1}(:,:) = ...
		  (PTree{jpObs}(:,1:end-1) + PTree{jpObs}(:,2:end))/2;  
      
  	else
      % single branch case at the end of the tree
      PTree{jpObs-1}(:,:) = PTree{jpObs}(:,:);
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

