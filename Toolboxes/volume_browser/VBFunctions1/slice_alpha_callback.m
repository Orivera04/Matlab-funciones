function slice_alpha_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Transparency has been changed

%	Ermitteln ob Einzelner Wert gewählt und Slicer aktivieren/deaktivieren
if get(handles.slice_alpha,'Value')==1
  set(handles.slice_alpha_single,'visible','on');    
else
  set(handles.slice_alpha_single,'visible','off');
end

% Aufruf Funktion Slice
slice_callback(h, eventdata, handles, varargin);
