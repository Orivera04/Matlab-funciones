function sl=deselectitems(sl,ind)
% DESELECTITEMS   Manually select list items
%
%   L=DESELECTITEMS(L,INDS) marks the items referenced by
%   ind in the object L as deselected and moves them to the 
%   unselected list box.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:02 $

% Created 2/2/2000

ud=get(sl.baselist,'userdata');

listsz=length(ud.reallist);
ind(ind>listsz)=[];
ind=unique(ind);

ud.sel=setdiff(ud.sel,ind);
ud.unsel=union(ud.unsel,ind);

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
