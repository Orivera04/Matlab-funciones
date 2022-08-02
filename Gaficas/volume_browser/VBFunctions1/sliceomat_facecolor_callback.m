function sliceomat_facecolor_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Face color has been changed 

%	Parameters
color_list={'m','c','r','g','b','w','k','-','none','flat','interp','-','custom'};

%	Get face color
facecolor=get(handles.sliceomat_facecolor,'Value');

% Ermitteln ob Custom Color... gewählt
if strcmp(color_list{facecolor},'custom')
    % UISETCOLOR aufrufen
    newcolor=uisetcolor;
    if size(newcolor,2)==3
        set(handles.sliceomat_facecolor,'userdata',newcolor);
    else
        % Ansonsten interp
        set(handles.sliceomat_facecolor,'Value',11);
        set(handles.sliceomat_facecolor,'userdata','interp');
    end
else
    % Rausfiltern der Trennlinien
    if ~strcmp(color_list{facecolor},'-') 
        set(handles.sliceomat_facecolor,'userdata',color_list{facecolor});
    else
        % Ansonsten interp
        set(handles.sliceomat_facecolor,'Value',11);
        set(handles.sliceomat_facecolor,'userdata','interp');
    end
end

% Aufruf Funktion Slicomat
sliceomat_callback(h, eventdata, handles, varargin);
