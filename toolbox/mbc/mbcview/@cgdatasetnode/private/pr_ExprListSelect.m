function pr_ExprListSelect(list,index)
%pr_ExprListShow(list,index)
%  Select items corresponding to index

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:22:25 $

% Must be in bottom list
pr_DeselectList(list);
items = list.ListItems;
done = repmat(0,1,length(index));
for i=1:double(items.Count)
   this = items.Item(i);
   thisi = str2double(this.SubItems(pr_ExprListIndex));
   f = find(thisi==index);
   if ~isempty(f)
      set(this,'selected',1);
      done(f) = 1;
      if all(done)
         break
      end
   end
end
