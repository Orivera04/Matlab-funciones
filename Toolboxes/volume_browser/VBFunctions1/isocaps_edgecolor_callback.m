function isocaps_edgecolor_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Edge color has been changed

%	Color options
color_list={'m','c','r','g','b','w','k','-','none','interp','-','custom'};

%	Get edge color
edgecolor=get(handles.isocaps_edgecolor,'Value');

%	Ermitteln ob Custom Color... gewählt
if strcmp(color_list{edgecolor},'custom')
    % UISETCOLOR aufrufen
    newcolor=uisetcolor;
    if size(newcolor,2)==3
        set(handles.isocaps_edgecolor,'userdata',newcolor);
    else
        % Ansonsten interp
        set(handles.isocaps_edgecolor,'Value',10);
        set(handles.isocaps_edgecolor,'userdata','interp');
    end
else
    % Rausfiltern der Trennlinien
    if ~strcmp(color_list{edgecolor},'-') 
        set(handles.isocaps_edgecolor,'userdata',color_list{edgecolor});
    else
        % Ansonsten interp
        set(handles.isocaps_edgecolor,'Value',10);
        set(handles.isocaps_edgecolor,'userdata','interp');
    end
end

% Aufruf Funktion isosurface_callback
isosurface_callback(h, eventdata, handles, varargin);
