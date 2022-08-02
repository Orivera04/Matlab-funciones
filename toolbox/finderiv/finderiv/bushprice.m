function DTree = bushprice(HJMTree)
%BUSHPRICE Unit bond prices (discounts) from forward rate tree.
%   Compute a state tree of discounts between the observation time of the
%   state and the maturities of the forward rates in the state.
%
%   This is a private function that is not meant to be called directly
%   by the user.
%
%   DiscTree = bushprice(HJMTree)
%
% Inputs:
%   HJMTree - Forward rate tree structure created by HJMTREE.
%
% Outputs:
%   DiscTree - Tree structure with a vector of unit bond prices at each node. 
%
% See also HJMTREE

%   Author(s): M. Reyes-Kattar 09/27/98
%   Copyright 1998-2002 The MathWorks, Inc.
%   $Revision: 1.10 $  $Date: 2002/04/14 16:37:35 $

%-----------------------------------------------------------------
% Checking inputs
%-----------------------------------------------------------------
if ~isafin(HJMTree,'HJMFwdTree')
	error('Input argument must be an HJMTree of forward rates.')
end
  
%---------------------------------------------------------------------
% Compute discount tree from FwdTree = (1+f) values
% Assume head-to-tail arrangements
% Include the 1 unit bond price P(t,t)
%---------------------------------------------------------------------
  
FwdTree = HJMTree.FwdTree;
[NumLevels, NumChild, NumPos, NumStates] = bushshape(FwdTree);

PTree = mkbush(NumLevels, NumChild, NumPos+1);

for iObs = 1:NumLevels
  PTree{iObs}(1,:) = 1;
  PTree{iObs}(2:end,:) = 1./cumprod( FwdTree{iObs}(:,:) , 1);
end

DTree = classfin('HJMPTree');
DTree.VolSpec = HJMTree.VolSpec;
DTree.tObs = HJMTree.tObs;

DTree.tVal   = cell(1,NumLevels);
DTree.CFlowT = cell(1,NumLevels);
for iObs = 1:NumLevels
  % Valuation time of discounts
  DTree.tVal{iObs} = DTree.tObs(iObs)*ones(NumPos(iObs)+1,1);
  
  % Cash flow time for discounts
  DTree.CFlowT{iObs} = DTree.tVal{iObs};
  DTree.CFlowT{iObs}(2:end) = HJMTree.CFlowT{iObs};
end

DTree.PTree = PTree;
  
