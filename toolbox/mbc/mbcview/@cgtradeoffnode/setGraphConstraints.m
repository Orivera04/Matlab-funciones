function obj = setGraphConstraints(obj, bConStatus)
%SETGRAPHCONSTRAINTS Enable/disable display of constraints on graphs
%
%  OBJ = SETGRAPHCONSTRAINTS(OBJ, DISPCONSTRAINTS) where DISPCONSTRAINTS is
%  a boolean true/false flag, sets the display of constraints on graphs on
%  or off.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:39 $ 

obj.GraphDisplayConstraints = bConStatus;

% Update heap copy
xregpointer(obj);
