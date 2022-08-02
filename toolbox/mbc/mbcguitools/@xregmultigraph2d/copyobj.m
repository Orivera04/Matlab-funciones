function new=copyobj(gr,p)
%  GRAPH2D/COPYOBJ   copyobj for xregmultigraph2d object
%   new = copyobj(gr,parent)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:56 $

% Bail if we've not been given a graph2d object
if ~isa(gr,'xregmultigraph2d')
   error('Cannot set properties: not an xregmultigraph2d object!')
end

new = xregmultigraph2d(p);
% Copy properties
ud1 = get(gr.axes,'userdata');
% clear callbacks
ud1.callback = [];
ud1.singlecallback = [];
ud1.multicallback = [];
ud1.lines = [];
ud1.patches = [];
ud1.contextmenu = [];
set(new.axes,'userdata',ud1);
% Copy data
% copy of object in the patch
% tdata in xfactor
% xdata in xtext
% cdata in yfactor
% ydata in ytext
% visible in badim
xdata = get(gr.xtext,'userdata');
cdata = get(gr.yfactor,'userdata');
ydata = get(gr.ytext,'userdata');

% set position
newpos = ud1.pos; 
newpos([1 2]) = [10 10];
set(new.xfactor,'string',get(gr.xfactor,'string'),'value',get(gr.xfactor,'value'));
set(new.yfactor,'string',get(gr.yfactor,'string'),'value',get(gr.yfactor,'value'));
set(new,'visible','on','position',newpos,...
    'backgroundcolor',get(p,'color'),...
    'tableptr',ud1.tableptr,...
    'frame',get(gr,'frame'),...
    'data',xdata,...
    'ydata',ydata,...
    'cdata',cdata,...
    'factors',ud1.xfactors,...
    'cfactor',ud1.cfactors,...
    'title',get(get(gr.axes,'title'),'string'),...
    'colorlimitstyle',get(gr.colorbar,'limitstyle'));
relrange = [get(gr.colorbar,'relminrange') get(gr.colorbar,'relmaxrange')];
if length(relrange)~=2, relrange = [0 1]; end
set(new.colorbar,'currentfactor',get(gr.colorbar,'currentfactor'),...
    'userange',get(gr.colorbar,'userange'),...
    'relrange',relrange);
pr_plot(new);
