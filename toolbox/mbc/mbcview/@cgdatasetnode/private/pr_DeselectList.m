function old_sel = pr_DeselectList(list)
%old_sel = pr_DeselectList(list)
% Deselect everything in list.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:22:22 $

if get(get(list,'listitems'),'count')==0
    old_sel = [];
    return
end
old_sel = get(list,'SelectedItemIndex');
if length(old_sel)>1 | old_sel~=-1
    for i = 1:length(old_sel)
        this = list.ListItems.Item(old_sel(i));
        set(this,'selected',0);
    end
else
    old_sel = [];
end
