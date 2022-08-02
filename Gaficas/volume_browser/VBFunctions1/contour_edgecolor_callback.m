function contour_edgecolor_callback(h, eventdata, handles) %#ok Used by callback
% Edge color has been changed

% Modified by E. Rietsch: October 15, 2006
%

% Parameters
color_list={'m','c','r','g','b','w','k','-','none','flat','interp','-','custom'};

% Auslesen von edgecolor
edgecolor=get(handles.contour_edgecolor,'Value');

% Ermitteln ob Custom Color... gewählt
if strcmp(color_list{edgecolor},'custom')
    % UISETCOLOR aufrufen
    newcolor=uisetcolor;
    if size(newcolor,2)==3
        set(handles.contour_edgecolor,'userdata',newcolor);
    else
        % Ansonsten interp
        set(handles.contour_edgecolor,'Value',11);
        set(handles.contour_edgecolor,'userdata','interp');
    end
else
    % Rausfiltern der Trennlinien
    if ~strcmp(color_list{edgecolor},'-') 
        set(handles.contour_edgecolor,'userdata',color_list{edgecolor});
    else
        % Ansonsten interp
        set(handles.contour_edgecolor,'Value',11);
        set(handles.contour_edgecolor,'userdata','interp');
    end
end
