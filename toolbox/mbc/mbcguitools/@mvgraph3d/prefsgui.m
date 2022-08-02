function gr=prefsgui(gr,varargin)
%PREFSGUI Preferences GUI for graph3d objects
%  
%  PREFSGUI(GR) opens a GUI for altering general preferences in the 
%  graph3d object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:27:59 $

scrsz=get(0,'screensize');
figh=xregdialog('position',[scrsz(3)/2-145 scrsz(4)/2-140 290 270],...
    'name','3D Graph Options',...
    'resize','off');

lyt=i_createlyt(figh,gr);

% ok and cancel buttons
okbtn=uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','OK',...
    'callback','set(gcbf, ''tag'', ''ok'', ''visible'', ''off'');');
cancbtn=uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','Cancel',...
    'callback','set(gcbf, ''tag'', ''cancel'', ''visible'', ''off'');');
applybtn=uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','Apply',...
    'callback',{@i_apply, gr});

main = xreggridbaglayout(figh, 'dimension', [2 4], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 65 65], ...
    'border', [10 10 10 10], ...
    'gapx', 7, ...
    'gapy', 10, ...
    'mergeblock', {[1 1], [1 4]}, ...
    'elements', {lyt, [], [], okbtn, [], cancbtn, [], applybtn});
figh.LayoutManager = main;
set(main, 'packstatus', 'on');
figh.showDialog(okbtn);

tg = get(figh, 'tag');
if strcmp(tg, 'ok')
    % Apply changes before deleting figure
    i_apply(applybtn, [], gr);
end

delete(figh);
return


function lyt=i_createlyt(figh,gr)

% Colors
ud.axcol=get(gr.axes,'color');
ud.gen.axcol.edit=uicontrol('style','edit',...
    'parent',figh,...
    'backgroundcolor',[1 1 1],...
    'callback',{@i_editchcol, gr, 'gen.axcol.push'});
ud.gen.axcol.push=uicontrol('style','toggle',...
    'value',0,...
    'callback',{@i_interactivechcol, gr, 'gen.axcol.edit'},...
    'parent',figh);
ud.gen.axcol.text=xregGui.labelcontrol('parent',figh,...
    'controlsize', 75, ...
    'string','Axes color:', ...
    'control', ud.gen.axcol.edit);

if ischar(ud.axcol)
    set([ud.gen.axcol.edit],'string','none');
else   
    set(ud.gen.axcol.push,'backgroundcolor',ud.axcol);
    set(ud.gen.axcol.edit,'string',['[' num2str(ud.axcol(1)) ' ' num2str(ud.axcol(2)) ' ' num2str(ud.axcol(3)) ']']);
end

ud.lbcol=get(gr.axes,'xcolor');
ud.gen.fgcol.edit=uicontrol('style','edit',...
    'parent',figh,...
    'backgroundcolor',[1 1 1],...
    'string',['[' num2str(ud.lbcol(1)) ' ' num2str(ud.lbcol(2)) ' ' num2str(ud.lbcol(3)) ']'],...
    'callback',{@i_editchcol, gr, 'gen.fgcol.push'});
ud.gen.fgcol.push=uicontrol('style','toggle',...
    'value',0,...
    'backgroundcolor',ud.lbcol,...
    'callback',{@i_interactivechcol, gr, 'gen.fgcol.edit'},...
    'parent',figh);
ud.gen.fgcol.text=xregGui.labelcontrol('parent',figh,...
    'controlsize', 75, ...
    'string','Axes'' markings color:', ...
    'control', ud.gen.fgcol.edit);

val=zeros(2,2);
st=get(gr.axes,'gridlinestyle');
val(find(strcmp(st,{'-',':','--','-.'})))=1;
if ~any(val)
    val(1)=1;
end
ud.hist.gridstyle=xregGui.rbgroup(figh,'nx',2,'ny',2, ...
    'string',{'solid','dashed';'dotted','dash-dot'},...
    'value',val);

grs = get(gr.axes,{'xgrid','ygrid','zgrid'});
val = strcmp(grs,'on');
% grid direction on/off
ud.hist.gridx.roll=uicontrol('parent', figh,...
    'style', 'checkbox', ... 
    'string','X-direction',...
    'value',val(1));
ud.hist.gridy.roll=uicontrol('parent', figh,...
    'style', 'checkbox', ...
    'string','Y-direction',...
    'value',val(2));
ud.hist.gridz.roll=uicontrol('parent', figh,...
    'style', 'checkbox', ...
    'string','Z-direction',...
    'value',val(3)); 

proj=get(gr.axes,'projection');
val=strcmp(proj,{'orthographic','perspective'});
ud.axesproj.type=xregGui.rbgroup(figh,'nx',2,'ny',1,...
    'string',{'Orthographic','Perspective'},'value',val);
