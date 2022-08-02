function [optim, ok] = gui_initselsolution(optim)
%GUI_INITSELSOLUTION GUI to initialise selected solution
%
%  [OPTIM, OK] = GUI_INITSELSOLUTION(OPTIM)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:38 $ 

sz = getsolutionsize(optim);
if all(sz>0)
    [optim.outputSelection, ok] = editInitSol(optim.outputSelection, sz(3), sz(1));
else
    ok = 0;
end