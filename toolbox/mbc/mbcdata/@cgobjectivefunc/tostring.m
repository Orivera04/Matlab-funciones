function ModStr = tostring(OF)
%---------------------------------------------------------------

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.8.2 $    $Date: 2004/02/09 06:50:34 $

% Get the model pointer from the objective function
pMod = OF.modptr;

if ~isempty(pMod)
    % Get the input list
    pInps = getinputs(pMod.info);
    
    % Form input string 
    inpNames = [];
    for i = 1:length(pInps)
        inpNames = [inpNames, pInps(i).getname, ', '];
    end
    inpNames = inpNames(1:end-2);
    
    % Form equation string 
    ModStr = [pMod.getname, '(', inpNames, ')'];
else
    ModStr = '';
end





