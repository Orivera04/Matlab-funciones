function Tree = checktree(Tree, IVar, options)
%CHECKTREE Check BDT and HJM trees.
%
%   This is a private function that is not meant to be called directly
%   by the user.
%

%   Author(s): M. Reyes-Kattar, 05/01/2000
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.7.2.1 $  $Date: 2003/08/29 04:46:19 $

% -------------------------------------------------------
% Extract pricing options
% -------------------------------------------------------
if nargin < 3 | isempty(options)
    options = derivset;
end    

% Sanity check on 'options'
if ~isa(options,'struct')
    error('finderiv:checktree:InvalidOptions','Options must be an options structure created with DERIVSET.');
end

if isafin(Tree, 'HJMFwdTree')
	TimeSpecFcn = 'hjmtimespec';
	TreeFcn = 'hjmtree';
elseif isafin(Tree, 'BDTFwdTree')
	TimeSpecFcn = 'bdttimespec';
	TreeFcn = 'bdttree';
else
	error('finderiv:checktree:InvalidTree','Input tree must be either an HJMTree of a BDTTree')
end

% Extract options information
[ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options);

% ---------------------------------------------------------
% Find all the combined cash flow dates for the portfolio.
% ---------------------------------------------------------

% Number of intruments
NumInst = instlength(IVar);

% Types of intruments
TypeList = insttypes(IVar);

AllOptDates = [];
AllCFDates = [];
Settle = [];
Reset = [];
Maturity = [];
Basis = [];
EMR = [];
for jType = 1:length(TypeList)
    switch TypeList{jType}
    case 'CashFlow'        
        
        % get data values
        Data = instgetcell(IVar, 'Type', 'CashFlow', 'FieldName', {'Settle', 'CFlowDates'});
        
        % Make sure we include Settle, even though it's not a CF date
        CFDates = [Data{1} Data{2}];
        
        % Find single vector containing all the cash flow dates
        AllCFDates = CFDates(:)';        
        AllCFDates(isnan(AllCFDates)) = [];
        AllCFDates = unique(AllCFDates);      
        
    case 'Bond'
        
        % get data values
        Data = instgetcell(IVar, 'Type', 'Bond', 'FieldName', {'Settle', 'Period', 'Maturity', 'Basis', 'EndMonthRule'});
        Settle = [Settle; Data{1}];
        Reset = [Reset; Data{2}];
        Maturity = [Maturity; Data{3}];
        Basis = [Basis; Data{4}];
        EMR = [EMR; Data{5}];
        
        
    case 'Fixed'
        
        % get data values
        Data = instgetcell(IVar, 'Type', 'Fixed', 'FieldName', {'Settle', 'FixedReset', 'Maturity', 'Basis'});
        Settle = [Settle; Data{1}];
        Data{2} = nan2default(Data{2},1);
        Reset = [Reset; Data{2}];
        Maturity = [Maturity; Data{3}];
        Basis = [Basis; Data{4}];
        EMR = [EMR; NaN*ones(size(Data{4}))];
        
        
    case 'Float'
        
        % get data values
        Data = instgetcell(IVar, 'Type', 'Float', 'FieldName', {'Settle', 'FloatReset', 'Maturity', 'Basis'});
        Settle = [Settle; Data{1}];
        Data{2} = nan2default(Data{2},1);
        Reset = [Reset; Data{2}];
        Maturity = [Maturity; Data{3}];
        Basis = [Basis; Data{4}];
        EMR = [EMR; NaN*ones(size(Data{4}))];        
        
    case 'Cap'
        
        % get data values
        Data = instgetcell(IVar, 'Type', 'Cap', 'FieldName', {'Settle', 'CapReset', 'Maturity', 'Basis'});
        Settle = [Settle; Data{1}];
        Data{2} = nan2default(Data{2},1);
        Reset = [Reset; Data{2}];
        Maturity = [Maturity; Data{3}];
        Basis = [Basis; Data{4}];
        EMR = [EMR; NaN*ones(size(Data{4}))];
        
    case 'Floor'
        
        % get data values
        Data = instgetcell(IVar, 'Type', 'Floor', 'FieldName', {'Settle', 'FloorReset', 'Maturity', 'Basis'});
        Settle = [Settle; Data{1}];
        Data{2} = nan2default(Data{2},1);
        Reset = [Reset; Data{2}];
        Maturity = [Maturity; Data{3}];
        Basis = [Basis; Data{4}];
        EMR = [EMR; NaN*ones(size(Data{4}))];        
        
    case 'Swap'
        
        % get data values
        Data = instgetcell(IVar, 'Type', 'Swap', 'FieldName', {'Settle', 'LegReset', 'Maturity', 'Basis'});
        
        % we have two instruments per swap (two legs), with potentially differing resets
        Settle = [Settle; repmat(Data{1}, 2, 1)];
        
        SwapReset = Data{2};
        % If they are all nans, then they are all defaults (single column of nans)
        if(all(isnan(SwapReset)))
            if(size(SwapReset,2)~=1)
                error('finderiv:checktree:InvalidSwapReset','Swap Reset should never be a NxM (M>1) array of NaNs')
            end
            SwapReset = repmat(SwapReset, 2, 1);
        end
        SwapReset = nan2default(SwapReset(:),1);
        Reset = [Reset; SwapReset];
        Maturity = [Maturity; repmat(Data{3},2,1)];
        Basis = [Basis; repmat(Data{4},2,1)];
        EMR = [EMR; NaN*ones(2*length(Data{4}),1)];        
        
        
    case 'OptBond'
        
        % get the option data values
        Data = instgetcell(IVar, 'Type',TypeList{jType}, 'FieldName',{'ExerciseDates', 'AmericanOpt'});
        ExerciseDates = Data{1};
        AmericanOpt = Data{2};
        
        %---------------------------------------------------------------------
        % Create European/Bermuda strike schedules. American options times are a
        % subset of the underlier times - hence, no need to consider them.
        %---------------------------------------------------------------------
        EuropeanInd = find(AmericanOpt==0);
        
        % European/Bermudan option
        if ~isempty(EuropeanInd)
            ExerciseE = ExerciseDates(EuropeanInd,:);
            
            % no dates before Settle
            ExerciseE( ExerciseE < Settle(1) ) = NaN;
            
            % Pack and remove trailing NaN's
            AllOptDates = ExerciseE(:);
            AllOptDates(isnan(AllOptDates)) = [];
            AllOptDates = unique(AllOptDates);
        end
        
    otherwise
        % leave NaN for these prices
        warning('finderiv:checktree:InvalidInstrumentType',['Cannot price instruments of type ' TypeList{jType}]);
    end
