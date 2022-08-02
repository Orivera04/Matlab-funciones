function obj = cgtradeoffkeytable
%CGTRADEOFFKEYTABLE Construct a new cgtradeoffkeytable object
%
%  OBJ = CGTRADEOFFKEYTABLE constructs an empty tradeoff key table obejct.
%  This object is used internally by tradeoff to manage a list of ID keys
%  that link together saved data and table cells.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:15 $ 

% The DataKeyTable holds an (n-by-3) array of numbers.  Column 1 is a key
% that is formed by constructing the linear index of a table cell.  This
% column may have zeros for entries that do not have a corresponding table
% cell.  Column 2 contains unique numbers that are used as keys when saving
% data in variable stores.  Column 3 contains a counter that is
% incremented every time tradeoff saves inputs agains that data key.

s = struct('DataKeyTable', uint32(zeros(0, 3)), ...
    'NextDataKeyNumber', 1, ...
    'TableSize', []);
obj = class(s, 'cgtradeoffkeytable');
