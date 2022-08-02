function mousetracker(srcobj,evt,obj,event)
% mousetracker
%
%  Pointer changer for splitlayout
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:09 $

fig=get(obj.xregcontainer,'parent');
ud=obj.datastore.info;
pr=xregGui.PointerRepository;
ID=ud.MousePtrID;
if event==1
   if ud.orientation
      ptr= 'uddrag';
   else
      ptr= 'lrdrag';
   end
   ud.MousePtrID=pr.stackSetPointer(fig,ptr);
   if ID>=0
      % ?? This normally means we are already "in" the region.  Try to remove the old pointer
      pr.stackRemovePointer(fig,ID);
   end
elseif event==-1
   if ud.MousePtrID>=0
      pr.stackRemovePointer(fig,ID);
      ud.MousePtrID=-1;
   end
end
obj.datastore.info=ud;