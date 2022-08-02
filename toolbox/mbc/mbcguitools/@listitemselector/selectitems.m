function sl=selectitems(sl,ind)
% SELECTITEMS   Manually select list items
%
%   L=SELECTITEMS(L,INDS) marks the items referenced by
%   ind in the object L as selected and moves them to the 
%   selected list box.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:07 $

% Created 2/2/2000


ud=get(sl.baselist,'userdata');

listsz=length(ud.reallist);
ind(ind>listsz)=[];
ind=unique(ind);

ud.unsel=setdiff(ud.unsel,ind);
ud.sel=union(ud.sel,ind);

set(sl.baselist,'value',1,'string',ud.charlist(ud.unsel),'userdata',ud);
set(sl.sellist,'value',1,'string',ud.charlist(ud.sel));

h=[sl.remone;sl.remall; sl.addone;sl.addall];
en={'off';'off';'off';'off'};
if ~isempty(ud.sel)
   en(1:2)={'on'};
end
if ~isempty(ud.unsel)
   en(3:4)={'on'};
end
set(h,{'enable'},en);

return







