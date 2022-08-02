function [datakey, Exists] = getDatakeyFromTable(obj, varargin)
%GETDATAKEYFROMTABLE Return the datakey linked to a table cell
%
%  DATAKEY = GETDATAKEYFROMTABLE(OBJ, R, C) returns the datakeys that are
%  linked to the given list of table cells.
%
%  [DATAKEY, EXISTS] = GETDATAKEYFROMTABLE(...) also returns a logical
%  vector that indicates whether a datakey was found for each requested
%  table cell.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:19 $ 

[Index, Exists] = getIndexFromTable(obj, varargin{:});
datakey = uint32(zeros(size(Index)));
datakey(Exists) = getDatakeyFromIndex(obj, Index(Exists));
