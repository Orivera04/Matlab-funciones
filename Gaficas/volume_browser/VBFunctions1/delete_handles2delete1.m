function delete_handles2delete1(gui_handle)
% Delete handles collected in field "handles2delete" of structure "userdata"
% saved in the application data of the GUI with handle "gui_handle"
% See also: "add_handle2delete1"
%
% Written by: E. Rietsch: October 21, 2006
% Last updated:
%
%             delete_handles2delete1(_gui_handle)
% INPUT
% gui_handle  handle of the GUI where the user data are stored

try
   userdata=getappdata(gui_handle,'userdata');
   if isempty(userdata)
      return
   elseif isfield(userdata,'handles2delete')
      temp=userdata.handles2delete;
      for ii=1:length(temp)
         try   
           delete(temp(ii))
         catch
     %  GUI/figure probably alrady deleted
         end
      end
      userdata=rmfield(userdata,'handles2delete');
      setappdata(gui_handle,'userdata',userdata)
   end
catch
   % Do nothing
end
