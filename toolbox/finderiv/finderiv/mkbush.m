function [Tree, NumStates] = mkbush(NumLevels, NumBranch, NumVector, TrimVector, NodeVal)
%MKBUSH Create a bushy tree with initial values NodeVal in all nodes.
%
%  [Tree, NumStates] = mkbush(NumLevels, NumChild, NumPos, TrimVector, NodeVal)
%
%  Inputs:
%    NumLevels  - Number of time levels of the tree.
%    NumChild   - 1 x NUMLEVELS vector with number of branches (children) of 
%                 the nodes in each level.
%    NumPos     - 1 x NUMLEVELS vector containing the length of the state 
%                 vectors in each level.
%    TrimVector - True to make NumPos follow the formula:
%                 NumPos(iLevel) == ( NumPos(1) - (iLevel-1) )
%                 Default is 0.
%    NodeVal    - Initial value at each node of the tree. 
%                 Default is NaN.
%
%  Outputs:
%    Tree      - Bushy tree.
%    NumStates - 1 x NUMLEVELS vector containing the number of state vectors 
%                in each level.
%
%  Example:
%		Tree = mkbush(4, 2, 3) will create a tree with four time levels, 
%     with two branches per node, a vector of three elements in each 
%     node with each element initialized to NaNs.
%
%
%  See also BUSHPATH, BUSHSHAPE

%   Author(s): J. Akao 03/27/98
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 16:37:52 $

%-----------------------------------------------------------------
% Inputs
%-----------------------------------------------------------------
if (nargin<2 | isempty(NumBranch))
  NumBranch = 2;
end

if (nargin<3 | isempty(NumVector))
  NumVector = NumLevels;
end

if (nargin<4 | isempty(TrimVector))
  TrimVector = logical(0);
end

% Node value to be used instead of NaN. Must be a scalar
if (nargin<5 | isempty(NodeVal))
   NodeVal = NaN;
else
   if(length(NodeVal) ~= 1)
      error('NodeVal must be a scalar')
   end
end

%-----------------------------------------------------------------
% You may pass in NumChild vector in the place of NumBranch
% You may pass in NumPos vector in the place of NumVector
%
% Dimensions
%  NumLevels        : number of time levels of the tree
%  NumChild(Level)  : number of branches (children) at each node
%  NumStates(Level) : number of states at level 
%  NumPos(Level)    : length of each state vector at level
%-----------------------------------------------------------------
Levels = (1:NumLevels);

% Parse for NumChild 9/21/98
if ( length(NumBranch) == NumLevels )
  % NumBranch is the number of children at each level
  NumChild = NumBranch;
else
  % NumBranch is a single number applied to all levels
  NumChild = NumBranch*ones(1,NumLevels);
  NumChild(end) = 0;
end
  
% Parse for NumPos
if ( length(NumVector) == NumLevels )
  % NumVector is the length of the vector stored at each level
  NumPos = NumVector;
else
  % NumVector is a single number: the length of the vector stored at root
  if TrimVector
    NumPos = NumVector - (Levels - 1);
  else
    NumPos = NumVector*ones(1,NumLevels);
  end
end

% Compute the number of states at each level
% Multiply by the number of branches at each stage
NumStates = ones(1,NumLevels);
NumStates(2:end) = NumChild(1:end-1);
NumStates = cumprod(NumStates);

%-----------------------------------------------------------------
% Create tree with initial NodeVal entries
%-----------------------------------------------------------------
 
% Store levels in a cell array
Tree = cell(1,NumLevels);

% Make the Root
Tree{1} = NodeVal*ones(NumPos(1), NumStates(1)); 

% make the children of each level (except the last)
for Level = 1:NumLevels-1
  Tree{Level+1} = NodeVal * ... 
      ones(NumPos(Level+1), NumStates(Level), NumChild(Level));
end

%-----------------------------------------------------------------
% Extract information
% Tree{Level}(:,:)     NumVector by NumStates (NumBranch^(Level-1))
% Tree{Level+1}(:,:,j) NumVector by NumStates of jth child
%-----------------------------------------------------------------

