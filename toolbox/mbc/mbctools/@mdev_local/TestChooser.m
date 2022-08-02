function SNo= TestChooser(mdev);
%TESTCHOOSER activeX listview to choose tests

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.3 $  $Date: 2004/02/09 08:04:15 $

[fH,h]= i_create;

hCols= h.ColumnHeaders;
hItem= invoke(hCols,'Add');
hItem.Text= 'Number';
hItem.Width= 50;
set(hItem,'tag', 'num');

hItem= invoke(hCols,'Add');
hItem.Text= 'Note';
hItem.Width= 300;

%set(hItem,'Alignment','lvwColumnRight');


Y= getdata(mdev,'Y');
TNo= testnum(Y);
hListItems= h.ListItems;
for i=1:size(Y,3);
   
   col=  sum(bitshift( fix((2^8-1)*mdev.Notes{i,2}),[0 8 16] ) ) ;
   
   hItem= invoke(hListItems,'Add');
   set(hItem,'key',['T',deblank(int2str(i)) ]);
   hItem.Text= num2str(TNo(i));
   hItem.ForeColor= uint32(col) ;

   set(hItem,'SubItems',1,char(mdev.Notes{i,1}) );
   
   
   s= get(get(hItem,'ListSubItems'),'Item',1);
   if mdev.FitOK(i)
      set(s,'ForeColor',col);
   else
      hItem.ForeColor= uint32(0) ;
      s.Text= 'Not Fitted';
      s.ForeColor= uint32(0) ;
   end

end

View= GetViewData(MBrowser);

h.SelectedItem= get(hListItems,'Item',View.SweepPos);
invoke(h.SelectedItem,'EnsureVisible');

SNo=1;

set(fH,'visible','on')

waitfor(fH,'tag')
SNo= 0;
if ishandle(fH)
   if strcmp(get(fH,'tag'),'ok')
      Key= get(h.SelectedItem,'key');
      SNo= str2num(Key(2:end));
   end
   delete(fH);
end



function [fH,h]= i_create;

fH= xregfigure('name','Test Selector',...
    'WindowStyle','modal',...
    'position',[100 100 440 400],...
    'visible','off');

h = xregGui.listview([20 50 400 300],double(fH),...
    {'columnclick','xreglvsorter';'DblClick','xregtestsel'});

h.View = 3;
h.HideSelection = 0;
h.GridLines = 0;
h.MultiSelect = 0;
h.FullRowSelect = 1;
h.Parent = double(fH);
h.Sorted = 0;
h.LabelEdit = 1;


okbtn = uicontrol('parent',fH,...
   'string','OK',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'position',[0 0 65 25]);
cancbtn = uicontrol('parent',fH,...
   'string','Cancel',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''cancel'');',...
   'position',[0 0 65 25]);

flw=xregflowlayout(fH,'orientation','right/bottom',...
   'elements',{cancbtn,okbtn},...
   'gap',7,...
   'border',[0 10 -7 10]);
brd=xregborderlayout(fH,'center',actxcontainer(h),'south',flw,...
   'innerborder',[20 45 20 20],...
   'packstatus','on');

fH.LayoutManager= brd;
xregcenterfigure(fH);
