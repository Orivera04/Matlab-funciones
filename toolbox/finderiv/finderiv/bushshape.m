function [NumLevels, NumChild, NumPos, NumStates, TrimVector] = bushshape(Tree)
%BUSHSHAPE Retrieve the shape of a bushy tree.
%
%  [NumLevels, NumChild, NumPos, NumStates, TrimVector] = bushshape(Tree)
%
%  Inputs:
%    Tree             - Bushy tree.
%
%  Outputs:
%    NumLevels        - Number of time levels of the tree.
%    NumChild         - 1 x NUMLEVELS vector with number of branches (children) of 
%                       the nodes in each level.
%    NumPos           - 1 x NUMLEVELS vector containing the length of the state 
%                       vectors in each level.
%    NumStates        - 1 x NUMLEVELS vector containing the number of state vectors 
%                       in each level.
%    TrimVector       - True if NumPos follows the formula:
%                       NumPos(iLevel) == ( NumPos(1) - (iLevel-1) ).
%
%  Example:
%    load deriv
%    [NumLevels, NumChild, NumPos, NumStates, TrimVector] = bushshape(HJMTree.FwdTree) returns:
%    
%    NumLevels  =   [4]
%    NumChild   =   [2     2     2     0]
%    NumPos     =   [4     3     2     1]
%    NumStates  =   [1     2     4     8]
%    TrimVector =   [1]
%
%
%  Notes:
%   Recreate the tree with:
%   Tree = mkbush(NumLevels, NumChild(1), NumPos(1), TrimVector);
%   Tree = mkbush(NumLevels, NumChild, NumPos);
%
%  See also BUSHPATH, MKBUSH

%   Author(s): J. Akao 9/21/98
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 16:38:01 $

NumLevels = length(Tree);

NumPos = zeros(1,NumLevels);
NumStates = zeros(1,NumLevels);
for iLevel = 1:NumLevels
  [NumPos(iLevel), NumStates(iLevel)] = size( Tree{iLevel}(:,:) );
end

% Find the number of children at the first NumLevels-1 nodes
% By convention the last level has no children
NumChild = zeros(1,NumLevels);
NumChild(1:end-1) = NumStates(2:end)./NumStates(1:end-1);

% Find if the tree was constructed with TrimVector on 
Levels = (1:NumLevels);
TrimVector = all( NumPos == (NumPos(1) - (Levels-1)) );

