 function [BinStockTree] = binstocktree(StockSpec, RateSpec, BinTimeSpec, method)
%BINSTOCKTREE  Engine function for CRRTree and EQPTree.
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:08 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------

if ~(strcmpi(method,'crr') | strcmpi(method, 'eqp'))
    error('finderiv:binstocktree:InvalidMethod','Argument ''method'' must be either ''CRR'' or ''EQP''')
end

% Set aside original RateSpec:
RateSpecOri = RateSpec;


% Stock Info
So          = StockSpec.AssetPrice;
Sigma       = StockSpec.Sigma;
ExDates     = StockSpec.ExDividendDates;
DivAmounts   = StockSpec.DividendAmounts;
DivType     = StockSpec.DividendType;

% Tree Info
ValuationDate   = BinTimeSpec.ValuationDate;
Maturity        = BinTimeSpec.Maturity;
NumPeriods      = BinTimeSpec.NumPeriods;
Basis           = BinTimeSpec.Basis;
EndMonthRule    = BinTimeSpec.EndMonthRule;
TreeTimes       = BinTimeSpec.tObs';
TreeDates       = BinTimeSpec.dObs';

% Make sure we consider only dividend payment date that are to the right of
% the valuation date
if(~isempty(ExDates) & ~isnan(ExDates))
    % Truncate payments before valuationDate
    TruncateIdx = ExDates<ValuationDate;

    if any(TruncateIdx)
        warning('finderiv:binstocktree:DivBeforeValuationDate','Dividend payments occurring before valuation date are ignored.')
    end

    ExDates(TruncateIdx) = [];
    DivAmounts(TruncateIdx) = [];
    
    % Truncate payments after tree maturity
    TruncateIdx = ExDates>Maturity;

    if any(TruncateIdx)
        warning('finderiv:binstocktree:DivAfterMaturity','Dividend payments occurring after maturity are ignored.')
    end

    ExDates(TruncateIdx) = [];
    DivAmounts(TruncateIdx) = [];
    
    % If there is anything left, find Times equivalents
    if(~isempty(ExDates))
        ExTimes = date2time(ValuationDate, ExDates, -1, Basis, EndMonthRule);
                        
    else
        % Throw a warning and behave as if no dividends were specified
        warning('finderiv:binstocktree:DivBeforeValuationDate','All dividend payments occur before tree''s valuation date.')
        DivAmounts = 0;
        DivType = [];
    end
end

% Define tree and time variables
NumLevels = NumPeriods + 1;
TMaturity = date2time(ValuationDate, Maturity, -1, Basis, EndMonthRule);

% Those ExDates that coincide with treedates have their
% corresponding times snap with the TreeTimes:
[MemberMask, Loc] = ismember(ExDates, TreeDates);
if any(MemberMask)
    ExTimes(MemberMask) = TreeTimes(Loc(Loc ~= 0));
end

% If the ValuationDate of the tree is between two maturities of the
% RateSpec, we need to truncate the information in the RateSpec so that we
% can set the ValuationDate of the RateSpec equal to the valuationDate of
% the tree:
RSValuationDate = intenvget(RateSpec, 'ValuationDate');
if(RSValuationDate < ValuationDate)
    RSStartDate = intenvget(RateSpec, 'StartDate');
    RSEndDate = intenvget(RateSpec, 'EndDate');
    
    % Those segments that are completely to the left of the ValuationDate
    % can be eliminated (emptied out)
    outIdx = find(RSStartDate < ValuationDate & RSEndDate <= ValuationDate);
    RSStartDate(outIdx) = [];
    RSEndDate(outIdx) = [];
    
    % Segments that start before ValuatinDate but that end after
    % ValuationDate can be truncated to start on ValuationDate.
    RSStartDate(find(RSStartDate < ValuationDate)) = ValuationDate;
    RateSpec = intenvset(RateSpec, 'StartDate', RSStartDate);
end

