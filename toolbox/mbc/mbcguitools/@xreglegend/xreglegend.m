function obj=xreglegend(varargin)
% xreglegend/xreglegend  xreglegend constructor function
%   Constructor function for an xreglegend object.
%   Usage:
%     obj = xreglegend
%     obj = xreglegend(FIG)
%     obj = xreglegend('Property1',Value1,...)
%     obj = xreglegend(FIG,'Property1',Value1,...)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:01 $


if nargin>0 & isnumeric(varargin{1})
   figh=varargin{1};
else
   figh=gcf;
end


% initial position
pos=[30 30 500 360];

%fa=getaxes(xregGui.figureaxes,figh);

cp=floor(pos(1:2)+pos(3:4).*0.5)-15;

obj.axes=xregaxes('parent',figh,...
   'units','pixels',...
   'position',[pos(1)+50 pos(2)+80 pos(3)-80 pos(4)-105],...
   'layer','top',...
   'xlim',[0 1],...
   'ylim',[0 1],...
   'clim',[0 1],...
   'visible','off',...
   'userdata',pos,...
   'color','w',...
   'xcolor','w','ycolor','w',...
   'xtick',[],'ytick',[],...
   'ydir','reverse');

obj.lines = [];
obj.markers = [];
obj.text = [];
obj.items = [];
obj.handles = [];

d.fontsize = get(0,'defaultuicontrolfontsize');
d.fontweight = get(0,'defaultuicontrolfontweight');
d.fontname = get(0,'defaultuicontrolfontname');
d.fontunits = get(0,'defaultuicontrolfontunits');
d.markersize = [];
d.marker = {};
d.markeredgecolor = {};
d.markerfacecolor = {};
d.linecolor = [];
d.linewidth = [];
d.linestyle = {};
d.gapx = 10;
d.linex = 20;
d.gapy = 5;
obj.d = d;

obj.ud = [];
obj.pos = [];

obj=class(obj,'xreglegend');

% save an object handle in the axes for later use.
builtin('set',obj.axes,'userdata',obj);

% set extra props if specified
if nargin>1 & isnumeric(varargin{1}); 
   % Set properties that are passed in
   obj=set(obj,'visible','on',varargin{2:end});
elseif nargin>0 & ~isnumeric(varargin{1})
   obj=set(obj,'visible','on',varargin{:});
else
   set([obj.axes],'visible','on');
end
