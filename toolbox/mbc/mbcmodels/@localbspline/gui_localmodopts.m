function [m,ok]=gui_localmodopts(m,action,fig,p)
%GUI_LOCALMODOPTS  Local model options dialog
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

%  $Revision: 1.7.2.4 $ $Date: 2004/04/20 23:19:01 $

if nargin<2
   action='figure';
end

switch lower(action)
case 'figure'
   [m,ok]=i_createfig(m);
case 'layout'
   m=i_createlyt(fig,p);
case 'knot'
   i_knotchng(fig); 
case 'rand'
   i_randchng(fig); 
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
   'position',[scsz(3).*0.5-125 scsz(4).*0.5-45 275 120],...
   'visible','off',...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'tag','LocalOpts',...
   'resize','off');

p=xregpointer(m);
lyt=i_createlyt(figh,p);

% ok and cancel buttons
okbtn = xreguicontrol('parent',figh,...
   'string','OK',...
   'visible','off',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'position',[0 0 65 25]);
cancbtn = xreguicontrol('parent',figh,...
   'visible','off',...
   'string','Cancel',...
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
set(brd, 'Visible','on');
set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');

waitfor(figh,'tag');
tg=get(figh,'tag');
switch lower(tg)
case 'ok'
   mout=p.info;
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
   
   ud.knots=xregGui.labelcontrol('parent',figh,...
      'ControlSize',60,...
      'visible','off',...
      'String','Number of knots:',...
      'Control',xregGui.clickedit('parent',figh,...
      'visible','off',...
      'backgroundcolor',[1 1 1],...
      'dragging','off',...
      'clickincrement',1,...
      'min',1,...
      'max',1000,...
      'rule','int'));
   ud.order=xregGui.labelcontrol('parent',figh,...
      'ControlSize',60,...
      'visible','off',...
      'String','Spline order:',...
      'Control',xregGui.clickedit('parent',figh,...
      'visible','off',...
      'backgroundcolor',[1 1 1],...
      'dragging','off',...
      'clickincrement',1,...
      'min',0,...
      'max',3,...
      'rule','int'));

  ud.rand=xregGui.labelcontrol('parent',figh,...
      'ControlSize',60,...
      'visible','off',...
      'String','Random starting points:',...
      'Control',xregGui.clickedit('parent',figh,...
      'visible','off',...
      'backgroundcolor',[1 1 1],...
      'dragging','off',...
      'clickincrement',1,...
      'min',0,...
      'max',1000,...
      'rule','int'));

   % data
   udh=ud.knots;
   
   % callbacks
   set(ud.knots.Control,'callback',{@i_knotchng,udh});
   set(ud.order.Control,'callback',{@i_orderchng,udh});
   set(ud.rand.Control,'callback',{@i_randchng,udh});
   
   lyt=xreggridbaglayout(figh,'dimension',[3,1],...
      'packstatus','off',...
      'rowsizes',[20 20 20],...
      'gap',5,...
      'elements',{ud.knots,ud.order,ud.rand});
   
   set(ud.knots,'userdata',ud);
else
   el = get(figh,'elements');
   ud=get(el{1},'userdata');
   ud.pointer=p;
   set(el{1},'userdata',ud);
   lyt=figh;
end
i_setvalues(ud,p);
return



function i_setvalues(ud,p)
m=p.info;
nk= get(m,'numknots');
k= get(m,'order');
set(ud.knots.Control,'value',nk);
set(ud.order.Control,'value',k);
if ~isfield(m.fitparams,'randstart')
   m.fitparams.randstart= 2;
   p.info= m;
end
set(ud.rand.Control,'value',m.fitparams.randstart);
return



function i_knotchng(src,evt,udh)
ud=get(udh,'userdata');
val=get(ud.knots.Control,'value');
m=ud.pointer.info;
k=get(m,'numknots');
if k~=val
   m=set(m,'numknots',val);
   ud.pointer.info=m;
end
return

function i_orderchng(src,evt,udh)
ud=get(udh,'userdata');
val=get(ud.order.Control,'value');
m=ud.pointer.info;
k=get(m,'order');
if k~=val
   m=set(m,'order',val);
   ud.pointer.info=m;
end
return


function i_randchng(src,evt,udh)
ud=get(udh,'userdata');
val=get(ud.rand.Control,'value');
m=ud.pointer.info;
m.fitparams.randstart= val;
ud.pointer.info=m;
return