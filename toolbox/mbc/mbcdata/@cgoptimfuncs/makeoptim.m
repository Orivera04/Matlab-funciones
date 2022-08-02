function out = makeoptim(obj, idx)
%MAKEOPTIM Construct optimization object
%
%  OPTIMOBJ = MAKEOPTIM(OBJ, IDX) constructs a cgoptim object for the
%  optimization function at index IDX in the current list.  If IDX is
%  omitted a cell array containing optimization objects for each function
%  will be returned.
%
%  Functions that are not found  or that have errors in them will not have
%  optimization objects constructed: in this case the return argument will
%  either be an empty matrix or a cell array that only contains the objects
%  that could be constructed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:50:59 $ 

nFuncs = length(obj.FunctionNames);
if nargin<2
    idx = 1:nFuncs;
else
    % Check index is OK
    if (numel(idx) ~= 1) || (idx > nFuncs) || (idx < 1)
        error('mbc:cgoptimfuncs:InvalidArgument', ...
            'Index must be scalar and less than or equal to the number of functions.')
    end
end

optim = cell(size(idx));
k = 1;
for n = idx(:)'
    if obj.FunctionFound(n)
        c = cgoptim(obj.FunctionNames{n});
        [c, ok, rpt] = setfunctionfile(c, obj.FunctionNames{n});
        if ok && getenabled(c)
            optim{k} = c; 
            k = k + 1;
        end
    end
end

if nargin==2
    out = optim{1};
else
    out = optim(1:k-1);
end