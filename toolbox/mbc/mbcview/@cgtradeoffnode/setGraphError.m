function obj = setGraphError(obj, bGEStatus)
%SETGRAPHERROR Enable/Disable display of error on graphs
%
%  OBJ = SETGRAPHERROR(OBJ, DISPERRROR) where DISPERROR is a boolean
%  true/false flag, sets the display of error lines on graphs on or off.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:40 $ 

obj.GraphDisplayError = bGEStatus;

% Update heap copy
xregpointer(obj);