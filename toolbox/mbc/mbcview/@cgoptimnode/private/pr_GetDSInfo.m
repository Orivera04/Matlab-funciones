function vals = pr_GetDSInfo(pOpt)
%PR_GETDSINFO
%
%   Private method to get all the information for all the data sets 
%   in the Data Set list

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.8.2 $    $Date: 2004/02/09 08:27:35 $

datasets = get(pOpt.info, 'oppoints');

vals = cell(length(datasets),3);
for n =1:length(datasets)
    if n==1
        vals{n,2} = 'Primary';
    else
        vals{n,2} = 'Helper';
    end
    if isvalid(datasets(n))
        Op = datasets(n).info;
        facs = get(Op, 'factors');
        DSStr = [getname(Op), '(', sprintf('%s, ', facs{:})];
        DSStr(end-1) = ')';
        vals{n,1} = DSStr(1:end-1);
        vals{n,3} = '';
    else
        vals{n,1} = '';
        vals{n,3} = 'Please select a data set';    
    end
end