function str = pFreeVarString(d, pOptim)
%PFREEVARSTRING Generate cell array of free variable settings
%
%  STRCELL = PFREEVARSTRING(VIEWDATA, POPTIM) creates a cell array
%  containing the values of free variables at the currently selected point.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:27:50 $ 

setsolutionvalues(pOptim.info, d.CurrentSolution, d.CurrentOpPoint);
pFreeVar = get(pOptim.info, 'values');
cValues = pveceval(pFreeVar, 'getvalue');
sNames = pveceval(pFreeVar, 'getname');
cValues = cellstr(mbcnum2str([cValues{:}]));

str = [sNames(:), cValues(:)];