% Throw a warning if RateSpec is not continuously compounded in case the
% users are not aware that the rates will change when compounding is set to
% -1
Compound  = intenvget(RateSpec, 'Compounding');
if Compound ~= -1
    msg1  = 'RateSpec was not created with continuous compounding. Compounding will be';
    msg2 = 'set to continuous while leaving discount factors unaltered. This will result';
    msg3 = 'in the recalculation of the interest rates.';
    msg = sprintf('\n%s\n%s\n%s\n', msg1, msg2, msg3);
    warning('finderiv:binstocktree:NonContinuousCompounding', msg);    
end

% Obtain the risk-free rates based on the given risk-free curve
RateSpec = intenvset(RateSpec, 'Basis', Basis, 'EndMonthRule', EndMonthRule, ...
    'Compounding', -1, 'ValuationDate', ValuationDate);
RateSpec = intenvset(RateSpec, 'EndTimes', TreeTimes(2:end));
RiskFreeRates = intenvget(RateSpec, 'Rates');

% -------------------------------------------------------------
% Calculate model parameters
% -------------------------------------------------------------

% Delta Time
dT = TMaturity/NumPeriods;

if strcmpi(method, 'crr')
    % CRR
    % up and down factors
    u = exp(Sigma * sqrt(dT));
    u = u * ones(NumPeriods,1);
    d = 1 ./ u;
else
    % EQP
    % up and down factors
    if strcmpi(DivType, 'continuous')
        EQPRates = RiskFreeRates - DivAmounts;
    else
        EQPRates = RiskFreeRates;
    end
    Expon = exp(2 * Sigma * sqrt(dT));
    d = 2 * exp(EQPRates * dT)/(1 + Expon);
    u = d * Expon;
end

% up probabilities
if strcmpi(DivType, 'continuous')
    q = DivAmounts * ones(NumPeriods,1);
    
    % The continuous model affects only the probabilities. For the rest of
    % the algorithm, behave as if no dividends were specified:
    DivAmounts = 0;
    DivType = [];
else
    q = zeros(NumPeriods,1);
end

if strcmpi(method, 'crr')
    p = ((exp((RiskFreeRates - q) * dT) - d) ./ (u - d))';
    if any(p>1)
        msg = sprintf('%s\n%s', 'The parameters entered generated probabilities greater than one.', ...
            'CRR will not generate acceptable results. ',...
            'Try the Equal Probabilities Method.');
        warning('finderiv:binstocktree:InvalidProbabilities',msg)    
    end
else
    % In eqprob, the probabilities are always 0.5
    p = 0.5 * ones(1,NumPeriods);
end

% -------------------------------------------------------------
% Find outputs
% -------------------------------------------------------------

% Build actual tree
STree = mktree(NumLevels, 1);

% Populate the tree
if isempty(DivType) | strcmpi(DivType, 'constant')
    % Calculate Dividend Factors
    if isempty(DivType)
        DivFactors = ones(1, NumLevels);
    else
        DivFactors = getdivfactors(TreeTimes, ExTimes, DivAmounts);                   
    end
    
    STree{1} = So;
    for iLevel = 2:NumLevels
                
        STree{iLevel}(:) = DivFactors(iLevel) * [u(iLevel-1) * ones(iLevel-1,1); d(iLevel-1)] .* ...
            [STree{iLevel-1}(:); STree{iLevel-1}(end)];
    end
else
    
    % Find the present value of all future cash flows at each
    % tree node time where there is a dividend payment
    CashFlows = TreeCashFlows(RateSpec, ExTimes, DivAmounts, TreeTimes);
    
    STree{1} = So - CashFlows(1);
    for iLevel = 2:NumLevels
        
        STree{iLevel}(:) = [u(iLevel-1) * ones(iLevel-1,1); d(iLevel-1)] .* ...
            [STree{iLevel-1}(:); STree{iLevel-1}(end)];
                
    end
    
    % Add the present value of future dividends to each node:
    for iLevel = 2:NumLevels

        STree{iLevel}(:) = STree{iLevel}(:) + CashFlows(iLevel);
        
        if any(STree{iLevel}(:) < 0)
            msg = sprintf('%s\n%s %f.', 'Dividend payments specified in StockSpec are larger', ...
                'than some tree stock prices at T =', TreeTimes(iLevel));
            error('finderiv:binstocktree:InvalidDividends',msg);
        end
    end
        
    % Finally, replace value at node zero
    STree{1} = So;
