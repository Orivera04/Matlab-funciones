function [StateList, LevelList] = bushbranch2state(NumChild, BranchList)
% BUSHBRANCH2STATE creates a list of the state locations of nodes
% reached by a list of branches from root.  A zero in the
% Branchlist indicates no movement. 
%
% [StateList, LevelList] = bushbranch2state(NumChild, BranchList)
%
% BranchLists must run horizontally
% BranchList : NumLists by ListLength

% JHA 7/21/98
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.5 $  $Date: 2002/04/14 16:37:29 $

[NumLists, ListLength] = size(BranchList);
if length(NumChild)==1,
  % expand the number of children to be the same at every level
  NumChild = NumChild(:,ones(1,ListLength));
end
%-----------------------------------------------------------------

% get the level of the nodes in the lists
LevelList = 1 + cumsum( BranchList>0 , 2);

% construct the number of states at each level of the tree
% and shift the list back
NumStates = cumprod( [ 1, NumChild ] );
NumStatesPrev = [0, NumStates];

% Find how much to increment the state based on the branching and
% the number of states at the previous level 
IncList = (BranchList>0) .* ( BranchList - 1 ) .* NumStatesPrev(  LevelList );

% The states start at 1, sum along the lists to get the state number.
StateList = 1 + cumsum( IncList , 2);

