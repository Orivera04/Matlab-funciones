function obj = delchild(obj, chindex)
%DELCHILD Notify parent of child deletion
%
%  OBJ = DELCHILD(OBJ, CHINDEX) is called when the child at chindex is
%  deleted.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:23 $ 

% Remove size lock from the table
pTable = obj.Tables(chindex);
pTable.info = pTable.removesizelock(obj.ObjectKey);

% Remove the table information in tradeoff
obj.Tables(chindex) = [];
obj.FillExpressions(chindex) = [];
obj.FillMaskExpressions(chindex) = [];

% If this is the last table being removed, destroy links from saved data
% points to table cells
if isempty(obj.Tables)
    obj.DataKeyTable = setNewTableSize(obj.DataKeyTable, []);
end

% Update heap copy of node
xregpointer(obj);
