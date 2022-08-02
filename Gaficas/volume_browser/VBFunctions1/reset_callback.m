function reset_callback(hobject, eventdata, handles, varargin)  %#ok Used in callback
% Reset and update statistical values
%
% Modified by E. Rietsch: October 15, 2006

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;

ud=get(figure_handle,'userdata');

%	Update statistics
set(handles.min,'String',min(ud.v(:)));
set(handles.max,'String',max(ud.v(:)));

%	Update colorbar
colorbar_callback(hobject, eventdata, handles, varargin);
