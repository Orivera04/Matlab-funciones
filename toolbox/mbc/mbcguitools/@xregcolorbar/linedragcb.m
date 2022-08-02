function cb = linedragcb(gr)
%XREGCOLORBAR/LINEDRAGCB   Callback function
%
%  Callback function for XREGCOLORBAR object.  Handles dragging of the
%  range indicator objects on the colourbar.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:31:21 $

%  Altered by Mungo Stacy
%             15/6/01

cb = [];
cb.ButtonDown = @i_ButtonDown;
cb.ButtonUp = @i_ButtonUp;
cb.Motion = @i_Motion;

%------------------------------------------------
function i_ButtonDown(src,event,gr,line)
%------------------------------------------------
% Get up-to-date version of object
gr = builtin('get',gr.colorbar.axes,'userdata');

obj=gr.colorbar.([line 'range']);

figh = get(gr.axes,'parent');

gr.colorbar.Manager=MotionManager(figh);
gr.colorbar.Manager.EnableTree=false;

PR = xregGui.PointerRepository;
ud = get(gr.patch,'userdata');
ud.pointerID = PR.stackSetPointer(figh,'top');

% create a text object to indicate variable value
cfactor=get(gr.cfactor,'string');
if ~strcmp(cfactor,' ');
    cfactor=cfactor{get(gr.cfactor,'value')};
else
    cfactor='Y';
end
% Anything longer falls out of box
cfactor = cfactor(1);

th=uicontrol('parent',figh,...
    'style','text',...
    'visible','off',...
    'backgroundcolor',[1 1 0.6],...
    'userdata',cfactor);

ud.upfcn=get(figh,'windowbuttonupfcn');
set(gr.patch,'userdata',ud);

set(obj,'facevertexcdata',1-get(obj,'facevertexcdata'));

set(figh,'windowbuttonupfcn',{gr.colorbar.linebupcb, gr, line, th});
gr.colorbar.Manager.MouseMoveFcn={gr.colorbar.linemotioncb, gr, line, th};

% store manager
builtin('set',gr.colorbar.axes,'userdata',gr);

% easy way to pop up text box immediately
i_Motion([],[],gr,line,th);
set(th,'visible','on');


%------------------------------------------------
function i_ButtonUp(src,event,gr,line,th)
%------------------------------------------------
% Get up-to-date version of object
gr = builtin('get',gr.colorbar.axes,'userdata');
figh = get(gr.axes,'parent');

obj=gr.colorbar.([line 'range']);
ud=get(gr.patch,'userdata');

set(obj,'facevertexcdata',1-get(obj,'facevertexcdata'));


gr.colorbar.Manager.MouseMoveFcn='';
gr.colorbar.Manager.EnableTree=true;
set(figh,'windowbuttonupfcn',ud.upfcn);

delete(th);
PR = xregGui.PointerRepository;
PR.stackRemovePointer(figh,ud.pointerID);

% update axes
pr_cbarfaces(gr.colorbar.bar,get(gr.colorbar.bar,'facevertexcdata'),gr);
pr_setMotionRegions(gr);
pr_plot(gr);
% fire callback
%firecb(obj);


%------------------------------------------------
function i_Motion(src,event,gr,line,th,axcp)
%------------------------------------------------
if nargin<6, axcp = []; end
% Get up-to-date version of object
gr = builtin('get',gr.colorbar.axes,'userdata');
figh = get(gr.axes,'parent');

% get current cursor point from figure
cp=get(figh,'currentpoint');
% translate to a data point in the colourbar axes!
cbpos=get(gr.colorbar.axes,'position');
ylim=get(gr.colorbar.axes,'ylim');
switch lower(line)
case 'min'
    % need to drag min to position of cursor. Special cases are:
    %    (1)  if min is dragged above max, it stops at max
    %    (2)  if min is dragged below axes, it stops at bottom of axes
    % Note that the midrange object needs to be moved too to keep it in the middle
    
    if isempty(axcp)
        axcp=(ylim(2)-ylim(1))*(cp(2)-cbpos(2))/cbpos(4);
    end
    % do checks to limit axcp if necessary
    if axcp<0.5
        axcp=0.5;
    end
    cmax=get(gr.colorbar.maxrange,'userdata');
    if axcp>cmax
        axcp=cmax;
    end
    strnum=axcp;
    % reset position of line
    % work out delta
    delta=2*(ylim(2)-ylim(1))/(cbpos(4));
    newvert=[0 axcp+delta/4; 0.5 axcp+2*delta; 1 axcp+delta/4;....
            0 axcp-delta/4; 0.5 axcp-2*delta; 1 axcp-delta/4];
    set(gr.colorbar.minrange,'vertices',newvert,'userdata',axcp);
    % move midrange bar
    axcp=(cmax+axcp)/2;
    newvert=[0 axcp+delta/4; 0.5 axcp+2*delta; 1 axcp+delta/4;....
            0 axcp-delta/4; 0.5 axcp-2*delta; 1 axcp-delta/4];
    set(gr.colorbar.midrange,'vertices',newvert,'userdata',axcp);
    
