function  [NumInst, InstPut, InstCall, NumPut, NumCall, AllStrike, BinStockTree] = ...
    procoptions(BinStockTree, OptSpec, Strike,Settle, ExerciseDates, AmericanOpt)
%PROCOPTIONS Engine function for optstockbycrr and optstockbyeqp.
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2003/08/31 19:44:30 $

% -------------------------------------------------------------
% Re-name variables
EOM = BinStockTree.TimeSpec.EndMonthRule;
Basis = BinStockTree.TimeSpec.Basis;

TreeTimes = BinStockTree.tObs;
TreeDates = BinStockTree.dObs;
% -------------------------------------------------------------

NumInst = size(OptSpec, 1);

% Verify Settle vs. ValuationDate
if any(Settle ~= TreeDates(1))
    warning('finderiv:procoptions:IgnoredSettle','Options will be valued at tree Valuation Date and not at option Settle.');
end


% -------------------------------------------------------------
% Verify that the tree is a useful one. If the tree was created
% for an stock that pays dividends, then all dividends must be
% paid by the option's maturity
% -------------------------------------------------------------
DivType  = lower(BinStockTree.StockSpec.DividendType);
if ~isempty(DivType)
    switch DivType
        case {'cash', 'constant'}
            MaxDivDate = max(BinStockTree.StockSpec.ExDividendDates);
            
        case{'continuous'}
            MaxDivDate = BinStockTree.TimeSpec.Maturity;
        otherwise
            error('finderiv:procoptions:InvalidDividendType','Unsupported DividendType in input tree structure')
    end
    
    [LastExDate,   NDperRow] = finargpack(1, ExerciseDates);
    LastExDate = unique(ExerciseDates(sub2ind(size(ExerciseDates), ...
        (1:NumInst)', NDperRow)));
    
    % If there is more than one option, we must make sure that all options
    % have the same maturity.
    if length(LastExDate) > 1
        str1 = 'When pricing multiple options using a dividend-paying stock,';
        str2 = 'all options must have the same maturity';
        msg = sprintf('%s\n%s', str1, str2);
        error('finderiv:procoptions:InvalidMaturity',msg)
    end


    % Build the new tree if necessary
    if MaxDivDate > LastExDate
        % Build a new tree with a maturity equal to ExDate
        str1 = 'The input tree contains dividends paid after option maturity.';
        str2 = 'Re-building the tree so that dividends line up appropriately';
        str3 = 'with the option(s).';
        msg = sprintf('%s\n%s\n%s', str1, str2, str3);
        warning('finderiv:procoptions:DividendsAfterMaturity',msg);
        
        TimeSpec = BinStockTree.TimeSpec;
        NewTimeSpec = bintimespec(TimeSpec.ValuationDate, LastExDate, TimeSpec.NumPeriods,...
            TimeSpec.Basis, TimeSpec.EndMonthRule);
        
        BinStockTree = binstocktree(BinStockTree.StockSpec, BinStockTree.RateSpec, ...
            NewTimeSpec, BinStockTree.Method);
        
        % Redefine variables to reflect changes
        TreeTimes = BinStockTree.tObs;
        TreeDates = BinStockTree.dObs;
    end
end
    

% Verify that the option's ExerciseDates are within the range of the tree
if(any(ExerciseDates > BinStockTree.TimeSpec.Maturity))
    error('finderiv:procoptions:InvalidExerciseDates','Option ExerciseDates occur after Tree Maturity')
end

if(any(ExerciseDates < BinStockTree.TimeSpec.ValuationDate))
    error('finderiv:procoptions:InvalidExerciseDates','Option ExerciseDates occur before Tree ValuationDate')
end


% -------------------------------------------------------------
% Process the options and find the prices
% -------------------------------------------------------------


% -------------------------------------------------------------
% American Options can be exercised from ValuationDate:
NExDates = size(ExerciseDates, 2);
if NExDates == 1
    ExerciseDates = [ExerciseDates NaN*ones(NumInst, 1)];  
end

% Find single date rows for American options, shift the to the right and
% place the valuationdate in the fisrt column.
SingleDateInd = find((sum(~isnan(ExerciseDates), 2) == 1) & logical(AmericanOpt));
ExerciseDates(SingleDateInd, 2) = ExerciseDates(SingleDateInd, 1);
ExerciseDates(SingleDateInd, 1) = BinStockTree.TimeSpec.ValuationDate;
%
% -------------------------------------------------------------

% Find time factor for exercise/maturity dates:
ExerciseTimes = NaN*ones(size(ExerciseDates));
ExerciseTimes(~isnan(ExerciseDates)) = date2time(BinStockTree.TimeSpec.ValuationDate, ...
    ExerciseDates(~isnan(ExerciseDates)), -1, Basis, EOM);

% -------------------------------------------------------------------------
% TreeTimes was generated via interpolation and will most likely have a
% granularity higher than "days". This would be a problem since
% ExerciseDates that are appropriate would not be mapped to the appropriate
% value in TreeTimes. To resolve this, we "snap" the valid
% ExerciseTimes into the appropriate interpolated times of the tree.

EDates = ExerciseDates(~isnan(ExerciseDates));
[TF, Idx] = ismember(EDates, TreeDates);
% Catch if any date is not on the tree
if(~all(TF))
    msg = sprintf('%s\n%s', 'Some ExerciseDates are not aligned with tree nodes. Valid ExerciseDates can ', ...
        'be found in the input tree structure field: ''dObs''');
    error(msg)
end
ExerciseTimes(~isnan(ExerciseTimes)) = TreeTimes(Idx);
% -------------------------------------------------------------------------



% Separate American from non-American (European and Bermudan) options
%---------------------------------------------------------------------
% create strike schedules
%---------------------------------------------------------------------
AmericanInd = find(AmericanOpt);
EuropeanInd = find(~AmericanOpt);

if ~isempty(AmericanInd)
    
    % American options can be evaluated on all tree nodes within the strike 
    % range of the option    
    ExerciseA = repmat(TreeTimes ,length(AmericanInd), 1);
    ND = length(TreeTimes);
        
    % no dates before First exercise opportunity
    ExerciseA( ExerciseA < ExerciseTimes(AmericanInd,ones(1,ND)) ) = NaN;
    
    % no dates after last exercise opportunity
    ExerciseA( ExerciseA > ExerciseTimes(AmericanInd,2*ones(1,ND)) ) = NaN;
    
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
    ExerciseE = ExerciseTimes(EuropeanInd,:);    
else
    StrikeE = [];
    ExerciseE = [];
end


% Catenate the American and European sets and then reorder
SchedStrike = finargcat(1, StrikeE, StrikeA);
SchedTimes  = finargcat(1, ExerciseE, ExerciseA);
  
SchedStrike([EuropeanInd; AmericanInd],:) = SchedStrike;
SchedTimes([EuropeanInd; AmericanInd],:) = SchedTimes;

% Pack and remove trailing NaN's
% The schedules could be empty
[SchedStrike] = finargpack(1, SchedStrike);
[SchedTimes]  = finargpack(1, SchedTimes);

% Mark instruments as either call or put
% Default is call
InstPut  = strcmpi(OptSpec,'put');
InstCall = ~InstPut;
NumPut = sum(InstPut);
NumCall = sum(InstCall);

% Place all times and strikes on the same time line:
[AllStrike, IsTreeDate, dummy, AllT] = bintreetime(SchedStrike, SchedTimes, SchedTimes, TreeTimes', TreeTimes');

% Set null strikes appropriately in AllStrike, depending on whether they
% are puts or calls:
NumStrikes = size(AllStrike, 2);
AllStrike( InstCall(:,ones(1,NumStrikes)) & (AllStrike==0) ) = Inf;
AllStrike(  InstPut(:,ones(1,NumStrikes)) & (AllStrike==0) ) = -Inf;

return
