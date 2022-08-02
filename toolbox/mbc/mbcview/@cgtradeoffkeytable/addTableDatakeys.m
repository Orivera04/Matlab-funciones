function [obj, datakey] = addTableDatakeys(obj, varargin)
%ADDTABLEDATAKEYS Create new datakeys that are linked to table cells
%
%  [OBJ, DATAKEY] = ADDTABLEDATAKEYS(OBJ, R, C) adds new datakeys that are
%  linked to the cells indexed by the elemnts of (R, C).  R and C are
%  vectors of length N that define N new datakeys to be added.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:14 $ 

L = uint32(sub2ind(obj.TableSize, varargin{:}));
L = L(:);

% Check that none of the table links already exist
if any(ismember(L, obj.DataKeyTable(:,1)))
    error('mbc:cgtradeoffkeytable:InvalidIndex', ...
        'An existing data key is already linked to a specified table cell.');
end

% Add new keys
[obj, datakey] = addDatakeys(obj, length(L));

% Link up table indices
obj.DataKeyTable((end - length(L) + 1):end,1) = L;
