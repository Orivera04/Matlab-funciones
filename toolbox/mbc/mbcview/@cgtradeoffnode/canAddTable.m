function OK = canAddTable(obj, pTable)
%CANADDTABLE Check whether table can be added to tradeoff
%
%  OK = CANADDTABLE(NODE, PTABLE) returns true if the table PTABLE can be
%  added to the tradeoff.  All tables in a tradeoff must be fed by the same
%  normalizers and have a single inport going into each normalizer.  PTABLE
%  can be an array of pointers to tables, in which case the return is still
%  a scalar logical indicating whether all of the tables can be added to
%  the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:13 $ 

OK = false;
if isempty(obj.Tables)
    % Check first table has two inports, one on each axis.
    tbl = info(pTable(1));
    if getNumAxes(tbl)==2 && hasinportperaxis(tbl)
        OK = true;
    end
    if OK && length(pTable)>1
        % Check that rest of tables match up against the first
        OK = i_checkcompatibility(tbl, pTable(2:end));
    end
else
    % Check that inputs to the new tables match those of the current tables
    % and the size matches the size of the current tables
    tbl = obj.Tables(1).info;
    OK = i_checkcompatibility(tbl, pTable);
end



function OK = i_checkcompatibility(tblBase, pToCheck)
tblToCheck = infoarray(pToCheck);
OK = true;
NToCheck = numel(pToCheck);
n = 1;
while (n<=NToCheck) && OK
    if getNumAxes(tblBase)~=getNumAxes(tblToCheck{n}) ...
            || all(getTableSize(tblBase)~=getTableSize(tblToCheck{n})) ...
            || all(getinputs(tblBase)~=getinputs(tblToCheck{n}))
        OK = false;
    end
    n = n+1;
end
