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
%   $Revision: 1.6.4.3 $  $Date: 2004/04/04 03:29:48 $





if nargin<2
    action='figure';
end

switch lower(action)
case 'figure'
    [m,ok]=i_createfig(m);
case 'layout'
    m=i_createlyt(fig,p);
case 'mdlchng'
    i_mdlchng(fig); 
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

p= xregpointer(m);
lyt=i_createlyt(figh,p);

% ok and cancel buttons
okbtn = xreguicontrol('parent',figh,...
    'string','OK',...
    'visible','off',...
    'style','pushbutton',...
    'callback','set(gcbf,''tag'',''ok'');',...
    'position',[0 0 65 25]);
cancbtn = xreguicontrol('parent',figh,...
    'string','Cancel',...
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
    
    
    ud.head=xreguicontrol('parent',figh,...
        'visible','off',...
        'style','text',...
        'string','User models:',...
        'horizontalalignment','left',...
        'position',[0 0 65 15]);
    ud.models=xreguicontrol('parent',figh,...
        'style','listbox',...
        'visible','off',...
        'backgroundcolor','w',...
        'interruptible','off',...
        'position',[0 0 200 50]);
    
    
    
    % callbacks
    set(ud.models,'callback',{@i_mdlchng,ud.models});
    
    lyt=xregborderlayout(figh,...
        'north',ud.head,...
        'center',ud.models,...
        'innerborder',[0 0 0 20]);
    set(ud.models,'userdata',ud);
else
    
    el = get(figh,'center');
    ud=get(el,'userdata');
    ud.pointer=p;
    set(el,'userdata',ud);
    lyt=figh;
end
i_setvalues(ud,p);
return



function i_setvalues(ud,p)


m=p.info;
if isGrowth(m)
    % Growth Model
    set(ud.head,'string','Growth models:');
    [G,Glist]= GrowthModels(m);
    set(ud.models,'string',Glist,'value',find(strcmp( name(m), G)) );
else
    % user defined model
    nf= nfactors(m);
    [cfglist,f]=getmodellist(m.userdefined,nf);
    set(ud.models,'string',cfglist,'value',f);
    % update model
    if strcmp(lmgroup(m),'xregtransient')
        set(ud.head,'string','Transient models:');
        u=xregtransient('name',cfglist{f});
    else
        set(ud.head,'string','User defined models:');
        u=xregusermod('name',cfglist{f});
    end
    mlist=m;
    mlist.userdefined= u;
    if ~modelcmp(mlist,m);
        mlist.userdefined= xinfo(mlist.userdefined,xinfo(m));
        mlist.userdefined= yinfo(mlist.userdefined,yinfo(m));
        p.info= mlist;
    end
end
return


function i_mdlchng(h,evt,udh)

ud=get(udh,'userdata');
m=ud.pointer.info;

if isGrowth(m)
    val= get(ud.models,'value');
    G= GrowthModels(m);
    m.userdefined= xregusermod('name',G{val});
else
    % user defined
    nf= nfactors(m);
    [cfglist,f]=getmodellist(m.userdefined,nf);
    
    val= get(ud.models,'value');
    if strcmp(lmgroup(m),'xregtransient')
        u=xregtransient('name',cfglist{val});
    else
        u=xregusermod('name',cfglist{val});
    end
    m.userdefined= u;
end
m.userdefined= xinfo(m.userdefined,xinfo(m));
m.userdefined= yinfo(m.userdefined,yinfo(m));
m= SetFeat(m,'default');


ud.pointer.info= m;

return






