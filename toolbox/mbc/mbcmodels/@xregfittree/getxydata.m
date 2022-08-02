function [xdata, ydata] = getxydata( Tree, panel )
%XREGFITTREE/GETXYDATA Get the data points inside a given panel
%  [X,Y] = GETXYDATA(T,PANEL) returns the data points that are in the given 
%  PANEL. 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

f = Tree.First(panel);
l = Tree.Last(panel);
xdata = Tree.XData(f:l,:);
ydata = Tree.YData(f:l,:);

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

