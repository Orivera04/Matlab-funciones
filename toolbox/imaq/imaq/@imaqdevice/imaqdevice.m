function obj = imaqdevice(arg)
%IMAQDEVICE Construct imaqdevice object.
%
%    IMAQDEVICE is the base class from which videoinput
%    objects are derived from.  It is used to allow these 
%    objects to inherit common methods.
%
%    This function should not be used directly by users.
% 
%    See also VIDEOINPUT.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:18 $

% Determine if function was called by the toolbox.
if ((nargin~=1) || ~ischar(arg) || ~strcmp('imaqdevice', arg))
    errID = 'imaq:imaqdevice:invalidSyntax';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Create an empty dummy object
obj.store={};
obj = class(obj,'imaqdevice');
