function data = getdata(op, name)
% CGOPPOINT/GETDATA Get the data corresponding to a factor
%
% data = GETDATA(op, factor_name)
% factor_name is a string or a cell array of strings

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 06:51:49 $

if ~(ischar(name) | iscell(name))
    error('CGOPPOINT/GETDATA: Required factor must be specified as a string, or cell array of strings');
    return;
end
if iscell(name)
    inds = [];
    for i =1 :length(name)
        if ~(ischar(name{i}))
            error('CGOPPOINT/GETDATA: Required factor must be specified as a string, or cell array of strings');
            return
        end
        inds = [inds findname(op, name{i})];
    end
else
    inds = findname(op, name);
end
if isempty(inds)
    error('CGOPPOINT/GETDATA: Cannot find required factor in the dataset');
    return;
end
data = op.data(:, inds);
