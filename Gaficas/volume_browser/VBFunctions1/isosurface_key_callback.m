function isosurface_key_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Keyboard entry of iso=value; updating of slider

%	Auslesen der Limits und Act-Werte
act=str2double(get(handles.isovalue,'String'));
max=str2double(get(handles.max,'String'));
min=str2double(get(handles.min,'String'));

%	Testen der act-Werte ob innerhalb des Limits, ggf anpassen
if act<min 
   act=min; 
end
if act>max
   act=max;
end

%	Isovalue und Slider Position setzen
set(handles.isovalue,'String',num2str(act));
set(handles.isovalue_slider,'Value',act);

%	Isosurface/Isocaps zeichnen
isosurface_callback(h, eventdata, handles, varargin);
