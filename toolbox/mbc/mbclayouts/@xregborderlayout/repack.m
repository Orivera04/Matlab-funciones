function repack(obj)
%REPACK Repack the layout
%
%  REPACK(OBJ) recalculates the positions of all of the contained elements.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:34:46 $ 


h = get(obj.xregcontainer,'elements');
p = get(obj.xregcontainer,'innerposition');
p(3:4)=max(p(3:4),[1 1]);

el_pos = obj.hGrid.getPositions(p);
if ~isempty(h{1})
    set(h{1}, 'position', el_pos{4});
end
if ~isempty(h{2})
    set(h{2}, 'position', el_pos{8});
end
if ~isempty(h{3})
    set(h{3}, 'position', el_pos{6});
end
if ~isempty(h{4})
    set(h{4}, 'position', el_pos{2});
end
if ~isempty(h{5})
    set(h{5}, 'position', el_pos{5});
end