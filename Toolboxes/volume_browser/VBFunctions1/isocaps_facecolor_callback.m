function isocaps_facecolor_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Flächenfarbe wurde geändert 

%   Parameters
color_list={'m','c','r','g','b','w','k','-','none','interp','-','custom'};

%   Auslesen von Facecolor
facecolor=get(handles.isocaps_facecolor,'Value');

% Ermitteln ob Custom Color... gewählt
if strcmp(color_list{facecolor},'custom')
    % UISETCOLOR aufrufen
    newcolor=uisetcolor;
    if size(newcolor,2)==3
        set(handles.isocaps_facecolor,'userdata',newcolor);
    else
        % Ansonsten interp
        set(handles.isocaps_facecolor,'Value',10);
        set(handles.isocaps_facecolor,'userdata','interp');
    end
else
    % Rausfiltern der Trennlinien
    if ~strcmp(color_list{facecolor},'-') 
        set(handles.isocaps_facecolor,'userdata',color_list{facecolor});
    else
        % Ansonsten interp
        set(handles.isocaps_facecolor,'Value',10);
        set(handles.isocaps_facecolor,'userdata','interp');
    end
end

% Aufruf Funktion isosurface_callback
isosurface_callback(h, eventdata, handles, varargin);
