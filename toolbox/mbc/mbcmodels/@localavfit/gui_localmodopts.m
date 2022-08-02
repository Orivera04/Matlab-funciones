function [m,ok]=gui_localmodopts(m,action,fig,p)
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
%   $Revision: 1.2.6.2 $  $Date: 2004/04/04 03:29:37 $

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

p=pointer(m);
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
    
    
    text1=xreguicontrol('parent',figh,...
        'style','text',...
        'visible','off',...
        'string','Current model:',...
        'horizontalalignment','left');
    ud.modelSetup=xreguicontrol('parent',figh,...
        'style','push',...
        'visible','off',...
        'string','Setup...',...
        'interruptible','off');
    ud.modelString= axestext(figh,...
        'visible','off',...
        'fontsize',10,...
        'clipping','on',...
        'verticalalignment','middle');
    

    % data
    udh= ud.modelSetup;
    
    % callbacks
    set(ud.modelSetup,'callback',{@i_mdlchng,udh});
    
    % note: below (in the ELSE) we find the handle to the button (holds userdata)
    % as the *last* element in the gblayout. Think if you change this
    lyt=xreggridbaglayout(figh,...
        'dimension',[4,3],...
        'rowsizes',[17, 20, -1, 25],...
        'colsizes',[10, -1, 80],...
        'mergeblock',{[1 1],[1,3]},...
        'mergeblock',{[2 2],[2,3]},...
        'mergeblock',{[3 3],[1,3]},...
        'mergeblock',{[4 4],[1,2]},...
        'elements',{...
            text1,[],[],[],...
            [],ud.modelString,[],[],...
            [],[],[],ud.modelSetup});
    set(ud.modelSetup,'userdata',ud);
else %% get the userdata from the handle of the button
    el = get(figh,'elements');
    ud=get(el{end},'userdata');
    ud.pointer=p;
    set(el{end},'userdata',ud);
    lyt=figh;
end
i_setvalues(ud,p);
return



function i_setvalues(ud,p)


m=p.info;
xi= xinfo(m);
m= xinfo(m,xi);
yi= yinfo(m);
m= yinfo(m,yi);

p.info= m;

set(ud.modelString,'string',str_func(m,1));

return


function i_mdlchng(h,EventData,udh)

ud=get(udh,'userdata');
m=ud.pointer.info;



[msub,OK]= gui_ModelSetup(m.model);
if OK
	
	msub= xinfo(msub,xinfo(m));
	msub= yinfo(msub,yinfo(m));

    m.model= msub;
    
    m= SetFeat(m,'default');
    
    ud.pointer.info= m;
end

set(ud.modelString,'string',str_func(m,1));

return






