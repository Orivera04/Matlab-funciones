function gr=set(gr,varargin)
%  XREGCOLORBAR/SET   Set interface for the xregcolorbar object
%   Provides a set interface to the xregcolorbar object.  
%
%   Valid properties are:
%     'Position'  -  4 element position vector in pixels
%     'Visible'   -  'on' or 'off'
%     'Data'      -  matrix of data with a column for each factor
%     'Factors'   -  cell array of strings corresponding to each factor
%     'Callback'  -  redraw callback
%     'CallbackMode'- 'All' or 'External': External only fires callbacks on 
%                        a user click, not on a set command.
%     'Parent'    -  change parent figure (useful for saving a copy of graph)
%     'Userange'  -  toggle on the range on the colormap variable
%     'Transparentcolor' - color to set ui item backgrounds to when the overall
%                          background is set to 'none' by prefsgui
%     'Backgroundcolor' - color for background patch
%     'Frame'     -  On/off: turn bounding frame on/off
%     'Limitstyle' - 'exclude','color'
%     'uicontextmenu' - set context menu for object
%     'currentfactor' - current selected factor
%     'minrange','midrange','maxrange'  -  set range position in current units
%     'range'     - set min, max to two-element vector
%     'relminrange','relmidrange','relmaxrange'  -  
%                    set relative range position (0<value<1)
%     'relrange'     - set min, max to relative two-element vector
%     'limitenable'  - enable limit box
%
%   Plus a load of other properties that are visible by getting the handles

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.4 $  $Date: 2004/04/04 03:29:10 $


% Bail if we've not been given an xregcolorbar object
if ~isa(gr,'xregcolorbar')
   error('Cannot set properties: not an xregcolorbar object!')
end
redraws=[0 0 0 0 0];  % flags to signal a cbarfaces
% loop over varargin
for n=1:2:(nargin-2)
   switch lower(varargin{n})
   case 'position'
      [gr,drawreqs]=i_position(gr,varargin{n+1});      
   case 'visible'
      [gr,drawreqs]=i_visible(gr,varargin{n+1}); 
   case 'parent'
      set([gr.patch;gr.cfactor;gr.ctext;gr.colorbar.axes;gr.colorbar.frame1;...
              gr.colorbar.frame2;gr.colorbar.userange],'parent',varargin{n+1});
      drawreqs=[0 0 0 0 0];
   case 'colormap'
      [gr,drawreqs]=i_cmap(gr,varargin{n+1});
   case {'data','value','number'}
      [gr,drawreqs]=i_data(gr,varargin{n+1}); 
   case 'factors'
      [gr,drawreqs]=i_factors(gr,varargin{n+1});
   case 'frame'
      [gr,drawreqs]=i_frame(gr,varargin{n+1});
   case 'userange'
      [gr,drawreqs]=i_userange(gr,varargin{n+1});
   case 'limitenable'
      [gr,drawreqs]=i_limitenable(gr,varargin{n+1});
   case 'currentfactor'
      [gr,drawreqs]=i_select(gr,varargin{n+1},'c');
   case 'transparentcolor'
      [gr,drawreqs]=i_transclr(gr,varargin{n+1});
   case 'backgroundcolor'
      [gr,drawreqs]=i_backclr(gr,varargin{n+1});
   case 'callback'
       ud = get(gr.patch,'userdata');
       ud.callback = varargin{n+1};
       set(gr.patch,'userdata',ud);
       drawreqs = [0 0 0 0 0];
   case 'callbackmode'
      [gr,drawreqs]=i_cbmode(gr,varargin{n+1});
   case {'limitstyle','colorlimitstyle'}
      [gr,drawreqs]=i_limitstyle(gr,varargin{n+1});
   case 'uicontextmenu'
      [gr,drawreqs]=i_contextmenu(gr,varargin{n+1});
   case {'minrange','midrange','maxrange'}
      [gr,drawreqs]=i_range(gr,varargin{n:n+1},'abs');
   case {'relminrange','relmidrange','relmaxrange'}
      [gr,drawreqs]=i_range(gr,varargin{n:n+1},'rel');
   case 'range'
      [gr,drawreqs]=i_allrange(gr,varargin{n+1},'abs');
   case 'relrange'
      [gr,drawreqs]=i_allrange(gr,varargin{n+1},'rel');
   end
   redraws= (redraws | drawreqs);
end
if redraws(2)
   pr_graphlim(gr);
end
if redraws(3)
   % Callbacks fired from here if necessary
   pr_plot(gr,1);
end
if redraws(4)
   pr_cbarfaces(gr.colorbar.bar,get(gr.colorbar.bar,'facevertexcdata'),gr);;
