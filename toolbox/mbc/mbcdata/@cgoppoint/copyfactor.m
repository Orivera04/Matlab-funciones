function obj = copyfactor(obj, idx)
%COPYFACTOR Duplicate columns of a dataset
%
%  OBJ = COPYFACTOR(OBJ, IDX) copies the columns specified in IDX.  The
%  duplicated columns will be marked as though they are unassigned imported
%  data.  Any grids that are present will be converted into blocks of data.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:26:00 $ 

if isa(idx, 'xregpointer')
    % Convert to an index
    idx = idx(~isnull(idx));
    idx = findptrs(idx, obj.ptrlist);
end

data = get(obj, 'data');
newdata = data(:, idx);
newnames = get(obj, idx, 'assignednames');
if ~iscell(newnames)
    newnames = {newnames};
end
% Add Copy_of_ to beginning of all names, then unique them
for n = 1:length(newnames)
    newnames{n} = ['Copy_of_' newnames{n}];
end
newnames = uniquename(obj, newnames);

% Add new columns
obj = addfactor(obj, newnames, newdata);

% Mark the new columns as imported data
nf = get(obj, 'numfactors');

obj = set(obj, ((nf-length(newnames)+1):nf), 'factor_type', 2, 'grid_flag', 7);

% Remove any grids that are hanging around
obj = convertGridToBlock(obj);
