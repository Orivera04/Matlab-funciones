function gr=prefsgui(gr,varargin)
%PREFSGUI Preferences GUI for mvgraph2d objects
%   GUI function for altering general preferences in the mvgraph2d object
%   Usage:
%   PREFSGUI(GR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:19:08 $

if nargin==1
    action='create';
else
    action=varargin{1};
end


switch lower(action)
    case 'create'   
        objud = gr.DataPointer.info;
        scrsz=get(0,'screensize');
        figh=xregfigure('visible','off',...
            'position',[scrsz(3)/2-145 scrsz(4)/2-130 290 238],...
            'name','2D Graph Options',...
            'units','pixels',...
            'resize','off');
        pUD = xregGui.RunTimePointer;
        pUD.LinkToObject(figh);
        
        ud.axcol=get(gr.axes,'xcolor');
        ud.gen.axcol.edit=uicontrol('style','edit',...
            'parent',figh,...
            'backgroundcolor',[1 1 1],...
            'string',['[' num2str(ud.axcol(1)) ' ' num2str(ud.axcol(2)) ' ' num2str(ud.axcol(3)) ']'],...
            'callback', {@i_editchcol, pUD, 'gen.axcol.push'});
        ud.gen.axcol.push=uicontrol('style','toggle',...
            'value',0,...
            'backgroundcolor',ud.axcol,...
            'callback',{@i_interactivechcol, pUD, 'gen.axcol.edit'}, ...
            'parent',figh);
        txt(1) = xregGui.labelcontrol('parent', figh, ...
            'string', 'Axes color:', ...
            'controlsize', 75, ...
            'Control', ud.gen.axcol.edit);
        
        ud.lncol=get(gr.line,'markerfacecolor');
        ud.gen.lncol.edit=uicontrol('style','edit',...
            'parent',figh,...
            'backgroundcolor',[1 1 1],...
            'string',['[' num2str(ud.lncol(1)) ' ' num2str(ud.lncol(2)) ' ' num2str(ud.lncol(3)) ']'],...
            'callback',{@i_editchcol, pUD, 'gen.lncol.push'});
        ud.gen.lncol.push=uicontrol('style','toggle',...
            'value',0,...
            'backgroundcolor',ud.lncol,...
            'callback',{@i_interactivechcol, pUD, 'gen.lncol.edit'},...
            'parent',figh);
        txt(2) = xregGui.labelcontrol('parent', figh, ...
            'string', 'Plot color:', ...
            'controlsize', 75, ...
            'Control', ud.gen.lncol.edit);
        
        ud.gen.lnsize.edit=xregGui.clickedit(figh,'min',1,'max',inf,'rule','int',...
            'clickincrement',1,'dragincrement',1,...
            'value',get(gr,'markersize'));
        txt(3) = xregGui.labelcontrol('parent', figh, ...
            'string', 'Plot marker size:', ...
            'controlsize', 75, ...
            'Control', ud.gen.lnsize.edit);  
        
        if objud.grid
            val=1;
        else
            val=0;
        end
        ud.hist.usegrid=uicontrol('style','checkbox',...
            'parent',figh,...
            'string','Show gridlines',...
            'value',val,...
            'callback',{@i_usegrid, pUD});
        if val
            en='on';
        else
            en='off';
        end
        ud.hist.gridstyletext=uicontrol('style','text',...
            'horizontalalignment','left',...
            'parent',figh,...
            'string','Gridline style:',...
            'enable',en);
        val=zeros(2,2);
        st=get(gr.axes,'gridlinestyle');
        switch lower(st)
            case '-'
                val(1)=1;
            case ':'
                val(2)=1;
            case '--'
                val(3)=1;
            case '-.'
                val(4)=1;
            otherwise
                val(1)=1;
        end
        ud.hist.gridstyle=xregGui.rbgroup(figh,'nx',2,'ny',2,'value',val,'string',...
            {'solid','dashed';'dotted','dash-dot'},...
            'enable',en);
        
        % ok and cancel buttons
        okbtn=uicontrol('style','pushbutton',...
            'parent',figh,...
            'position',[145 7 65 25],...
            'string','OK',...
            'callback',{@i_ok, pUD, gr});
        cancbtn=uicontrol('style','pushbutton',...
            'parent',figh,...
            'position',[218 7 65 25],...
            'string','Cancel',...
            'callback',{@i_cancel, figh});
        applybtn=uicontrol('style','pushbutton',...
            'parent',figh,...
            'position',[218 7 65 25],...
            'string','Apply',...
            'callback',{@i_apply, pUD, gr});
        
        
        grd1 = xreggridbaglayout(figh, 'packstatus', 'off', ...
            'dimension', [3 2], ...
            'rowsizes', [20 20 20], ...
            'colsizes', [180 30], ...
            'gapx', 5, ...
            'gapy', 3, ...
            'elements', {txt(1), txt(2), txt(3), ud.gen.axcol.push, ud.gen.lncol.push});
        frm1=xregframetitlelayout(figh,'center',grd1,'innerborder',[10 10 10 10],'title','General');
        grd2 = xreggridbaglayout(figh, 'dimension', [2 2], ...
            'rowsizes', [20 -1], ...
            'colsizes', [80 -1], ...
            'mergeblock', {[1 1], [1 2]}, ...
            'elements', {ud.hist.usegrid, ud.hist.gridstyletext, [], ud.hist.gridstyle});
        frm2=xregframetitlelayout(figh,'center',grd2,'innerborder',[10 10 5 10],'title','Scatter plot');
        mainlyt = xreggridbaglayout(figh, 'dimension', [3 4], ...
            'rowsizes', [90 -1 25], ...
            'colsizes', [-1 65 65 65], ...
            'gapx', 7, ...
            'gapy', 10, ...
            'border', [10 10 10 10], ...
            'mergeblock', {[1 1], [1 4]}, ...
            'mergeblock', {[2 2], [1 4]}, ...
            'elements', {frm1, frm2, [], [], [], okbtn, [], [], cancbtn, [], [], applybtn}, ...
            'container', double(figh), ...
            'packstatus', 'on');
        
        ud.figure = figh;
        pUD.info = ud;
        set(figh,'visible','on',...
            'closerequestfcn',{@i_cancel, figh});
        drawnow;
        set(figh,'windowstyle','modal');
        waitfor(figh,'tag','finished');
        
        delete(figh);
end



function i_cancel(src, evt, figh)
set(figh, 'tag','finished');

function i_ok(src, evt, pUD, gr)
i_applydata(gr,pUD);
ud = pUD.info;
set(ud.figure,'tag','finished');

function i_apply(src, evt, pUD, gr)
i_applydata(gr,pUD);



function i_usegrid(src, evt, pUD)
ud = pUD.info;
% need to enable/disable stuff
if get(ud.hist.usegrid,'value')
    en='on';
else
    en='off';
end
set(ud.hist.gridstyletext,'enable',en);
set(ud.hist.gridstyle,'enable',en);


function i_editchcol(src, evt, pUD, field)
ud = pUD.info;
changeobj=i_getfield(ud,field);
% grab string 
str=get(src,'string');
if strcmp(str,'none')
    set(changeobj,'backgroundcolor',get(0,'defaultuicontrolbackgroundcolor'));      
else
    col=str2num(str);
    if length(col(:))~=3 || any(col>1 | col<0)
        col = get(changeobj,'backgroundcolor');
        set(obj,'string',['[' num2str(col(1)) ' ' num2str(col(2)) ' ' num2str(col(3)) ']']);
    else
        set(changeobj,'backgroundcolor',col);
    end
end


function i_interactivechcol(src, evt, pUD, field)
ud = pUD.info;
changeobj=i_getfield(ud,field);
col=get(src,'backgroundcolor');
col2=uisetcolor(col);
if ~all(col2==col)
    set(src,'backgroundcolor',col2,'value',0);
    set(changeobj,'string',['[' num2str(col2(1),2) ' ' num2str(col2(2),2) ' ' num2str(col2(3),2) ']']);
else
    set(src,'value',0);
end


function i_applydata(gr,pUD)
ud = pUD.info;

vis=get(gr.axes,'visible');
set(gr,'visible','off');

col=get(ud.gen.axcol.push,'backgroundcolor');
set([gr.axes;gr.colorbar.axes],{'xcolor','ycolor','zcolor'},{col,col,col});
set([gr.xtext;gr.ytext],'foregroundcolor',col);
set(gr.line,'markerfacecolor',get(ud.gen.lncol.push,'backgroundcolor'));
set(gr.line,'markersize',get(ud.gen.lnsize.edit,'value'));

if get(ud.hist.usegrid,'value')
    grd='on';
else
    grd='off';
end
set(gr,'grid',grd);
grids={'-',':','--','-.'};
val=get(ud.hist.gridstyle,'selected');
set(gr.axes,'gridlinestyle',grids{val});

set(gr,'visible',vis);



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