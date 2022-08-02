function repack(obj)
%  Synopsis
%     function repack(obj)
%     
%  Description
%     This function reapplies the packing command to the objects in question

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:59 $

h = get(obj,'ELEMENTS');
pos=get(obj,'innerposition');
pos(3:4)=max(pos(3:4),[1 1]);

ud=obj.g.info;

% only pack objects on the visible card, and mark as drawn
cdraw=ones(1,ud.numcards);
cdraw(ud.currentcard)=0;
ud.carddraw=cdraw;

crds=ud.cards;
if ~isempty(crds)
   dodraw=find(crds==ud.currentcard);
   for n=dodraw;
      set(h{n},'position',pos);
   end
end

obj.g.info=ud;
return
