function isosurface_slider_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Slider has been moved -> update iso-value
%
%	Get slider position
act=get(handles.isovalue_slider,'Value');

%	Set iso-value
set(handles.isovalue,'String',num2str(act));

%	Plot iso-surface/iso-caps
isosurface_callback(h, eventdata, handles, varargin);
