function [Price, PriceTree] = optstockbybintree(BinStockTree, varargin) 
%OPTSTOCKBYBINTREE Engine function for optstockbycrr and optstockbyeqp.
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2003/08/31 19:44:29 $

% -------------------------------------------------------------
% Process Input arguments
% -------------------------------------------------------------

if nargin < 6
    AmericanOpt = 0;
end

[OptSpec,Strike,Settle,ExerciseDates,AmericanOpt] = instargoptstock(varargin{:});


% Generic processing for all stock options
[NumInst, InstPut, InstCall, NumPut, NumCall, AllStrike, BinStockTree] = ...
    procoptions(BinStockTree, OptSpec,Strike,Settle,ExerciseDates, AmericanOpt);

% -------------------------------------------------------------
%Re-name variables
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
NumLevels = treeshape(SPrices);
PTree = mktree(NumLevels, NumInst);
PayOff = PTree;

% Build Price Tree
for iLevel=NumLevels:-1:1
    if(iLevel < NumLevels)
        % Discount the price from the previous level back to this one:
        DPrice  = Disc(iLevel) * (UpProbs(iLevel)*PTree{iLevel+1}(:, 1:end-1) + ...
            DnProbs(iLevel)*PTree{iLevel+1}(:, 2:end));
    else
        DPrice = zeros(size(PTree{iLevel}));
    end
    
    % Find pay-offs at current tree level
    PayOff{iLevel}(InstCall, :) = max(0, SPrices{iLevel}(ones(NumCall,1),:) - ...
        repmat(AllStrike(InstCall, iLevel), 1, iLevel));
    
    PayOff{iLevel}(InstPut, :) = max(0, -SPrices{iLevel}(ones(NumPut,1),:) + ...
        repmat(AllStrike(InstPut, iLevel), 1, iLevel));
    
   PTree{iLevel}(:) = max(PayOff{iLevel}, DPrice);
end

Price = PTree{1}(:);

if nargout<2
	return
end

PriceTree = classfin('BinPriceTree');
PriceTree.PTree = PTree;
PriceTree.tObs = TreeTimes;
PriceTree.dObs = TreeDates;

return



