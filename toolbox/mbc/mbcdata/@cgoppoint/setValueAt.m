function obj = setValueAt(obj, R, C, Value)
%SETVALUEAT Set a single value in the dataset
%
%  OBJ = SETVALUEAT(OBJ, R, C, VALUE) sets the value of the point (R, C) in
%  the dataset to be Value.  The dataset is updated and re-evaluated to
%  reflect the alteration.  If the value at (R, C) is not editable, the
%  dataset will be unchanged.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:26:01 $ 

overwrite = get(obj, 'iseditable');
if ~overwrite(C)
    return
end

data = get(obj, 'data');
new_row = data(R, :);
new_row(:, C) = Value;

% Use a single-row version of the dataset to evaluate the new value
tempObj = set(obj, 'data', new_row);
tempObj = eval_fill(tempObj);
data(R, :) = get(tempObj, 'data');

obj = set(obj, 'data', data);
obj = set(obj, C, 'grid_flag', 7);

% Record an original name so we can unassign this data block from its
% original variable (i.e. treat as if imported data)
myname = get(obj, 'factors');
obj = set(obj, C, 'orig_name', myname(C));
obj = set(obj, C, 'created_flag', 0);

% See if we need to update other members of the group to reflect the change
obj = SetGroupDependants(obj, C);

% Convert any remaining grid into a block of data
obj = convertGridToBlock(obj);
