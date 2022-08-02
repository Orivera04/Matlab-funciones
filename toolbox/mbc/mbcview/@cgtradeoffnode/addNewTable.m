function [obj, pTable, OK] = addNewTable(obj, sName, DefValue)
%ADDNEWTABLE Create a new table and add to the tradeoff
%
%  [OBJ, PTABLE, OK] = ADDNEWTABLE(OBJ, NAME) creates a new table and adds
%  it to the tradeoff session.  PTABLE is the pointer to the new table.  OK
%  indicates whether a new table was successfully created: if OK is false
%  then PTABLE will be a null pointer.
%
%  [OBJ, PTABLE, OK] = ADDNEWTABLE(OBJ, NAME, DEFVALUE) specifies a value
%  to intialise the table with.  If not specified, the table will contain
%  zeros.
%  
%  It is not possible to create a new table when the tradeoff is empty (no
%  tables have yet been added) so in this case OK will always be false.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:07 $ 

if numTables(obj)==0
    pTable = null(xregpointer);
    OK = false;
    return
end

if nargin<3
    DefValue = 0;
end

% Create new table that has same normalizers as current tables and is the
% same size
tbl_current = obj.Tables(1).info;
pTable = cglookuptwo(sName, DefValue.*ones(getTableSize(tbl_current)), ...
    get(tbl_current, 'x'), get(tbl_current, 'y'));

[obj, OK] = addTable(obj, pTable, true);
if ~OK
    % Destroy table and return a null pointer
    freeptr(pTable);
    pTable = xregpointer;
else
    % Add table to project as well
    addtoproject(obj, pTable); 
end