end

% ---------------------------------------------------------------------
% Find cash flow dates for all intruments except CF & OptBond
% ---------------------------------------------------------------------
AllData = [Settle Maturity Reset Basis EMR];

% In general: NaN ~= NaN. 
AllNaN = isnan(AllData);
AllData(find(AllNaN)) = 0;
[AllData, I] = unique(AllData, 'rows');
AllNaN = AllNaN(I,:);
AllData(find(AllNaN))=NaN;

[CFAmounts, CFDates, CFTimes] = cfamounts(1, AllData(:,1), AllData(:,2), AllData(:,3), ...
                    AllData(:, 4), AllData(:, 5));

% ----------------------------------------------------------
% Set all parameters to a single time line
[dummy, AllDates] = cfport(CFAmounts, CFDates, CFTimes);                

% Combine cash flow dates with those of CFs and OptBonds
AllDates = union(AllDates, union(AllCFDates, AllOptDates));

TreeDates = [Tree.TimeSpec.ValuationDate; Tree.TimeSpec.Maturity];

% Rebuild the tree if necessary
if (~all(ismember(AllDates, TreeDates)))
    
    if(ConstRate)
        if(ShowWarnings)
            warning('finderiv:checktree:ResultsApproximated','Not all cash flows are aligned with the tree. Result will be approximated.');    
        end    	    
    else        
        if(ShowWarnings)
            warning('finderiv:checktree:RebuildingTree','Not all cash flows are aligned with the tree. Rebuilding tree.');    
        end     
        
        if(ShowDiagnostics)
			if(isafin(Tree, 'HJMFwdTree'))
            	NumBranch = Tree.VolSpec.NumBranch;
            	DiagMsg = sprintf('\nBuilding new tree with %d levels.\nLast node will have %d states.\n',...
                	(length(AllDates)-1), NumBranch ^ (length(AllDates)-2));
			else
				DiagMsg = sprintf('\nBuilding new tree with %d levels.\nLast node will have %d states.\n',...
				length(AllDates)-1, length(AllDates)-1);
			end			
			disp(DiagMsg);
        end       		
		
        TimeSpecNew  = feval(TimeSpecFcn, Tree.TimeSpec.ValuationDate, AllDates(2:end), ...
            Tree.RateSpec.Compounding);
        Tree = feval(TreeFcn, Tree.VolSpec, Tree.RateSpec, TimeSpecNew);
    end
end
return

% -----------------------------------------
% Change NaNs for a default value
function DataOut = nan2default(DataIn, Def)
        NaNPos = find(isnan(DataIn));
        if(~isempty(NaNPos))
            DataIn(NaNPos) = Def;
        end
        DataOut = DataIn;
return 

