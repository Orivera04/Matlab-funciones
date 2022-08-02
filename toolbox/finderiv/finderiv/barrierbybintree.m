function [Price, PriceTree] = barrierbybintree(BinStockTree, varargin) 
% BARRIERBYBINTREE Engine function for barrierbycrr and barrierbyeqp.
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.3 $  $Date: 2003/09/22 19:13:55 $

if nargin < 8
    Rebate = 0;
end

% Pull out the method from the input arguments
if nargin > 9
    Options = varargin{9};
    varargin = varargin(1:8);
else    
    Options = derivset;    
end

method = derivget(Options, 'BarrierMethod');

if(~strcmp(method, 'unenhanced') & ~strcmp(method, 'interp'))
    error('finderiv:barrierbybintree:InvalidMethod','Input argument ''method'' must be either ''unenhanced'' or ''interp''')
end


% -------------------------------------------------------------
% Process Input arguments
% -------------------------------------------------------------
[OptSpec,Strike,Settle,ExerciseDates,AmericanOpt, BarrierSpec, Barrier, Rebate] = instargbarrier(varargin{:});

UIMask = strcmpi(BarrierSpec, 'ui');
UOMask = strcmpi(BarrierSpec, 'uo');
DIMask = strcmpi(BarrierSpec, 'di');
DOMask = strcmpi(BarrierSpec, 'do');

UMask = UIMask | UOMask;
DMask = DIMask | DOMask;

UIIdx = find(UIMask);
UOIdx = find(UOMask);
DIIdx = find(DIMask);
DOIdx = find(DOMask);

UpsIdx = sort([UIIdx; UOIdx]);
DwnIdx = sort([DIIdx; DOIdx]);


% -------------------------------------------------------------
% Make sure barrier type, barrier value, and initial stock price
% are consistent
% -------------------------------------------------------------
if any(Barrier(UpsIdx) < BinStockTree.StockSpec.AssetPrice)
    error('finderiv:barrierbybintree:InvalidUpBarrier','Up barrier values cannot be smaller than initial Stock price')
end

if any(Barrier(DwnIdx) > BinStockTree.StockSpec.AssetPrice)
    error('finderiv:barrierbybintree:InvalidDownBarrier','Down barrier values cannot be larger than initial Stock price')
end

% Generic processing for all stock options
[NumInst, InstPut, InstCall, NumPut, NumCall, AllStrike, BinStockTree] = ...
    procoptions(BinStockTree, OptSpec,Strike,Settle, ExerciseDates, AmericanOpt);

% Variable re-names
SPrices = BinStockTree.STree;
TreeTimes = BinStockTree.tObs;
TreeDates = BinStockTree.dObs;

% -------------------------------------------------------------
% Locate the barrier(s) along the tree
% -------------------------------------------------------------
NumLevels = length(TreeTimes);

% Initialize location arrays
EffBarrierLoc  = NaN * ones(NumInst, NumLevels);
ModBarrierLoc  = EffBarrierLoc;

% Create a mask for "active" nodes under both the effective and modified
% barrier. Active nodes are the nodes that are within the barrier
% boundaries and therefore are the ones that we will do backward induction
% on. Initialize the variables here:
EffMaskTree = mktree(NumLevels, NumInst, false);
ModMaskTree = EffMaskTree;

