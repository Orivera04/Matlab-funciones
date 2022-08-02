function isosurface_callback(varargin)
% Creates an isosurface

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;
axis_handle=V3D_HANDLES.axis_handle;

handles=varargin{3};

%	Get user data
ud=get(figure_handle,'userdata');

% alten CLim sichern
oldclim=get(axis_handle,'CLim');

%	Parameter options for drop-down menues
lighting_list={'none','flat','gouraud','phong'};
whichplane_list={'all','xmin','xmax','ymin','ymax','zmin','zmax'};
enclose_list={'above','below'};

% Auslesen Einstellungen von Isosurface in Struktur isoud
isoud.isosurface=get(handles.isosurface,'Value');
isoud.isosurface_facecolor=get(handles.isosurface_facecolor,'userdata');
isoud.isosurface_edgecolor=get(handles.isosurface_edgecolor,'userdata');
isoud.isosurface_facecolor_value=get(handles.isosurface_facecolor,'Value');
isoud.isosurface_edgecolor_value=get(handles.isosurface_edgecolor,'Value');
isoud.isosurface_alpha=get(handles.isosurface_alpha,'Value');
isoud.isosurface_lighting=get(handles.isosurface_lighting,'Value');

% Auslesen Einstellungen von Isocaps in Struktur isoud
isoud.isocaps=get(handles.isocaps,'Value');
isoud.isocaps_facecolor=get(handles.isocaps_facecolor,'userdata');
isoud.isocaps_edgecolor=get(handles.isocaps_edgecolor,'userdata');
isoud.isocaps_facecolor_value=get(handles.isocaps_facecolor,'Value');
isoud.isocaps_edgecolor_value=get(handles.isocaps_edgecolor,'Value');
isoud.isocaps_alpha=get(handles.isocaps_alpha,'Value');
isoud.isocaps_lighting=get(handles.isocaps_lighting,'Value');
isoud.isocaps_whichplane=get(handles.isocaps_whichplane,'value');
isoud.isocaps_enclose=get(handles.isocaps_enclose,'value');

% Auslesen Einstellungen von Isonormal in Struktur isoud
isoud.isonormals=get(handles.isonormals,'Value');

% wenn Isosurface oder Isocaps aktiviert
if isoud.isosurface  ||  isoud.isocaps  || isoud.isonormals
    %	Get isovalues
    isoud.isovalue=str2num(get(handles.isovalue,'String')); %#ok More than one value possible
else
    % kein Isovalue
    isoud.isovalue=[];
end

%	Find and delete all V3D:ISOSURFACES
delete(findobj(figure_handle,'Tag','V3D:ISOSURFACE'));

% V3D_Fenster in Vordergrund bringen
% figure(figure_handle);
figure(handles.figure1)

%	Several isovalues?
for i=1:length(isoud.isovalue)
    % wenn Isosurface aktiviert
    if isoud.isosurface  ||  isoud.isonormals
        hold on
        % Isosurface erstellen
        V3D_ISOSURFACE = patch(isosurface(ud.x,ud.y,ud.z,ud.v,isoud.isovalue(i)));
        % Isocolor aktiviert ?
        if (isoud.isosurface_facecolor_value==10  ||  isoud.isosurface_edgecolor_value==10) 
            isocolors(ud.x,ud.y,ud.z,ud.v,V3D_ISOSURFACE);
        end    
        % Attribute setzen
        set(V3D_ISOSURFACE,'FaceColor',isoud.isosurface_facecolor);
        set(V3D_ISOSURFACE,'EdgeColor',isoud.isosurface_edgecolor);
        set(V3D_ISOSURFACE,'FaceLighting',lighting_list{isoud.isosurface_lighting});
        set(V3D_ISOSURFACE,'EdgeLighting',lighting_list{isoud.isosurface_lighting});
        set(V3D_ISOSURFACE,'FaceAlpha',isoud.isosurface_alpha);
        set(V3D_ISOSURFACE,'EdgeAlpha',isoud.isosurface_alpha); 
        set(V3D_ISOSURFACE,'Tag','V3D:ISOSURFACE');
        set(V3D_ISOSURFACE,'userdata',isoud);
        % Isonormale aktiviert?
        if isoud.isonormals
            isonormals(ud.x,ud.y,ud.z,ud.v,V3D_ISOSURFACE);
        end
        hold off
    end
    % wenn Isocaps aktiviert
    if isoud.isocaps   
        hold on
        % Isopatch erstellen
        V3D_ISOCAPS = patch(isocaps(ud.x,ud.y,ud.z,ud.v,isoud.isovalue(i),...
                  whichplane_list{isoud.isocaps_whichplane},...
                  enclose_list{isoud.isocaps_enclose}));
        % Attribute setzen    
        set(V3D_ISOCAPS,'FaceColor',isoud.isocaps_facecolor);
        set(V3D_ISOCAPS,'EdgeColor',isoud.isocaps_edgecolor);
        set(V3D_ISOCAPS,'FaceLighting',lighting_list{isoud.isocaps_lighting});
        set(V3D_ISOCAPS,'EdgeLighting',lighting_list{isoud.isocaps_lighting});
        set(V3D_ISOCAPS,'FaceAlpha',isoud.isocaps_alpha);
        set(V3D_ISOCAPS,'EdgeAlpha',isoud.isocaps_alpha); 
        set(V3D_ISOCAPS,'Tag','V3D:ISOSURFACE');
        set(V3D_ISOCAPS,'userdata',isoud);
        hold off
    end
end

%	Minimum und Maximum Color setzen
set(axis_handle,'CLim',oldclim);
