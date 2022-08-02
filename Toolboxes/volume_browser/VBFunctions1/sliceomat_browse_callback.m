function sliceomat_browse_callback(varargin) %#ok Used in callback
% Browse button has been activated 

%	Check if there is a default path and default filename
gui_handle=get_gui_handle;
userdata=getappdata(gui_handle,'userdata');
if isfield(userdata,'path')
   filename=fullfile(userdata.path,userdata.filename);
else
   filename='sliceomat.avi';
end

handles=varargin{3};
[filename,pathname] = uiputfile(filename,'Save as...');

if ~isequal(filename,0) && ~isequal(pathname,0)
   set(handles.sliceomat_filename,'String',fullfile(pathname,filename));
   userdata.path=pathname;
   userdata.filename=filename;
   setappdata(gui_handle,'userdata',userdata)
end
