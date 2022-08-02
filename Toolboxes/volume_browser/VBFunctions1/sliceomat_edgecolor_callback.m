function sliceomat_edgecolor_callback(h,eventdata,handles,varargin) %#ok Used in callback
% Border color has been changed

%	Parameters
color_list={'m','c','r','g','b','w','k','-','none','flat','interp','-','custom'};

%	Auslesen von Edgecolor
edgecolor=get(handles.sliceomat_edgecolor,'Value');

% Ermitteln ob Custom Color... gewählt
if strcmp(color_list{edgecolor},'custom')
    % UISETCOLOR aufrufen
    newcolor=uisetcolor;
    if size(newcolor,2)==3
        set(handles.sliceomat_edgecolor,'userdata',newcolor);
    else
        % Ansonsten interp
        set(handles.sliceomat_edgecolor,'Value',11);
        set(handles.sliceomat_edgecolor,'userdata','interp');
    end
else
    % Rausfiltern der Trennlinien
    if ~strcmp(color_list{edgecolor},'-') 
        set(handles.sliceomat_edgecolor,'userdata',color_list{edgecolor});
    else
        % Ansonsten interp
        set(handles.sliceomat_edgecolor,'Value',11);
        set(handles.sliceomat_edgecolor,'userdata','interp');
    end
end

% Aufruf Funktion Slicomat
sliceomat_callback(h, eventdata, handles, varargin);
