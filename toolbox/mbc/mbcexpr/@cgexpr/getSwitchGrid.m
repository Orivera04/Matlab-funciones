function gridOK = getSwitchGrid(m, pGrid)
%GETSWITCHGRID Generate a logical grid of valid sites 
%
%  GRID = GETSWITCHGRID(M, PGRID) returns a logical grid of true/false
%  values corresponding to every combination of input settings specified by
%  the gridded inports, PGRID, for the expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:08:42 $ 

gridOK = evaluategrid(m , pGrid, 'custom', @isSwitchPoint);
