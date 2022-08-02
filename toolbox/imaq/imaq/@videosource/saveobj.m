function obj = saveobj(B)
%SAVEOBJ Save filter for objects.
%
%    B = SAVEOBJ(A) is called by SAVE when an object is saved to a .MAT
%    file. The return value B is subsequently used by SAVE to populate the
%    .MAT file.  SAVEOBJ can be used to convert an object that maintains 
%    information outside the object array into saveable form (so that a
%    subsequent LOADOBJ call can recreate it).
%
%    SAVEOBJ will be separately invoked for each object to be saved.
%
%    SAVEOBJ can be overloaded only for user objects.  SAVE will not call
%    SAVEOBJ for a built-in datatype (such as double) even if @double/saveobj
%    exists.
%
%    See also IMAQ/PRIVATE/SAVE.
%

%    CP 9-3-2001
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:51 $

% Get the field we will use to store stuff.
obj = B;
if ~isvalid(obj)
    % Invalid objects are saved and loaded for us by MATLAB.
    return;
end
uddchildren = imaqgate('privateGetfield', obj, 'uddobject');

% Determine the indices of the parent's sources we need to return upon
% loading.
parent = get(uddchildren(1), 'Parent');
allSources = get(parent, 'Source');
srcIndex = (B==allSources);

% Save the parent.
parentinfo = saveobj(parent);

% Store the information we need to do the recreation.
storeField = imaqgate('privateGetfield', obj, 'imaqchild');
storeField = isetfield(storeField, 'store', {parentinfo, srcIndex});
obj = isetfield(obj, 'imaqchild', storeField);

% Clear out the UDD objects.
obj = isetfield(obj, 'uddobject', []);
