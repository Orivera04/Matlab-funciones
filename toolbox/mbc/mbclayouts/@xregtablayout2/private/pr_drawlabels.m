function pr_drawlabels(obj,sw)
% PR_DRAWLABELS  Reposition text labels on tabs
%
%   PR_DRAWLABELS(OBJ) repositions all labels
%   PR_DRAWLABELS(OBJ,[A B]) implements repositioning A and B
%   after a selection.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:17 $


ud=get(obj.whiteline,'userdata');
if ud.buttonloc==0
   pos=get(obj,'innerposition')-[1 2 -3 -23]-ud.innerborder;  % the extra points are taken already for the tabs!
elseif ud.buttonloc==1
   pos=get(obj,'innerposition')-[1 22 -3 -23]-ud.innerborder;  % the extra points are taken already for the tabs!
end
t_ext = ud.tabextents;
sel = get(obj.xregcardlayout,'currentcard');

sum_t_ext =sum(t_ext);
if sum_t_ext>(pos(3)-2)
   t_ext = (pos(3)-2).*t_ext./sum_t_ext;
end

ntabs = length(t_ext);
len_to_sel = [1 cumsum(t_ext)];

if nargin==1
   set(ud.tablabels(:),'visible','off');
   lab_pos = zeros(ntabs,4);
   lab_pos(:,4) = 15;
   if ud.buttonloc==0
      lab_pos(:,2) = pos(2)+pos(4)-19;
   elseif ud.buttonloc==1
      lab_pos(:,2) = pos(2)+4;
   end
   lab_pos(:,1) = pos(1)+1+len_to_sel(1:(end-1))'+7;
   lab_pos(:,3) = max(1,t_ext'-2-10);
   if ud.buttonloc==0
      lab_pos(sel,2) = lab_pos(sel,2)+2;
   elseif ud.buttonloc==1
      lab_pos(sel,2) = lab_pos(sel,2)-2;
   end
   
   % faster to loop over the set call than use num2cell (has loops anyway!)
   for i=1:ntabs
      set(ud.tablabels(i),'position',lab_pos(i,:));
   end
   if ud.visible
      set(ud.tablabels(:),'visible','on');
   end
elseif nargin==2
   if ud.buttonloc==0
      set(ud.tablabels(sw(1)),'position',get(ud.tablabels(sw(1)),'position')-[0 2 0 0]);
      set(ud.tablabels(sw(2)),'position',get(ud.tablabels(sw(2)),'position')+[0 2 0 0]);
   elseif ud.buttonloc==1
      set(ud.tablabels(sw(1)),'position',get(ud.tablabels(sw(1)),'position')+[0 2 0 0]);
      set(ud.tablabels(sw(2)),'position',get(ud.tablabels(sw(2)),'position')-[0 2 0 0]);
   end
end

return
