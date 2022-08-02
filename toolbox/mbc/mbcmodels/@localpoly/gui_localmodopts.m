function [m,ok]=gui_localmodopts(m,action,fig,p);
% GUI_LOCALMODOPTS  Local model options dialog
%
%   [M,OK]=GUI_LOCALMODOPTS(M) creates a modal dialog for
%   setting up options specific to the current local model
%   class.  This function is the default, creating a simple
%   'No options available dialog'.  Overload it in local 
%   models which have additional options such as spline order.
%
%   LYT=GUI_LOCALMODOPTS(M,'layout',FIG,P) creates and returns
%   a layout in figure FIG, based around altering the model in
%   the pointer P.  This interface must be supported by overloaded
%   methods.  FIG may also be an existing layout object in which
%   case the layout is updated with fresh information from the 
%   model in P.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/04/04 03:29:41 $





if nargin<2
    action='figure';
end

switch lower(action)
case 'figure'
    [m,ok]=i_createfig(m);
case 'layout'
    m=i_createlyt(fig,p);
case 'loword'
    i_ordchng(fig); 
end




function [mout,ok]=i_createfig(m)

scsz=get(0,'screensize');
figh=figure('menubar','none',...
    'toolbar','none',...
    'numbertitle','off',...
    'name','Local Model Options',...
    'doublebuffer','on',...
    'renderer','zbuffer',...
    'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
    'position',[scsz(3).*0.5-125 scsz(4).*0.5-45 250 85],...
    'visible','off',...
    'color',get(0,'defaultuicontrolbackgroundcolor'),...
    'tag','LocalOpts',...
    'resize','off');

p=pointer(m);
lyt=i_createlyt(figh,p);

% ok and cancel buttons
okbtn = xreguicontrol('parent',figh,...
    'string','OK',...
    'style','pushbutton',...
    'visible','off',...
    'callback','set(gcbf,''tag'',''ok'');',...
    'position',[0 0 65 25]);
cancbtn = xreguicontrol('parent',figh,...
    'string','OK',...
    'visible','off',...
    'style','pushbutton',...
    'callback','set(gcbf,''tag'',''cancel'');',...
    'position',[0 0 65 25]);
flw=xregflowlayout(figh,'orientation','right/center',...
    'elements',{cancbtn,okbtn},...
    'border',[0 10 0 10]);
brd=xregborderlayout(figh,'center',lyt,'south',flw,...
    'innerborder',[10 45 10 10],...
    'container',figh,...
    'packstatus','on');

set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');

waitfor(figh,'tag');
tg=get(figh,'tag');
switch lower(tg)
case 'ok'
    mout=p.info
    ok=1;
case 'cancel'
    mout=m;
    ok=0;
end
freeptr(p);
delete(figh);
return



function lyt=i_createlyt(figh,p)

if ~isa(figh,'xregcontainer')
    ud.pointer=p;
    ud.figh=figh;
    text1=xreguicontrol('parent',figh,...
        'style','text',...
        'string','Order:',...
        'visible','off',...
        'horizontalalignment','left',...
        'position',[0 0 70 15]);
    ud.loword=xreguicontrol('parent',figh,...
        'style','edit',...
        'visible','off',...
        'backgroundcolor','w',...
        'interruptible','off',...
        'position',[0 0 60 20]);
    
    % data
    builtin('set',text1,'userdata',localpoly);
    objh=sprintf('%20.15f',text1);
    udh=sprintf('%20.15f',ud.loword);
    
    % callbacks
    set(ud.loword,'callback',['gui_localmodopts(get(' objh ',''userdata''),''loword'',' udh ');']);
    
    flw2=xregflowlayout(figh,...
        'gap',5,...
        'border',[-5 0 0 0],...
        'orientation','left/center',...
        'elements',{text1,ud.loword});
    lyt=xregborderlayout(figh,...
        'north',flw2,...
        'innerborder',[0 0 0 20]);
    set(ud.loword,'userdata',ud);
else
    el = get(get(figh,'north'),'elements');
    ud=get(el{2},'userdata');
    ud.pointer=p;
    set(el{2},'userdata',ud);
    lyt=figh;
end
i_setvalues(ud,p);
return



function i_setvalues(ud,p)
m=p.info;
ord=order(m);
set(ud.loword,'string',ord);
return


function i_ordchng(udh)
ud=get(udh,'userdata');

val=str2num(get(ud.loword,'string'));
m=ud.pointer.info;
ord=order(m);
% check val
if isempty(val) | length(val)>1 | val~=floor(val) ...
        | val<0
    set(ud.loword,'string',ord);
else
    m=setorder(m,val);
    ud.pointer.info=m;
end

return





