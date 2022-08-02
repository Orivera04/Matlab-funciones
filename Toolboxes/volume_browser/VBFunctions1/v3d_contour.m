function varargout = v3d_contour(varargin)
% Contour menu für volume browser
%
% Adaptation of function "v3d_contour" by Robert Barsch; the original
% version is available at The Matlab Central File Exchange, File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Modified by E. Rietsch: October 15, 2006
%
% --------------------------------------------------------------------
% 
% v3d_contour(hObject,eventdata)
%   Expects the figure ID of the graphic window when called

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;
% axis_handle=V3D_HANDLES.axis_handle;

% Initialisation der GUI
% ----------------------

% figure_handle und axis_handle setzen
% aktuelle Achse in Figure figure_handle finden
% axis_handle=get(figure_handle,'CurrentAxes');
% Benutzerdaten userdata der Figure figure_handle auslesen

%	Create a field "first_contour" to create defaults the first time 
%       the menu item is selected
ud=get(figure_handle,'userdata');
options=getappdata(figure_handle,'options');


if ~isfield(ud,'first_contour')
   ud.first_contour=true;
   grid(V3D_HANDLES.axis_handle,'on')
end

%	Use axis mnemonices in GUI
set(figure_handle,'userdata',ud)

%	FIG Datei oeffnen + handles generieren
fid = openfig(mfilename,'reuse');

%	Store handle of menu so that it can be deleted upon termination of the browser
add_handle2delete1(fid,figure_handle)

%	Generate a structure of handles to pass to callbacks, and store it. 
handles = guihandles(fid);

%	Make GUI invisible
set(fid,'visible','off','userdata',figure_handle);

% GUI Werte aktualisieren
% -----------------------

% alle V3D-Contourslices finden und deren Koordinaten und Colorflags auslesen + setzen
if length(findobj(figure_handle,'Tag','V3D:CONTOUR'))
    temp=findobj(figure_handle,'Tag','V3D:CONTOUR');
    % Userdata auslesen
    objud=get(temp(1),'userdata');
    % Edgecolor und Isovalue setzen
    set(handles.contour_edgecolor,'Value',objud.edgecolor_value);
    set(handles.contour_isovalue,'String',num2str(objud.isovalue));

    % Slice setzen
    if (size(objud.x,1))
        s=num2str(objud.x(1));
        for ii=2:size(objud.x,2) % Krampf da num2str unnötig viele Leerzeichen produziert
            c=num2str(objud.x(ii));
            s=strcat(s,[' ' c]);
        end
        set(handles.contour_xact,'String',s);   % Setzen der Slices
        set(handles.contour_x,'Value',1);         % X aktivieren
    end
    if (size(objud.y,1))
        s=num2str(objud.y(1));
        for i=2:size(objud.y,2)
            c=num2str(objud.y(i));
            s=strcat(s,[' ' c]);
        end
        set(handles.contour_yact,'String',s);
        set(handles.contour_y,'Value',1);
    end
    if (size(objud.z,1))
        s=num2str(objud.z(1));
        for i=2:size(objud.z,2)
            c=num2str(objud.z(i));
            s=strcat(s,[' ' c]);
        end
        set(handles.contour_zact,'String',s);
        set(handles.contour_z,'Value',1);
    end
    clear g sl;
end


% GUI plazieren und anzeigen
% --------------------------

% Position der GUI auf rechts oben festlegen 
movegui(fid,'northeast'); 

% Customize the axis directions in the GUI
set(handles.contour_x,'String',options.xinfo{1});
set(handles.contour_y,'String',options.yinfo{1});
set(handles.contour_z,'String',options.zinfo{1});

%	Make window visible
set(fid,'visible','on');

% Handles aktualisieren, GUI aufrufen + auf Aktionen warten
% ---------------------------------------------------------
contour_callback([], [], handles)
guidata(fid, handles);
    
% Wait for callbacks to run and window to be dismissed:
uiwait(fid);

if nargout > 0
	varargout{1} = fid;
end

