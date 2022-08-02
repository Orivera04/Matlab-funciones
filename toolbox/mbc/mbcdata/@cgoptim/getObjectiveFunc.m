function objective = getObjectiveFunc(optim,objective_name);
% cgoptim/getObjectiveFunc 
% Return a named objective

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:14 $

ind = find(strcmp(objective_name, optim.objectiveFuncLabels));
if isempty(ind)
    error('Invalid ObjectiveFunc name');
else
    % return the requested objective
    objective = optim.objectiveFuncs(ind);
end
