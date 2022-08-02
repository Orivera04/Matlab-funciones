function obj = repack(obj,varargin)
%  Synopsis
%     function obj = repack(obj)
%     
%  Description
%     This function reapplies the packing command to the objects in question
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:10 $



ud=obj.datastore.info;
h = get(obj,'ELEMENTS');
pos=get(obj,'innerposition');

% Need to decide whether to nick N pixels for the resizer button
if ud.resizable
   nick=ud.divwidth;
else
   nick=0;
end

split=ud.split;
if ud.orientation
   % up-down
   sz=(pos(4)-nick);
   H2=round(split(2).*sz);
   H1=sz-H2;
   or{1}=round([pos(1) pos(2)+H2+nick pos(3) H1]);
   or{2}=round([pos(1) pos(2) pos(3) H2]);
   btpos=round([pos(1) pos(2)+H2 max(pos(3),1) ud.divwidth]);
else
   % left-right
   sz=(pos(3)-nick);
   W1=round(split(1).*sz);
   W2=sz-W1;
   or{1}=round([pos(1) pos(2) W1 pos(4)]);
   or{2}=round([pos(1)+W1+nick pos(2) W2 pos(4)]);
   btpos=round([pos(1)+W1 pos(2) ud.divwidth max(pos(4),1)]);
end
set(obj.rsbutton,'position',btpos);

% pass on sizes to subobjects
% this object only supports up to two contained objects.  Any others are ignored

% apply inner borders
ibord=ud.innerborderl;
or{1}=or{1}+[ibord(4) ibord(3) -(ibord(2)+ibord(4)) -(ibord(1)+ibord(3))];
ibord=ud.innerborderr;
or{2}=or{2}+[ibord(4) ibord(3) -(ibord(2)+ibord(4)) -(ibord(1)+ibord(3))];

stp=min(2,length(h));
for n=1:stp
   or{n}(3:4)=max([1 1],or{n}(3:4));
   set(h{n},'position',or{n});
end

