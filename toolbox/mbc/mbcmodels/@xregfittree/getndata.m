function n = getndata( Tree, panel )
%XREGFITTREE/GETNDATA Get the number of data points inside a given panel
%  GETNDATA(T,PANEL) returns the number of data points that are in the given 
%  PANEL. 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

n = Tree.Last(panel) - Tree.First(panel) + 1;

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

