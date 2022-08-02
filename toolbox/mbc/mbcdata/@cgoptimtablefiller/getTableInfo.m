function [fillfacs, soltype, solind] = getTableInfo(obj, tables)
%GETTABLEINFO Return filling information for given tables
%
%  [FILLFACS, SOLTYPE, SOLIND] = GETTABLEINFO(OBJ, TABLES) returns filling
%  information for pointers in the (1-by-NTABS) pointer array, TABLES.
%  FILLTABS is a (1-by-NTABS) pointe array of quantities that will fill the
%  tables. SOLTYPE is a (1-by-NTABS) cell array describing the type of
%  solution from the optimization that will be used to fill each table.
%  Each solution type is either 'soution', 'pareto', or 'weightedsolution'.
%  For information on the SOLIND vector, type HELP CGOPTIMTABLEFILLER.
%  
%  See also CGOPTIMTABLEFILLER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:08 $

errmsg = 'Cannot find all tables in the table filler';

% Ensure that tables input is a pointer array of tables
[ok, msg] = pCheckTables(tables);
if ~ok
    error('mbc:cgoptimtablefiller:InvalidArgument', errmsg);
end

% Ensure that all the pointers can be located in the object
inds = findptrs(tables, obj.tables);
if ~all(inds)
    errmsg = 'Cannot find all tables in the table filler';
    error('mbc:cgoptimtablefiller:InvalidArgument', errmsg);
end

% If ok, return the information
fillfacs = obj.fillfactors;
soltype = obj.solutiontype;
solind = obj.solutionindex;