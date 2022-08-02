function RemoveCallbacks(obj)
% XREGCONTAINER/REMOVECALLBACKS Function to remove relevent callbacks from a xregcontainer and all children
%
% RemoveCallbacks(Container Object) iterates down all children removing the callbacks
% 'callback', 'ButtonDownFcn', 'CreateFcn', 'DeleteFcn'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:35:11 $


elements = obj.g.elements;
for i = 1:length(elements)
	RemoveCallbacks(elements{i});
end