% Find the last exercise date for each instrument:
[dummy,   NDperRow] = finargpack(1, ExerciseDates);
LastExDate = ExerciseDates(sub2ind(size(ExerciseDates), ...
        (1:NumInst)', NDperRow));

% By definition, the barrier cannot have been crossed on settle. Hence, we
% start at the second tree level
for iLevel = 2:NumLevels    
    
    % ----------------------------------------------------------
    % Up-In & Up-Out
    % ----------------------------------------------------------
    
    % The effective barrier is right after crossing the real barrier
    UpMask = SPrices{iLevel}(ones(length(UpsIdx), 1), :) >= Barrier(UpsIdx, ones(1,iLevel));
    [r, c] = find(diff(UpMask, 1, 2));
    if ~isempty(r)
        [dummy, I] = sort(r);
        EffBarrierLoc(UpsIdx(r), iLevel) = c(I);
        ModBarrierLoc(UpsIdx, iLevel) = EffBarrierLoc(UpsIdx, iLevel)+1;
    end
    EffMaskTree{iLevel}(UpsIdx, :) = ~UpMask;
    % Modified mask is same as effective, but shifted to the right. Only
    % shift those that do have an effective barrier node on this level
    % (it could be just NaN).
    ModMaskTree{iLevel}(UpsIdx,:) = EffMaskTree{iLevel}(UpsIdx, :);
    ShiftUpsIdx = UpsIdx(any(UpMask,2));
    ModMaskTree{iLevel}(ShiftUpsIdx,:) = [false(length(ShiftUpsIdx), 1) EffMaskTree{iLevel}(ShiftUpsIdx, 1:end-1)];
    
    % Also consider the nodes in the previous level
    switchedMask = isnan(EffBarrierLoc(:, iLevel-1)) & ~isnan(EffBarrierLoc(:, iLevel));
    ModMaskTree{iLevel-1}(switchedMask & UMask, 1) = false;
    ModBarrierLoc(switchedMask & UMask, iLevel-1) = 1;
        
    % ----------------------------------------------------------
    % Down-In & Down-Out
    % ----------------------------------------------------------
    
    % The effective barrier is right after crossing the real barrier
    DwnMask = SPrices{iLevel}(ones(length(DwnIdx), 1), :) <= Barrier(DwnIdx, ones(1,iLevel));
    [r, c] = find(diff([zeros(size(DwnIdx)) DwnMask], 1, 2));
    if ~isempty(r)
        [dummy, I] = sort(r);
        EffBarrierLoc(DwnIdx(r), iLevel) = c(I);
        ModBarrierLoc(DwnIdx, iLevel) = EffBarrierLoc(DwnIdx, iLevel)-1;
    end
    EffMaskTree{iLevel}(DwnIdx, :) = ~DwnMask;
    % Modified mask is same as effective mask, but shifted to the left. Only
    % shift those that do have an effective barrier node on this level
    % (it could be just NaN).
    ModMaskTree{iLevel}(DwnIdx,:) = EffMaskTree{iLevel}(DwnIdx, :);
    ShiftDwnIdx = DwnIdx(any(DwnMask,2));
    ModMaskTree{iLevel}(ShiftDwnIdx, :) = [EffMaskTree{iLevel}(ShiftDwnIdx, 2:end) false(length(ShiftDwnIdx), 1)];
    
    % Also consider the nodes in the previous level
    switchedMask = isnan(EffBarrierLoc(:, iLevel-1)) & ~isnan(EffBarrierLoc(:, iLevel));
    ModMaskTree{iLevel-1}(switchedMask & DMask, end) = false;
    ModBarrierLoc(switchedMask & DMask, iLevel-1) = iLevel-1;
    
    % The last node of all instruments is not really part of the modified
    % barrier. As such it needs to be calculated normally when building the
    % "barriered" tree (outs are payoff, ins are rebate).
    DateMask= TreeDates(iLevel) == LastExDate;
    if any(DateMask)
        idx = sub2ind([NumInst, iLevel], find(DateMask), ModBarrierLoc(DateMask, iLevel));
        ModMaskTree{iLevel}(idx) = true;
    end
    
    % Finally, some of the options may expire before the tree does. Make
    % sure that the calculation masks at the levels passed the option's
    % expiration are set to false
    DateMask=TreeDates(iLevel) > LastExDate;
    ModMaskTree{iLevel}(DateMask, :) = false;
    EffMaskTree{iLevel}(DateMask, :) = false;    
end

% The first node needs to always be calculated:
EffMaskTree{1} = true(NumInst,1);
ModMaskTree{1} = true(NumInst,1);

% -------------------------------------------------------------
% Find barrier values for 'in' options. Set the 'in' and 'out' option
% values along the effective barrier
% -------------------------------------------------------------
InIdx = sort([UIIdx; DIIdx]);
OutIdx = sort([UOIdx; DOIdx]);

% Find the prices for the knock-ins beforehand so we can use them later as
% we populate the barrier nodes.
if ~isempty(InIdx)
    [Dummy, InPriceTree] = optstockbybintree(BinStockTree, OptSpec(InIdx), Strike(InIdx,:),...
        Settle(InIdx),ExerciseDates(InIdx),AmericanOpt(InIdx));
else
    InPriceTree = [];
end

% Find values along the modified barrier when barrier is the effective
% barrier
[EffBarrierVals, EffPTree] = findmodvalues(BinStockTree, InPriceTree, OptSpec, AllStrike, ExerciseDates, ...
    Rebate, EffBarrierLoc, EffMaskTree, ModBarrierLoc, InIdx, OutIdx);
if strcmp(method, 'unenhanced')
    PTree = EffPTree;
else
        
    % Find values along the modified barrier when barrier is the modified
    % barrier. For outs the values along the modified barriers is simply
    % thge rebate, but for ins this is not true. Also, even for outs, we
    % still need the payoff tree since it is used later on (after
    % interpolation).
    [ModBarrierVals, PTree] = findmodvalues(BinStockTree, InPriceTree, OptSpec, AllStrike, ExerciseDates, ...
        Rebate, ModBarrierLoc, ModMaskTree, ModBarrierLoc, InIdx, OutIdx);
    
    % Extract Stock prices along the effective and modified barriers
    [EffStockPrices, ModStockPrices] = extractbarriers(BinStockTree.STree, ModBarrierLoc, EffBarrierLoc);
    
    
    % Use interpolation formula to find corrected values along the modified
    % barrier, and set the interpolated values along the modified barrier of
    % the price tree.
    mask = ~isnan(EffStockPrices);
    InterpModVals = NaN * ones(size(ModStockPrices));
    ExpBarrier = Barrier(:, ones(1,NumLevels));
    InterpModVals(mask) = (ExpBarrier(mask) - ModStockPrices(mask)) ./ (EffStockPrices(mask) - ModStockPrices(mask)) .* EffBarrierVals(mask) + ...
        (EffStockPrices(mask) - ExpBarrier(mask)) ./ (EffStockPrices(mask) - ModStockPrices(mask)) .* ModBarrierVals(mask);
    
    % Find the mod barrier nodes that don't have an effective barrier node at
    % the same tree level. These mod barrier nodes should contain the values
    % found when the effective barrier is used. This is also true for the
    % expiration boundary of each option.
    mask = ~isnan(ModBarrierLoc) & isnan(EffBarrierLoc);
%     [dummy, loc] = ismember(LastExDate, TreeDates);
%     idx = sub2ind(size(ModBarrierLoc), (1:NumInst)', loc);
%     mask(idx) = true;
      
    % -------------
    InterpModVals(mask) = EffBarrierVals(mask);
    
    % Place the newly found values along the modified barries of a new tree:
    %PTree = mktree(NumLevels, NumInst);
    for iLevel=1:NumLevels
        ActiveNodes = ~isnan(ModBarrierLoc(:, iLevel));
        if any(ActiveNodes)
            idx = sub2ind([NumInst, iLevel], find(ActiveNodes), ModBarrierLoc(ActiveNodes, iLevel));
            PTree{iLevel}(idx) = InterpModVals(ActiveNodes, iLevel);
        end
    end
    
    % Find the corrected price tree using the corrected values on the modifed
    % barrier
    PTree = barriertree(BinStockTree, PTree, ModMaskTree, InstPut, InstCall, NumPut, NumCall, AllStrike, LastExDate);    
end


Price = PTree{1}(:);

if nargout<2
	return
end

% Build the barrier tree according to the expected output:
%   For OUTS:
%           1.- Values passed the barrier should be zero.
%           2.- Values along the effective barrier are set to the rebate
%               2.a.- If using interpolated metod, the values along the
%               modified barrier are the result of the interplation
%           3.- Values inside the barrier are the resullt of backward
%               programming from the barrier values
%
%   For INS:
%           1.- Values passed the barrier are the values of the vanilla
%               instuments.
%           2.- Values along the effective barrier are set to the vanilla
%               options seetling at the node
%               2.a.- If using interpolated method, the values along the
%               modified barrier are the result of interpolation
%           3.- Values at instrument maturity inside the barrier are set to
%               their rebate
%           4.- Values inside the barrier are the resullt of backward
%               programming from the barrier values

InMask = UIMask | DIMask;
OutMask = UOMask | DOMask;

for iLevel=1:NumLevels
    % Set a mask for all values outside of the effective barrier:
    mask = ~EffMaskTree{iLevel}; % <--- Includes the effective barrier. Must take out.
    
    % Find the indices of the effective nodes at this level
    cols  = (1:NumInst)';
    NNanMask = ~isnan(EffBarrierLoc(:, iLevel));
    if any(NNanMask)    
        idx = sub2ind([NumInst, iLevel], cols(NNanMask), EffBarrierLoc(NNanMask, iLevel));
        mask(idx) = false; % <-- Take out eff barrier nodes
        
        if strcmp(method, 'interp')
            % Copy the values along the effective barrier, if any.      
            PTree{iLevel}(idx) = EffPTree{iLevel}(idx);
        end
    end
                
    % For outs, set the values outside the effective barrier to zero
    OMask = mask;
    OMask(InMask, :) = false;
    PTree{iLevel}(OMask) = 0;
    
    % For ins, set the values outside the effective barrier to the value of
    % the corresponding vanilla opion
    IMask = mask;
    IMask(OutMask, :) = false;
    if any(IMask(:))
        PTree{iLevel}(IMask) = InPriceTree.PTree{iLevel}(IMask(InMask,:));
    end
end

PriceTree = classfin('BinPriceTree');
PriceTree.PTree = PTree;
PriceTree.tObs = TreeTimes;
PriceTree.dObs = TreeDates;


return


% -------------------------------------------------------------
% Option pricing using backward induction on a binary tree 
% with barrier values.
% -------------------------------------------------------------
function PTree = barriertree(BinStockTree, PTree, MaskTree, InstPut, InstCall, NumPut, NumCall, AllStrike, LastExDate)

% -------------------------------------------------------------
% Re-name variables
TreeTimes = BinStockTree.tObs;
TreeDates = BinStockTree.dObs;
% -------------------------------------------------------------

% Obtain structural information from the tree:
NumLevels = length(TreeTimes);
UpProbs = BinStockTree.UpProbs;
DnProbs = 1-UpProbs;
RateSpec = BinStockTree.RateSpec;

% Find the discount between levels in the tree:
RateSpec = intenvset(RateSpec, 'StartTimes', TreeTimes(1:end-1)', ...
    'EndTimes', TreeTimes(2:end)');
Disc  = intenvget(RateSpec, 'Disc');

% Pull out prices pout of the stock tree struct
SPrices = BinStockTree.STree;

% Pre-create the Price Tree and payoff cell arrays
NumInst = length(InstPut);
NumLevels = treeshape(SPrices);
%PTree = mktree(NumLevels, NumInst);
%PayOff = PTree;
PayOff = mktree(NumLevels, NumInst);

% Build Price Tree
for iLevel=NumLevels-1:-1:1
    
    % The mask indicate the nodes that need to be calculated
    mask = MaskTree{iLevel} & (TreeDates(iLevel) < LastExDate(:, ones(1,iLevel)));
    
    % Isolate the up and down nodes from the next level so that we can
    % apply the mask to them:
    Ups = PTree{iLevel+1}(:, 1:end-1);
    Dwn = PTree{iLevel+1}(:, 2:end);
    
    % Discount the price from the previous level back to this one:
    DPrice  = Disc(iLevel) * (UpProbs(iLevel)*Ups + DnProbs(iLevel)*Dwn);
    
    % Find pay-offs at current tree level
    PayOff{iLevel}(InstCall, :) = max(0, SPrices{iLevel}(ones(sum(InstCall),1),:) - ...
        repmat(AllStrike(InstCall, iLevel), 1, iLevel));
    
    PayOff{iLevel}(InstPut, :) = max(0, -SPrices{iLevel}(ones(sum(InstPut),1),:) + ...
        repmat(AllStrike(InstPut, iLevel), 1, iLevel));
    
   PTree{iLevel}(mask) = max(PayOff{iLevel}(mask), DPrice(mask));
end




% -------------------------------------------------------------
% Utility function to extract a subtree given a level and a state.
% Used to find the subtree of the stock tree to be used when calculating
% the knock in value of the corresponding security.
% -------------------------------------------------------------
function SubBinStockTree = extractsubtree(BinStockTree, Level, State)

% Copy the original tree structure and adapt the fields that change
SubBinStockTree = BinStockTree;

% Take subset of times and probabilities
SubBinStockTree.tObs = BinStockTree.tObs(Level:end);
SubBinStockTree.dObs = BinStockTree.dObs(Level:end);
SubBinStockTree.UpProbs = BinStockTree.UpProbs(Level:end);

LastLevel = BinStockTree.TimeSpec.NumPeriods+1;
NumLevels = LastLevel-Level+1;

% Extract Tree data
SubBinStockTree.STree = cell(1, NumLevels);
for iLevel = Level:LastLevel;
    SubBinStockTree.STree{iLevel-Level+1} = BinStockTree.STree{iLevel}(State:(State+iLevel-Level));
end

% Fix the time spec
SubBinStockTree.TimeSpec.ValuationDate  = SubBinStockTree.dObs(1);
SubBinStockTree.TimeSpec.Maturity = SubBinStockTree.dObs(end);
SubBinStockTree.TimeSpec.NumPeriods = NumLevels-1;
return;


% -------------------------------------------------------------
% FINDMODVALUES
% This function returns the values of the nodes along the modified barrier
% given a set of nodes conforming a barrier. These nodes are typically
% either the effective barrier or the modified barrier.
% -------------------------------------------------------------
function [ModBarrierVals, PTree] = findmodvalues(BinStockTree, InPriceTree, OptSpec, AllStrike, ExerciseDates, ...
    Rebate, BarrierLoc, MaskTree, ModBarrierLoc, InIdx, OutIdx)

% Extract some basic information
TreeDates = BinStockTree.dObs;
SPrices  = BinStockTree.STree;
NumLevels = length(BinStockTree.STree);
NumInst = size(OptSpec, 1);
InstPut  = strcmpi(OptSpec,'put');
InstCall = ~InstPut;

% Find maturities for each option
[dummy,   NDperRow] = finargpack(1, ExerciseDates);
LastExDate = ExerciseDates(sub2ind(size(ExerciseDates), ...
        (1:NumInst)', NDperRow));

% -------------------------------------------------------------
% Pre-fabricate the array to hold the values on the modified
% nodes
ModBarrierVals  = NaN*ones(NumInst, NumLevels);

% Create a Mask for knock-in barrier nodes to indicate where values need to
% be calculated:
InMask = false(NumInst, NumLevels);
InLocMask = InMask;
InMask(~isnan(BarrierLoc))= true;
InLocMask(InIdx, :) = true;
InLocMask = InMask & InLocMask;

% Do the same for knock-out barrier nodes
OutMask = false(NumInst, NumLevels);
OutLocMask = OutMask;
OutMask(~isnan(BarrierLoc))= true;
OutLocMask(OutIdx, :) = true;
OutLocMask = OutMask & OutLocMask;

% Pre-create a price tree:
PTree = mktree(NumLevels, NumInst);

% Place values along the barriers and at option maturity
for iLevel = 2:NumLevels
    
    if ~isempty(InIdx)
        % Values along the barrier
        StateMask = false(NumInst, iLevel);
        StateMask(BarrierLoc(InLocMask(:, iLevel), iLevel)) = true;
        
        % Also, once passed the option maturity, there is nothing to be
        % done
        StateMask = StateMask & (TreeDates(iLevel) <= repmat(LastExDate, 1, iLevel));        
        
        PTree{iLevel}(InLocMask(:, iLevel), StateMask) = ...
            InPriceTree.PTree{iLevel}(InLocMask(InIdx, iLevel), StateMask);
        
        % Values at option Maturity
        
        % Knock-ins pay rebate if the option expires without ever
        % knocking in. Rebate shows up at option maturity
        InMask = false(NumInst,1);
        InMask(InIdx) = true;
        DateMask  = (TreeDates(iLevel) == LastExDate) & InMask; % ins that are expiring at this level
        if any(DateMask)
            mask = MaskTree{iLevel} & DateMask(:, ones(1,size(MaskTree{iLevel},2)));
            RebateEx = Rebate(:, ones(1, size(mask,2)));
            PTree{iLevel}(mask) = RebateEx(mask);
        end
        
    end
        
    if ~isempty(OutIdx)
        
        % Values along the barrier
        
        % For knock-outs, the equivalent security is simply the rebate payoff
        if(any(OutLocMask(:, iLevel)))
            idx = sub2ind(size(PTree{iLevel}), find(OutLocMask(:, iLevel)), BarrierLoc(OutLocMask(:, iLevel), iLevel));
            PTree{iLevel}(idx) = Rebate(OutLocMask(:, iLevel));
        end

        % Values at option maturity
        
        % At maturity knock outs value at pay-off
        OutMask = false(NumInst,1);
        OutMask(OutIdx) = true;
        DateMask = (TreeDates(iLevel) == LastExDate) & OutMask; % outs that are expiring at this level
        OutCallMask  = DateMask & InstCall;
        OutPutMask   = DateMask & InstPut;
        
        if any(OutCallMask)
            PayOff = max(0, SPrices{iLevel}(ones(sum(OutCallMask),1),:) - ...
                repmat(AllStrike(OutCallMask, iLevel), 1, iLevel));
            PTree{iLevel}(OutCallMask(:, ones(1, iLevel)) & MaskTree{iLevel}) = PayOff(MaskTree{iLevel}(OutCallMask, :));
        end
        
        if any(OutPutMask)
            PayOff = max(0, -SPrices{iLevel}(ones(sum(OutPutMask),1),:) + ...
                repmat(AllStrike(OutPutMask, iLevel), 1, iLevel));
            PTree{iLevel}(OutPutMask(:, ones(1, iLevel)) & MaskTree{iLevel}) = PayOff(MaskTree{iLevel}(OutPutMask, :));
        end
    end    
end

% Find the price tree using the effective barrier
PTree = barriertree(BinStockTree, PTree, MaskTree, InstPut, InstCall, length(InstPut), ...
            length(InstCall), AllStrike, LastExDate);


% Pull out values along the modified barrier
for iLevel=1:NumLevels
    ActiveNodes = ~isnan(ModBarrierLoc(:, iLevel));
    if any(ActiveNodes)
        idx = sub2ind([NumInst, iLevel], find(ActiveNodes), ModBarrierLoc(ActiveNodes, iLevel));
        ModBarrierVals(ActiveNodes, iLevel)  = PTree{iLevel}(idx);
    end
end

return

% -------------------------------------------------------------
% Extract the Stock prices along the modified and effective barriers
%
% EffStockPrices: NumInst x NumLevels array with prices for the barrier nodes and
% NaNs for levels where there is no barrier nodes.
%
% ModStockPrices: NumInst x NumLevels array with prices for the barrier nodes and
% NaNs for levels where there is no barrier nodes.
% -------------------------------------------------------------
function [EffStockPrices, ModStockPrices] = extractbarriers(STree, ModBarrierLoc, EffBarrierLoc)

    [NumInst, NumLevels] = size(EffBarrierLoc);
    EffStockPrices = NaN * ones(NumInst, NumLevels);
    ModStockPrices = NaN * ones(NumInst, NumLevels);
    
    for iLevel=1:NumLevels
        Prices = STree{iLevel}(ones(NumInst,1), :);
        
        % Effective Barrier
        ActiveNodes = ~isnan(EffBarrierLoc(:, iLevel));
        if(any(ActiveNodes))
            idx = sub2ind([NumInst, iLevel], find(ActiveNodes), EffBarrierLoc(ActiveNodes, iLevel));
            EffStockPrices(ActiveNodes, iLevel) = Prices(idx);
        end
        
        % Modiefied Barrier
        ActiveNodes = ~isnan(ModBarrierLoc(:, iLevel));
        if(any(ActiveNodes))
            idx = sub2ind([NumInst, iLevel], find(ActiveNodes), ModBarrierLoc(ActiveNodes, iLevel));
            ModStockPrices(ActiveNodes, iLevel) = Prices(idx);
        end
        
    end
    
return
