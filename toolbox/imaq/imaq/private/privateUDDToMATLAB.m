function mobjects = privateUDDToMATLAB(uddobjects)
%PRIVATEUDDTOMATLAB Convert objects to their appropriate MATLAB object type.
%
%    MOBJECTS = PRIVATEUDDTOMATLAB(UDDOBJECTS) converts the vector of UDD
%    objects, UDDOBJECTS, to a vector of video input MATLAB objects.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:19 $

% Initialize return arguments.
mobjects = [];

% Convert each udd object to a MATLAB object.
for i=1:length(uddobjects),
    mConstructor = get(uddobjects(i), 'Type');
    mobjects = [ mobjects feval(mConstructor, uddobjects(i)) ];
end