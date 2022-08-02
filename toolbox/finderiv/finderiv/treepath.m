function [FwdRates] = treepath(Tree, BranchList)
%TREEPATH Retrieve entries from a node of a recombining tree.
%  The node path is described by the sequence of branchings 
%  taken, starting at the root.  The top branch is number
%  one, the second-to-top is 2, and so on. Set the branch sequence
%  to zero to obtain the entries at the root node.
%
%  [Values] = treepath(Tree, BranchList)
%
%  Inputs:
%    Tree       - Recombining tree.
%    BranchList - NUMPATHS by PATHLENGTH matrix containing
%                 the sequence of branchings.
%
%  Outputs:
%    Values     - NUMVALS by NUMPATHS matrix containing
%                 the retrieved entries of a recombining tree.
%

%  See also TREESHAPE, MKTREE

%   Author(s): M. Reyes-Kattar 01/27/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $    $Date: 2002/04/14 16:38:43 $

%-----------------------------------------------------------------
% Inputs 
%-----------------------------------------------------------------
if nargin < 2
	error('Tree and BranchList are required inputs')
end

% Make sure all the values are either 0's(root), 1's (up) or 2's(down)
if any(BranchList(:)~= 0 & BranchList(:)~= 1 & BranchList(:)~= 2)
	error('Branching sequence must be composed of 0''s (root), 1''s (up), and 2''s (down)')
end

% Make sure it's BDT tree-like
[NLevels, NumPos, IsPriceTree] = treeshape(Tree);
if(~all(NumPos == NumPos(1)) | (IsPriceTree ~= 0 & IsPriceTree ~= 1))
	error('Tree must be a BDT tree')
end

% BranchList cannot be longer than the length of the tree unless
% the extra elements are zero
if(size(BranchList,2) > NLevels)
	if any(any(BranchList(:, NLevels+1:end)~=0))
		warning('Elements in BranchList passed the end of the tree are ignored')
	end
	BranchList(:, NLevels+1:end) = [];
end

% If the first row is of zeros, take it out
ZeroCol=0;
if(all(BranchList(:,1)==0))
	ZeroCol=1;
	BranchList(:,1)=[];
end

[NumLists, ListLength] = size(BranchList);

% Create mask containing any other zeros
ZeroMask = (BranchList==0);

Iones = ones(1, NumLists);
IndexList =  ones(NumLists,ListLength) + cumsum(max(0, BranchList - 1),2);

if NumPos == 1 & ~IsPriceTree
	
	FwdRates = ones(ListLength+1, NumLists) * NaN;
	FwdRates(1,:) = Tree{1}(Iones);
	for iPath=1:ListLength
		FwdRates(iPath+1,:) = Tree{iPath+1}(IndexList(:,iPath));
	end
	
	% trailing zeros are set to NaN. Compensate for first node
	ZeroMask = logical([zeros(NumLists,1) ZeroMask]);
	FwdRates(ZeroMask')=NaN;
else
	% We have something like a price tree. Return the values 
	% at the end of each path
	LastCol = max(cumsum(~ZeroMask, 2), [], 2) + 1;
	if(isempty(LastCol))
		LastCol = ones(NumLists,1);
	end
	IndexList = [ones(NumLists,1) IndexList];
	
	FwdRates = ones(NumPos(1), NumLists) * NaN;
	for iPath=1:NumLists		
		FwdRates(:, iPath) = Tree{LastCol(iPath)}(:, IndexList(iPath, LastCol(iPath)));
	end
end




