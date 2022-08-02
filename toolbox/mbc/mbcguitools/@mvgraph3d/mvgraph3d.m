function gr=mvgraph3d(varargin)
%MVGRAPH3D   MVGraph3d constructor function
%   Constructor function for a mvgraph3d object.
%   Usage:
%   GR=MVGRAPH3D
%   GR=MVGRAPH3D(FIG)
%   GR=MVGRAPH3D('Property1',Value1,...)
%   GR=MVGRAPH3D(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:19:26 $

if nargin>0 & ishandle(varargin{1})
   figh=varargin{1};
else
   figh=gcf;
end
% initial position
pos=[30 30 500 360];

% DATA STORAGE.  The different bits of data are stored as follows:
s.data = [];
s.factors = {};
s.limits = {};
s.type = 'scatter';
s.factorselection = 0;  % normal
s.position = pos;
s.visible = 'on';
s.frame = 1;
s.datatags = 0;  % 0 = none, 1 = count, 2 = custom
s.customdatatags = {};
s.datataghandles = [];

gr.patch=xregGui.oblong('parent',figh,...
   'position',pos,...
   'facecolor',[1 1 1],...
   'visible','off',...
   'hittest','off',...
   'layer','back');

cp=floor(pos(1:2)+pos(3:4).*0.5)-15;
gr.badim=xregGui.axesimage('parent',figh,...
   'image',pr_badim,...
   'position',[cp 32 32],...
   'visible','off',...
   'hittest','off');

gr.axes=xregGui.axes('parent',figh,...
   'units','pixels',...
   'position',[pos(1)+55 pos(2)+100 pos(3)-150 pos(4)-125],...
   'layer','top',...
   'visible','off',...
   'xgrid','on',...
   'ygrid','on',...
   'zgrid','on',...
   'projection','perspective',...
   'view',[-30 30],...
   'box','on',...
   'color',[1 1 1]);

gr.surf=handle(patch('parent',gr.axes,...
   'hittest','off',...
   'visible','off',...
   'facecolor','none',...
   'edgecolor',get(double(gr.axes),'defaultsurfacefacecolor'),...
   'facelighting', 'none',...
   'edgelighting', 'flat',...
   'vertices',[]));

cmap=get(figh,'colormap');
clim=get(gr.axes,'clim');
gr.colorbar.axes=xregGui.axes('parent',figh,...
   'units','pixels',...
   'position',[pos(1)+pos(3)-60 pos(2)+90 20 pos(4)-115],...
   'layer','top',...
   'ylim',[0.5 size(cmap,1)+0.5],...
   'xlim',[0 1],...
   'clim',clim,...
   'visible','off',...
   'xtick',[],...
   'box','on',...
   'yaxislocation','right');
gr.colorbar.bar=handle(patch('parent',gr.colorbar.axes,...
   'vertices',[0 0 0;0 1 0;1 1 0;1 0 0],...
   'facevertexcdata',[0],...
   'visible','off',...
   'cdatamapping','scaled',...
   'faces',[1 2 3 4],...
   'edgecolor','none',...
   'facecolor','flat'));

% set up faces for colorbar
pr_cbarfaces(gr.colorbar.bar,cmap);

% set up labels according to color limits in axis
labpoints=get(gr.colorbar.axes,'ytick');
actpoints=(labpoints-1)./(size(cmap,1)-1);
set(gr.colorbar.axes,'yticklabel',cellstr(num2str(actpoints','%3.2f')));

gr.xfactor=xregGui.uicontrol('style','popupmenu',...
   'parent',figh,...
   'position',[pos(1)+pos(3)/6-35 pos(2)+10 70 20],...
   'string',' ',...
   'backgroundcolor','w',...
   'visible','off',...
   'tag','1');
gr.xtext=xregGui.uicontrol('style','text',...
   'parent',figh,...
   'position',[pos(1)+pos(3)/6-35 pos(2)+32 70 16],...
   'string','X-axis factor:',...
   'backgroundcolor','w',...
   'visible','off',...
   'enable','inactive');

gr.yfactor=xregGui.uicontrol('style','popupmenu',...
   'parent',figh,...
   'position',[pos(1)+pos(3)/2-35 pos(2)+10 70 20],...
   'string',' ',...
   'backgroundcolor','w',...
   'visible','off',...
   'tag','2');
gr.ytext=xregGui.uicontrol('style','text',...
   'parent',figh,...
   'position',[pos(1)+pos(3)/2-35 pos(2)+32 70 16],...
   'string','Y-axis factor:',...
   'backgroundcolor','w',...
   'visible','off',...
   'enable','inactive');

gr.zfactor=xregGui.uicontrol('style','popupmenu',...
   'parent',figh,...
   'position',[pos(1)+5*pos(3)/6-35 pos(2)+10 70 20],...
   'string',' ',...
   'backgroundcolor','w',...
   'visible','off',...
   'tag','3');
gr.ztext=xregGui.uicontrol('style','text',...
   'parent',figh,...
   'position',[pos(1)+5*pos(3)/6-35 pos(2)+32 70 16],...
   'string','Z-axis factor:',...
   'backgroundcolor','w',...
   'visible','off',...
   'enable','inactive');

gr.DataPointer = xregGui.RunTimePointer(s);
gr.DataPointer.LinkToObject(gr.axes);

gr=class(gr,'mvgraph3d');

set([gr.xfactor;gr.yfactor;gr.zfactor],'callback',{@i_factorchange,gr});
set(gr.colorbar.bar,'buttondownfcn',{@i_cmapcb,gr});

% set extra props if specified
if nargin>1 & ishandle(varargin{1}); 
   % Set properties that are passed in
   gr=set(gr,'visible','on',varargin{2:end});
elseif nargin>0 & ~ishandle(varargin{1})
   gr=set(gr,'visible','on',varargin{:});
else
   set([gr.axes;gr.patch;gr.xfactor;gr.yfactor;gr.zfactor; ...
           gr.xtext;gr.ytext;gr.ztext; ...
           gr.colorbar.axes;gr.colorbar.bar;gr.surf],'visible','on');
   mv_rotate3d(double(gr.axes),'ON');
end




function i_factorchange(src,evt,g)
factor_change(g,src);
return

function i_cmapcb(src,evt,g)
cmapcb(g);
return