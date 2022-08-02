function mbcabout
%MBCABOUT  Open an "about" box displaying MBC information
%
%  MBCABOUT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:25:44 $

fH=xregdialog('Name','About MBC Toolbox','resize','off');
xregcenterfigure(fH,[522 500]);

% text to layer on top of image
txt1=axestext(fH,'string','Model-Based Calibration Toolbox','fontsize',16,'fontweight','bold',...
    'horizontalalignment','right','verticalalignment','top');
txt2=axestext(fH,'string',['Version ' mbcver],'fontsize',14,'fontweight','bold',...
    'horizontalalignment','right','verticalalignment','top');

% load splash image into an image object.
imH=xregGui.axesimage('parent',fH,...
    'image',xregresload('mbcsplash.bmp','bmp'));


clsbutton=uicontrol('parent',fH,'style','pushbutton',...
    'string','Close','callback','set(gcbf,''visible'',''off'');');

addontxt=uicontrol('style','text',...
    'parent',fH,...
    'horizontalalignment','left',...
    'string','The following packages of additional functionality have been detected by the MBC toolbox:');

addonlist=xregGui.listview([0 0 10 10],double(fH),{'ColumnClick','xreglvsorter'});
addonlist.FullRowSelect=1;
addonlist.View=3;
addonlist.LabelEdit=1;
addonlist.FullRowSelect=1;
addonlist.GridLines=1;

ch=addonlist.ColumnHeaders;
head= ch.Add;
head.Text='Name';
head.Width=300;
head= ch.Add;
head.Text='Version';
head.Width=100;

its=addonlist.listitems;
if ~isempty(findpackage('xregtools'))
    ext=xregtools.extensions;
end
for n=1:ext.NumAddOns
    it= its.Add;
    it.text=ext.AddOnNames{n};
    set(it,'subitems',1,ext.AddOnVersions{n});
end
if ~isempty(findpackage('cgtools'))
    ext=cgtools.extensions;
end
for n=1:ext.NumAddOns
    it= its.Add;
    it.text=ext.AddOnNames{n};
    set(it,'subitems',1,ext.AddOnVersions{n});
end


frmgrd=xreggridbaglayout(fH,'dimension',[2 1],...
    'packstatus','off',...
    'rowsizes',[15 -1],...
    'gapy',10,...
    'elements',{addontxt,actxcontainer(addonlist)});
botfrm=xregframetitlelayout(fH,...
    'center',frmgrd,...
    'title','Add ons',...
    'innerborder',[15 10 10 10]);

imfrm=xregpanellayout(fH,'innerborder',[0 0 0 0],...
    'center',imH);
txtgrid=xreggridbaglayout(fH,'dimension',[2 1],...
    'rowsizes',[30 30],...
    'border',[20 20 20 20],...
    'elements',{txt1,txt2});

layer=xreglayerlayout(fH,'elements',{imfrm,txtgrid});
grd=xreggridbaglayout(fH,...
    'dimension',[3 2],...
    'rowsizes',[302 -1 25],...
    'colsizes',[-1 65],...
    'gap',10,...
    'border',[10 10 10 10],...
    'mergeblock',{[1 1],[1 2]},...
    'mergeblock',{[2 2],[1 2]},...
    'elements',{layer,botfrm,[],[],[],clsbutton});


fH.LayoutManager=grd;
set(grd,'packstatus','on');
fH.showDialog(clsbutton);
delete(fH)
