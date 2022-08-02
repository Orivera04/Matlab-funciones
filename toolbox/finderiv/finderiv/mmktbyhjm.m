function MMktTree = mmktbyhjm(HJMTree)
%MMKTBYHJM Money Market tree from forward rate tree.
%
% MMktTree = mmktbyhjm(HJMTree)
%
% Input:
%   HJMTree    - Forward rate tree structure created by HJMTREE.
%
% Output:
%    MMktTree  - Money market tree.
%
% Example:
%    load deriv
%    MMktTree = mmktbyhjm(HJMTree);
%
%  See also HJMTREE

%   Author(s): M. Reyes-Kattar 12/08/1999
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.5 $  $Date: 2002/04/14 16:37:58 $

%---------------------------------------
% Checking the input arguments.
%---------------------------------------
if ~isafin(HJMTree,'HJMFwdTree')
  error('The first argument must be an HJM tree created by HJMTREE');
end

if (nargin < 1)
   error('You must enter HJMTree');
end

Tree = HJMTree.FwdTree;

[NumLevels, NumChild, NumPos, NumStates, TrimVector] = bushshape(Tree);

% mkbush(#nodes, # branches, # elements in vector)
BTree = mkbush(NumLevels, NumChild, 1);

%---------------------------------------
% Find the tree of the money market.
%---------------------------------------
BTree{1} = 1;
BTree{2}(1,:) = Tree{1}(1,:) * ones(size(BTree{2}(1,:)));
for i=3:NumLevels
   if(TrimVector)
      B = BTree{i-1}(1,:) .* Tree{i-1}(1,:);
   else
      B = BTree{i-1}(1,:) .* Tree{i-1}(i-1,:);
   end   
   B = (ones(NumChild(1),1) * B)';
   BTree{i}(1,:) = B(:)';
end 

TreeTimes = [HJMTree.tObs'; HJMTree.CFlowT{end}];

% Build output structures
MMktTree = classfin('HJMMmktTree');
MMktTree.tObs = TreeTimes';
MMktTree.MMktTree = BTree;




