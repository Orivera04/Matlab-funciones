function slice_view_callback(varargin)
% x aktivieren - rest deaktivieren 

hobject=varargin{1};
handles=varargin{3};
set(handles.slice_view,'Value',0);
set(hobject,'Value',1);
