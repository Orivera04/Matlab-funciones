function bGEStatus = getGraphError(obj)
%GETGRAPHERROR Return setting of error display on graphs
%
%  DISPERROR = GETGRAPHERROR(OBJ) returns true if the display of errors on
%  graphs is turned on for this object, false otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:31 $ 

bGEStatus = obj.GraphDisplayError;