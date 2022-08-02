function [NLevels, NumPos, IsPriceTree] = treeshape(Tree)
%TREESHAPE Retrieve the shape of a recombining tree.
%
%  [NumLevels, NumPos, IsPriceTree] = treeshape(Tree)
%
%  Inputs:
%    Tree             - Recombining tree.
%
%  Outputs:
%    NumLevels        - Number of time levels of the tree.
%    NumPos           - 1 x NUMLEVELS vector containing the length of the state 
%                       vectors in each level.
%    IsPriceTree      - Boolean determining if a final horizontal branch is present
%                       in the tree.
%
%
%  See also TREEPATH, MKTREE

%   Author(s): M. Reyes-Kattar 01/27/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $    $Date: 2002/04/14 16:38:34 $

if ~iscell(Tree)
	error('Tree must be a recombining tree')
end

NLevels = length(Tree);

if nargout < 2
	return
end

for iLevel = 1:NLevels
	NumPos(iLevel) = size(Tree{iLevel},1);
end

if nargout < 3
	return
end

% Check if last level has same number of states as previous
% one
IsPriceTree = (size(Tree{end},2) == size(Tree{end-1},2));

