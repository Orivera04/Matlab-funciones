function obj = imaqchild(arg)
%IMAQCHILD Construct imaqchild object.
%
%    IMAQCHILD is the base class from which image acquisition
%    video source objects are derived from. It is used to allow these 
%    objects to inherit common methods.
%
%    This function is not intended to be used directly.
%
%    See also VIDEOINPUT, VIDEOSOURCE.
%

%    CP 1-25-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:52 $

% Determine if function was called by the toolbox.
if ((nargin~=1) || ~strcmp('imaqchild', arg))
    errID = 'imaq:imaqchild:invalidSyntax';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Create an empty dummy object
obj.store = {};
obj = class(obj,'imaqchild');
