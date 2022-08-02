function [Price, PriceTree] = asianbybintree(BinStockTree, varargin) 
%ASIANBYBINTREE Engine function for asianbycrr and asianbyeqp.
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:02 $

% -------------------------------------------------------------
% Process Input arguments
% -------------------------------------------------------------
if nargin > 10
    error('finderiv:asianbybintree:InvalidInput','Too many input variables specified.')
end

% Pull out Hull-White granularity parameter setting. Hull-White recommends 
% h<=0.005
if nargin > 9
    h = varargin{end};
    if h > 0.005
        warning('finderiv:asianbybintree:InvalidParameterH','Hull-White recommends h<=0.005 for accurate results.');
    end
    
    if (length(h)>1 | h < 0)
        error('finderiv:asianbybintree:InvalidParameterH','Input argument ''h'' must be a positive scalar.')
    end
    varargin=varargin(1:end-1);
else
    h = 0.005;
end

[OptSpec,Strike,Settle,ExerciseDates,AmericanOpt,AvgType, AvgPrice, AvgDate] = instargasian(varargin{:});

% =============================================================
% m-index array:
%
%  Hull-White array of m-indexes. Every tree level will hold an
%  (implicit) array of indexes corresponding to the m-values that 
%  guarantee coverage of the F-value range for all nodes in that 
%  level. The equation is of the mode So*exp(m*h), with 
%  Mmin <= m <= Mmax
%
%  M: 2 X NumLevels array where the first row corresponds to the
%  max value of m and the second row corresponds to the min value
%  of m.
% ==============================================================
if ~isnan(AvgDate)
    TAvg = date2time(AvgDate, BinStockTree.TimeSpec.ValuationDate, -1, BinStockTree.TimeSpec.Basis);
else
    TAvg = NaN;
end
[MAri, MGeo] = GetMArray(BinStockTree, AvgType, h, AvgPrice, TAvg);

% Now solve for arithmetics first and then solve for geometrics
bArithmetic =  strcmpi(AvgType, 'arithmetic');
Price = NaN * ones(length(bArithmetic), 1);

if any(bArithmetic)
    Price(bArithmetic) = asianbybintree2(BinStockTree, h, true, OptSpec(bArithmetic, :),MAri,Strike(bArithmetic),...
        Settle(bArithmetic),ExerciseDates(bArithmetic,:),AmericanOpt(bArithmetic), TAvg); 
end

if any(~bArithmetic)
    Price(~bArithmetic) = asianbybintree2(BinStockTree, h, false, OptSpec(~bArithmetic, :),MGeo,Strike(~bArithmetic),...
        Settle(~bArithmetic),ExerciseDates(~bArithmetic,:),AmericanOpt(~bArithmetic), TAvg);
end

if nargout > 1
    % There isn't a tree for asians because there  would be too many values on
    % each node (one per possible path followed to that node). Still, we
    % need to generate a tree to be able to call this function from
    % bintreeprice. Just generate one full of NaNs.
    NumLevels = length(BinStockTree.tObs);
    NumInst = length(AmericanOpt);
    PTree = mktree(NumLevels, NumInst);
    PTree{1} = Price;
    PriceTree = classfin('BinPriceTree');
    PriceTree.PTree = PTree;
    PriceTree.tObs = BinStockTree.tObs;
    PriceTree.dObs = BinStockTree.dObs;

end

return



function Price = asianbybintree2(BinStockTree, h, bArithmetic, OptSpec,MArray,Strike,Settle,...
                    ExerciseDates,AmericanOpt, TAvg); 

% Generic processing for all stock options
[NumInst, InstPut, InstCall, NumPut, NumCall, AllStrike, BinStockTree] = ...
    procoptions(BinStockTree, OptSpec,Strike,Settle,ExerciseDates, AmericanOpt);

% -------------------------------------------------------------
%Re-name variables
TreeTimes = BinStockTree.tObs;
TreeDates = BinStockTree.dObs;
% -------------------------------------------------------------