end

% Build Tree Structure
BinStockTree = classfin('BinStockTree');
BinStockTree.Method = upper(method);
BinStockTree.StockSpec = StockSpec;
BinStockTree.TimeSpec = BinTimeSpec;
BinStockTree.RateSpec = RateSpecOri;
BinStockTree.tObs = TreeTimes';
BinStockTree.dObs = TreeDates';
BinStockTree.STree = STree;
BinStockTree.UpProbs = p;

return;

% if nargout > 1
%     % Local Volatility
%     SigmaLoc = log(u/d) .* sqrt(p .* (1-p)) ./ sqrt(dT);    
% end

% =============================================================
% AUX Function Block
% =============================================================
function CashFlows = TreeCashFlows(RateSpec, ExTimes, DivAmounts, TreeTimes)

% Ignore cash flows occuring before and at tree ValuationDate
BadCFIdx = ExTimes <= TreeTimes(1);
if any(BadCFIdx)
    warning('finderiv:binstocktree:DivBeforeValuationDate', 'Dividend payments before and at ValuationDate are ignored');
    ExTimes(BadCFIdx) = [];
    DivAmounts(BadCFIdx) = [];
end

% Pull out div at ValuationDate. They don't need to be discounted:
ValDatePayment = 0;
if ExTimes(1) == TreeTimes(1)
    ValDatePayment = DivAmounts(1);
    DivAmounts(1)=[];
    ExTimes(1)=[];
end


% Union all times but retrieve location of tree times and ExTimes
AllTimes = union(TreeTimes, ExTimes);
[dummy, TTIdx] = ismember(TreeTimes, AllTimes);
[dummy, ETIdx] = ismember(ExTimes, AllTimes);


% Find applicable discounts to bring CFs to present value
RateSpecNew = intenvset(RateSpec, 'StartTimes', AllTimes(1:end-1), ...
                'EndTimes', AllTimes(2:end));
    
Disc = intenvget(RateSpecNew, 'Disc');

% Build a discount matrix to find the present value of future
% dividend payments on each node

% Find the index of elements in the lower right triangle
% of matrix, excluding the anti-diagonal
MaskIdx = find(~flipud(triu(ones(length(Disc)))));

% Calculate cummulative discounts at each node
CummDisc = flipud(Disc(:)) * ones(size(Disc'));
CummDisc(MaskIdx) = 1;
CummDisc = cumprod(CummDisc);
CummDisc(MaskIdx) = 0;
CummDisc = flipud(CummDisc);

% Calculate cummulative discounted future dividends
AllAmounts  = zeros(length(AllTimes)-1,1);
AllAmounts(ETIdx-1) = DivAmounts;

% Last node always has zero since there are no future dividends to consider.
% Hence, pad the result vector of discounted dividends with a zero.
CashFlows = [CummDisc * AllAmounts; 0];

% Extract Cash Flows on tree times
CashFlows = CashFlows(TTIdx);

% Add any payments made at ValDate
CashFlows(1) = CashFlows(1);

return;

%----------------------------
function DivFactors = getdivfactors(TreeTimes, ExTimes, DivAmounts)

NDiv = length(DivAmounts);
NumLevels = length(TreeTimes);

TreeTimes = (TreeTimes(:))';
TreeTimesEx = TreeTimes(ones(NDiv,1), :);


ExTimes = ExTimes(:);
ExTimesEx = ExTimes(:, ones(1, NumLevels));

DivAmounts = 1-DivAmounts(:);
DivAmountsEx = DivAmounts(:, ones(1, NumLevels));

% Put ones only where the ExDate snaps into the TreeDat
Mask = diff([false(NDiv,1) TreeTimesEx >= ExTimesEx], 1, 2);

DivFactors = Mask .* DivAmountsEx;
DivFactors(~Mask) = 1;

if(size(DivFactors,1)>1)
    DivFactors = prod(DivFactors);
end