end
if redraws(5)
   pr_setMotionRegions(gr);
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_position  -  alter position of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_position(gr,newpos);
drawreqs=[0 0 0 0 0];
% decide whether object is set to invisible
vis=get(gr.colorbar.userange,'userdata');
% set objects invisible
set([gr.patch;gr.ctext;gr.cfactor;gr.colorbar.axes;gr.colorbar.bar;gr.colorbar.frame1;...
      gr.colorbar.frame2;gr.colorbar.minrange;gr.colorbar.midrange;gr.colorbar.maxrange;...
      gr.colorbar.userange],'visible','off');

mnsz=minsize(gr);
if newpos(3)<mnsz(1) | newpos(4)<mnsz(2)
   % go to blackout mode
else
   
   % work out positions
   % patch
   ptchpos=newpos+[0 1 -1 -1];
   ptchpos(3:4)=max(ptchpos(3:4),[1 1]);
   set(gr.patch,'position',ptchpos);
   
   % decide uiwidth
   uihs=min(40, (newpos(3)-8)*0.5 );
   halfuihs=uihs*0.5;
   
   % ctext
   pos(1)=newpos(1)+newpos(3)-2*uihs -4;  
   pos(2)=newpos(2)+35;
   pos(3)=uihs*2;
   pos(4)=20;
   set(gr.ctext,'position',pos);
   
   % cfactor
   pos(1)=newpos(1)+newpos(3)-2*uihs -4;   
   pos(2)=newpos(2)+15;
   pos(3)=uihs*2;
   pos(4)=20;
   set(gr.cfactor,'position',pos);
   
   % colorbar
   % axes
   pos(1)=newpos(1)+newpos(3)-60;
   pos(2)=newpos(2)+100;
   pos(3)=20;
   pos(4)=newpos(4)-125;
   set(gr.colorbar.axes,'position',pos);
   
   drawreqs(2)=1;
   
   % bar
   % no resize necessary
   
   % range bars
   ylim=get(gr.colorbar.axes,'ylim');
   clen=ylim(2)-ylim(1);
   delta=2*(clen)/pos(4);
   barval=get(gr.colorbar.minrange,'userdata');
   set(gr.colorbar.minrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
         0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
   barval=get(gr.colorbar.midrange,'userdata');
   set(gr.colorbar.midrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
         0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
   barval=get(gr.colorbar.maxrange,'userdata');
   set(gr.colorbar.maxrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
         0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
   
   
   % extra frame bits
   pos(1)=newpos(1)+newpos(3)-51;
   pos(2)=newpos(2)+90;
   pos(3)=2;
   pos(4)=10;
   set(gr.colorbar.frame1,'position',pos);
   
   pos(1)=newpos(1)+newpos(3)-86;
   pos(2)=newpos(2)+89;
   pos(3)=72;
   pos(4)=1;
   set(gr.colorbar.frame2,'position',pos);
   
   % range checkbox
   pos(1)=newpos(1)+newpos(3)-86;
   pos(2)=newpos(2)+65;
   pos(3)=72;
   pos(4)=24;
   set(gr.colorbar.userange,'position',pos);
   
   
   if ~strcmp(vis,'off')
      hndls=[gr.ctext;gr.cfactor;gr.colorbar.axes];
      ud = get(gr.ctext,'userdata');
      if ud.limitenable
          hndls = [hndls;gr.colorbar.frame1;...
                  gr.colorbar.frame2;gr.colorbar.userange];
      end
      if get(gr.colorbar.userange,'value')
         hndls=[hndls;gr.colorbar.midrange;gr.colorbar.minrange;gr.colorbar.maxrange];
      end
      hndls = [hndls;gr.colorbar.bar;gr.patch];
      
      set(hndls,'visible','on');
   end
end
set(gr.cfactor,'userdata',newpos);
% update mouse motion regions
drawreqs(5) = 1;

return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_data  -  insert data into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_data(gr,data);
set(gr.colorbar.frame1,'userdata',data);
drawreqs=[1 1 1 0 0];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_factors  -  insert factors into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_factors(gr,factors);
if isempty(factors)
    factors = {' '};
elseif ischar(factors)
   factors={factors};
end
% Shorten all error factor names
factors= i_ShortenCFactor('Error (', factors);
factors= i_ShortenCFactor('Absolute Error', factors);
factors= i_ShortenCFactor('Relative Error', factors);
factors= i_ShortenCFactor('Absolute Relative Error', factors);
% Shorten other factor names
for i = 1:length(factors)
    if length(factors{i}) > 14
        factors{i} = factors{i}(1:14);
    end
end
set(gr.colorbar.frame2,'userdata',factors);
set(gr.cfactor,'string',factors,'value',1);
drawreqs=[1 0 1 0 0];
return

%-----------------------------------------------------------------------
function mycfacs = i_ShortenCFactor(str2shorten, mycfacs)
%-----------------------------------------------------------------------

ind = strmatch(str2shorten, mycfacs);
if ~isempty(ind)
    switch str2shorten
    case 'Error ('
        mycfacs{ind} = 'Error';
    case 'Absolute Error'
        mycfacs{ind} = 'Abs Error';
    case 'Relative Error'
        mycfacs{ind} = 'Rel Error';        
    case 'Absolute Relative Error'
        mycfacs{ind} = 'Abs Rel Error';
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_visible  -  alter visibility of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_visible(gr,vis);
drawreqs=[0 0 0 0 0];

%hndls=gr.patch;
hndls = [];
mnsz=minsize(gr);
pos=get(gr.cfactor,'userdata');
if pos(3)<mnsz(1) | pos(4)<mnsz(2)
    %too small
else
    hndls=[hndls;gr.ctext;gr.cfactor;gr.colorbar.axes];
    ud = get(gr.ctext,'userdata');
    if ud.limitenable
        hndls = [hndls;gr.colorbar.frame1;...
                gr.colorbar.frame2;gr.colorbar.userange];
    end
    if get(gr.colorbar.userange,'value')
        hndls=[hndls;gr.colorbar.midrange;gr.colorbar.minrange;gr.colorbar.maxrange];
   end
   % Bar must be after range markers
   hndls = [hndls;gr.colorbar.bar];
end
% Patch has to be last, otherwise xregGui draws it over everything else.
hndls = [hndls;gr.patch];
switch lower(vis)
case {'on','off'}
otherwise
   vis=get(gr.colorbar.userange,'userdata');
end
set(gr.colorbar.userange,'userdata',vis);
set(hndls,'visible',vis);

return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_cmap  -  insert new colormap for image view
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_cmap(gr,cmap);

oldylim=get(gr.colorbar.axes,'ylim');
% update colorbar
set(gr.colorbar.axes,'ylim',[0.5 size(cmap,1)+0.5]);
pr_cbarfaces(gr.colorbar.bar,cmap,gr);

cbpos=get(gr.colorbar.axes,'position');
% update range bars on colorbar
clen=size(cmap,1);
delta=2*(clen)/(cbpos(4));
barval=get(gr.colorbar.minrange,'userdata');
barval=0.5+(clen).*(barval-oldylim(1))./(oldylim(2)-oldylim(1));
set(gr.colorbar.minrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
      0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4],'userdata',barval);
barval=get(gr.colorbar.midrange,'userdata');
barval=0.5+(clen).*(barval-oldylim(1))./(oldylim(2)-oldylim(1));
set(gr.colorbar.midrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
      0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4],'userdata',barval);
barval=get(gr.colorbar.maxrange,'userdata');
barval=0.5+(clen).*(barval-oldylim(1))./(oldylim(2)-oldylim(1));
set(gr.colorbar.maxrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
      0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4],'userdata',barval);

