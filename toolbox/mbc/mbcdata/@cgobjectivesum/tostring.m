function ModStr = tostring(OS)
%---------------------------------------------------------------

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 06:50:47 $

% Get the model pointer from the objective function
pMod = get(OS,'modptr');

pOp = OS.oppoint;
if ~isempty(pMod)
    % Form equation string 
    ModStr = ['Weighted sum of ' pMod.getname,' over ',pOp.getname];
else
    ModStr = '';
end