case 'mid'    
    if isempty(axcp)
        midcp=(ylim(2)-ylim(1))*(cp(2)-cbpos(2))/cbpos(4);
    else
        midcp = axcp;
    end
    % do checks to limit axcp if necessary
    
    oldmin=get(gr.colorbar.minrange,'userdata');
    oldmax=get(gr.colorbar.maxrange,'userdata');
    
    mincp=midcp-(oldmax-oldmin)/2;
    maxcp=midcp+(oldmax-oldmin)/2;
    
    if mincp<ylim(1)
        % push maxcp back up
        maxcp=maxcp+ylim(1)-mincp;
        mincp=ylim(1);
    end
    if maxcp>ylim(2)
        % push mincp back down
        mincp=mincp-maxcp+ylim(2);
        maxcp=ylim(2);
    end
    
    % rework midcp according to max and min
    midcp=(mincp+maxcp)/2;
    strnum=midcp;
    delta=2*(ylim(2)-ylim(1))/(cbpos(4));
    newvert=[0 mincp+delta/4; 0.5 mincp+2*delta; 1 mincp+delta/4;....
            0 mincp-delta/4; 0.5 mincp-2*delta; 1 mincp-delta/4];
    set(gr.colorbar.minrange,'vertices',newvert,'userdata',mincp);
    newvert=[0 midcp+delta/4; 0.5 midcp+2*delta; 1 midcp+delta/4;....
            0 midcp-delta/4; 0.5 midcp-2*delta; 1 midcp-delta/4];
    set(gr.colorbar.midrange,'vertices',newvert,'userdata',midcp);
    newvert=[0 maxcp+delta/4; 0.5 maxcp+2*delta; 1 maxcp+delta/4;....
            0 maxcp-delta/4; 0.5 maxcp-2*delta; 1 maxcp-delta/4];
    set(gr.colorbar.maxrange,'vertices',newvert,'userdata',maxcp);
    
case 'max'
    if isempty(axcp)
        axcp=(ylim(2)-ylim(1))*(cp(2)-cbpos(2))/cbpos(4);
    end
    % do checks to limit axcp if necessary
    if axcp>ylim(2)
        axcp=ylim(2);
    end
    cmin=get(gr.colorbar.minrange,'userdata');
    if axcp<cmin
        axcp=cmin;
    end
    strnum=axcp;
    % reset position of line
    % work out delta
    delta=2*(ylim(2)-ylim(1))/(cbpos(4));
    newvert=[0 axcp+delta/4; 0.5 axcp+2*delta; 1 axcp+delta/4;....
            0 axcp-delta/4; 0.5 axcp-2*delta; 1 axcp-delta/4];
    set(gr.colorbar.maxrange,'vertices',newvert,'userdata',axcp);
    % move midrange bar
    axcp=(cmin+axcp)/2;
    newvert=[0 axcp+delta/4; 0.5 axcp+2*delta; 1 axcp+delta/4;....
            0 axcp-delta/4; 0.5 axcp-2*delta; 1 axcp-delta/4];
    set(gr.colorbar.midrange,'vertices',newvert,'userdata',axcp);
end

% redraw text box
if ishandle(th)
    %position
    tpos(1)=cp(1)-55;tpos(2)=cp(2);tpos(3)=50;tpos(4)=16;
    %string
    cfactor=get(th,'userdata');
    % need to scale number to actual values.
    ud=get(gr.ctext,'userdata');
    clim = ud.clim;
    strnum=clim(1)+(clim(2)-clim(1)).*strnum./(ylim(2)-ylim(1));
    tstr=[cfactor '=' sprintf('%5.3f',strnum)];
    set(th,'position',tpos,'string',tstr);
end


