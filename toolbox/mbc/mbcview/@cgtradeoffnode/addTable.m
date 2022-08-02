function [obj, OK] = addTable(obj, pTable, omitCheck)
%ADDTABLE A short description of the function
%
%  [NODE, OK] = ADDTABLE(NODE, PTABLE) adds a table to be traded off.  The
%  operation will first be checked to make sure the table conforms with all
%  of the tradeoff requirements.  If not, the node is unmodified and this
%  function returns with OK = false;
%
%  [NODE, OK] = ADDTABLE(NODE, PTABLE, OMITCHECK) allows specification of
%  whether the table should be checked.  These checks should only be
%  skipped if you are 100% sure that the table conforms with the
%  requirements, for example if you have already called the CANADDTABLE
%  method on it.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:08 $ 

% Prevent table from being added more than once
if any(obj.Tables==pTable)
    OK = false;
    return
end

if nargin<3
    omitCheck = false;
end

if ~omitCheck
    OK = canAddTable(obj, pTable);
else
    OK = true;
end
if ~OK
    return
end

% Add a size lock to the table
pTable.info = pTable.addsizelock(obj.ObjectKey);

obj.Tables = [obj.Tables, pTable];
obj.FillExpressions = [obj.FillExpressions, xregpointer];
obj.FillMaskExpressions = [obj.FillMaskExpressions, xregpointer];

% If this is the first table, initialise the table size in the key table
if length(obj.Tables)==1
    obj.DataKeyTable = setNewTableSize(obj.DataKeyTable, pTable.getTableSize);
end

% Update heap copy of node
xregpointer(obj);

% Generate sub-node for table
tblnd = cgnode(pTable.info, address(obj), pTable, 1);
obj = AddChild(obj, tblnd);
