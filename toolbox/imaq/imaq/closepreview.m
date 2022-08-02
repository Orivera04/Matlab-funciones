function closepreview(in)
%CLOSEPREVIEW Close image preview window.
% 
%    CLOSEPREVIEW(OBJ) closes the image preview window associated with 
%    the image acquisition object OBJ.
% 
%    CLOSEPREVIEW closes all image preview windows for all image 
%    acquisition objects.
% 
%    See also IMAQHELP, IMAQDEVICE/PREVIEW.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:55 $

% Make sure that the only input argument allowed is [].
if nargin==1,
    if ~isempty(in)
        errID = 'imaq:closepreview:invalidType';
        error(errID, privateMsgLookup(errID));
    else
        % >> closepreview(imaqfind) % where imaqfind returns []
        return;
    end
end

% Close all preview windows.
closepreview(imaqfind);