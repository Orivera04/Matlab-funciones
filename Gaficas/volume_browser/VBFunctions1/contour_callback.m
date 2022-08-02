function contour_callback(varargin)
% Contourslice erstellen/ändern/löschen

% Modified by E. Rietsch: October 15, 2006

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;
axis_handle=V3D_HANDLES.axis_handle;

eventdata=varargin{2};
handles=varargin{3};

% axis_handle bestimmen
% axis_handle=get(figure_handle,'CurrentAxes');

% Benutzerdaten userdata der Figure figure_handle auslesen
ud=get(figure_handle,'userdata');

% alten CLim sichern
oldclim=get(axis_handle,'CLim');
 
% Konstanten
method_list={'linear','nearest','cubic'};

% Auslesen Einstellungen von Contourslice in Struktur objud
objud.method=get(handles.contour_method,'Value');
objud.edgecolor=get(handles.contour_edgecolor,'userdata');
objud.edgecolor_value=get(handles.contour_edgecolor,'Value');
objud.isovalue=str2num(get(handles.contour_isovalue,'String')); %#ok More than one variable is possible

% wenn Slice X aktiviert
if get(handles.contour_x,'Value')
    % X Wert auslesen
    objud.x=str2num(get(handles.contour_xact,'String')); %#ok More than one variable is possible
else
    % X wurde nicht aktiviert
    objud.x=[];
end
% wenn Slice Y aktiviert
if get(handles.contour_y,'Value')
    % Y Wert auslesen
    objud.y=str2num(get(handles.contour_yact,'String')); %#ok More than one variable is possible
else
    % Y wurde nicht aktiviert
    objud.y=[];
end
% wenn Slice Z aktiviert
if get(handles.contour_z,'Value')
    % Z Wert auslesen
    objud.z=str2num(get(handles.contour_zact,'String')); %#ok More than one variable is possible
else
    % Z wurde nicht aktiviert
    objud.z=[];
end

%	If no slice is activated then activate x-slice to make something happen when
%       the tool is started
if isempty(objud.x)  &&  isempty(objud.y)  &&  isempty(objud.z)  &&  ud.first_contour
   ud.first_contour=false;
   set(figure_handle,'userdata',ud)

   set(handles.contour_x,'Value',1)
   xslice=mean(ud.x);
   objud.x=xslice;
   set(handles.contour_xact,'String',num2str(xslice));

   set(handles.contour_y,'Value',1)
   yslice=mean(ud.y);
   objud.y=yslice;
   set(handles.contour_yact,'String',num2str(yslice));

   set(handles.contour_z,'Value',1)
   zslice=mean(ud.z);
   objud.z=zslice;
   set(handles.contour_zact,'String',num2str(zslice));
end


delete(findobj(figure_handle,'Tag','OrigSlice'))   %%ER

% alle V3D-Slices finden und löschen
delete(findobj(figure_handle,'Tag','V3D:SLICEOMAT'));

% alle V3D-Contourslices finden und löschen
delete(findobj(figure_handle,'Tag','V3D:CONTOUR'));

% V3D_Fenster in Vordergrund bringen
figure(figure_handle);
hold on
figure(handles.figure1);

% Contourslice erstellen
V3D_CONTOUR = contourslice(ud.x,ud.y,ud.z,ud.v,objud.x,objud.y,objud.z,objud.isovalue,method_list{objud.method});

% Turn on grid
% grid_callback(handles.grid, eventdata, handles)

% Attribute setzen    
set(V3D_CONTOUR,'EdgeColor',objud.edgecolor);
set(V3D_CONTOUR,'Tag','V3D:CONTOUR');
set(V3D_CONTOUR,'userdata',objud);
hold off

% Minimum und Maximum Color setzen
set(axis_handle,'CLim',oldclim);
clear ha sl oldclim;
