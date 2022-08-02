function bYStatus = getGraphSameY(obj)
%GETGRAPHSAMEY Return setting of common Y-axis display on graphs
%
%  USESAMEY = GETGRAPHSAMEY(OBJ) returns true if the usage of a common
%  Y-axis on graphs is turned on for this object, false otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:32 $ 

bYStatus = obj.GraphDisplaySameY;
