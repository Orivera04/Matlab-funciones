function obj = repack(obj)
%  Synopsis
%     function obj = repack(obj)
%
%  Description
%     This function reapplies the packing command to the objects in question
%     If recurse is set to yes the packing is applied to all lower
%     level objects as well. Use the recurse option for example when
%     one of your objects has to resize itself depending on the position
%     of some other things.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:05 $

ud=get(obj.blackline,'userdata');
h = get(obj,'ELEMENTS');
pos=get(obj,'innerposition')+[2 2 -4 -4];

% redo 3d line rendering
pr_3dlines(obj);

if length(h)
   bord=ud.borders;
   axsz=pos(4);
   pos=pos+[bord(4) bord(3) -(bord(2)+bord(4)) -(bord(1)+bord(3))];
   if ud.tagtext
      % take off a bit at the top for the tag object
      pos=pos-[0 0 0 ud.tagextent(4)];
   end
   
   % pass on sizes to subobjects
   % this object only supports one contained object.  Any others are ignored
   pos(3:4)=max([1 1],pos(3:4));
   set(h{1},'position',pos);
end
