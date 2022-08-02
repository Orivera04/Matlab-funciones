function np = numPoints(obj)
%NUMPOINTS Get number of saved input points in tradeoff 
%
%  NP = NUMPOINTS(OBJ) returns the number of input points that have been
%  saved in the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:56 $ 

np = length(obj.DataKeyTable);
