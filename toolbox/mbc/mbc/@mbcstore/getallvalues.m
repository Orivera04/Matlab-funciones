function [keys, values] = getallvalues(obj)
%GETALLVALUES Return all data from object
%
%  [KEYS, VALUES] = GETALLVALUES(OBJ) returns all of the keys and data
%  stored in the object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:26 $ 

keys = obj.KeyList;
values = obj.DataList;