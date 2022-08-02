function cbselect(obj,ind)
% CBSELECT   Item selection callback for texlistbox
%
%   CBSELECT(OBJ,IND)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:20:35 $

% Created 5/10/2000

ud=get(obj.xreglistctrl,'userdata');

if ud.selmode
   % multi-selection
   % test for button press type
   sel=get(ud.parent,'selectiontype');
   switch sel
   case {'normal','open'}
      if isempty(ud.value) | any(ind~=ud.value)
         set(obj,'value',ind);
      else
         return
      end
   case 'alt'
      % Ctrl-click
      newval=setxor(ud.value,ind);
      set(obj,'value',newval);
      
      ud=get(obj.xreglistctrl,'userdata');
      if isempty(newval) | ~any(newval==ind)
         ud.multiclickind=-ind;
      else
         ud.multiclickind=ind;
      end
      set(obj.xreglistctrl,'userdata',ud);
   case 'extend'
      % Shift-click
      stind=ud.multiclickind;
      if stind<0
         stind=-stind;
         if stind<ind
            stind=stind+1;
         elseif stind>ind
            stind=stind-1;
         else
            return
         end
      end
      if stind>ind
         newval=stind:-1:ind;
      else
         newval=stind:1:ind;
      end
      set(obj,'value',newval);
      
      % maintain last click selection
      ud=get(obj.xreglistctrl,'userdata');
      ud.multiclickind=stind;
      set(obj.xreglistctrl,'userdata',ud);
   end
else
   % single selection
   if isempty(ud.value) | ind~=ud.value
      set(obj,'value',ind);
   else
      return
   end
end


% fire callback
ud=get(obj.xreglistctrl,'userdata');
evalin('base',ud.callback);


return

