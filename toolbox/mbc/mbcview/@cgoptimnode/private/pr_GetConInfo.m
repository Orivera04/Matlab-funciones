function vals = pr_GetConInfo(pOpt)
%PR_GETCONINFO
%
%  Private method to get all the information for all constraints
%  in the Constraint list

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.8.2 $    $Date: 2004/02/09 08:27:34 $

confuncs = get(pOpt.info, 'constraints');

vals = cell(length(confuncs),2);
for n =1:length(confuncs)
    thisfunc = confuncs(n).info;
    vals{n,1} = tostring(thisfunc);
    
    % Constraint status (i.e. selected or not)
    if ~isempty(vals{n,1})
        vals{n,2} = '';
    else
        vals{n,2} = 'Please select a constraint';        
    end 
end