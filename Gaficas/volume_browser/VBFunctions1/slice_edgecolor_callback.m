function slice_edgecolor_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Edge color has been changed

%	Parameters
color_list={'m','c','r','g','b','w','k','-','none','flat','interp','-','custom'};

%	Read edge color
edgecolor=get(handles.slice_edgecolor,'Value');

%	Check if Custom color... has been selected
if strcmp(color_list{edgecolor},'custom')
    % UISETCOLOR aufrufen
    newcolor=uisetcolor;
    if size(newcolor,2)==3
        set(handles.slice_edgecolor,'userdata',newcolor);
    else
        % Ansonsten interp
        set(handles.slice_edgecolor,'Value',11);
        set(handles.slice_edgecolor,'userdata','interp');
    end
else
    % Rausfiltern der Trennlinien
    if ~strcmp(color_list{edgecolor},'-') 
        set(handles.slice_edgecolor,'userdata',color_list{edgecolor});
    else
        % Ansonsten interp
        set(handles.slice_edgecolor,'Value',11);
        set(handles.slice_edgecolor,'userdata','interp');
    end
end

%	Call Slice callback
slice_callback(h, eventdata, handles, varargin);
