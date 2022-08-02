function vals = pr_GetObjInfo(pOpt)
%PR_GETOBJINFO
%
%  Private method to get all the information for all objectives 
%  in the Objective list

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.8.2 $    $Date: 2004/02/09 08:27:36 $

objfuncs = get(pOpt.info, 'objectiveFuncs');

vals = cell(length(objfuncs),3);
for n =1:length(objfuncs)
    thisfunc = objfuncs(n).info;
    vals{n,1} = tostring(thisfunc);
    
    % Type of optimisation (i.e. max/min)
    typevec = get(thisfunc, 'minstr');
    switch typevec
        case 'min'
            vals{n,2} = 'Minimize';
        case 'max'
            vals{n,2} = 'Maximize';
        case {'helper', 'neither'}
            vals{n,2} = 'Helper';
        otherwise
            vals{n,2} = '';
    end
    
    % Model status (i.e. selected or not)
    if ~isempty(vals{n,1})
        vals{n,3} = '';
    else
        vals{n,3} = 'Please select a model';        
    end 
end