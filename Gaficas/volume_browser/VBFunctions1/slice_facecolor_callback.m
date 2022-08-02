function slice_facecolor_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Face color has been changed

%	Parameters
color_list={'m','c','r','g','b','w','k','-','none','flat','interp','-','custom'};

%	Auslesen von Facecolor
facecolor=get(handles.slice_facecolor,'Value');

%	Ermitteln ob Custom Color... gew�hlt
if strcmp(color_list{facecolor},'custom')
    % UISETCOLOR aufrufen
    newcolor=uisetcolor;
    if size(newcolor,2)==3
        set(handles.slice_facecolor,'userdata',newcolor);
    else
        % Ansonsten interp
        set(handles.slice_facecolor,'Value',11);
        set(handles.slice_facecolor,'userdata','interp');
    end
else
    % Rausfiltern der Trennlinien
    if ~strcmp(color_list{facecolor},'-') 
        set(handles.slice_facecolor,'userdata',color_list{facecolor});
    else
        % Ansonsten interp
        set(handles.slice_facecolor,'Value',11);
        set(handles.slice_facecolor,'userdata','interp');
    end
end

% Aufruf Funktion Slice
slice_callback(h, eventdata, handles, varargin);

