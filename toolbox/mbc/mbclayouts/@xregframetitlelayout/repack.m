function obj = repack(obj,varargin)
%  Synopsis
%     function obj = repack(obj)
%
%     obj is the xregframetitlelayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:13 $


ud=get(obj.title,'userdata');
cdata=get(obj.xregcontainer,'containerdata');
h = cdata.elements;
pos=cdata.innerposition;
% decide position for axes, text
framepos=pos;
if ud.title
   pos(4)=pos(4)-6;  
end
% assume title has correct x length
ttlpos=get(obj.title,'position');
ttlpos=[pos(1)+10 pos(2)+pos(4)-10 ttlpos(3) min(16,pos(4)+6)];
% set frame
pos(3)=max(5,pos(3));
pos(4)=max(5,pos(4));
ttlpos(3)=max(1,ttlpos(3));
ttlpos(4)=max(1,ttlpos(4));


set(obj.title,'position',ttlpos);
% do the 3d etched lines
pr_3dlines(obj);

bord=ud.borders;
pos=pos+[bord(4) bord(3) -(bord(2)+bord(4)) -(bord(1)+bord(3))];

% pass on sizes to subobjects
% this object only supports one contained object.  Any others are ignored
if length(h)
   pos(3:4)=max([1 1],pos(3:4));
   set(h{1},'position',pos);
end
