function sl=listitemselector(varargin)
%LISTITEMSELECTOR   Constructor function for the listitemselector object
%   LISTITEMSELECTOR is the creator function for the 'listitemselector' guitool
%   Usage:
%   SL=LISTITEMSELECTOR
%   SL=LISTITEMSELECTOR(FIG)
%   SL=LISTITEMSELECTOR('Property1',Value1,...)
%   SL=LISTITEMSELECTOR(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:04 $

% Created 2/2/2000

if nargin>0 & ishandle(varargin{1}) & strcmp(get(varargin{1},'type'),'figure')
   figh=varargin{1};
else
   figh=gcf;
end

pos=get(0,'defaultuicontrolposition');
pos(3)=200;
pos(4)=170;

% decide btn heights and separations
if pos(4)<154
   btnsep=floor(pos(4)./15.4);
   btnh=btnsep.*2.6;
else
   btnh=26;
   btnsep=10;
end

% create objects
sl.baselist=uicontrol('parent',figh,...
   'style','listbox',...
   'visible','off',...
   'position',[pos(1) pos(2) (pos(3)-btnh-20).*0.5 pos(4)],...
   'horizontalalignment','left',...
   'backgroundcolor','w',...
   'max',2,...
   'min',0);
sl.sellist=uicontrol('parent',figh,...
   'style','listbox',...
   'visible','off',...
   'position',[pos(1)+pos(3).*0.5+10+btnh.*0.5 pos(2) (pos(3)-btnh-20).*0.5 pos(4)],...
   'horizontalalignment','left',...
   'backgroundcolor','w',...
   'max',2,...
   'min',0);
cbtxt=sprintf('%20.15f',sl.sellist);
set(sl.baselist,'callback',['listselcb(get(' cbtxt ',''userdata''),''base'');']);
set(sl.sellist,'callback',['listselcb(get(' cbtxt ',''userdata''),''sel'');']);

sl.addall=uicontrol('parent',figh,...
   'style','pushbutton',...
   'visible','off',...
   'string','>>',...
   'position',[pos(1)+.5*pos(3)-.5*btnh  pos(2)+.5*pos(4)+1.5*btnsep btnh btnh],...
   'callback',['moveitemcb(get(' cbtxt ',''userdata''),''addall'');'],...
   'fontweight','bold',...
   'tooltipstring','Select all',...
   'enable','off');
sl.addone=uicontrol('parent',figh,...
   'style','pushbutton',...
   'visible','off',...
   'position',[pos(1)+pos(3).*0.5-btnh.*0.5  pos(2)+.5*pos(4)+2.5*btnsep+btnh btnh btnh],...
   'string','>',...
   'callback',['moveitemcb(get(' cbtxt ',''userdata''),''addone'');'],...
   'fontweight','bold',...
   'tooltipstring','Select item',...
   'enable','off');
sl.remone=uicontrol('parent',figh,...
   'style','pushbutton',...
   'visible','off',...
   'position',[pos(1)+pos(3).*0.5-btnh.*0.5  pos(2)+.5*pos(4)-1.5*btnsep-btnh btnh btnh],...
   'string','<',...
   'callback',['moveitemcb(get(' cbtxt ',''userdata''),''remone'');'],...
   'fontweight','bold',...
   'tooltipstring','Deselect item',...
   'enable','off');
sl.remall=uicontrol('parent',figh,...
   'style','pushbutton',...
   'visible','off',...
   'position',[pos(1)+pos(3).*0.5-btnh.*0.5  pos(2)+.5*pos(4)-2.5*btnsep-2*btnh btnh btnh],...
   'string','<<',...
   'callback',['moveitemcb(get(' cbtxt ',''userdata''),''remall'');'],...
   'fontweight','bold',...
   'tooltipstring','Deselect all',...
   'enable','off');

bgcol=get(figh,'color');
sl.unselttl=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'position',[pos(1) pos(2)+pos(4)-16 (pos(3)-btnh-20).*0.5 16],...
   'string','',...
   'backgroundcolor',bgcol,...
   'horizontalalignment','left');
sl.selttl=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'position',[pos(1)+pos(3).*0.5+10+btnh.*0.5 pos(2)+pos(4)-16 (pos(3)-btnh-20).*0.5 16],...
   'string','',...
   'backgroundcolor',bgcol,...
   'horizontalalignment','left');

ud.buttonsepdist=10;
ud.position=pos;
ud.charlist={};
ud.reallist={};
ud.unsel=[];
ud.sel=[];
ud.titles=0;
ud.callback='';
ud.selectfcn='';

% set userdata in left listbox
set(sl.baselist,'userdata',ud);

sl=class(sl,'listitemselector');
% save copy of object
builtin('set',sl.sellist,'userdata',sl);


% set extra props if specified
if nargin>1 & isnumeric(varargin{1}); 
   % Set properties that are passed in
   sl=set(sl,'visible','on',varargin{2:end});
elseif nargin>0 & ~isnumeric(varargin{1})
   sl=set(sl,'visible','on',varargin{:});
else
   set([sl.baselist;sl.sellist;sl.addone;sl.addall;sl.remone;sl.remall],'visible','on');
end

