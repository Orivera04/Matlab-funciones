function [BranchList] = bushloc2branch(NumChild, StateLevel, StateLoc)
% BUSHLOC2BRANCH creates a list of the branchings taken to reach a
% pictured location in the tree.  The location is numbered by StateLevel
% starting from 1 right to left, and by StateLoc starting from 1 top to
% bottom in the level.
%
% [BranchList] = bushloc2branch(NumChild, StateLevel, StateLoc)
%
% NumChild   - number of children at each level of the tree
%
% StateLevel - Level of location in tree    (NumLists by 1 or scalar)
% StateLoc   - Number down from top of tree (NumLists by 1 or scalar)
%
% BranchList - List of branchings (NumLists by ListLength)
%

% JHA 9/23/98
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.5 $  $Date: 2002/04/14 16:37:32 $

%-----------------------------------------------------------------
% Parse Inputs
% ListLength (scalar)
% NumChild   (1 by ListLength or more)
% StateLevel (NumLists by 1)
% StateLoc   (NumLists by 1)
%-----------------------------------------------------------------

% process lists
StateLevel = StateLevel(:);
StateLoc   = StateLoc(:);
NumLists = max( length(StateLoc), length(StateLevel) );
if (length(StateLoc)==1),
  StateLoc = StateLoc(ones(NumLists,1),:);
end
if (length(StateLevel)==1),
  StateLevel = StateLevel(ones(NumLists,1),:);
end

% process length
ListLength = max(StateLevel);
if (length(NumChild)==1)
  % expand the number of children to be the same at every level
  NumChild = NumChild(:,ones(1,ListLength));
else
  % cut the list off at the top
  NumChild = NumChild(:,1:ListLength);
end

%-----------------------------------------------------------------
% DF - Digit factors (NumLists by ListLength)
% Intermediates: IndLevel, Level, NC (NumLists by ListLength)
%-----------------------------------------------------------------
[IndLevel , Level] = meshgrid((1:ListLength), StateLevel);

NC = NumChild(ones(NumLists,1),:);
NC(IndLevel >= Level) = 1;

DF = fliplr( cumprod( fliplr(NC) , 2 ) );

%-----------------------------------------------------------------
% Compute the branches from the top-down location and digit factors
% TDLoc is for branches after the root (NumLists by ListLength-1)
%-----------------------------------------------------------------
TDLoc = StateLoc(:, ones(1,ListLength-1)) - 1;


BranchList = zeros(NumLists, ListLength);
BranchList(:,2:end) = 1 + floor( mod( TDLoc, DF(:,1:end-1) ) ./ DF(:,2:end) );

% Screen steps beyond the end
BranchList(IndLevel > Level) = 0;

