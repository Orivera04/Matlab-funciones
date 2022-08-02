function optim = deleteOppoint(optim, OppointLabel);
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:53:06 $

% Delete an input operating point set from the optimization 
% optim = deleteOppoint(optim, OppointLabel); deletes the Oppoint labelled OppointLabel

if ~optim.canaddoppoints
    error('Cannot decrease the number of operating point sets in this optimization');
end


if ~isstr(OppointLabel)
    error('OppointLabel must be a string');
end

index = strmatch(OppointLabel, optim.oppointLabels, 'exact');
if ~isempty(index)
    
    % delete the label
    optim.oppointLabels(index) = []; 
    % delete the oppoint value labels
    optim.oppointValueLabels(index) = [];
    % delete the constraint
    optim.oppoints(index) = []; 
end


