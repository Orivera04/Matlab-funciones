function out = fieldnames(obj, flag)
%FIELDNAMES Get image acquisition object property names.
%
%    NAMES = FIELDNAMES(OBJ) returns a cell array of strings containing 
%    the names of the properties associated with image acquisition object, OBJ.
%    OBJ can be an array of image acquisition objects of the same type.
%
%    See also VIDEOINPUT, IMAQDEVICE/GET.

%    CP 8-24-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:50 $

if ~isa(obj, 'imaqchild')
    errID = 'imaq:fieldnames:invalidType';
    error(imaqgate('privateMsgLookup', errID));
end

% Error if invalid.
if ~all(isvalid(obj)),
    errID = 'imaq:fieldnames:invalidOBJ';
    error(imaqgate('privateMsgLookup', errID));
end

try
    out = fieldnames(get(obj));
catch
    errID = 'imaq:fieldnames:mixedArray';
    error(imaqgate('privateMsgLookup', errID));
end
