function optim = deleteObjectiveFunc(optim, ObjectiveFuncLabel)
%DELETEOBJECTIVEFUNC Remove an objective from the optimization
% 
%  OPTIM = DELETEOBJECTIVEFUNC(OPTIM, LABEL) removes the specified
%  objective from the optimization.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/04/04 03:26:07 $

if ~optim.canaddobjectiveFuncs
    error('Cannot decrease the number of operating point sets in this optimization');
end

if ~ischar(ObjectiveFuncLabel)
    error('ObjectiveFuncLabel must be a string');
end   

index = strmatch(ObjectiveFuncLabel, optim.objectiveFuncLabels, 'exact');
if ~isempty(index)
    % If the objective is in the list of output column headers, then remove
    % it and the associated output data
    ptr = optim.objectiveFuncs(index);
    inoutput = ismember(optim.outputColumns, ptr);
    if any(inoutput)
        optim.outputColumns = optim.outputColumns(~inoutput);
        optim.outputData = optim.outputData(:,~inoutput,:);
    end

    % Free the memory associated with this objective function
    freeptr(ptr);
           
    % Delete the last label
    optim.objectiveFuncLabels(end) = []; 
    % Delete the objective
    optim.objectiveFuncs(index) = []; 
end