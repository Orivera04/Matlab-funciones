function v3d_iso(varargin)
% Iso-menu for V3D
% 
% Adaptation of function "v3d_iso" by Robert Barsch; the original
% version is available at The Matlab Central File Exchange, File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Modified by E. Rietsch: October 15, 2006
% 
% v3d_iso


global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;

ud=get(figure_handle,'userdata');

%	FIG Datei oeffnen + handles generieren
fid = openfig(mfilename,'reuse');

 %	Store handle of menu so that it can be deleted upon termination of the browser
add_handle2delete1(fid,figure_handle)

%	Generate a structure of handles to pass to callbacks, and store it. 
handles = guihandles(fid);
% GUI vorerst unsichtbar machen
set(fid,'visible','off','userdata',figure_handle);

% GUI Werte aktualisieren
% -----------------------

% Maximum und Minimum von Isovalue und Isovalue_Sliders setzen
minv=min(ud.v(:));
maxv=max(ud.v(:));
set(handles.min,'String',num2str(minv));
set(handles.isovalue,'String',num2str(minv));
set(handles.max,'String',num2str(maxv));
set(handles.isovalue_slider,'min',minv);
set(handles.isovalue_slider,'value',(minv+maxv)*0.5);
set(handles.isovalue_slider,'max',maxv);
set(handles.isovalue,'String',num2str((minv+maxv)*0.5));

% alle V3D:ISOSURFACES finden und deren Isovalue und Colorflags auslesen + setzen
if (length(findobj(figure_handle,'Tag','V3D:ISOSURFACE')))
    temp=findobj(figure_handle,'Tag','V3D:ISOSURFACE');
    % Userdata auslesen
    isoud=get(temp(1),'userdata');
    % wenn Isovalue vorhanden sind
    if (size(isoud.isovalue,1))
        % Isovalue Werte setzen
        set(handles.isovalue,'String',num2str(isoud.isovalue));
        set(handles.isovalue_slider,'Value',isoud.isovalue);
        % Isosurface Werte in GUI aktualisieren
        set(handles.isosurface,'Value',isoud.isosurface);
        set(handles.isosurface_facecolor,'Value',isoud.isosurface_facecolor_value);
        set(handles.isosurface_edgecolor,'Value',isoud.isosurface_edgecolor_value);
        set(handles.isosurface_facecolor,'userdata',isoud.isosurface_facecolor);
        set(handles.isosurface_edgecolor,'userdata',isoud.isosurface_edgecolor);
        set(handles.isosurface_alpha,'Value',isoud.isosurface_alpha);
        set(handles.isosurface_lighting,'Value',isoud.isosurface_lighting);
        % Isocap Werte in GUI aktualisieren
        set(handles.isocaps,'Value',isoud.isocaps);
        set(handles.isocaps_facecolor,'Value',isoud.isocaps_facecolor_value);
        set(handles.isocaps_edgecolor,'Value',isoud.isocaps_edgecolor_value);
        set(handles.isocaps_facecolor,'userdata',isoud.isocaps_facecolor);
        set(handles.isocaps_edgecolor,'userdata',isoud.isocaps_edgecolor);
        set(handles.isocaps_alpha,'Value',isoud.isocaps_alpha);
        set(handles.isocaps_lighting,'Value',isoud.isocaps_lighting);
        set(handles.isocaps_whichplane,'value',isoud.isocaps_whichplane);
        set(handles.isocaps_enclose,'value',isoud.isocaps_enclose);
        % Isonormal Werte in GUI aktualisieren
        set(handles.isonormals,'Value',isoud.isonormals);
    end
end

% GUI plazieren und anzeigen
% --------------------------

% Position der GUI auf rechts oben festlegen 
movegui(fid,'northeast'); 
% Fenster sichtbar machen
set(fid,'visible','on');

% Handles aktualisieren, GUI aufrufen + auf Aktionen warten
% ---------------------------------------------------------

delete(findobj(figure_handle,'Tag','OrigSlice'))   %%ER
isosurface_callback([], [], handles)        %%ER

guidata(fid, handles);
    
% Wait for callbacks to run and window to be dismissed:
uiwait(fid);
