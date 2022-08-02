function out = privateGetField(obj, field)
%PRIVATEGETFIELD Get image acquisition object internal fields.
%
%    VAL = PRIVATEGETFIELD(OBJ, FIELD) returns the value of object's, OBJ,
%    FIELD to VAL.
%
%    This function is a helper function used to access image acquisition 
%    object fields. This function should not be used directly by users.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:14 $

% Convert object to structure so we can access its fields.
objStruct = struct(obj);

% Return the specified field information.
if isfield(objStruct, field),
    out = objStruct.(field);
else
    errID = 'imaq:privateGetField:invalidField';
    error(errID, [privateMsgLookup(errID) field]);
end
