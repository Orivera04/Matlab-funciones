function clear(varargin)
%CLEAR Clear image acquisition object from the workspace.
%
%    CLEAR OBJ removes the video input object, OBJ, from the MATLAB
%    workspace. If the video input object has a Running property value
%    of on, the video input object will continue executing.
%
%    OBJ can also be a video source object.   
%
%    Cleared objects can be restored to the MATLAB workspace with
%    the IMAQFIND function.
%
%    To remove OBJ from memory use the DELETE function.
%
%    See also IMAQFIND, IMAQDEVICE/DELETE, ISVALID.
%

%   CP 9-01-01
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:04 $
