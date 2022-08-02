function [FwdRates] = bushpath(Tree, BranchList)
%BUSHPATH Retrieve entries from a node of a bushy tree.
%  The node path is described by the sequence of branchings 
%  taken, starting at the root.  The top branch is number
%  one, the second-to-top is 2, and so on. Set the branch sequence
%  to zero to obtain the entries at the root node.
%
%  [Values] = bushpath(Tree, BranchList)
%
%  Inputs:
%    Tree       - Bushy tree.
%    BranchList - NUMPATHS by PATHLENGTH matrix containing
%                 the sequence of branchings.
%
%  Outputs:
%    Values     - NUMVALS by NUMPATHS matrix containing
%                 the retrieved entries of a bushy tree.
%
%  Example:
%    load deriv
%    FwdRates = bushpath(HJMTree.FwdTree, [1 2 1])
%
%  returns the rates at the tree node located by taking the first 
%  branch, then the second branch, and finally the first branch 
%  again:
%
% FwdRates =
% 
%    1.03560000000000
%    1.03643598560876
%    1.05255047501569
%    1.04629989983901
%
%  See also BUSHSHAPE, MKBUSH

%   Author(s): J. Akao 07/21/98
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.10 $  $Date: 2002/04/14 16:38:49 $

%-----------------------------------------------------------------
% Inputs 
%-----------------------------------------------------------------
[NumLists, ListLength] = size(BranchList);

%-----------------------------------------------------------------
% Read dimensions from the tree shape
%  NumLevels        : number of time levels of the tree
%  NumVector        : number of entries in vector at root node
%  NumChild(Level)  : number of branches (children) at each node
%  NumStates(Level) : number of states at level 
%  NumPos(Level)    : length of each state vector at level
%-----------------------------------------------------------------
NumLevels = length(Tree);

NumPos = zeros(1,NumLevels);
NumStates = zeros(1,NumLevels);
for iLevel = 1:NumLevels
  [NumPos(iLevel), NumStates(iLevel)] = size( Tree{iLevel}(:,:) );
end

% Find the length of the logical vectors at every node
NumVector = NumPos(1);

% check if you have to look back for old entries
% Otherwise every time step is stored at each node
TrimVector = ~all( NumPos == NumPos(1) );

% Find the number of children at the first NumLevels-1 nodes
NumChild = NumStates(2:end)./NumStates(1:end-1);

%-----------------------------------------------------------------
% Tree{LevelLast(i)}(:,StateLast(i)) is the vector at the node
% reached by the i'th list of branchings
%
% LevelList : list of levels moved through to get to end node
% StateList : list of states moved through to got to end node
%-----------------------------------------------------------------

% turn the list of branches into a list of nodes
if ( TrimVector & any(BranchList(:,1)~=0) )
  % make sure the root is included in every list if you will need to
  % search nodes for past rates.
  BranchList = [ zeros(NumLists,1), BranchList ];
end
[StateList, LevelList] = bushbranch2state(NumChild, BranchList);

% Find the location of the final node reached
LevelLast = LevelList(:,end);
StateLast = StateList(:,end);

%-----------------------------------------------------------------
% FwdRates : NumVector by NumLists
%-----------------------------------------------------------------

% Allocate memory for the forward rate curves
FwdRates = zeros(NumVector, NumLists);

if (~TrimVector)
  % you can get the whole curve from the final node
  
  for iList = 1:NumLists,
    FwdRates(:,iList) = Tree{ LevelLast(iList) }(:, StateLast(iList));
  end

else
  % you have to step back to previous nodes to get the rates
  % each node contains the last NumPos(Level) rates
  
  for iList = 1:NumLists,
    % Find the first rate contained at the last node
    
    PosInLast = NumVector + 1 - NumPos( LevelLast(iList) );
    
    % Get one rate entry per node before the last node
    % Assume LevelList(iList,:) runs 1,2,3...
    for iPos = 1:PosInLast-1,
      FwdRates(iPos,iList) = ...
          Tree{ LevelList(iList, iPos) }(1, StateList(iList, iPos));
    end
    
    % Get the remaining rates from the last node
    FwdRates(PosInLast:NumVector,iList) = ...
        Tree{ LevelLast(iList) }(:, StateLast(iList));
    
  end
    
end  
    

