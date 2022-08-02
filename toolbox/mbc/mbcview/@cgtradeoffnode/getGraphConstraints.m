function bConStatus = getGraphConstraints(obj)
%GETGRAPHCONSTRAINTS Return setting of constraints display on graphs
%
%  GETGRAPHCONSTRAINTS(OBJ) returns true if the display of  constraints on
%  graphs is turned on for this object, false otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:30 $ 

bConStatus = obj.GraphDisplayConstraints;
