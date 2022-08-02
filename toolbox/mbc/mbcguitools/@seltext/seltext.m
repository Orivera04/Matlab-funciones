function obj = seltext(varargin)
% SELTEXT Text that has a 'selected' state
%
%  SELTEXT combines a background rectangle and an axestext object.
%  The object has a "selected" state, used for combining the items
%  in a list box style
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:20:33 $


if nargin>0 & ishandle(varargin{1}) & strcmp(get(varargin{1},'type'),'figure')
   figh=varargin{1};
   varargin(1)=[];
else
   figh=gcf;
end

pos=get(0,'defaultuicontrolposition');

obj.version=1;

ud.selcolor=[0 0 0.5];
ud.position=pos;
ud.bgcolor=get(figh,'defaultuicontrolbackgroundcolor');
ud.fgcolor=get(figh,'defaulttextcolor');
ud.selected=0;
ud.userdata=[];
ud.callback='';       % mirrors callback setting
ud.enable=1;

fa=xregGui.figureaxes;
ax=getaxes(fa,figh);
obj.back=xregrectangle('parent',ax,'visible','off','position',pos,...
   'facecolor',ud.bgcolor,'edgecolor','none','userdata',ud);

txt=axestext(figh,'visible','off','hittest','off','clipping','on',...
   'position',pos);


obj=class(obj,'seltext',txt);

if ~any(strcmp('visible',lower(varargin(1:2:end))))
   set(obj.back,'visible','on');
   set(txt,'visible','on');
end
if length(varargin)
   obj=set(obj,varargin{:});
end
return
