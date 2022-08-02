function Tree = mktree(NumLevels, NumPos, NodeVal, IsPriceTree)
%MKTREE Create a recombining tree with initial values NodeVal in all nodes.
%
%  Tree = mktree(NumLevels, NumPos, NodeVal, IsPriceTree)
%
%
%  Inputs:
%    NumLevels   - Number of time levels of the tree.
%    NumPos      - 1 x NUMLEVELS vector containing the length of the state 
%                  vectors in each level.
%    NodeVal     - Initial value at each node of the tree. 
%                  Default is NaN.
%    IsPriceTree - Boolean determining if a final horizontal branch is added to
%                  the tree. Default is 0.
%
%  Outputs:
%    Tree      - Recombining tree.
%
%  Example:
%	  Tree = mktree(4,3) will create a tree with four time levels, 
%     with a vector of three elements in each node with each element 
%     initialized to NaNs.
%
%  See also TREEPATH, TREESHAPE

%   Author(s): M.Reyes-Kattar 02/05/2001
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.3.2.1 $    $Date: 2003/08/29 04:46:43 $

%-----------------------------------------------------------------
% Inputs
%-----------------------------------------------------------------
if(nargin < 2)
	error('finderiv:mktree:InvalidInputs','NumLevels and NumPos are required arguments')
end

if(nargin < 3)
	NodeVal = NaN;
end

if(nargin < 4)
	IsPriceTree = logical(0);
end

if(NumLevels < 1 | NumLevels ~= floor(NumLevels))
	error('finderiv:mktree:InvalidNumLevels','NumLevels must be a positive integer')
end

if(NumPos < 1 | NumPos ~= floor(NumPos))
	error('finderiv:mktree:InvalidNumPos','NumPos must be a positive integer')
end

NumPosLength = length(NumPos);
if(NumPosLength ~= 1 & NumPosLength ~= NumLevels)
	error('finderiv:mktree:InvalidNumPos','NumPos must be a scalar of a vector of length NumLevels')
end

if(NumPosLength == 1)
	NumPos = NumPos*ones(1, NumLevels);
end

if islogical(NodeVal)
    for iLevel=1:(NumLevels-1)
        Tree{iLevel} = NodeVal & true(NumPos(iLevel), iLevel);
    end
else
    for iLevel=1:(NumLevels-1)
        Tree{iLevel} = NodeVal * ones(NumPos(iLevel), iLevel);
    end
end

% Fill last level for a price tree
if(islogical(NodeVal))
    if(IsPriceTree)
        Tree{NumLevels} = NodeVal & true(NumPos(NumLevels), NumLevels-1);
    else
        Tree{NumLevels} = NodeVal & true(NumPos(NumLevels), NumLevels);
    end
else
    if(IsPriceTree)
        Tree{NumLevels} = NodeVal * ones(NumPos(NumLevels), NumLevels-1);
    else
        Tree{NumLevels} = NodeVal * ones(NumPos(NumLevels), NumLevels);
    end
end
