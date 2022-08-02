function [X, BDTNewFwdTree]= addbdtlevel(R, X0, Compounding, tObs, BDTFwdTree)
%ADDBDTLEVEL Calculate yields for a given level of a BDT tree

%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01/27/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $  $Date: 2002/04/14 16:38:37 $

% Find the rates for the new level
TreeLength = length(BDTFwdTree);

NewLevelRates = zeros(1,TreeLength+1);
NewLevelRates(1) = R(1);

iNode = 2:(TreeLength+1);
NewLevelRates(2:end) = NewLevelRates(1) ./ (R(2) .^ (iNode-1));

NewLevelFwdFactor = 1 ./ rate2disc(Compounding, NewLevelRates', tObs(TreeLength+2), tObs(TreeLength+1))';

BDTNewFwdTree = BDTFwdTree;
BDTNewFwdTree{TreeLength+1} = NewLevelFwdFactor;

% Calculate the total yield including the new level
[NLevels, NumPos] = treeshape(BDTNewFwdTree);
PriceTree = mktree(NLevels, NumPos, NaN);
for iLevel = NLevels:-1:1
	if(iLevel == NLevels)
		PriceTree{iLevel}(:) = 1 ./ BDTNewFwdTree{iLevel}(:);
	else
		PriceTree{iLevel}(:) = (PriceTree{iLevel+1}(1:end-1) + PriceTree{iLevel+1}(2:end)) ./...
			(2 * BDTNewFwdTree{iLevel});
	end
end

% ----------------------------------------------------
% Calculate the yield of the total tree:

% PriceTree{1} contains the unit price at t=0. Since it's a unit
% price, it's basically a discount. Find the yield corresponding
% to that discount:

% Use disc2rate intead of the formula below....
r = disc2rate(Compounding, PriceTree{1}, tObs(NLevels+1));
%r = (((1/PriceTree{1})^(1/NLevels)) - 1) * Compounding;

% Find the yields at level 2 (time =1)
Yields = disc2rate(Compounding, PriceTree{2}(:), tObs(NLevels));

% Calculate the volatility
Vol = log(Yields(1)/Yields(2))/(2*sqrt(tObs(2)-tObs(1)));

% Define out as difference between input and calculated values
% X0 = [Rate; Volatility]
X = [r - X0(1); X0(2) - Vol];

return