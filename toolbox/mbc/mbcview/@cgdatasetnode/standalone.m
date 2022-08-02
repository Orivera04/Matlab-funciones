function standalone(nd)
%STANDALONE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:22:59 $

c = cgbrowser;
cfh = c.Figure;
pos = get(cfh,'position');
pos = pos + [20+200 -20 -200 0];
f = figure('menubar','none','position',pos,...
    'color',get(0,'defaultuicontrolbackgroundcolor'),...
    'renderer','zbuffer',...
    'numbertitle','off',...
    'tag','XX_DatasetViewer_XX',...
    'name','Data Set Viewer');
vm = uimenu(f,'label','View');
tm = uimenu(f,'label','Tools');
info = struct('Figure',f,...
    'ViewMenuH',vm,...
    'ToolsMenuH',tm);

[lyt,tblyt,d]= creategui(nd,info);

set(lyt,'north',tblyt,...
    'container',f,...
    'border',[5 5 5 0],...
    'innerborder',[0 0 0 33],...
    'packstatus','on',...
    'visible','on');

set(f,'resizefcn',{@i_Repack,lyt});

c.setViewData(d);

d=show(nd,c,d);
d=view(nd,c,d);
c.setViewData(d);


function i_Repack(src,ev,bl)
repack(bl);