ud.axesproj.txt=xregGui.labelcontrol('parent',figh,...
    'controlsize', 180, ...
    'string','Axes projection:', ...
    'control', ud.axesproj.type, ...
    'BaselineOffsetMode', 'manual');

grd1 = xreggridbaglayout(figh, 'packstatus', 'off', ...
    'dimension', [2 2], ...
    'rowsizes', [20 20], ...
    'colsizes', [190 30], ...
    'gapx', 5, ...
    'gapy', 3, ...
    'elements', {ud.gen.axcol.text, ud.gen.fgcol.text, ud.gen.axcol.push, ud.gen.fgcol.push});
frm1 = xregframetitlelayout(figh, 'title', 'Colors', ...
    'center', grd1, ...
    'innerborder', [15 10 10 10]);
grd2 = xreggridbaglayout(figh, 'dimension', [3 2], ...
    'rowsizes', [20 20 20], ...
    'colsizes', [100 -1], ...
    'gapx', 10, ...
    'gapy', 3, ...
    'mergeblock', {[1 2], [2 2]}, ...
    'elements', {ud.hist.gridx.roll, ud.hist.gridy.roll, ud.hist.gridz.roll, ud.hist.gridstyle});
frm2 = xregframetitlelayout(figh, 'title', 'Grid', ...
    'center', grd2, ...
    'innerborder', [15 10 10 10]);
lyt = xreggridbaglayout(figh, 'dimension', [3 1], ...
    'rowsizes', [78, 100, 20], ...
    'gapy', 10, ...
    'elements', {frm1, frm2, ud.axesproj.txt});

ud.graph=gr;
set(figh,'userdata',ud);
return


function i_apply(src, evt, gr)
figh = get(src, 'parent');
ud=get(figh,'userdata');

% update object
vis=get(gr.axes,'visible');
set(gr,'visible','off');
axcol=get(ud.gen.axcol.edit,'string');
if strcmp(axcol,'none')
    set(gr.axes,'color','none');
else
    set(gr.axes,'color',get(ud.gen.axcol.push,'backgroundcolor'));
end
col=get(ud.gen.fgcol.push,'backgroundcolor');
set([gr.axes;gr.colorbar.axes],{'xcolor','ycolor','zcolor'},{col,col,col});
set([gr.xtext;gr.ytext;gr.ztext], 'foregroundcolor',col);
set(get(gr.colorbar.axes,'title'),'color',col);

val(1)=get(ud.hist.gridx.roll,'value');
val(2)=get(ud.hist.gridy.roll,'value');
val(3)=get(ud.hist.gridz.roll,'value');
grs=repmat({'off'},1,3);
grs(val~=0)={'on'};
set(gr.axes,{'xgrid','ygrid','zgrid'},grs);
grids={'-',':','--','-.'};
val=get(ud.hist.gridstyle,'selected');
set(gr.axes,'gridlinestyle',grids{val}); 

proj={'orthographic','perspective'};
proj=proj{get(ud.axesproj.type,'selected')};
set(gr.axes,'projection',proj);

set(gr,'visible',vis);
return


function i_editchcol(src, evt, gr, field)
figh= get(src, 'parent');
ud=get(figh,'userdata');
changeobj=i_getfield(ud,field);

% grab string
str=get(src,'string');
if strcmp(str,'none')
    set(changeobj,'backgroundcolor',get(0,'defaultuicontrolbackgroundcolor'));
    set(src,'string','none');
else
    col=str2num(str);
    if length(col(:))~=3 || any(col>1 | col<0)  
        % revert
        col=get(changeobj(1),'backgroundcolor');
        set(src,'string',['[' num2str(col(1)) ' ' num2str(col(2)) ' ' num2str(col(3)) ']']);
    else
        set(changeobj,'backgroundcolor',col);
    end
end  


function i_interactivechcol(src, evt, gr, field)
figh= get(src, 'parent');
ud=get(figh,'userdata');
changeobj=i_getfield(ud,field);

col=get(src,'backgroundcolor');
col2=uisetcolor(col);
if ~all(col2==col)
    set(src,'backgroundcolor',col2,'value',0);
    set(changeobj,'string',['[' num2str(col2(1),2) ' ' num2str(col2(2),2) ' ' num2str(col2(3),2) ']']);
else
    set(src,'value',0);
end



%========================================================================
% i_getfield......replacement for external getfield
%========================================================================

function [out]=i_getfield(base,ext)
% parse ext for .'s
dots=findstr(ext,'.');
% set up subsrefs structs
if isempty(dots)
    s=struct('type','.','subs',ext);
else
    dots=[1 dots+1 length(ext)+2];
    for n=1:(length(dots)-1)
        sbs(n)={ext(dots(n):(dots(n+1)-2))};
    end
    s=struct('type',repmat({'.'},1,length(dots)-1),'subs',sbs);
end
out=subsref(base,s);
return