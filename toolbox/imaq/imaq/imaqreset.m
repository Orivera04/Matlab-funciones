function imaqreset
%IMAQRESET Disconnect and delete all image acquisition objects.
%
%    IMAQRESET deletes any image acquisition objects existing in 
%    memory as well as unloads all adaptors loaded by the toolbox. As
%    a result, the image acquisition hardware is reset.
%
%    IMAQRESET is the image acquisition command that returns MATLAB to 
%    the known state of having no image acquisition objects and no 
%    loaded image acquisition adaptors.
%
%    IMAQRESET will also force the toolbox to search for new hardware 
%    that may have been installed while MATLAB was running.
%
%    See also IMAQHELP, IMAQDEVICE/DELETE, IMAQ/PRIVATE/CLEAR.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:01 $
try
    imaqmex('imaqreset');
catch
    rethrow(lasterror);     
end
