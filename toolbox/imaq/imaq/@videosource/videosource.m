function obj = videosource(arginput)
%VIDEOSOURCE Construct a video source object.
%
%    Video source objects are automatically created when
%    a video input object is created using VIDEOINPUT.
%
%    This function is not intended to be used directly
%    by the user.
%
%    See also IMAQHELP, VIDEOINPUT.
%

%    CP 1-26-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:54 $

% Require only one input.
errID = 'imaq:videosource:invalidSyntax';
if (nargin~=1),
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Initialize MATLAB OOPs class info.
className = 'videosource';
parentClassName = 'imaqchild';
obj.type = className;
obj.version = imaqmex;

% Create our object.
parent = imaqchild(parentClassName);
if iscell(arginput) && ~isempty(arginput),
    % IMAQMEX is providing us a cell array of UDD objects.
    % Convert to a [] vector, create OOPS object, and return.
    obj.uddobject = [arginput{:}];
    obj.type = localCreateTypeNameCell(obj);
    obj = class(obj, className, parent);
    
elseif strcmp(class(arginput),'handle') || ...
    ~isempty(strfind( class(arginput), 'imaq.') ),
    % SUBSREF needs us to cast a UDD handle to an OOPs object.
    % Store the UDD object and create a new MATLAB object.
    %
    % This is also used by LOADOBJ to recreate objects.
    obj.uddobject = arginput;
    obj.type = localCreateTypeNameCell(obj);
    obj = class(obj, className, parent);
    
elseif strcmp(class(arginput), className),
    % Return the object as is.
    obj = arginput;
    
elseif isstruct(arginput) && isfield(arginput, parentClassName) && ...
        isa(arginput.imaqchild, parentClassName),
    % We were provided a previously constructed video source structure.
    %
    % Note: Since MATLAB adds a field for the parent when
    %       creating a new object with CLASS, we first need 
    %       to remove the existing dummy parent object.
    arginput = rmfield(arginput, parentClassName);
    obj = class(arginput, className, parent);
    
else
    % Invalid call.
    errID = 'imaq:videosource:invalidSyntax';
    error(errID, imaqgate('privateMsgLookup',errID));
end

%%%%%%%%%%%%%%%%%%%%%%%%%
function typeList = localCreateTypeNameCell(obj)
% Creates a cell array of class names equal to the length object handles.

typeList = cell(1, length(obj.uddobject));
if length(typeList)>0,
    % DEAL errors when 0 video sources are provided.
    [typeList{:}] = deal(obj.type);
end
