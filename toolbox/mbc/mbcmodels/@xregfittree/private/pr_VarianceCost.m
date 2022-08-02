function cost = pr_VarianceCost( Tree, panel )
%PR_VARIANCECOST Compute the variance cost for a panel
%  PR_VARIANCECOST(TREE,PANEL) 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

f = Tree.First(panel);
l = Tree.Last(panel);
cost = sum( (Tree.YData(f:l) - Tree.Mean(panel)).^2 )/(l - f + 1);

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

