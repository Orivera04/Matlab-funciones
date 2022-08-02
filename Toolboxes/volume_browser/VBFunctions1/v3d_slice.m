function v3d_slice(varargin)
% Slice menu for Volume Browser
% 
% Adaptation of function "v3d_slice" originally written by Robert Barsch;
% the original version is available at The Matlab Central File Exchange,
% File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Modified by E. Rietsch: October 22, 2006
% Last modified: January 5, 2007: Change initial GUI location
%
% v3d_slice(figure_handle)
%   Expects the figure ID of the figure window when called

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;
   
%	Initialize GUI

%	Find handle of figure_handle and axis_handle
% figure_handle=varargin{1};

%	Get user data
ud=get(figure_handle,'userdata');

%	FIG Datei oeffnen + handles generieren
fid = openfig(mfilename,'reuse','invisible');

% Position der GUI auf rechts oben festlegen 
movegui(fid,'northeast'); 

%	Make GUI invisible
set(fid,'visible','off');

%	Store handle of menu so that it can be deleted upon termination of the browser
add_handle2delete1(fid,figure_handle)

%	Generate a structure of handles to pass to callbacks, and store it. 
handles = guihandles(fid);
    
% GUI Werte aktualisieren
% -----------------------

%	Wenn Alphadata gegeben in GUI integrieren ansonsten ausblenden
if ud.alphadata
    set(handles.slice_alpha,'String',{'Single value','Alphamap (flat)','Alphamap (interp)','AlphaData (flat)','AlphaData (interp)'});
else
    set(handles.slice_alpha,'String',{'Single value','Alphamap (flat)','Alphamap (interp)'});
end

%	Find all V3D:SLICE slice and their coordinated and colorflags
temp=findobj(figure_handle,'Tag','V3D:SLICE');

if ~isempty(temp)
   
   % Userdata auslesen
   slud=get(temp(1),'userdata');
   % Slice Werte in GUI aktualisieren
   set(handles.slice_facecolor,'Value',slud.facecolor_value);
   set(handles.slice_facecolor,'userdata',slud.facecolor);
   set(handles.slice_edgecolor,'Value',slud.edgecolor_value);
   set(handles.slice_edgecolor,'userdata',slud.edgecolor);
   set(handles.slice_method,'Value',slud.method);
   set(handles.slice_alpha,'Value',slud.alpha);
   set(handles.slice_alpha_single,'Value',slud.alpha_single);

%	Ermitteln ob Einzelner Wert gewählt und Slicer aktivieren/deaktivieren
   if get(handles.slice_alpha,'Value')==1
      set(handles.slice_alpha_single,'visible','on');    
   else
      set(handles.slice_alpha_single,'visible','off');
   end
   set(handles.slice_lighting,'Value',slud.lighting);

%	Create slice data
   if ~isempty(slud.x)
      s=vector2str(slud.x);
      set(handles.slice_xact,'String',s);     % Setzen der Slices
      set(handles.slice_x,'Value',1);         % X aktivieren
   end
   if (size(slud.y,1))
      s=vector2str(slud.x);
      set(handles.slice_yact,'String',s);
      set(handles.slice_y,'Value',1);
   end
   if (size(slud.z,1))
      s=vector2str(slud.x);
      set(handles.slice_zact,'String',s);
      set(handles.slice_z,'Value',1);
   end

else
%	If no slices have been selected create default slices
   set(handles.slice_x,'Value',1);
   set(handles.slice_y,'Value',1);
   set(handles.slice_z,'Value',1);
   set(handles.slice_xact,'String',num2str(ud.x(round(end/2))));
   set(handles.slice_yact,'String',num2str(ud.y(round(end/2))));
   set(handles.slice_zact,'String',num2str(ud.z(round(end/2))));
   figure(figure_handle)
   oldcamva=camva;
   myview(3);
   camva(oldcamva);
   cla;
   clear oldcamva
   slice_callback(handles.slice_x,[],handles)
end

%  Position GUI and make it visible
% --------------------------

    % Customize the axis directions in the GUI
ud=get(figure_handle,'userdata');
options=getappdata(figure_handle,'options');

set(handles.slice_x,'String',options.xinfo{1});
set(handles.slice_y,'String',options.yinfo{1});
set(handles.slice_z,'String',options.zinfo{1});
hhs=get(handles.slice_view,'UserData');
[dummy,index]=sort(hhs);	%#ok The first output argument is not required
set(handles.slice_view(index(1)),'String',options.xinfo{1})
set(handles.slice_view(index(2)),'String',options.yinfo{1})
set(handles.slice_view(index(3)),'String',options.zinfo{1})


% Fenster sichtbar machen
set(fid,'visible','on');

%	Update handles and wait for events
guidata(fid, handles);
uiwait(fid);
