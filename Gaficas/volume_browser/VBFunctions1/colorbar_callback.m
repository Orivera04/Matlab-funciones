function colorbar_callback(varargin)
% Update colorbar and colormap 
% Standard callback arguments
%
% Modified by E. Rietsch: October 15, 2006

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;

handles=varargin{3};

% figure_handle aus userdata auslesen
% figure_handle=get(gcf,'userdata');

normal_pointer=get(figure_handle,'Pointer');
set(figure_handle,'Pointer','watch')
drawnow

% axis_handle bestimmen
axis_handle=get(figure_handle,'CurrentAxes');

% Benutzerdaten userdata der Figure figure_handle auslesen
ud=get(figure_handle,'userdata');

% alle vorhandenen Colorbars löschen
delete(findobj(figure_handle,'Tag','V3D:COLORBAR'));

% V3D_Fenster in Vordergrund bringen
figure(figure_handle);

% Liste der Farbpalette auslesen + gewählten Eintrag auslesen
cmap_list=v3d_getcolormap;
cmap_val=get(handles.cmap_list,'Value');

% Farbpalette einlesen
ud.cmap.name=cmap_list{cmap_val};
cmap=str2num(v3d_getcolormap(ud.cmap.name)); %#ok More than one numeric variable

% Reverse gesetzt?
ud.cmap.reverse=get(handles.cmap_reverse,'Value');
if ud.cmap.reverse
   cmap=flipud(cmap);
   drawnow
end

% Helligkeitsgrad auslesen
ud.cmap.brighten=get(handles.cmap_brighten,'Value');
cmap=brighten(cmap,ud.cmap.brighten);

%	Define colormap
set(figure_handle,'Colormap',cmap);

% Color-Minimum und Color-Maximum auslesen, testen und für axis_handle setzen
% Achtung: CLim setzen bevor neuer Colorbar erstellt wird!
mincolor=str2double(get(handles.min,'String'));
maxcolor=str2double(get(handles.max,'String'));
%   Test if maxcolor > mincolor
if maxcolor<=mincolor
   maxcolor=mincolor+1;
   set(handles.min,'String',num2str(mincolor));
   set(handles.max,'String',num2str(maxcolor));
end
set(axis_handle,'CLim',[mincolor,maxcolor]);

%	If colorbar is requested
if get(handles.anzeigen,'Value')
    %   Read location and create new colorbar
    horizontal={'vert','hori'};
    horizontal_val=get(handles.horizontal,'Value');
    V3D_COLORBAR=colorbar(horizontal{horizontal_val+1},'peer',axis_handle);
    %   Normal or reverse?
    reverse={'normal','reverse'};
    reverse_val=get(handles.reverse,'Value');
    set(V3D_COLORBAR,'XDir',reverse{reverse_val+1});
    set(V3D_COLORBAR,'YDir',reverse{reverse_val+1});
    % Tag zu V3D:COLORBAR setzen
    set(V3D_COLORBAR,'Tag','V3D:COLORBAR');    
end

% Benutzerdaten userdata der Figure figure_handle setzen
set(figure_handle,'userdata',ud);
drawnow
set(figure_handle,'Pointer',normal_pointer)
