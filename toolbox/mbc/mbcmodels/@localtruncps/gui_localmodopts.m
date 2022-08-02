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
%   $Revision: 1.5.4.5 $  $Date: 2004/04/04 03:29:46 $




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
case 'knot'
   i_knotchng(fig); 
case 'terms'
   i_termsel(fig);
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
   'callback','set(gcbf,''tag'',''ok'');',...
   'position',[0 0 65 25]);
cancbtn = xreguicontrol('parent',figh,...
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
      'string','Order:',...
      'horizontalalignment','left',...
      'position',[0 0 65 15]);
   ud.loword=xreguicontrol('parent',figh,...
      'style','edit',...
      'visible','off',...
      'backgroundcolor','w',...
      'interruptible','off',...
      'position',[0 0 50 20]);
   % only one knot for now
   text2=xreguicontrol('parent',figh,...
      'style','text',...
      'string','Number of knots:',...
      'visible','off',...
      'horizontalalignment','left',...
      'position',[0 0 120 15]);
   ud.knots=xreguicontrol('parent',figh,...
      'style','edit',...
      'visible','off',...
      'backgroundcolor','w',...
      'interruptible','off',...
      'position',[0 0 50 20]);
   
   % only one knot for now
   ud.terms=xreguicontrol('parent',figh,...
      'style','push',...
      'visible','off',...
      'string','Polynomial...',...
      'interruptible','off',...
      'position',[0 0 70 25]);
   
   
   % data
   builtin('set',text1,'userdata',localtruncps);
   objh=sprintf('%20.15f',text1);
   udh=sprintf('%20.15f',ud.loword);
   
   % callbacks
   set(ud.loword,'callback',['gui_localmodopts(get(' objh ',''userdata''),''loword'',' udh ');']);
   set(ud.knots,'callback',['gui_localmodopts(get(' objh ',''userdata''),''knot'',' udh ');']);
   set(ud.terms,'callback',['gui_localmodopts(get(' objh ',''userdata''),''terms'',' udh ');']);
   
   flw1=xregflowlayout(figh,...
      'gap',5,...
      'border',[-5 0 0 0],...
      'orientation','left/center',...
      'elements',{text1,ud.loword,ud.terms});
   flw2=xregflowlayout(figh,...
      'gap',10,...
      'border',[-10 0 0 0],...
      'orientation','left/center',...
      'elements',{text2,ud.knots});
   grd=xreggridlayout(figh,'dimension',[2,1],...
      'gap',2,...
      'elements',{flw1,flw2},...
      'border',[0 0 0 0]);
   lyt=xregborderlayout(figh,...
      'center',grd,...
      'innerborder',[0 0 0 0]);
   set(ud.loword,'userdata',ud);
else
   el = get(get(figh,'center'),'elements');
   el=get(el{1},'elements');
   ud=get(el{2},'userdata');
   ud.pointer=p;
   set(el{2},'userdata',ud);
   lyt=figh;
end
i_setvalues(ud,p);
return



function i_setvalues(ud,p)
m=p.info;
ord=get(m,'order');
k= length(get(m,'knot'));
set(ud.loword,'string',ord-1);
set(ud.knots,'string',k);
return


function i_ordchng(udh)
ud=get(udh,'userdata');

val=str2num(get(ud.loword,'string'));
m=ud.pointer.info;
ord=get(m,'order');
k=get(m,'knot');
% check val
if isempty(val) | length(val)>1 | val~=floor(val) ...
      | val<1
  % minimum order is one
  set(ud.loword,'string',ord-1);
else
    % order is one more than display
    m=set(m,'order',val+1);
    ud.pointer.info= m ;
end

return



function i_knotchng(udh)
ud=get(udh,'userdata');

val=str2num(get(ud.knots,'string'));
m=ud.pointer.info;
ord=get(m,'order');
k=length(m.knots);
% check val
if isempty(val) | length(val)>1 | val~=floor(val) ...
      | val<1
   set(ud.knots,'string',k);
elseif val~=k
	set(m,'knot',zeros(val,1));
	m= SetFeat(m,'default');
   ud.pointer.info=m;
end

return




function i_termsel(udh)

ud=get(udh,'userdata');
m=ud.pointer.info;

scsz=get(0,'screensize');
figh=xregfigure('menubar','none',...
   'toolbar','none',...
   'numbertitle','off',...
   'name','Polynomial Terms',...
   'doublebuffer','on',...
   'renderer','zbuffer',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'position',[scsz(3).*0.5-20 scsz(4).*0.5-45 220 200],...
   'visible','off',...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'tag','LocalOpts',...
   'resize','off');
figh= double(figh);

tsel= term_selector(figh,'frame.visible','off');

% ok and cancel buttons
okbtn = xreguicontrol('parent',figh,...
   'string','OK',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'position',[0 0 65 25]);
cancbtn = xreguicontrol('parent',figh,...
   'string','Cancel',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''cancel'');',...
   'position',[0 0 65 25]);
flw=xregflowlayout(figh,'orientation','right/center',...
   'elements',{cancbtn,okbtn},...
   'gap',7,...
   'border',[0 10 -7 10]);
frm=xregframetitlelayout(figh,...
   'center',tsel,'innerborder',[0 0 0 0]);
brd=xregborderlayout(figh,'container',figh,...
   'center',frm,'south',flw,...
   'innerborder',[10 45 10 10],...
   'packstatus','on');

poly= polynom(m);
tsstat= getstatus(m);
% set(poly,'status',tsstat(1:size(poly,1)));
model(tsel,poly);

set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');

waitfor(figh,'tag');
tg=get(figh,'tag');
switch lower(tg)
case 'ok'
   mout= model(tsel);
   polyst= getstatus(mout);
   polyst(polyst==3)=1;
   np= length(polyst);
   if ~all(tsstat(1:np)==polyst)
      tsstat(1:np)=polyst;
      m.xreglinear= set(m.xreglinear,'status',tsstat);
      m= DelFeat(m,':');
      n= size(m,1);
      [Feats,Defaults,values]= features(m);
      m= AddFeat(m,values,Defaults);
      ud.pointer.info=m;
   end
   
end
delete(figh);
return
