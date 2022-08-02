function obj = repack(obj,varargin)
%  Synopsis
%     function obj = repack(obj)
%
%  Description
%     This function reapplies the packing command to the objects in question

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:36:58 $


ud=get(obj.xregcontainer,'userdata');
h = get(obj,'ELEMENTS');
pos=get(obj,'innerposition');
pos=round(pos);

if ud.barstyle==0
   divw=10;
else
   divw=4;  % flat
end
split=ud.split;

if ud.orientation
   % up-down
   divw=min(divw,pos(4));
   sz=(pos(4)-divw);
   r1_wid=round(split(1).*sz);
   r2_wid= sz - r1_wid;
   or{1}=[pos(1) pos(2)+pos(4)-r1_wid pos(3) r1_wid];
   or{2}=[pos(1) pos(2) pos(3) r2_wid];
   btpos=[pos(1) pos(2)+r2_wid pos(3) divw];
else
   % left-right
   divw=min(divw,pos(3));
   sz=(pos(3)-divw);
   r1_wid=round(split(1).*sz);
   r2_wid= sz - r1_wid;
   or{1}=[pos(1) pos(2) r1_wid pos(4)];
   or{2}=[pos(1)+pos(3)-r2_wid pos(2) r2_wid pos(4)];
   btpos=[pos(1)+r1_wid pos(2) divw pos(4)];
end

set(ud.rsbutton,'position',btpos);
% pass on sizes to subobjects
% this object only supports up to two contained objects.  Any others are ignored

% apply inner borders
ibord=ud.innerborders;
or{1}=or{1}+[ibord(1,4) ibord(1,3) -(ibord(1,2)+ibord(1,4)) -(ibord(1,1)+ibord(1,3))];
or{2}=or{2}+[ibord(2,4) ibord(2,3) -(ibord(2,2)+ibord(2,4)) -(ibord(2,1)+ibord(2,3))];

stp=min(2,length(h));
for n=1:stp
   or{n}(3:4)=max([1 1],or{n}(3:4));
   set(h{n},'position',or{n});
end
