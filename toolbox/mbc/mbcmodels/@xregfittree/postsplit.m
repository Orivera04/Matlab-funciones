function varargout = postsplit( Tree, data )
%XREGFITTREE/POSTSPLIT  Build a regression tree for RBF fitting
%  TREE = POSTSPLIT(TREE,PANEL,DATA) is the sequel to PRESPLIT: it performs the 
%  split that PRESPLIT computed. It is an error to call this if DATA.Panel has 
%  any children, i.e., if it has already been split.
%
%  See also XREGFITTREE, XREGFITTREE\SPLIT, XREGFITTREE\PRESPLIT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $ 

panel = data.Parent;
if any( Tree.Children(panel,:) ~= 0 ),
    error( 'DATA.Panel has already been split' );
end

splitDim = data.SplitDim;

%
% Reorder the data points
% -----------------------
first = Tree.First(panel);
last  = Tree.Last(panel);
splitReorder = [ data.ChildPoints{1}; data.ChildPoints{2} ];
Tree.XData(first:last,:) = Tree.XData(splitReorder,:);
Tree.YData(first:last)   = Tree.YData(splitReorder);

leftFirst  = Tree.First(data.Parent);
rightFirst = leftFirst + length( data.ChildPoints{1} );
leftLast   = rightFirst - 1;
rightLast  = Tree.Last(data.Parent);

%
% set up left (lower) child
% -------------------------
lPanel = length( Tree.Parent ) + 1;
m = mean( Tree.YData(leftFirst:leftLast) );

Tree.Parent(lPanel)      = data.Parent;
Tree.Children(lPanel,:)  = [0, 0];
Tree.Center(lPanel,:)    = data.Centers(1,:);
Tree.HalfWidth(lPanel,:) = data.HalfWidths(1,:);
Tree.UpperBdry(lPanel,:) = Tree.UpperBdry(panel,:);
Tree.UpperBdry(lPanel,splitDim) = false;
Tree.LowerBdry(lPanel,:) = Tree.LowerBdry(panel,:);
Tree.Mean(lPanel)        = m;
Tree.First(lPanel)       = leftFirst;
Tree.Last(lPanel)        = leftLast;
Tree.Splitable(lPanel)   = true;
Tree.SplitDim(lPanel)    = 0;
Tree.UserData{lPanel}    = [];

%
% set up right (upper) child
% --------------------------
rPanel = lPanel + 1;
m = mean( Tree.YData(rightFirst:rightLast) );

Tree.Parent(rPanel)      = data.Parent;
Tree.Children(rPanel,:)  = [0, 0];
Tree.Center(rPanel,:)    = data.Centers(2,:);
Tree.HalfWidth(rPanel,:) = data.HalfWidths(2,:);
Tree.UpperBdry(rPanel,:) = Tree.UpperBdry(panel,:);
Tree.LowerBdry(rPanel,:) = Tree.LowerBdry(panel,:);
Tree.LowerBdry(rPanel,splitDim) = false;
Tree.Mean(rPanel)        = m;
Tree.First(rPanel)       = rightFirst;
Tree.Last(rPanel)        = rightLast;
Tree.Splitable(rPanel)   = true;
Tree.SplitDim(rPanel)    = 0;
Tree.UserData{rPanel}    = [];

%
% update parent panel
% -------------------
Tree.Children(panel,:) = [lPanel, rPanel];
Tree.SplitDim(panel)   = data.SplitDim;
Tree.Splitable(panel)  = false;

%
% all done, assign outputs and return
% -----------------------------------
if nargout == 1
    varargout{1} = Tree;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), Tree );
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

