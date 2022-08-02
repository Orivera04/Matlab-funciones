function closepreview(obj)
%CLOSEPREVIEW Close image preview window.
% 
%    CLOSEPREVIEW(OBJ) closes the image preview window associated with 
%    the video input object OBJ.
% 
%    CLOSEPREVIEW closes all image preview windows for all image 
%    acquisition objects.
% 
%    See also IMAQHELP, IMAQDEVICE/PREVIEW.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:04 $

% Error checking.
if ~isa(obj, 'imaqdevice'),
    errID = 'imaq:closepreview:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~all(isvalid(obj)),
    errID = 'imaq:closepreview:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Close preview window.
closepreview(imaqgate('privateGetField', obj, 'uddobject'));