% Asians can be either floating or fixed. Floatings have only NaNs in
% the Strike input arg, while fixed will specify a value. Create A mask
% to clasify the options since the equation is different for each type.
InstFloat = all(isnan(Strike),2);
InstFixed = ~InstFloat;

InstCallFloat = InstFloat & InstCall;
InstCallFixed = InstFixed & InstCall;
InstPutFloat  = InstFloat & InstPut;
InstPutFixed  = InstFixed & InstPut;

FloatMask = InstCallFloat | InstPutFloat;

NumCallFloat = sum(InstCallFloat); 
NumPutFloat = sum(InstPutFloat);
NumCallFixed = sum(InstCallFixed);
NumPutFixed = sum(InstPutFixed);

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
So = SPrices{1};

% Pre-allocate an array that wil fit all the v-vals
Vvals = nan*ones(NumInst, NumLevels, MArray(1,end)-MArray(2,end)+1);

if isnan(TAvg)
    TAvg = 0;
end

% Build Price Tree
for iLevel=NumLevels:-1:1
    
    % Expand the values implied by the m-indexes for this level. 
    % These are the F-values for this level.
    MIdx = MArray(1,iLevel):-1:MArray(2,iLevel);
    
    if(iLevel < NumLevels)
        FValsNext  = FVals;
        NumFValsNext = NumFVals;
    end
    NumFVals = length(MIdx);
    FVals  = zeros(1,1,NumFVals);
    FVals(1,1,:) = So*exp(h*MIdx);
        
    if(iLevel < NumLevels)
        % Discount the price from the previous level back to this one.
        
        % First, calculate the F-vals for the next level starting from this
        % one
        FValsEx = repmat(FVals, [1, iLevel, 1]);
        SPricesNextEx = repmat(SPrices{iLevel+1}, [1, 1, NumFVals]);
        
        if bArithmetic
            FValsExNextUp = (FValsEx * (TreeTimes(2)*iLevel+TAvg) + TreeTimes(2)*SPricesNextEx(:, 1:(end-1),:)) ./ (TreeTimes(2)*(iLevel+1)+TAvg);
            FValsExNextDn = (FValsEx * (TreeTimes(2)*iLevel+TAvg) + TreeTimes(2)*SPricesNextEx(:, 2:end,:)) ./ (TreeTimes(2)*(iLevel+1)+TAvg);
        else
            FValsExNextUp = (FValsEx .^ (TreeTimes(2)*iLevel+TAvg) .* SPricesNextEx(:, 1:(end-1),:) .^ TreeTimes(2)) .^ (1/(TreeTimes(2)*(iLevel+1)+TAvg));
            FValsExNextDn = (FValsEx .^ (TreeTimes(2)*iLevel+TAvg) .* SPricesNextEx(:, 2:end,:) .^ TreeTimes(2)) .^ (1/(TreeTimes(2)*(iLevel+1)+TAvg));
        end
 
        % Expans the Fvals to cover all instruments:
        FValsExNextUp = repmat(FValsExNextUp, NumInst,1);
        FValsExNextDn = repmat(FValsExNextDn, NumInst,1);        
  
        StatesUp = [1:iLevel]; StatesDn = [2:iLevel+1]; 
        StatesUp = repmat(StatesUp, [NumInst, 1, NumFVals]);
        StatesDn = repmat(StatesDn, [NumInst, 1, NumFVals]);
        
        InstIdx = (1:NumInst)'; InstIdx = repmat(InstIdx, [1, iLevel, NumFVals]);
        
        if NumInst == 1
            % Interpolate to find the corresponding Vvals
            [x, y] = meshgrid(FValsNext(:), 1:iLevel+1);
            Vvals2D = reshape(Vvals(1, 1:iLevel+1, 1:NumFValsNext), iLevel+1, NumFValsNext);
            
            VvalsInterpUp = interp2(x, y, Vvals2D, FValsExNextUp(:), StatesUp(:));
            VvalsInterpDn = interp2(x, y, Vvals2D, FValsExNextDn(:), StatesDn(:));
        else
            % Interpolate to find the corresponding Vvals
            [x, y, z] = meshgrid(1:iLevel+1, 1:NumInst, FValsNext(:));
            
            VvalsInterpUp = interp3(x, y, z, Vvals(1:NumInst, 1:iLevel+1, 1:NumFValsNext), StatesUp(:), InstIdx(:), FValsExNextUp(:));
            VvalsInterpDn = interp3(x, y, z, Vvals(1:NumInst, 1:iLevel+1, 1:NumFValsNext), StatesDn(:), InstIdx(:), FValsExNextDn(:));            
            
            if any(isnan([VvalsInterpUp; VvalsInterpDn]))
                % 3D Interpolation didn't work. This means that the range
                % passed in was outside the lookup table and therefore
                % extrapolation would have been needed. We also know that this
                % is not a true 3D lookup, as intruments and states remain
                % constant across interpolation. We can use this
                % information to take advantage of interp1's extrapolation
                % capability (which interp3 does not have)
                
                % Find where the NaNs are, locate instrument and state,and
                % interpolate one-dimentionally along the vVal axis.
                NaNIdx = find(isnan(VvalsInterpUp));
                if ~isempty(NaNIdx)
                    [InstIdx, LevelIdx, FValIdx] = ind2sub([NumInst, iLevel, NumFVals], NaNIdx);
                    % Permute dimensions so that FVals end up as columns
                    PVvalsNext = permute(Vvals(1:NumInst, 1:iLevel+1, 1:NumFValsNext), [3 2 1]);
                    PFValsNext = permute(repmat(FValsNext, [NumInst, iLevel+1, 1]), [3,2,1]);
                    
                    for valIdx = 1:size(InstIdx,1);
                        VvalsInterpUp(NaNIdx(valIdx)) = interp1(PFValsNext(:, LevelIdx(valIdx), InstIdx(valIdx)), ...
                            PVvalsNext(:, LevelIdx(valIdx), InstIdx(valIdx)), FValsExNextUp(InstIdx(valIdx), LevelIdx(valIdx), FValIdx(valIdx)),...
                            'linear', 'extrap');                        
                    end
                end
                
                NaNIdx = find(isnan(VvalsInterpDn));
                if ~isempty(NaNIdx)
                    [InstIdx, LevelIdx, FValIdx] = ind2sub([NumInst, iLevel, NumFVals], NaNIdx);
                    % Permute dimensions so that FVals end up as columns
                    PVvalsNext = permute(Vvals(1:NumInst, 1:iLevel+1, 1:NumFValsNext), [3 2 1]);
                    PFValsNext = permute(repmat(FValsNext, [NumInst, iLevel+1, 1]), [3,2,1]);
                    
                    for valIdx = 1:size(InstIdx,1);
                        VvalsInterpDn(NaNIdx(valIdx)) = interp1(PFValsNext(:, LevelIdx(valIdx), InstIdx(valIdx)), ...
                            PVvalsNext(:, LevelIdx(valIdx), InstIdx(valIdx)), FValsExNextDn(InstIdx(valIdx), LevelIdx(valIdx), FValIdx(valIdx)),...
                            'linear', 'extrap');                        
                    end
                end
                
            end
        end                
        
        VvalsInterpUp = reshape(VvalsInterpUp, [NumInst, iLevel, NumFVals]);
        VvalsInterpDn = reshape(VvalsInterpDn, [NumInst, iLevel, NumFVals]);
        
        % Discount back to find the discounted prices
        DVals = Disc(iLevel)*(UpProbs(iLevel)* VvalsInterpUp + DnProbs(iLevel)*VvalsInterpDn);
        
    else
        DVals = zeros(NumInst, iLevel, NumFVals);
    end
    
    
    FValsEx = repmat(FVals, [NumInst, iLevel, 1]);
    SPricesEx = repmat(SPrices{iLevel}, [NumInst, 1, NumFVals]);
    
    FloatMaskEx = repmat(FloatMask,[1, iLevel, NumFVals]);
    AllStrikeEx = repmat(AllStrike(:, iLevel), [1 iLevel NumFVals]);
    InfMask = isinf(AllStrikeEx) & FloatMaskEx;
    FValsEx(InfMask) = AllStrikeEx(InfMask);
    
    % Find pay-offs at current tree level
    Vvals(InstCallFloat,1:iLevel,1:length(MIdx)) = max(0, SPricesEx(InstCallFloat,:,:) - ...
        FValsEx(InstCallFloat,:, :));
    
    Vvals(InstPutFloat, 1:iLevel,1:length(MIdx)) = max(0, -SPricesEx(InstPutFloat,:,:) + ...
        FValsEx(InstPutFloat, :,:));
    
    Vvals(InstCallFixed, 1:iLevel,1:length(MIdx)) = max(0, FValsEx(InstCallFixed, :,:) - ...
        AllStrikeEx(InstCallFixed, :,:));    
    
    Vvals(InstPutFixed, 1:iLevel,1:length(MIdx)) = max(0, -FValsEx(InstPutFixed,:,:) + ...
        AllStrikeEx(InstPutFixed, :,:));
    
    Vvals(:, 1:iLevel,1:length(MIdx)) = max(Vvals(:, 1:iLevel,1:length(MIdx)), DVals);
