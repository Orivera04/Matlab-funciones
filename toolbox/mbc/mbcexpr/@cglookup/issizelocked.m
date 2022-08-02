function bLocked = issizelocked(LU, guids)
%ISSIZELOCKED Check whether a table's size is locked
%
%  LOCKED = ISSIZELOCKED(OBJ, GUIDS) returns true if the table's size
%  cannot be unlocked by the keys in the guidarray GUIDS.
%
%  LOCKED = ISSIZELOCKED(OBJ) returns true if the table has been locked by
%  anyone.  This is equivalent to specifying an empty GUIDS vector.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:24 $ 

if nargin<2
    guids = guidarray(0);
end

if isempty(LU.sizelocks)
    bLocked = false;
elseif isempty(guids)
    bLocked = true;
else
    % Check all sizelocks ahve an index in guids
    bLocked = any(getIndices(guids, LU.sizelocks) == 0);
end