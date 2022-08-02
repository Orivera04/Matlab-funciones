function obj = setTableInfo(obj, tables, fillfacs, soltype, solind)
%SETTABLEINFO Set filling information for given tables
%
%  OBJ = SETTABLEINFO(OBJ, TABLES, FILLFACS, SOLTYPE, SOLIND) sets filling
%  information for tables in the pointer array, TABLES. TABLES must be a
%  row vector of table pointers that are a subset of those table pointers
%  in OBJ. FILLFACS must be a 1-by-len(TABLES) pointer array of fill
%  factors. SOLTYPE must be a 1-by-len(TABLES) cell array of strings, each
%  string being either 'solution', 'pareto' or 'weightedpareto'. SOLIND
%  must be a 1-by-len(TABLES) double array of integers.
%  
%  See also CGOPTIMTABLEFILLER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:37 $

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

% Ensure that the user has supplied sensible information for the table
% filling object
[ok, msg] = pCheckTableLinks(tables, fillfacs, soltype, solind);
if ~ok
    error('mbc:cgoptimtablefiller:InvalidArgument', errmsg);
end

% If ok, set the information for the tables
obj.fillfactors(inds) = fillfacs;
obj.solutiontype(inds) = soltype;
obj.solutionindex(inds) = solind;