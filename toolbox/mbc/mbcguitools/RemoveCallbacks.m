function RemoveCallbacks(h)
% REMOVECALLBACKS Function to remove relevent callbacks from a graphics handle and all children
%
% RemoveCallbacks(handle) iterates down all children removing the callbacks
% 'callback', 'ButtonDownFcn', 'CreateFcn', 'DeleteFcn'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:33:06 $

% Created 18/9/2000

if ~ishandle(h)
   warning('Callbacks can only be removed from handle graphics objects');
   return
end

% First remove callback string for a uicontrol
if strcmpi(get(h,'type'),'uicontrol')
   set(h,'callback','');
end

% Now remove Fcn's
set(h,'ButtonDownFcn','','CreateFcn','','DeleteFcn','');

% Now do the same for the children
ch = get(h,'children');
if ~isempty(ch)
   for i = 1:length(ch)
      RemoveCallbacks(ch(i));
   end
end