drawreqs=[0 1 1 0 1];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_transclr  -  change transparency colour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_transclr(gr,col);
drawreqs=[0 0 0 0 0];
set(gr.colorbar.bar,'userdata',col);
% update if patch is set to none.
cnow=get(gr.patch,'color');
if ischar(cnow)
   if strcmp(cnow,'none')
      set([gr.ctext;gr.colorbar.userange],'backgroundcolor',col);
   end
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_backclr  -  change background colour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_backclr(gr,col);
drawreqs=[0 0 0 0 0];
if ischar(col) & strcmp(col,'none')
   bgcol=get(gr.colorbar.bar,'userdata');
else
   bgcol=col;
end
set(gr.patch,'color',col);
set([gr.ctext;gr.colorbar.userange],'backgroundcolor',bgcol);
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_frame  -  turn bounding frame on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_frame(gr,state);
if strcmp(state,'on')
   set(gr.patch,'box','on','xcolor','k','ycolor','k','zcolor','k');
else
   bgcol=get(gr.colorbar.bar,'userdata');
   set(gr.patch,'box','off','xcolor',bgcol,'ycolor',bgcol,'zcolor',bgcol);
end
drawreqs=[0 0 0 0 0];
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_limitstyle  -  change limit style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_limitstyle(gr,style);
if strcmp(style,'inactive')
    [gr,drawreqs] = i_limitenable(gr,'off');
