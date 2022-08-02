function v3d_color(varargin)
% Colormenu for Volume Browser
% 
% Adaptation of function "v3d_color" by Robert Barsch; the original
% version is available at The Matlab Central File Exchange, File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Modified by E. Rietsch: October 15, 2006
%
% v3d_color(figure_handle)
%   Expects the figure handle of the main graphic window
%

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;
axis_handle=V3D_HANDLES.axis_handle;

%	Get usee data
ud=get(figure_handle,'userdata');

%	Get GUI window
fid = openfig(mfilename,'reuse');

%	Store the handle of GUI so that it can be deleted upon termination of the browser
add_handle2delete1(fid,figure_handle)

%	Generate a structure of handles to pass to callbacks, and store it. 
handles = guihandles(fid);
% set(fid,'visible','off','userdata',figure_handle);
set(fid,'visible','off');

%	Update GUI values

%	Brightness
set(handles.cmap_brighten,'Value',ud.cmap.brighten);
    
%	Color map
cmap_list = v3d_getcolormap;
set(handles.cmap_list,'String',cmap_list);

%	Select actual color map
cmap_val = strmatch(ud.cmap.name,cmap_list,'exact');
set(handles.cmap_list,'Value',cmap_val(1));

%	Reverse color map?
set(handles.cmap_reverse,'Value',ud.cmap.reverse);    

%	Set color limits
clim=get(axis_handle,'CLim');
set(handles.max,'String',num2str(clim(2)));
set(handles.min,'String',num2str(clim(1)));

%	Set background
if (mean(get(axis_handle,'color'))==0) 
    set(handles.bgschwarz,'Value',1);
else
    set(handles.bgschwarz,'Value',0);
end

%	Determine volume statistics
set(handles.dmin,'String',min(ud.v(:)));
set(handles.dmax,'String',max(ud.v(:)));
set(handles.dmean,'String',mean(ud.v(:)));
set(handles.dmedian,'String',median(ud.v(:)));

%	Find all colorbars in V3D window; copy values in first colorbar to GUI
if (length(findall(figure_handle,'tag','V3D:COLORBAR')))
   cc=findall(figure_handle,'tag','V3D:COLORBAR');
%	Reverse or normal?
   xdir=get(cc(1),'XDir');
%	Position des Farbbalkens (zur Bestimmung ob hori oder vert) -> Krücke!!!, anders gehts aber net
   pos=get(cc(1),'Position'); 
%	Setzen des horizontal Flag
   if pos(3) > pos(4) 
      set(handles.horizontal,'Value',1);
   else
      set(handles.horizontal,'Value',0);
   end
%	Setzen des reverse flags
   if strcmp(xdir,'reverse')
      set(handles.reverse,'Value',1)
   end
%	Setzen des anzeigen flags
   set(handles.anzeigen,'Value',1); 
end

%	Position GUI and make it visible
movegui(fid,'northeast'); 
set(fid,'visible','on');

%	Update handles
guidata(fid, handles);
    
%	Wait for callbacks to run and window to be dismissed:
uiwait(fid);
   