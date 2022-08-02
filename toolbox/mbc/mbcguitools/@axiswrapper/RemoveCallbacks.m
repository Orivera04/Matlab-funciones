function RemoveCallbacks(obj)
% AXISWRAPPER/REMOVECALLBACKS Function to remove relevent callbacks from an axiswrapper axis
%
% RemoveCallbacks(Axiswrapper) iterates down all children removing the callbacks
% 'callback', 'ButtonDownFcn', 'CreateFcn', 'DeleteFcn'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:17:55 $



% Call RemoveCallbacks on the axiswrapper axis handle
ud=obj.g.info;
RemoveCallbacks(ud.axes);
