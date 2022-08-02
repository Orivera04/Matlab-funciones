function constraint = getConstraint(optim,constraint_name);
% cgoptim/getConstraint
% Return a named constraint

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:12 $

ind = find(strcmp(constraint_name, optim.constraintLabels));
if isempty(ind)
    error('Invalid Constraint name');
else
    % return the requested constraint
    constraint = optim.constraints(ind);
end
