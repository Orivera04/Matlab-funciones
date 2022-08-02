function obj = setGraphSameY(obj, bYStatus)
%SETGRAPHSAMEY Enable/disable use of common Y-axis on graphs
%
%  OBJ = SETGRAPHSAMEY(OBJ, USESAMEY) where USESAMEY is a boolean
%  true/false flag, sets the usage of a common Y-axis on graphs on or off.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:41 $ 

obj.GraphDisplaySameY = bYStatus;

% Update heap copy
xregpointer(obj);
