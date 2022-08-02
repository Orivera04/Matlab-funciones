function obj = loadobj(B)
%LOADOBJ Load filter for objects.
%
%   OBJ = LOADOBJ(B) is called by LOAD when an object is 
%   loaded from a .MAT file. The return value, OBJ, is subsequently 
%   used by LOAD to populate the workspace.  
%
%   LOADOBJ will be separately invoked for each object in the .MAT file.
%
%    See also IMAQ/PRIVATE/LOAD.
%

%    CP 9-3-2002
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:50 $

obj = B;
if ~isvalid(obj)
    % Invalid objects are saved and loaded for us by MATLAB.
    return;
end

% Access the stored information.
storeField = imaqgate('privateGetfield', B, 'imaqchild');
storeField = imaqgate('privateGetfield', storeField, 'store');

% Set the parent up to use what was saved before.
parentObj = storeField{1};

% Return the necessary sources.
sources = get(parentObj, 'Source');
uddSources = imaqgate('privateGetfield', sources, 'uddobject');
obj = uddSources(storeField{2});
obj = videosource(obj);
