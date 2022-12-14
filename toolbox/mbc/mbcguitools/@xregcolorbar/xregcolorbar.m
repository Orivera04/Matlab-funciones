function gr=xregcolorbar(varargin)
%XREGCOLORBAR/XREGCOLORBAR   XREGCOLORBAR constructor function
%   Constructor function for a XREGCOLORBAR object.
%   Usage:
%   GR=XREGCOLORBAR
%   GR=XREGCOLORBAR(FIG)
%   GR=XREGCOLORBAR('Property1',Value1,...)
%   GR=XREGCOLORBAR(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.4.3 $  $Date: 2004/04/04 03:29:11 $

if nargin>0 & isnumeric(varargin{1})
   figh=varargin{1};
else
   figh=gcf;
   set(figh,'renderer','zbuffer');
end

% Store data in:
% object - colorbar.axes
% data - colorbar.frame1
% factors - colorbar.frame2
% visibility - userange
% position - cfactor
% ctext - various: axes clim, plot indices etc
% callback,mouseID - patch

% initial position
pos=[30 30 100 300];

ud = [];
ud.MousePtrStackID = [];
ud.callback = [];
ud.setcallback = 1;
gr.patch=xregGui.axes('parent',figh,...
   'units','pixels',...
   'position',pos,...
   'xtick',[],...
   'ytick',[],...
   'box','on',...
   'color','w',...
   'parent',figh,...
   'visible','off',...
   'handlevisibility','off',...
   'tag','xregcolorbar_obj',...
   'xlim',[0 1],...
   'ylim',[0 1],...
   'userdata',ud,...
   'ydir','reverse');

cmap=get(figh,'colormap');
clim=get(gr.patch,'clim'); %default one
gr.colorbar.axes=xregGui.axes('parent',figh,...
   'units','pixels',...
   'position',[pos(1)+pos(3)-60 pos(2)+100 20 pos(4)-125],...
   'layer','top',...
   'ylim',[0.5 size(cmap,1)+0.5],...
   'xlim',[0 1],...
   'clim',clim,...
   'visible','off',...
   'xtick',[],...
   'box','on',...
   'yaxislocation','right');
gr.axes = gr.colorbar.axes;
gr.colorbar.bar=xregGui.patch('parent',gr.colorbar.axes,...
   'vertices',[0 0 0;0 1 0;1 1 0;1 0 0],...
   'facevertexcdata',[0],...
   'visible','off',...
   'faces',[1 2 3 4],...
   'edgecolor','none',...
   'facecolor','flat',...
   'tag','cbar',...
   'userdata',get(figh,'color'));

% need to give patches a width , otherwise the buttondown fcn never fires.
clen=size(cmap,1);
delta=2*(clen)/(pos(4)-125);
gr.colorbar.midrange=xregGui.patch('parent',gr.colorbar.axes,...
   'visible','off',...
   'vertices',[0 (clen/2)+delta/4 1; 0.5 (clen/2)+2*delta 1; 1 (clen/2)+delta/4 1;...
      0 (clen/2)-delta/4 1; 0.5 (clen/2)-2*delta 1; 1 (clen/2)-delta/4 1],...
   'faces',[1 2 5 4;2 3 6 5],...
   'facevertexcdata',[1 1 0.7;0.7 0 0;1 1 0.7;1 1 0.7;0.7 0 0;1 1 0.7],...
   'facecolor','interp',...
   'edgecolor','none',...
   'userdata',clen/2,...
   'interruptible','off',...
   'erasemode','normal',...
   'tag','midbar');
gr.colorbar.minrange=xregGui.patch('parent',gr.colorbar.axes,...
   'visible','off',...
   'vertices',[0 (3*clen/8)+delta/4; 0.5 (3*clen/8)+2*delta; 1 (3*clen/8)+delta/4;...
      0 (3*clen/8)-delta/4; 0.5 (3*clen/8)-2*delta; 1 (3*clen/8)-delta/4],...
   'faces',[1 2 5 4;2 3 6 5],...
   'facevertexcdata',[1 1 0.7;0 0 0.7;1 1 0.7;1 1 0.7;0 0 0.7;1 1 0.7],...
   'facecolor','interp',...
   'edgecolor','none',...
   'userdata',3*clen/8,...
   'interruptible','off',...
   'erasemode','normal',...
   'tag','minbar');
gr.colorbar.maxrange=xregGui.patch('parent',gr.colorbar.axes,...
   'visible','off',...
   'vertices',[0 (5*clen/8)+delta/4; 0.5 (5*clen/8)+2*delta; 1 (5*clen/8)+delta/4;...
      0 (5*clen/8)-delta/4; 0.5 (5*clen/8)-2*delta; 1 (5*clen/8)-delta/4],...
   'faces',[1 2 5 4;2 3 6 5],...
   'facevertexcdata',[1 1 0.7;0 0 0.7;1 1 0.7;1 1 0.7;0 0 0.7;1 1 0.7],...
   'facecolor','interp',...
   'edgecolor','none',...
   'userdata',5*clen/8,...
   'interruptible','off',...
   'erasemode','normal',...
   'tag','maxbar');

gr.colorbar.frame1=xregGui.uicontrol('style','frame',...
   'parent',figh,...
   'position',[pos(1)+pos(3)-51 pos(2)+90 2 10],...
   'visible','off',...
   'enable','inactive');
gr.colorbar.frame2=xregGui.uicontrol('style','frame',...
   'parent',figh,...
   'position',[pos(1)+pos(3)-86 pos(2)+89 72 1],...
   'visible','off',...
   'enable','inactive');
gr.colorbar.userange=xregGui.uicontrol('style','checkbox',...
   'parent',figh,...
   'position',[pos(1)+pos(3)-86 pos(2)+65 72 24],...
   'backgroundcolor','w',...
   'userdata','on',...
   'string','Limit range',...
   'visible','off');


% set up labels according to color limits in axis
labpoints=get(gr.colorbar.axes,'ytick');
actpoints=(labpoints-1)./(clen-1);
set(gr.colorbar.axes,'yticklabel',cellstr(num2str(actpoints','%3.2f')));

gr.cfactor=xregGui.uicontrol('style','popupmenu',...
   'parent',figh,...
   'position',[pos(1)+4*pos(3)/5-35 pos(2)+10 70 20],...
   'string',' ',...
   'backgroundcolor','w',...
   'userdata',pos,...
   'visible','off',...
   'tag','4');
ud = [];
ud.clim = clim;
ud.limitstyle = 'exclude';
ud.limitenable = 1;
gr.ctext=xregGui.uicontrol('style','text',...
   'parent',figh,...
   'position',[pos(1)+4*pos(3)/5-35 pos(2)+32 70 16],...
   'string','Color by:',...
   'backgroundcolor','w',...
   'userdata',ud,...
   'visible','off',...
   'enable','inactive');

gr.MouseMotion = [];

% set up faces for colorbar
pr_cbarfaces(gr.colorbar.bar,cmap,gr);

gr=class(gr,'xregcolorbar');

% set up callbacks with object
set(gr.colorbar.userange,'callback',{@chboxcb,gr});
cb = linedragcb(gr);
gr.colorbar.linebupcb = cb.ButtonUp;
gr.colorbar.linemotioncb = cb.Motion;
set(gr.colorbar.maxrange,'buttondownfcn',{cb.ButtonDown,gr,'max'});
set(gr.colorbar.minrange,'buttondownfcn',{cb.ButtonDown,gr,'min'});
set(gr.colorbar.midrange,'buttondownfcn',{cb.ButtonDown,gr,'mid'});
set(gr.colorbar.bar,'buttondownfcn',{@cmapcb,gr});
set(gr.cfactor,'callback',{@i_plot,gr});

mcb = @i_setMousePtr;
% Create some motion managers
gr.MouseMotion = [...
        xregGui.MotionManager('MouseInFcn',{mcb,gr,1},...
        'MouseOutFcn',{mcb,gr,0}),...
        xregGui.MotionManager('MouseInFcn',{mcb,gr,1},...
        'MouseOutFcn',{mcb,gr,0}),...
        xregGui.MotionManager('MouseInFcn',{mcb,gr,1},...
        'MouseOutFcn',{mcb,gr,0}),...
        xregGui.MotionManager('ExternalRef',gr.colorbar.axes,'UseExternalRef','on')];

mm=MotionManager(figh);
mm.RegisterManager(gr.MouseMotion(4));
for n=1:3
   gr.MouseMotion(4).RegisterManager(gr.MouseMotion(n));
end

% save an object handle in the patch for later use.
builtin('set',gr.colorbar.axes,'userdata',gr);

% set extra props if specified
if nargin>1 & isnumeric(varargin{1}); 
   % Set properties that are passed in
   gr=set(gr,'visible','on',varargin{2:end});
elseif nargin>0 & ~isnumeric(varargin{1})
   gr=set(gr,'visible','on',varargin{:});
else
   set([gr.cfactor;gr.ctext;gr.colorbar.axes;gr.colorbar.bar;...
           gr.colorbar.userange;gr.colorbar.frame1;...
           gr.colorbar.frame2],'visible','on');
end



%-------------------------------------------
function chboxcb(src,event,gr)
%-------------------------------------------
%XREGCOLORBAR/CHBOXCB   Callback function
%

set(gr,'userange',get(gr.colorbar.userange,'value'));
ud = get(gr.patch,'userdata');
cb = ud.callback;
vis = get(gr.colorbar.userange,'userdata');
if ~isempty(cb) & strcmp(vis,'on') & ~ud.setcallback
    % Ensure callback fired once.
    xregcallback(cb);
end

%-------------------------------------------
function cmapcb(src,event,gr)
%-------------------------------------------
%CMAPCB   Callback function
% callback function for interactively chnaging colormap in image
% display of xregcolorbar object.  Uses UISETCOLORMAP.

% Get up-to-date version of object
gr = builtin('get',gr.colorbar.axes,'userdata');

figh=get(gr.axes,'parent');

% look for a double click
if strcmp(lower(get(figh,'selectiontype')),'open')
   PR = xregGui.PointerRepository;
   pointerID = PR.stackSetPointer(figh,'watch');
   
   cmapnow=get(gr.colorbar.bar,'facevertexcdata');
   % pop up ui for colormap
   cmap=uisetcolormap(cmapnow,NaN);
   
   if cmap==0
      % User pressed cancel
      set(figh,'pointer','arrow');
      return
   end
   
   % Apply colormap to object
   set(gr,'colormap',cmap);
   PR = xregGui.PointerRepository;
   PR.stackRemovePointer(figh,pointerID);
   figure(figh);
end
return

%-------------------------------------------
function i_plot(src,event,gr)
%-------------------------------------------
pr_graphlim(gr);
pr_plot(gr);

%-------------------------------------------
function i_setMousePtr(src,event,gr,region)
%-------------------------------------------
% SETMOUSEPTR  Set the correct mouse pointer
%
%   obj.setMousePtr(region)
%   where region =:
%     0  -  Mouse out
%     1  -  Up/Down


fH=get(gr.axes,'parent');
pr=xregGui.PointerRepository;
ud = get(gr.patch,'userdata');
ID=ud.MousePtrStackID;
switch region
case 0
   if ~isempty(ID)
      pr.stackRemovePointer(fH,ID);
      ud.MousePtrStackID=[];
   end
case 1
   % switch to new pointer
   ud.MousePtrStackID= pr.stackSetPointer(fH,'uddrag');
   % if we were in old region, remove this one form underneath new one
   i_rempointer(pr,fH,ID);
end
set(gr.patch,'userdata',ud);

function i_rempointer(pr,fH,ID)
if ~isempty(ID)
   pr.stackRemovePointer(fH,ID);
end
return