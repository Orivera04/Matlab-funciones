function MMktTree = mmktbybdt(BDTTree)
%MMKTBYBDT Money Market tree from BDT interest rate tree.
%
% MMktTree = mmktbybdt(BDTTree)
%
% Input:
%   BDTTree    - Interest rate tree structure created by BDTTREE.
%
% Output:
%    MMktTree  - Money market tree.
%
% Example:
%    load deriv
%    MMktTree = mmktbybdt(BDTTree);
%
%  See also BDTTREE

%   Author(s): M. Reyes-Kattar 7/23/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $  $Date: 2002/04/14 16:40:13 $

%---------------------------------------
% Checking the input arguments.
%---------------------------------------
if ~isafin(BDTTree,'BDTFwdTree')
  error('The first argument must be a BDT tree created by BDTTREE');
end

if (nargin < 1)
   error('You must enter BDTTree');
end

Tree = BDTTree.FwdTree;
StartTimes = [BDTTree.TimeSpec.ValuationDate BDTTree.TimeSpec.Maturity(end-1)];
EndTimes = BDTTree.TimeSpec.Maturity;

[NumLevels] = treeshape(Tree);
BTree = mktree(NumLevels, 1, 0, 0);

%---------------------------------------
% Find the tree of the money market.
%---------------------------------------
BTree{1} = 1;
BTree{2}(:,:) = Tree{1} * ones(size(BTree{2}));
for i=3:NumLevels
	
	% Multiply previous BTree times previous Tree
	B = BTree{i-1} .* Tree{i-1};
	
	% Find equivalent rate
	Rates = disc2rate(BDTTree.TimeSpec.Compounding, B, ...
		EndTimes(i-1), StartTimes(1));
	
	% Average rates for nodes that have more than one parent
	colIdx = 1:length(Rates);
	Idx = [1 colIdx; colIdx colIdx(end)];
	
	TotalRates = [0.5 0.5] * Rates(Idx);
	
	% Turn back to Discounts
	BTree{i} = rate2disc(BDTTree.TimeSpec.Compounding, ...
		TotalRates, EndTimes(i-1), StartTimes(1));
end 

TreeTimes = [BDTTree.tObs'; BDTTree.CFlowT{end}];

% Build output structures
MMktTree = classfin('BDTMmktTree');
MMktTree.tObs = TreeTimes';
MMktTree.MMktTree = BTree;




