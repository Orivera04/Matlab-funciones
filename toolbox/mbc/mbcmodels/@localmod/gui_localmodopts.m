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


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:12 $

if nargin<2
    action='figure';
end

switch lower(action)
case 'figure'
    [m,ok]=i_createfig(m);
case 'layout'
    m=i_createlyt(fig,p);
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

p=xregpointer(m);
lyt=i_createlyt(figh,p);

% ok and cancel buttons
okbtn = xreguicontrol('parent',figh,...
    'visible','off',...
    'string','OK',...
    'style','pushbutton',...
    'callback','set(gcbf,''tag'',''ok'');',...
    'position',[0 0 65 25]);
flw=xregflowlayout(figh,'orientation','top/center',...
    'elements',{okbtn},...
    'border',[0 10 0 10]);
brd=xregborderlayout(figh,'center',lyt,'south',flw,...
    'innerborder',[10 45 10 10],...
    'container',figh,...
    'packstatus','on');

set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');

waitfor(figh,'tag');

% No concept of altering things here: only a cancel option
mout=m;
ok=0;

freeptr(p);
delete(figh);
return



function lyt=i_createlyt(figh,p)

if ~isa(figh,'xregcontainer')
    str = 'There are no additional options available for this model class.';
    u=xreguicontrol('style','text',...
        'parent',figh,...
        'visible','off',...
        'string',str,...
        'horizontalalignment','left');
    lyt=xreglayerlayout(figh,'elements',{u},'packstatus','off');
else
    % no updating necessary
    lyt=figh;
end


return