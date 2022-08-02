function h = plot(rules,ax,xfac,yfac,cb,cur_rule)
% handles = Plot(rules,axes,xfac,yfac,cur_rule)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:55:25 $

persistent handles

if nargin<6 | isempty(cur_rule), cur_rule = 0; end
if nargin<2
    error('axis required');
end

f = find(ishandle(handles));
handles = handles(f);

if length(handles)>=length(rules.fact_i1)
    delete(handles(length(rules.fact_i1)+1:end));
    handles = handles(1:length(rules.fact_i1));
else
    for i = length(handles)+1:length(rules.fact_i1)
        handles = [handles xregGui.line('parent',ax)];
    end
end
h = handles;
if ~isempty(rules.fact_i1)
    for i = 1:length(rules.fact_i1)
        
        xlim = get(ax,'xlim');
        ylim = get(ax,'ylim');
        xmin = xlim(1); xmax = xlim(2);
        ymin = ylim(1); ymax = ylim(2);
        mask = [0 0];
        if xfac==rules.fact_i1(i)
            xmin = rules.min1(i);
            xmax = rules.max1(i);
            mask(1) = 1;
        elseif xfac==rules.fact_i2(i)
            xmin = rules.min2(i);
            xmax = rules.max2(i);
            mask(1) = 2;
        end
        if yfac==rules.fact_i1(i)
            ymin = rules.min1(i);
            ymax = rules.max1(i);
            mask(2) = 1;
        elseif yfac==rules.fact_i2(i)
            ymin = rules.min2(i);
            ymax = rules.max2(i);
            mask(2) = 2;
        end
        if i==cur_rule & rules.enable(i)
            width = 4;
            bdf = {@i_dragbox,ax,cb,mask};
        else
            if i==cur_rule
                width = 2;
            else
                width = 0.5;
            end
            bdf = [];
        end
        if rules.enable(i)
            style = '-';
        else
            style = '-.';
        end
        if rules.exclude(i)
            col = 'r';
        else
            col = 'k';
        end
        set(h(i),'xdata',[xmin xmin xmax xmax xmin],...
            'ydata',[ymin ymax ymax ymin ymin],...
            'parent',ax,'linewidth',width,'color',col,...
            'linestyle',style,...
            'visible','on',...
            'buttondownfcn',bdf);
    end
end

handles = h;

%------------------------
function i_dragbox(lh,ev,ax,cb,mask)
%------------------------
pt=get(ax,'currentpoint');
pt = pt(1,1:2);

% Work out which side or corner is being dragged
% Convert to pixels

% get the axes position and 
oldunits=get(ax,'units');
set(ax,'units','pixels');
apos=get(ax,'pos');
set(ax,'units',oldunits);
xlim=get(ax,'xlim');
xlen=xlim(2)-xlim(1);
ylim=get(ax,'ylim');
ylen=ylim(2)-ylim(1);

% get ratios to convert pt to pixel units.
xratio=xlen/apos(3);
yratio=ylen/apos(4);

% check for a shift in x or y
xshift=(0-xlim(1));
yshift=(0-ylim(1));

% convert pt into pixels from bottom left of axes.
pt=[((pt(1)+xshift)/xratio) ((pt(2)+yshift)/yratio)];

% Get line position
xdata = get(lh,'xdata');
ydata = get(lh,'ydata');
% Now convert box edges
xminpt=((xdata(1)+xshift)/xratio);
xmaxpt=((xdata(4)+xshift)/xratio);
yminpt=((ydata(1)+yshift)/yratio);
ymaxpt=((ydata(2)+yshift)/yratio);

% Check edges
% Store as N E S W
click = repmat(0,1,4);
click(1) = (abs(pt(2)-ymaxpt)<5);
click(3) = (abs(pt(2)-yminpt)<5);
click(4) = (abs(pt(1)-xminpt)<5);
click(2) = (abs(pt(1)-xmaxpt)<5);
if all(click([1 3]))
    click(3) = 0;
end
if all(click([2 4]))
    click(4) = 0;
end
% prevent x/y limits moving, if not affected by this view
filter = mask([2 1 2 1]);
click = click & filter;

if any(click)
    if click(1)
        if click(2)
            ptrtype = 'topr';
        elseif click(4)
            ptrtype = 'topl';
        else
            ptrtype = 'top';
        end
    elseif click(3)
        if click(2)
            ptrtype = 'botr';
        elseif click(4)
            ptrtype = 'botl';
        else
            ptrtype = 'bottom';
        end
    elseif click(2)
        ptrtype = 'right';
    else
        ptrtype = 'left';
    end
    
    figh = get(ax,'parent');
    PR = xregGui.PointerRepository;
    ID = PR.stackSetPointer(figh,ptrtype);
    Manager=MotionManager(figh);
    Manager.EnableTree=false;
    upfcn=get(figh,'windowbuttonupfcn');
    set(figh,'windowbuttonupfcn',{@i_buttonup, Manager, figh,upfcn,lh,ID,cb,mask});
    Manager.MouseMoveFcn={@i_motion,ax,lh,click,xlim,ylim};
    set(lh,'erasemode','xor');
end

%------------------------
function i_motion(src,ev,ax,lh,click,xlim,ylim)
%------------------------
% line drawn in order   2   3
%                      1 5  4
pt=get(ax,'currentpoint');
pt = pt(1,1:2);
xdata = get(lh,'xdata');
ydata = get(lh,'ydata');
% Check for axis limits
if click(1)  %top
    ydata([2 3]) = min(ylim(2),max(pt(2),ydata(1)));
elseif click(3)  %bottom
    ydata([1 4 5]) = max(ylim(1),min(pt(2),ydata(2)));
end
if click(2)  %right
    xdata([3 4]) = min(xlim(2),max(pt(1),xdata(1)));
elseif click(4)  %left
    xdata([1 2 5]) = max(xlim(1),min(pt(1),xdata(3)));
end
set(lh,'xdata',xdata,'ydata',ydata);

%------------------------
function i_buttonup(src,ev,Manager,figh,upfcn,lh,ID,cb,mask)
%------------------------
Manager.MouseMoveFcn='';
Manager.EnableTree=true;
PR = xregGui.PointerRepository;
PR.stackRemovePointer(figh,ID);
set(figh,'windowbuttonupfcn',upfcn);
set(lh,'erasemode','normal');

xdata = get(lh,'xdata');
ydata = get(lh,'ydata');
lim1 = []; lim2 = [];
if mask(1)==1
    lim1 = xdata([1 4]);
elseif mask(1)==2
    lim2 = xdata([1 4]);
end
if mask(2)==1
    lim1 = ydata([1 2]);
elseif mask(2)==2
    lim2 = ydata([1 2]);
end
if ~isempty(cb)
    if iscell(cb)
        xregcallback(cb);
    else
        xregcallback({cb,lim1,lim2});
    end
end


