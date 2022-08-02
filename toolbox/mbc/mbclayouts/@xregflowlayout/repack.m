function  repack(obj,varargin)
%  Synopsis
%     function  repack(obj)
%
%     obj is the packObject
%     
%  Description
%     This function reapplies the packing command to the objects in question

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:59 $


ud=obj.g.info;
h = get(obj.xregcontainer,'elements');
gap=ud.gap;
nh=length(h);

pos=zeros(nh+1,4);
pos(1,:)=get(obj,'innerposition');
pos(1,3:4)=max(pos(1,3:4),[1 1]);

% prepare position matrices
if nh>0
   for n=2:nh+1
      pos(n,:)=get(h{n-1},'position');
   end
end

doexpand=find(strcmp(ud.expand,{'OFF','ON'}))-1;

if nh > 0
   switch upper(ud.orientation)
   case {'LEFT/TOP','LEFT'}
      if doexpand
         pos= gui_size_y_first(pos);
      end
      pos(1:2,:)=gui_align_left(pos(1:2,:),gap);
      pos(2:end,:)=gui_pack_left(pos(2:end,:),gap);
      pos=gui_align_top(pos,0);
   case 'LEFT/BOTTOM'
      if doexpand
         pos= gui_size_y_first(pos);
      end
      pos(1:2,:)=gui_align_left(pos(1:2,:),gap);
      pos(2:end,:)=gui_pack_left(pos(2:end,:),gap);
      pos=gui_align_bottom(pos,0);
   case 'LEFT/CENTER'
      if doexpand
         pos= gui_size_y_first(pos);
      end
      pos(1:2,:)=gui_align_left(pos(1:2,:),gap);
      pos(2:end,:)=gui_pack_left(pos(2:end,:),gap);
      pos=gui_align_middle(pos,0);
   case {'RIGHT/TOP','RIGHT'}
      if doexpand
         pos= gui_size_y_first(pos);
      end
      pos(1:2,:)=gui_align_right(pos(1:2,:),-gap);
      pos(2:end,:)=gui_pack_right(pos(2:end,:),gap);
      pos=gui_align_top(pos,0);
   case 'RIGHT/BOTTOM'
      if doexpand
         pos= gui_size_y_first(pos);
      end
      pos(1:2,:)=gui_align_right(pos(1:2,:),-gap);
      pos(2:end,:)=gui_pack_right(pos(2:end,:),gap);
      pos=gui_align_bottom(pos,0);
   case 'RIGHT/CENTER'
      if doexpand
         pos= gui_size_y_first(pos);
      end
      pos(1:2,:)=gui_align_right(pos(1:2,:),-gap);
      pos(2:end,:)=gui_pack_right(pos(2:end,:),gap);
      pos=gui_align_middle(pos,0);
   case {'TOP/LEFT','TOP'}
      if doexpand
         pos= gui_size_x_first(pos);
      end
      pos(1:2,:)=gui_align_top(pos(1:2,:),-gap);
      pos(2:end,:)=gui_pack_top(pos(2:end,:),gap);
      pos=gui_align_left(pos,0);
   case 'TOP/RIGHT'
      if doexpand
         pos= gui_size_x_first(pos);
      end
      pos(1:2,:)=gui_align_top(pos(1:2,:),-gap);
      pos(2:end,:)=gui_pack_top(pos(2:end,:),gap);
      pos=gui_align_right(pos,0);
   case 'TOP/CENTER'
      if doexpand
         pos= gui_size_x_first(pos);
      end
      pos(1:2,:)=gui_align_top(pos(1:2,:),-gap);
      pos(2:end,:)=gui_pack_top(pos(2:end,:),gap);
      pos=gui_align_center(pos,0);
   case {'BOTTOM/LEFT','BOTTOM'}
      if doexpand
         pos= gui_size_x_first(pos);
      end
      pos(1:2,:)=gui_align_bottom(pos(1:2,:),gap);
      pos(2:end,:)=gui_pack_bottom(pos(2:end,:),gap);
      pos=gui_align_left(pos,0);
   case 'BOTTOM/RIGHT'
      if doexpand
         pos= gui_size_x_first(pos);
      end
      pos(1:2,:)=gui_align_bottom(pos(1:2,:),gap);
      pos(2:end,:)=gui_pack_bottom(pos(2:end,:),gap);
      pos=gui_align_right(pos,0);
   case 'BOTTOM/CENTER'
      if doexpand
         pos= gui_size_x_first(pos);
      end
      pos(1:2,:)=gui_align_bottom(pos(1:2,:),gap);
      pos(2:end,:)=gui_pack_bottom(pos(2:end,:),gap);
      pos=gui_align_center(pos,0);
   end
   
   for n=1:nh
      set(h{n},'position',pos(n+1,:));
   end
end







