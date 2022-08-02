function pT = getTable(obj, idx)
%GETTABLE Return specified table from tradeoff
%
%  TBL = GETTABLE(OBJ, INDEX) returns the table at the speicifed INDEX in
%  the tradeoff.  INDEX must be between 1 and numTables(obj).  pT is a
%  pointer to a table.
%  TBL = GETTABLE(OBJ, 'all') returns a pointer vector containing pointers
%  to all of the tables in the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:37 $

if ischar(idx)
    if strcmp(idx, 'all')
        pT = obj.Tables;
    else
        error('mbc:cgtradeoffnode:InvalidIndex', ...
            'Specify ''all'' to get all the tables or a numeric index for a specific table.');
    end
else
    if idx>=1 && idx <=numTables(obj)
        pT = obj.Tables(idx);
    else
        error('mbc:cgtradeoffnode:InvalidIndex', ...
            'Table index must be between 1 and numTables(obj).');
    end
end
