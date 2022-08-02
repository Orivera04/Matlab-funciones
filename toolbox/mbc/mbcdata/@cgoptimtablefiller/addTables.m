function obj = addTables(obj, tables, fillfacs, soltypes, solinds)
%ADDTABLES Set up tables to be filled by the optimization results
%
%  ADDTABLES(OBJ, TABLES, FILLFACS, SOLTYPES, SOLINDS) adds the tables in
%  the pointer array, TABLES, to the optimization table filler object, OBJ,
%  for filling. The filling item for each table is given in the pointer
%  array FILLFACS, which must have the same dimension as TABLES. The
%  solution type and solution index are specified through SOLTYPES and
%  SOLINDS respectively. Again, these quantities must have the same
%  dimension as TABLES. 
%
%  See also CGOPTIMTABLEFILLER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:05 $

% Ensure that tables input is a pointer array of tables
[ok, msg] = pCheckTables(tables);
if ~ok
    error('mbc:cgoptimtablefiller:InvalidArgument', msg);
end

% Ensure that the table links are consistent
[ok, msg] = pCheckTableLinks(tables, fillfacs, soltypes, solinds);
if ~ok
    error('mbc:cgoptimtablefiller:InvalidArgument', msg);
end

% If here, we can add the new tables to the table filler object
if size(tables, 1) > 1
    tables = tables';
    fillfacs = fillfacs';
    soltypes = soltypes';
    solinds = solinds';
end
obj.tables = [obj.tables, tables];
obj.fillfactors = [obj.fillfactors, fillfacs];
obj.solutiontype = [obj.solutiontype, soltypes];
obj.solutionindex = [obj.solutionindex, solinds];



