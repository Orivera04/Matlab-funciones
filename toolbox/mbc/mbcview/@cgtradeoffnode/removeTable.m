function [obj, numRemoved] = removeTable(obj, pTable)
%REMOVETABLE Remove a table from the tradeoff
%
%  [NODE, NDELETED] = REMOVETABLE(NODE, PTABLE) removes the specified
%  tables from the tradeoff.  If any of the tables are not in the tradeoff
%  they will be stepped over silently.  NDELETED gives the number of table
%  nodes that have been removed from the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:37 $ 

% Remove the child node associated with this table.  This will remove
% the table from the tradeoff's list of tables too
p_child = getTableNodes(obj);
pTablesFromNodes = pveceval(p_child, @getdata);
numRemoved = 0;
for n = 1:length(p_child)
    if any(pTablesFromNodes{n}==pTable)
        delete(info(p_child(n)));
        numRemoved = numRemoved + 1;
    end
end
obj = info(address(obj));
