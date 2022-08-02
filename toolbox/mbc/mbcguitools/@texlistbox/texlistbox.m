function obj=texlistbox(varargin)
% TEXLISTBOX  Constructor for TexListBox
%
%  T=TEXLISTBOX constructs a list box which uses Axes text objects
%  to render the strings.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:20:39 $

% Created 4/10/2000

if nargin>0 & ishandle(varargin{1}) & strcmp(get(varargin{1},'type'),'figure')
   figh=varargin{1};
   varargin(1)=[];
else
   figh=gcf;
end

obj.version=1;

ud.string={''};   % cell array of strings
ud.userdata=[];
ud.value=1; % selected index/indices
ud.selmode=0;   % single/multi-select
ud.multiclickind=1;  % last select for use with multi-select mode
ud.max=1;
ud.min=0;
ud.parent=figh;
ud.fonts.fontsize=get(figh,'defaultuicontrolfontsize');
ud.fonts.fontname=get(figh,'defaultuicontrolfontname');
ud.callback='';
% decide cell height
ax=axestext(figh,'visible','off',...
   'fontsize',ud.fonts.fontsize,...
   'fontname',ud.fonts.fontname,...
   'string','Yy');
ext=get(ax,'extent');
delete(ax);
l=xreglistctrl(figh,'visible','off',...
   'cellborder',0,...
   'cellheight',ext(4)-2,...
   'userdata',ud,...
   'callback','cbselect(%OBJECT%,%VALUE%);');

obj=class(obj,'texlistbox',l);

% install the sub-object as the callback dispatcher.
set(obj,'object',obj);

if ~any(strcmp('visible',lower(varargin(1:2:end))))
   set(obj.xreglistctrl,'visible','on');
end
if length(varargin)
   obj=set(obj,varargin{:});
end
return
