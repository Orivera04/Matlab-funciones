function gui_handle=get_gui_handle
% Get handle of GUI of volume browser
%
% Written by: E. Rietsch: October 21, 2006
% Last updated:
%
%             gui_handle=get_gui_handle
% OUTPUT
% gui_handle  handle of volume browser GUI

if ~isstruct(get(gcf,'userdata'))
   gui_handle=get(gcf,'userdata');
else
   gui_handle=gcf;
end