end

Price = Vvals(:,1,1);

return



function [MAri, MGeo] = GetMArray(BinStockTree, AvgType, h, AvgPrice, TAvg)

bArithmetic =  strcmpi(AvgType, 'arithmetic');
bAri = any(bArithmetic);
bGeo = any (~bArithmetic);

MGeo = []; MAri = [];
if bAri
    MAri = GetMArray2(BinStockTree, true, h, AvgPrice, TAvg);
end

if bGeo
    MGeo = GetMArray2(BinStockTree, false, h, AvgPrice, TAvg);
end

return 


function M = GetMArray2(BinStockTree, bAri, h, AvgPrice, TAvg)

% Unpack some tree info
NumLevels = length(BinStockTree.tObs);

% pre-create M-arrays. First level is always 1.
M=nan*ones(2, NumLevels);


% Initialize the bounds arrays
ObsTime = BinStockTree.tObs(2)- BinStockTree.tObs(1);
if ~isnan(AvgPrice)
    Bounds = (AvgPrice * TAvg + BinStockTree.STree{1} * ObsTime) / (TAvg + ObsTime);
    Bounds = Bounds(ones(2,1));
    M(:,1) = log(Bounds / BinStockTree.STree{1}) / h;
    M(1,1) = ceil(M(1,1));
    M(2,1) = floor(M(2,1));

else
    TAvg = 0;
    Bounds = BinStockTree.STree{1}(ones(2,1));
    M(:, 1) = 0;
end


% Populate M Arrray
for iLevel=2:NumLevels
    if any(bAri)        
        Bounds=(Bounds*(ObsTime*(iLevel-1)+ TAvg)+ ObsTime * [BinStockTree.STree{iLevel}(1); BinStockTree.STree{iLevel}(end)])/(ObsTime*iLevel+ TAvg);
    else    
        Bounds=(Bounds .^ (ObsTime*(iLevel-1)+ TAvg) .* [BinStockTree.STree{iLevel}(1); BinStockTree.STree{iLevel}(end)] .^ ObsTime) .^ (1/(ObsTime*iLevel + TAvg));
    end
    
    % Find the min boundary values for m
    % So * exp(m*h)
    M(:, iLevel) = log(Bounds / BinStockTree.STree{1}) / h;
    M(1,iLevel) = ceil(M(1, iLevel));
    M(2,iLevel) = floor(M(2, iLevel));
    
    Bounds = BinStockTree.STree{1}*exp(h*M(:, iLevel));
end

return

