function  h=listview(T,pos,fH,callbacks,TreeCtrl,h)
% MCTREE/LISTVIEW listview activeX control for children of tre
%
% h= treecontrol(T,pos,fH,callbacks,TreeCtrl,h)
%
% where:
% pos	- a length 4 vector specifying position in pixels
% fH 	- figure handle
% callbacks - a cell array of strings specifying the event handling
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.10.4.3 $  $Date: 2004/02/09 06:47:55 $



if nargin>3
   % Create an instance of the Control
   if isempty(callbacks)
      h = xregGui.listview(pos,fH);
   else
      h = xregGui.listview(pos,fH,callbacks);
	end
	IL= imlistMBrowser(T);
   h.InsertSmallIcons(IL);
   
   h.View = 3;
   h.HideSelection = 0;
   h.GridLines = 1;
   h.MultiSelect = 1;
   h.FullRowSelect = 1;
   h.Parent = fH;
else
   h=pos;
   TreeCtrl= fH;
   h.ColumnHeaders.Clear;
   h.ListItems.Clear;
   pos= move(h);
end   

h.Sorted = 0;
h.LabelEdit = 1;

ch= children(T); 

OldUnits= get(0,'units');
spix= get(0,'ScreenSize');
set(0,'units','points');
spos= get(0,'ScreenSize');
set(0,'units',OldUnits);

wid= 144;

hCols= h.ColumnHeaders;
hItem= hCols.Add;
hItem.Text = [ChildType(T),'s'];
hItem.Width = wid;

if length(ch)>0
   SubList= children(T,'statistics');
   [s,ColHead,Width]= childstats(T);
	sok= ~all(~isfinite(s),1);
	if ~all(sok)
		s= s(:,sok);
		ColHead= ColHead(sok);
      Width= Width(sok);
   end
   Width= Width*0.7;
   
   for i= 1:length(ColHead)
      hItem= hCols.Add;
      set(hItem,...
         'Text', ColHead{i},...
         'Width', max(72,5*Width(i)*wid),...
         'Alignment', 'lvwColumnRight',...
         'Tag', 'num');
   end
   
   hListItems= h.ListItems;
   sp=1;
   for i=1:length(ch)
      Image= ch(i).icon;
      Name= ch(i).name;
      hItem= hListItems.Add;
      set(hItem,'Text',Name,...
         'ToolTipText',Name,...
         'SmallIcon',Image,...
         'Key',['K',deblank(num2str(double(ch(i))))]);
      
      if ~isempty(SubList{i})
         for j=1:min(length(ColHead),size(s,2))
            if isfinite(s(sp,j))
               set(hItem,'SubItems',j,num2str(s(sp,j)) );
            end
         end
         sp= sp+1;
      end
   end	
   h.SelectedItem = hListItems.Item(1);
end


