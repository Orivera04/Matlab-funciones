function add_handle2delete1(handle,gui_handle)
% Add a handle to an array of handles that should be deleted on exit from a GUI
% This list of handles is in the field 'handles2delete' of structure "userdata"
% saved in the application data of the GUI
%    userdata=getappdata(gui_handle,'userdata')
%
% See also: "delete_handles2delete1"
%
% Written by: E. Rietsch: October 20, 2006
% Last updated:
%
%             add_handle2delete(handle,gui_handle)

% INPUT
% handle      handle to add to vector "structure.handles2delete"
% gui_handle  handle of the GUI where the user data are stored

userdata=getappdata(gui_handle,'userdata');

if isempty(userdata)
   userdata.handles2delete=handle(:);

elseif isstruct(userdata)
   if isfield(userdata,'handles2delete')
      userdata.handles2delete=[userdata.handles2delete;handle(:)];
   else
      userdata.handles2delete=handle(:);
   end

else
   error('Variable "userdata" must be empty or a structure.')

end

setappdata(gui_handle,'userdata',userdata)
