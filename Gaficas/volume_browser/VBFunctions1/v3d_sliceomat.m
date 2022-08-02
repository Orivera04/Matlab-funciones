function v3d_sliceomat(varargin)
% Slicemenu for V3D
% 
% Adaptation of function "v3d_sliceomat" by Robert Barsch; the original
% version is available at The Matlab Central File Exchange, File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Modified by: E. Rietsch: October 15, 2006
% 
%   v3d_sliceomat

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;

ud=get(figure_handle,'userdata');
options=getappdata(figure_handle,'options');

if ~isfield(ud,'first_slice')
   ud.first_slice=true;
end
set(figure_handle,'userdata',ud)

%	FIG Datei oeffnen + handles generieren
fid = openfig(mfilename,'reuse');

%	Store handle of menu so that it can be deleted upon termination of the browser
add_handle2delete1(fid,figure_handle)

%	Generate a structure of handles to pass to callbacks, and store it. 
handles = guihandles(fid);

set(fid,'visible','off','userdata',figure_handle); % Make GUI invisible

 %	Store handle of GUI so that it can be deleted upon termination of the browser

%	Set the labels for the axis checkboxed
set(handles.sliceomat_x,'String',options.xinfo{1});
set(handles.sliceomat_y,'String',options.yinfo{1});
set(handles.sliceomat_z,'String',options.zinfo{1});

%	Update GUI values
%	Set maxima and minima of the sliders
set(handles.sliceomat_xmax,'String',num2str(max(ud.x)));
set(handles.sliceomat_xmin,'String',num2str(min(ud.x)));
set(handles.sliceomat_ymax,'String',num2str(max(ud.y)));
set(handles.sliceomat_ymin,'String',num2str(min(ud.y)));
set(handles.sliceomat_zmax,'String',num2str(max(ud.z)));
set(handles.sliceomat_zmin,'String',num2str(min(ud.z)));
set(handles.sliceomat_xact,'String',num2str((max(ud.x)-min(ud.x))/2+min(ud.x)));
set(handles.sliceomat_yact,'String',num2str((max(ud.y)-min(ud.y))/2+min(ud.y)));
set(handles.sliceomat_zact,'String',num2str((max(ud.z)-min(ud.z))/2+min(ud.z)));
set(handles.sliceomat_xslider,'max',max(ud.x));
set(handles.sliceomat_xslider,'min',min(ud.x));
set(handles.sliceomat_yslider,'max',max(ud.y));
set(handles.sliceomat_yslider,'min',min(ud.y));
set(handles.sliceomat_zslider,'max',max(ud.z));
set(handles.sliceomat_zslider,'min',min(ud.z));
set(handles.sliceomat_xslider,'Value',(max(ud.x)-min(ud.x))/2+min(ud.x));
set(handles.sliceomat_yslider,'Value',(max(ud.y)-min(ud.y))/2+min(ud.y));
set(handles.sliceomat_zslider,'Value',(max(ud.z)-min(ud.z))/2+min(ud.z));

%	If alpha data available integrate them into GUI; otherwise leave menu item off
if ud.alphadata
   set(handles.sliceomat_alpha,'String',{'Single value','Alphamap (flat)','Alphamap (interp)','AlphaData (flat)','AlphaData (interp)'});
else
   set(handles.sliceomat_alpha,'String',{'Single value','Alphamap (flat)','Alphamap (interp)'});
end

% alle V3D:SLICEOMAT-Slices finden und deren Koordinaten und Colorflags auslesen + setzen
if (length(findobj(figure_handle,'Tag','V3D:SLICEOMAT')))
   temp=findobj(figure_handle,'Tag','V3D:SLICEOMAT');
   % Userdata auslesen
   slud=get(temp(1),'userdata');
   % Sliceomat Werte in GUI aktualisieren
   set(handles.sliceomat_facecolor,'Value',slud.facecolor_value);
   set(handles.sliceomat_facecolor,'userdata',slud.facecolor);
   set(handles.sliceomat_edgecolor,'Value',slud.edgecolor_value);
   set(handles.sliceomat_edgecolor,'userdata',slud.edgecolor);
   set(handles.sliceomat_method,'Value',slud.method);
   set(handles.sliceomat_alpha,'Value',slud.alpha);
   set(handles.sliceomat_alpha_single,'Value',slud.alpha_single);
   % Ermitteln ob Einzelner Wert gewählt und Slicer aktivieren/deaktivieren
   if get(handles.sliceomat_alpha,'Value')==1
       set(handles.sliceomat_alpha_single,'visible','on');    
   else
       set(handles.sliceomat_alpha_single,'visible','off');
   end
   set(handles.sliceomat_lighting,'Value',slud.lighting);
   % Slice setzen
   if (size(slud.x,1)) % wenn X-Slice eingetragen, also nicht leer
      set(handles.sliceomat_xslider,'Value',slud.x);         % X-Slider setzen
      set(handles.sliceomat_xact,'String',num2str(slud.x));    % X-Wert setzen
      set(handles.sliceomat_x,'Value',1);                     % X aktivieren
   end
   if (size(slud.y,1))
      set(handles.sliceomat_yslider,'Value',slud.y);
      set(handles.sliceomat_yact,'String',num2str(slud.y));
      set(handles.sliceomat_y,'Value',1);            
   end
   if (size(slud.z,1))
      set(handles.sliceomat_zslider,'Value',slud.z);
      set(handles.sliceomat_zact,'String',num2str(slud.z));
      set(handles.sliceomat_z,'Value',1);            
   end
end

%	Position GUI
movegui(fid,'northeast'); 
set(fid,'visible','on');

guidata(fid, handles);
    
%	Wait for callbacks to run and window to be dismissed:

uiwait(fid);