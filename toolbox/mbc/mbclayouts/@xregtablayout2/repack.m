function repack(obj)
%  Synopsis
%     function repack(obj)
%
%     obj is the packObject
%     
%  Description
%     This function reapplies the packing command to the objects in question

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:18 $


ud=get(obj.whiteline,'userdata');
if ~ud.tabsdrawn
   pr_draw3D(obj);
   pr_drawlabels(obj);
   ud.tabsdrawn=1;
   set(obj.whiteline,'userdata',ud);
end
repack(obj.xregcardlayout);
return