function [Price, PriceTree] = cfbyhjm(HJMTree, varargin)
%CFBYHJM Price cash flows from an HJM interest rate tree.
%        Dynamic programming subroutine for HJMPRICE.
%
%   [Price, PriceTree] = cfbyhjm(HJMTree, CFlowAmounts, CFlowDates, Settle)
%
%   [Price, PriceTree] = cfbyhjm(HJMTree, CFlowAmounts, CFlowDates, Settle, Basis, Options)
%
% Inputs: Type "help instcf" for a description of cash flow arguments.
%
%   HJMTree      - Forward rate tree structure created by HJMTREE.
%
%   CFlowAmounts - NINSTxMOSTCFS matrix of cash flow amounts.  Each row
%                  is a list of cash flow values for one instrument.  
%                  If an instrument has fewer than MOSTCFS cash flows, the 
%                  end of the row is padded with NaN's.
%
%   CFlowDates   - NINSTxMOSTCFS matrix of cash flow dates.  Each entry
%                  contains the serial date of the corresponding cash flow 
%                  in CFlowAmounts. If an instrument has fewer than MOSTCFS 
%                  cash flows, the end of the row is padded with NaN's.
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
%       the HJM Tree. The cash flow argument, Settle, is ignored.
%
% See also HJMTREE, HJMPRICE, INSTCF, CFAMOUNTS.
%

%   Author(s): J. Akao, M. Reyes-Kattar 5-Mar-1999
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.16.2.1 $  $Date: 2003/08/29 04:46:18 $

%---------------------------------------------------------------------
% Parse input arguments
%---------------------------------------------------------------------
if ~isafin(HJMTree,'HJMFwdTree')
  error('finderiv:cfbyhjm:InvalidTree','The first argument must be an HJM tree created by HJMTREE');
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
if (~isempty(Settle) & (any(Settle ~= Settle(1)) | Settle(1) ~= HJMTree.TimeSpec.ValuationDate))
   Settle = HJMTree.TimeSpec.ValuationDate;
   warning('finderiv:cfbyhjm:IgnoredSettle','Cash Flows are valued at HJM Tree ValuationDate rather than Settle');
end


% Find semmi-annual TFactors for CFDates
CFTimes = CFDates;
for iInst = 1:size(CFDates,1)
   CFTimes(iInst, ~isnan(CFTimes(iInst,:))) = ...
      date2time(Settle(1), CFDates(iInst,~isnan(CFTimes(iInst,:))), 2, Basis(iInst))';
end

% change semiannual time factors to compounded times (JHA)?
[dummy, F] = date2time([],[], HJMTree.TimeSpec.Compounding);
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
TreeDates = [HJMTree.TimeSpec.ValuationDate; 
             HJMTree.TimeSpec.Maturity];
TreeTimes = [0; HJMTree.CFlowT{1}];

% Extract branch averaging information applicable for all but the last level
NumBranch = HJMTree.VolSpec.NumBranch;
PBranch = HJMTree.VolSpec.PBranch;

% ----------------------------------------------------------
% If the tree doesn't cover all the CF times, we may need to generate
% a new one so that all CFs fall in a tree node
% ----------------------------------------------------------
HJMTreeOri = [];
if (~all(ismember(AllTimes, TreeTimes)))
    
    if(ConstRate)
        if(ShowWarnings)
            warning('finderiv:cfbyhjm:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:cfbyhjm:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
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
% Make a new price tree including final times
%---------------------------------------------------------------------
FwdTree = HJMTree.FwdTree;
[NumLevels, NumChild, NumPos, NumStates] = bushshape(FwdTree);

% Make a new structure with the final times on the end (NumLevels+1)
NumPChild = [NumChild(1:end-1), 1, 0];
NumPStates = [NumStates, NumStates(end)];

PriceBush = mkbush(NumLevels+1, NumPChild, ...
   NumInst*ones(1,NumLevels+1), 0, 0);

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
  
  % If you are on a tree date, average down to start the next state level
  if IsTreeDate(iCF) & (iCF>1) 
    if (NumPChild(jpObs-1)==NumBranch)
      % average over NumBranch children
      
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


Price = PriceBush{1}(:);

if nargout<2
  return
end

PriceTree = classfin('HJMPriceTree');
PriceTree.tObs = TreeTimes';
PriceTree.PBush = PriceBush;

return

