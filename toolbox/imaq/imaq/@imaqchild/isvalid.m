function isok = isvalid(obj)
%ISVALID True for image acquisition objects associated with hardware.
%
%    OUT = ISVALID(OBJ) returns a logical array, OUT, that contains a 1 
%    where the elements of OBJ are image acquisition objects associated 
%    with hardware and a 0 where the elements of OBJ are image acquisition 
%    objects not associated with hardware.
%
%    OBJ is an invalid image acquisition object when it is no longer 
%    associated with any hardware.  If this is the case, OBJ should be 
%    cleared from the workspace.
%
%    See also IMAQCHILD/DELETE, IMAQ/PRIVATE/CLEAR, IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:57 $

% Verify UDD object is valid.
isok = imaqgate('privateValidCheck', obj);
