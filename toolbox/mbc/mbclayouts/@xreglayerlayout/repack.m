function repack(obj)
%  Synopsis
%     function repack(obj)
%
%     obj is the packObject
%     
%  Description
%     This function reapplies the packing command to the objects in question

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:25 $


h = get(obj,'ELEMENTS');
pos=get(obj,'innerposition');
pos(3:4)=max(pos(3:4),[1 1]);
for n=1:length(h);
   set(h{n},'position',pos);
end
