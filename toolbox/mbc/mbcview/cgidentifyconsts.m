function consts = cgidentifyconsts(tableptr,featureptr)
%CGIDENTIFYCONSTS Identifies inputs to the feature which are not inputs to the table.
%
% consts = cgidentifyconsts(tableptr, featureptr)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $

tinports = tableptr.getinports;
finports = featureptr.getinports;
modelptr = featureptr.get('model');
if ~isempty(modelptr)
    finports = [finports modelptr.getinports];
    finports = unique(finports);
end

n = length(tinports);
for i=1:n
    % if we have symvalues, the inputs to these are not
    % consts.  Add them to the list of table inports.
    if tinports(i).issymvalue
        tinports = [tinports tinports(i).getvariable];
    end
end

tinports = unique(tinports);
consts = setdiff(finports, tinports);


