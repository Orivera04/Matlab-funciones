function [OK,msg] = cgchecktableinputs(tableptr,featureptr)
%CGCHECKTABLEINPUTS Checks for problems with inputs to a table in a feature.
% [OK,msg] = cgchecktableinputs(tableptr,featureptr)
% If the inputs to the table, the feature, and the feature's model are such
% that it will be possible to plot both the feature and the model over the
% range of the inputs to the table, then OK is non-zero, and msg is empty.
% Otherwise, OK is zero, and msg contains a string describing the problem.
% Possible problems are:
%   No model is associated with the feature.
%   One of the table variables does not appear in the model.
%   The table and the model have too many variables in common.
%   The inputs to the table are not independent.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $

OK = 0;

tinports = tableptr.getinports;
finports = featureptr.getinports;

modelptr = featureptr.get('model');
if isempty(modelptr)
    msg = 'No model is associated with this feature';
    return;
end
minports = modelptr.getinports;

for i=1:length(tinports)
    if cgisindependentvars(tinports(i),minports);
        msg = ['Table variable ' tinports(i).getname 'does not appear in the model'];
        return;
    end
end

dep = cgisindependentvars(minports,tinports);
if sum(~dep)>length(tinports)
    if length(tinports)==1
        msg = 'The model and the table have more than one variable in common.';
    else
        msg = ['The model and the table have more than '...
                num2str(length(tinports)) ' variables in common.'];
    end
    return;
end

if length(tinports)>1
    if ~cgisindependentvars(tinports(1),tinports(2))
        msg = 'The variables feeding into this table are not independent';
        return;
    end
end

OK = 1;
msg = [];

