function src = getselectedsource(obj)
%GETSELECTEDSOURCE Return the current selected video source object.
% 
%    SRC = GETSELECTEDSOURCE(OBJ) searches OBJ's Source property 
%    and returns a video source object, SRC, that has a 
%    Selected property value of 'on'.
%
%    OBJ must be a 1x1 video input object.
%
%    See also VIDEOINPUT, IMAQHELP, IMAQDEVICE/GET.
%

%    CP 9-05-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:15 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:getselectedsource:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif (length(obj) > 1)
    errID = 'imaq:getselectedsource:OBJ1x1';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~isvalid(obj)
    errID = 'imaq:getselectedsource:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Locate and return the selected source object.
sources = get(obj, 'Source');
selectedVals = get(sources, 'Selected');
src = sources(strcmp('on', selectedVals));
