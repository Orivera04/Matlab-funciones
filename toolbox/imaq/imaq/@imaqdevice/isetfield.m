function obj = isetfield(obj, field, value)
%ISETFIELD Set image acquisition object internal fields.
%
%    OBJ = ISETFIELD(OBJ, FIELD, VAL) sets the value of OBJ's FIELD 
%    to VAL.
%
%    This function is a helper function for the concatenation and
%    manipulation of image acquisition object arrays. This function should
%    not be used directly by users.
%
%    See also VIDEOINPUT.

%    CP 9-3-2002
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:23 $

% Assign the specified field information.
try
    obj.(field) = value;
catch
    errID = 'imaq:isetfield:invalidField';
    error(errID, [privateMsgLookup(errID) field]);
end
