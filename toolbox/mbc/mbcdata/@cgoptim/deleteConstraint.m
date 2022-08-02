function optim = deleteConstraint(optim, ConstraintLabel);
%DELETECONSTRAINT Remove a constraint from the optimization
%
%  OPTIM = DELETECONSTRAINT(OPTIM, CONNAME) removes the constraint that
%  matches the CONNAME string.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:53:04 $

if ~optim.canaddconstraints
    error('Cannot decrease the number of constraints in this optimization');
end

index = strmatch(ConstraintLabel, optim.constraintLabels, 'exact');
if ~isempty(index)
    % Check the constraint isn't in the list of output column headers
    ptr = optim.constraints(index);
    inoutput = ismember(optim.outputColumns, ptr);
    if any(inoutput)
        optim.outputColumns = optim.outputColumns(~inoutput);
        optim.outputData = optim.outputData(:,~inoutput,:);
    end
    
    freeptr(ptr);    
    % delete the label
    optim.constraintLabels(index) = []; 
    % delete the constraint
    optim.constraints(index) = []; 
end