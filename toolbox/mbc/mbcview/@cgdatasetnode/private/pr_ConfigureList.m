function pr_ConfigureList(lh,th,cols,width,title,tt)
% pr_ConfigureList(list,titlehandle,cols,width,title,tooltip)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:22:20 $

set(lh,'multiselect',true);
set(lh,'hideselection',false);
LI = lh.ListItems;
LI.Clear;
if ischar(cols)
    if strcmp(lower(cols),'empty')
        cols = {' '};
        set(lh,'hideselection',true);
        set(lh,'inactive',true);
        hand = LI.Add;
        set(hand,'text',width);
        width = 400;
    else
        cols = {cols};
    end
end

% Check if same thing being created; do not alter column widths
redo = true;
COLH = lh.ColumnHeaders;
if lh.ColumnHeaders.Count == length(cols)
   redo = false;
   for i = 1:length(cols)
      if ~strcmp(get(COLH.Item(i),'text'),cols{i})
         redo = true;
         break
      end
   end
end
if redo
   COLH.Clear;
   for i = 1:length(cols)
      hItem = COLH.Add;
      set(hItem , 'text' , cols{i});
      set(hItem , 'width' , width(i));
   end
end

set(lh,'sortkey',0);
set(lh,'sortorder',0);
set(lh,'inactive',false);
if ~isempty(strmatch(get(lh, 'userdata'), {'tables';'factors';'rules'}, 'exact'))
   set(lh,'fullrowselect',true);
else
   set(lh,'fullrowselect',false);
end

if nargin<5, title = ''; end
if nargin<6, tt = ''; end
set(th, 'title', title, 'titletooltipstring', tt);
