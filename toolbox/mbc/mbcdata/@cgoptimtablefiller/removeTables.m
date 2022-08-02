function obj = removeTables(obj, tables)
%REMOVETABLES Remove tables to be filled by the optimization results
%
%  REMOVETABLES(OBJ, TABLES) removes the tables in the pointer array,
%  TABLES, from the optimization table filler object, OBJ, for filling. 
%
%  See also CGOPTIMTABLEFILLER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:36 $

% Ensure that tables input is a pointer array of tables
[ok, msg] = pCheckTables(tables);
if ~ok
    error('mbc:cgoptimtablefiller:InvalidArgument', msg);
end

% Locate the table pointers in the optimization table filler object
inds = findptrs(tables, obj.tables);
inds = setdiff(inds, 0);

% Remove the tables
obj.tables(inds) = [];
obj.fillfactors(inds) = [];
obj.solutiontype(inds) = [];
obj.solutionindex(inds) = [];