else
    if isempty(strmatch(lower(style),{'normal','exclude','color','limit'}))
        error('xregcolorbar: set: unrecognised limit style');
    end
    ud = get(gr.ctext,'userdata');
    ud.limitstyle = lower(style);
    set(gr.ctext,'userdata',ud);
    drawreqs=[0 0 1 1 0];
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_contextmenu  -  set context menu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_contextmenu(gr,menu);
if isempty(menu), menu = 0; end
set([gr.patch;gr.ctext;gr.cfactor;gr.colorbar.axes;gr.colorbar.bar;gr.colorbar.frame1;...
      gr.colorbar.frame2;gr.colorbar.minrange;gr.colorbar.midrange;gr.colorbar.maxrange;...
      gr.colorbar.userange],'uicontextmenu',menu);
drawreqs=[0 0 0 0 0];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_select  -  change factor selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_select(gr,sel,ax);

switch ax
case 'c'
   obj=gr.cfactor;
end

set(obj,'value',sel);
drawreqs=[0 1 1 0 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_range  -  set single range position
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_range(gr,line,value,absrel);

ylim=get(gr.colorbar.axes,'ylim');
ud=get(gr.ctext,'userdata');
clim = ud.clim;

% need to scale number to actual values.
switch absrel
case 'abs'
    actval = value;
    udval = (value - clim(1))/(clim(2)-clim(1))*(ylim(2)-ylim(1)) + ylim(1);
    line = line(1:3);
case 'rel'
    udval = value*(ylim(2) - ylim(1)) + ylim(1);
    actval = value*(clim(2) - clim(1)) + clim(1);
    line = line(4:6);
end

% Use the motion routine to sort out new positions
%  and check for limiting cases.
feval(gr.colorbar.linemotioncb, [], [], gr, line, -1, udval);
drawreqs = [0 0 1 0 0];
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_allrange  -  set all three range positions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_allrange(gr,value,absrel);

if ~isnumeric(value) | length(value)~=2
    error('xregcolorbar::set: range must be two element vector');
end
ylim=get(gr.colorbar.axes,'ylim');
ud=get(gr.ctext,'userdata');
clim = ud.clim;

% need to scale number to actual values.
switch absrel
case 'abs'
    minud = (value(1) - clim(1))/(clim(2)-clim(1))*(ylim(2)-ylim(1)) + ylim(1);
    maxud = (value(2) - clim(1))/(clim(2)-clim(1))*(ylim(2)-ylim(1)) + ylim(1);
case 'rel'
    minud = value(1)*(ylim(2) - ylim(1)) + ylim(1);
    maxud = value(2)*(ylim(2) - ylim(1)) + ylim(1);
end
% Check for limits
if minud<ylim(1)
    minud = ylim(1);
end
if maxud>ylim(2)
    maxud = ylim(2);
end
midud = (minud+maxud)/2;

set(gr.colorbar.minrange,'userdata',minud);
set(gr.colorbar.midrange,'userdata',midud);
set(gr.colorbar.maxrange,'userdata',maxud);
% Use the cmap routine to sort out new positions
[gr,drawreqs]=i_cmap(gr,get(gr.colorbar.bar,'facevertexcdata'));
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_checkbox  -  set range limit check box
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_userange(gr,val);

if ischar(val)
    switch val
    case 'off'
        val = 0;
    case 'on'
        val = 1;
    end
end
set(gr.colorbar.userange,'value',val);

hndls = [gr.colorbar.midrange;gr.colorbar.minrange;gr.colorbar.maxrange];
switch val
case 0
   vis='off';
case 1
   vis='on';
   set(gr.colorbar.bar,'visible','off');
   hndls = [hndls;gr.colorbar.bar];
end
% xregGui needs things to be switched on in correct order
set(hndls,'visible',vis);

drawreqs = [0 0 1 1 1];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_cbmode  -  set callback mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_cbmode(gr,mode);

ud = get(gr.patch,'userdata');
switch mode
case 'all'
    ud.setcallback = 1;
case 'external'
    ud.setcallback = 0;
end
set(gr.patch,'userdata',ud);
drawreqs = [0 0 0 0 0];
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_limitenable  -  set limit enable mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_limitenable(gr,state);

ud = get(gr.ctext,'userdata');
switch state
case 'on'
    ud.limitenable = 1;
case 'off'
    ud.limitenable = 0;
end
hndls = [gr.colorbar.frame1;...
        gr.colorbar.frame2;gr.colorbar.userange];
set(hndls,'visible',state);
set(gr.ctext,'userdata',ud);
drawreqs = [0 0 0 0 0];
return