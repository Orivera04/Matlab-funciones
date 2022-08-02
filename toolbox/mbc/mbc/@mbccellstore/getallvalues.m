function [keys, values] = getallvalues(obj)
%GETALLVALUES Return all data from object
%
%  [KEYS, VALUES] = GETALLVALUES(OBJ) returns all of the keys and data
%  stored in the object. VALUES is returned as a cell array of the data
%  stored.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:43:55 $ 

[keys, values] = getallvalues(obj.mbcstore);
if isempty(values)
    values = {};
end