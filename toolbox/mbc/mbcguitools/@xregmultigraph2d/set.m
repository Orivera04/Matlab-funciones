function gr=set(gr,varargin)
%  GRAPH2D/SET   Set interface for graph2d object
%   Provides a set interface to the graph2d object.  This object has two modes
%   of operation:  if a factors list is specified then it plots ones column
%   against another.  If row and column headings are specified then it plots a 2D
%   image of the entire data matrix.
%
%   Valid properties are:
%     'Position'  -  4 element position vector in pixels
%     'Visible'   -  'on' or 'off'
%     'Data'      -  matrix of data with a column for each factor
%     'YData'     -  matrix of data with a column for each y-factor
%     'CData'     -  matrix of data, same size as YData, value for each point
%     'Factors'   -  cell array of strings corresponding to each factor
%     'CFactor'   -  string corresponding to color data
%     'YFactors'  -  cell array of strings; used for title
%     'FactorSelection' - 'Exclusive', 'normal' factor selection type
%     'FillMask'  -  matrix of 0 | 1, size(no. y factors, no. x factors) indicating
%                      whether to plot markers filled or empty for multiplots.
%     'Parent'    -  change parent figure (useful for saving a copy of graph)
%     'Type'      -  one of 'single', 'multi', 'MultiNoError' or 'table'
%     'Transparentcolor' - color to set ui item backgrounds to when the overalll
%                          background is set to 'none' by prefsgui
%     'Backgroundcolor' - color for background patch
%     'Callback'  -  Callback string, function handle or cell array to execute 
%                    when a different factor is chosen.
%     'SinglePlotCallback' - Callback to execute when single line is plotted
%                            (eg to turn legend off/on)
%     'MultiPlotCallback'  - Callback to execute when multiple lines are plotted
%     'Userdata'  -  Userdata field for general use by user.
%     'Grid'      -  Turn grid on or off.
%     'Markersize'-  Set lines to use the given markersize
%     'Marker'    -  Set lines to use the given markers (cell array, or string 
%                     of single character markers)
%     'Markercolor'- Set lines to use the given marker colors when colorbar is off
%                     Must be nx3 matrix (empty for default).
%     'Frame'     -  On/off: turn the bounding box on and off
%     'Table'     -  Set ptr to table
%     'TableIndex'-  Index of valid points
%     'ColorBar'  -  On/Off: turn colorbar on and off
%     'ColorLimitStyle' - 'normal','limit','inactive'
%                    Fix colorbar map between min and max 
%                    (normal) or map between limits (limit), or disable.
%     'ColorExcludeStyle' - 'color','blank','exclude'  Determines how to color
%                     points outside colorbar limits.
%     'YunitString'- Display units, shown for error and multiple selection.
%     'Title'     -  Set title of graph
%
%   Plus a load of other properties that are visible by getting the handles

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:36 $

% Bail if we've not been given a graph2d object
if ~isa(gr,'xregmultigraph2d')
   error('Cannot set properties: not an xregmultigraph2d object!')
end

redraws=[0 0 0 0];  % flags to signal a factorsort, graphlim, plot and cbarfaces

% loop over varargin
for n=1:2:(nargin-2)
   drawreqs=[0 0 0 0];
   switch lower(varargin{n})
   case 'position'
      [gr,drawreqs]=i_position(gr,varargin{n+1});      
   case 'visible'
      [gr,drawreqs]=i_visible(gr,varargin{n+1}); 
   case {'data','value','number','xdata'}
      [gr,drawreqs]=i_xdata(gr,varargin{n+1}); 
   case {'ydata','output'}
      [gr,drawreqs]=i_ydata(gr,varargin{n+1}); 
   case {'colordata','cdata'}
      [gr,drawreqs]=i_cdata(gr,varargin{n+1}); 
   case {'factors','infactors','xfactors'}
      [gr,drawreqs]=i_factors(gr,varargin{n+1},'x');
   case {'colorstring','colorfactor','cfactor'}
      [gr,drawreqs]=i_factors(gr,varargin{n+1},'c');
   case 'yfactors'
      [gr,drawreqs]=i_factors(gr,varargin{n+1},'y');
   case 'parent'
      set([gr.axes;gr.xfactor;gr.xtext;gr.yfactor;gr.ytext],'parent',varargin{n+1});
      drawreqs=[0 0 0 0];
   case 'type'
      [gr,drawreqs]=i_type(gr,varargin{n+1});
   case 'colormap'
      [gr,drawreqs]=i_cmap(gr,varargin{n+1});
   case 'grid'
      [gr,drawreqs]=i_grid(gr,varargin{n+1});
   case 'factorselection'
      [gr,drawreqs]=i_seltype(gr,varargin{n+1});
   case 'currentxfactor'
      [gr,drawreqs]=i_select(gr,varargin{n+1},'x');
   case 'currentyfactor'
      [gr,drawreqs]=i_select(gr,varargin{n+1},'y');
   case {'currentcfactor','currentcolorfactor'}
      [gr,drawreqs]=i_select(gr,varargin{n+1},'c');
   case {'limits','xlimits'}
      [gr,drawreqs]=i_limits(gr,varargin{n+1},'x');
   case {'ylimits'}
      [gr,drawreqs]=i_limits(gr,varargin{n+1},'y');
   case 'transparentcolor'
      [gr,drawreqs]=i_transclr(gr,varargin{n+1});
   case 'backgroundcolor'
      [gr,drawreqs]=i_backclr(gr,varargin{n+1});
   case 'callback'
      [gr,drawreqs]=i_callback(gr,varargin{n+1},'factor');
   case {'singleplotcallback','singlecallback'}
      [gr,drawreqs]=i_callback(gr,varargin{n+1},'single');
   case {'multiplotcallback','multicallback'}
      [gr,drawreqs]=i_callback(gr,varargin{n+1},'multi');
   case 'frame'
      [gr,drawreqs]=i_frame(gr,varargin{n+1});
   case 'colorbar'
      [gr,drawreqs]=i_colorbar(gr,varargin{n+1});
   case 'userdata'
      ud=get(gr.axes,'userdata');
      ud.userdata=varargin{n+1};
      set(gr.axes,'userdata',ud);
   case 'markersize'
      [gr,drawreqs]=i_markersize(gr,varargin{n+1});
   case 'markercolor'
      [gr,drawreqs]=i_markercolor(gr,varargin{n+1});
   case {'table','tableptr'}
      [gr,drawreqs]=i_table(gr,varargin{n+1});
   case 'uicontextmenu'
      [gr,drawreqs]=i_menu(gr,varargin{n+1});
   case 'fillmask'
      [gr,drawreqs]=i_fillmask(gr,varargin{n+1});
   case {'marker','markers'}
      [gr,drawreqs]=i_marker(gr,varargin{n+1});
   case 'colorlimitstyle'
      drawreqs = [1 0 1 1];
      set(gr.colorbar,varargin{n:n+1});
   case 'colorexcludestyle'
      [gr,drawreqs]=i_excludestyle(gr,varargin{n+1});
   case {'yunitstring','yunit'}
      [gr,drawreqs]=i_yunitstring(gr,varargin{n+1});
   case 'title'
      [gr,drawreqs]=i_settitle(gr,varargin{n+1});
   case 'tableindex'
      [gr,drawreqs]=i_tableindex(gr,varargin{n+1});
   end
   redraws= (redraws | drawreqs);
end

if redraws(1)
   pr_factorsort(gr);
end
if redraws(4)
   pr_initlines(gr)
end
if redraws(2)
   pr_graphlim(gr);
end
if redraws(3)
   pr_plot(gr);
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_position  -  alter position of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_position(gr,newpos);

drawreqs=[0 0 0 0];

% decide whether object is set to invisible
vis=get(gr.badim,'userdata');
ud = get(gr.axes,'userdata');

ud.pos = newpos;

% set objects invisible
set([gr.badim;gr.axes;gr.patch;gr.xfactor;gr.yfactor;gr.xtext;gr.ytext],'visible','off');
hextras=i_hextras(gr.axes,'off');
set(hextras,'visible','off');
set(gr.colorbar,'visible','off');

set(gr.axes,'userdata',ud);

% if position is too small, display an image indicating this!
mnsz=minsize(gr);
if newpos(3)<mnsz(1) | newpos(4)<mnsz(2)
   % go to blackout mode
   % need to calc position of icon
   cp=max(newpos(1:2),floor(newpos(1:2)+newpos(3:4).*0.5)-15);
   wd=min([32 32],newpos(3:4));
   wd=max(wd,[1 1]);
   %ptchpos=newpos+[0 1 -1 -1];
   %ptchpos(3:4)=max(ptchpos(3:4),[1 1]);
   %set(gr.patch,'position',ptchpos,'visible',vis);
   set(gr.badim,'xdata',[cp(1) cp(1)+wd(1)],'ydata',[cp(2) cp(2)+wd(2)],'visible',vis);
else
   % work out positions
   % patch
   ptchpos=newpos+[0 1 -1 -1];
   ptchpos(3:4)=max(ptchpos(3:4),[1 1]);
   set(gr.patch,'position',ptchpos)
   
   % colorbar
   if ud.colorbar & ptchpos(3)>250
       newpos(3) = newpos(3) - 100;
       set(gr.colorbar,'position',[newpos(3)+ptchpos(1) ptchpos(2)+1 100 ptchpos(4)-1],'visible',vis);
   end
   % axes
      if newpos(4)<250
         delta=max(60,(80-0.5*(250-newpos(4))));
      else
         delta=80;
      end
      pos(2)=newpos(2)+delta;
      pos(4)=newpos(4)-delta-25;
      pos(1)=newpos(1)+50;
      pos(3)=newpos(3)-80;
   set(gr.axes,'position',pos);
   
   uihs=70;
   % check sizes of ui's fit
   if newpos(3)<280
      % need to have smaller uis
      uihs=floor((newpos(3)-4)./4);
   end
   
   
   % ui's
   pos(1)=newpos(1);  
   pos(2)=newpos(2);
   pos(3)=newpos(3);
   if newpos(4)<250
      % gradually reduce from 50 to 30 pixels 
      pos(4)=max(30,50-0.5*(250-newpos(4)));
   else
      % max out at 50 from 250 upwards
      pos(4)=50;
   end
   
   set(gr.controls,'position',pos);   
   
   drawreqs(2)=1;
   
   if ~strcmp(vis,'off')
      hndls=[gr.axes;gr.patch];
      hndls=[hndls;gr.xtext;gr.xfactor;gr.ytext;gr.yfactor];
      set(i_hextras(hextras,'on'),'visible','on');
      set(hndls,'visible','on');
   end
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_hextras  -  check whether patches have any data defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There is an R12 bug, where patches with xdata = [] cause
%  seg violation when the axes are right-clicked
% Get around this by ensuring such patches are invisible.

function h=i_hextras(hndls,vis);

switch vis
case 'off'
    h = get(hndls,'children');
case 'on'
    h = [];
    for i = 1:length(hndls)
        if strcmp(lower(get(hndls(i),'type')),'patch') & isempty(get(hndls(i),'xdata'))
        else
            h = [h hndls(i)];
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_visible  -  alter visibility of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_visible(gr,vis);

drawreqs=[0 0 0 0];

if strcmp(vis,'off');
   oldvis = get(gr.badim,'userdata');
   hextras=i_hextras(gr.axes,'off');
   set([gr.badim;gr.xfactor;gr.yfactor;gr.xtext;gr.ytext;...
         gr.axes;gr.patch],'visible',vis);
   set(hextras(:),'visible','off');
   set(gr.badim,'userdata','off');
   set(gr.colorbar,'visible',vis);
else
   mnsz=minsize(gr);
   hndls=[];
   ud=get(gr.axes,'userdata');
   pos = ud.pos;
   if pos(3)<mnsz(1) | pos(4)<mnsz(2)
      hndls=[hndls; gr.badim];
   else
      hextras=i_hextras([ud.lines(:);ud.patches(:)],'on');
       % This will miss any added children (eg unknown, application
       %  dependant lines).  However, it's all a bit difficult since
       %  xregGui deparents lines once they become invisible, so getting
       %  the children of an axes no longer returns these handles.  Tricky!
       % Also, what if additional lines are created whilst the whole thing
       %  is invisible?  Leave this until someone needs it!
       % Could grab children before making axis invisible, but what if graph
       %  is then turned invisible again?  Or what if these children are
       %  deleted whilst invisible? - trying to turn them back on would 
       %  give an error.
      hndls=[hndls;hndls;gr.xtext;gr.xfactor;gr.ytext;gr.yfactor;...
        gr.axes;gr.patch];
      set(hextras,'visible','on');
   end
   set(hndls,'visible','on');
   set(gr.badim,'userdata','on');
   if ud.colorbar
       set(gr.colorbar,'visible','on');
   end
end
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_data  -  insert data into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_xdata(gr,data);
% interesting one.  Need to plot nth column of data if there are labels
% defined and they don't go outside the defined data
set(gr.xtext,'userdata',data);
drawreqs=[1 1 1 1];
return

function [gr,drawreqs]=i_ydata(gr,data);
% interesting one.  Need to plot nth column of data if there are labels
% defined and they don't go outside the defined data
set(gr.ytext,'userdata',data);
drawreqs=[1 1 1 1];
return

function [gr,drawreqs]=i_cdata(gr,data);
% interesting one.  Need to plot nth column of data if there are labels
% defined and they don't go outside the defined data
set(gr.yfactor,'userdata',data);
drawreqs=[1 1 1 1];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_factors  -  insert factors into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_factors(gr,factors,ax);

if ischar(factors)
    factors = {factors};
elseif size(factors,1)==1 & size(factors,2)>2
   factors=factors(:);
end

drawreqs=[1 0 1 0];
ud = get(gr.axes,'userdata');
switch ax
case 'x'
    ud.xfactors = factors;
    % Check some table stuff
    i_tablestuff(gr,ud);
case 'c'
    ud.cfactors = factors;
case 'y'
    ud.yfactors = factors;
end
set(gr.axes,'userdata',ud);
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_type  -  change type of 2d graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_type(gr,tp)
tp=lower(tp);
drawreqs=[0 0 0 0];
if ~any(strcmp(tp,{'single','multi','table','multinoerror'}))
   return
end
ud = get(gr.axes,'userdata');
if ~strcmp(tp,ud.type)
    ud.type = tp;
   
   drawreqs([1 2 3 4])=1;
    set(gr.axes,'userdata',ud);
   
end
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_cmap  -  insert new colormap for image view
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_cmap(gr,cmap);
% update colorbar
set(gr.colorbar,'cmap',cmap);

% Will need to replot data to ensure new colormap is carried into data
drawreqs=[0 0 1 0];

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_grid  -  turn grid on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_grid(gr,grd);

if strcmp(grd,'on')
   val=1;
else
   val=0;
end

ud = get(gr.axes,'userdata');
ud.grid = val;
set(gr.axes,'userdata',ud,'xgrid',grd,'ygrid',grd);
drawreqs=[0 0 0 0];
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_select  -  change factor selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_select(gr,sel,ax);

switch ax
case 'x'
   set(gr.xfactor,'value',sel);
case 'y'
   set(gr.yfactor,'value',sel);
case 'c'
    set(gr.colorbar,'currentfactor',sel);
end

drawreqs=[0 0 1 0];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_limits  -  set explicit limits on the factors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_limits(gr,lim,ax);

ud = get(gr.axes,'userdata');
switch ax
case 'x'
    if iscell(lim)
        ud.limits = lim;
    end
case 'y'
    ud.ylimits = lim;
end
set(gr.axes,'userdata',ud);
drawreqs=[0 1 0 0];
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_seltype  -  change behaviour of lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_seltype(gr,selset);
drawreqs=[0 0 0 0];

switch lower(selset)
case 'exclusive'
    val = 1;
    % Don't worry about trying to enforce exclusive setting now.
case 'normal'
    val = 0;
end
ud = get(gr.axes,'userdata');
ud.exclusive = val;
set(gr.axes,'userdata',ud);
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_transclr  -  change transparency colour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_transclr(gr,col);

ud = get(gr.axes,'userdata');
ud.transcolor = col;
set(gr.axes,'userdata',ud);
% update if patch is set to none.
cnow=get(gr.patch,'facecolor');
if ischar(cnow)
   if strcmp(cnow,'none')
      set([gr.xtext;gr.ytext],'backgroundcolor',col);
   end
end
drawreqs=[0 0 0 0];
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_backclr  -  change background colour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_backclr(gr,col);

ud = get(gr.axes,'userdata');

if ischar(col) & strcmp(col,'none')
    bgcol = ud.transcolor;
else
   bgcol=col;
end
set(gr.patch,'facecolor',col);
set([gr.xtext;gr.ytext],'backgroundcolor',bgcol);
set(gr.colorbar,'backgroundcolor',bgcol);
drawreqs=[0 0 0 0];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_frame  -  turn bounding frame on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_frame(gr,state);
if strcmp(state,'on')
   set(gr.patch,'edgecolor','k');
else
   set(gr.patch,'edgecolor','none');
end
drawreqs=[0 0 0 0];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_colorbar  -  turn colorbar on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_colorbar(gr,state);
ud = get(gr.axes,'userdata');
if isnumeric(state)
    val = state;
elseif strcmp(state,'on')
   val = 1;
else
   val = 0;
end
ud.colorbar = val;
set(gr.axes,'userdata',ud);
% update colorbar position and visiblity
[gr,drawreqs] = i_position(gr,ud.pos);
% Got to sort factors to get names for colorbar
drawreqs = drawreqs | [1 0 1 0];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_markersize  -  change size of line markers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_markersize(gr,size);
ud = get(gr.axes,'userdata');
ud.markersize = size;
set(gr.axes,'userdata',ud);
hndls = [ud.lines ud.patches];
if ~isempty(hndls)
    set(hndls,'markersize',size);
end
drawreqs=[0 0 0 0];
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_markercolor  -  change color of line markers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_markercolor(gr,color);

drawreqs=[0 0 0 0];
ud = get(gr.axes,'userdata');
if ischar(color)
    color = cellstr(color(:));
elseif isnumeric(color)
    if size(color,2)==3
        color = num2cell(color,2);
    else
        color = {};
    end
elseif ~iscell(color)
    color = {};
end
ud.markercolor = color;
set(gr.axes,'userdata',ud);
% Need to check correct number given.
%  Then need to replot (may be filled/empty)
drawreqs=[0 0 1 1];
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_table  -  insert table into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_table(gr,tableptr);

ud = get(gr.axes,'userdata');
ud.tableptr = tableptr;
set(gr.axes,'userdata',ud);
% Work out some stuff
i_tablestuff(gr,ud);
drawreqs=[0 1 1 0];
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_tablestuff  -  check factor matching
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_tablestuff(gr,ud);

% Work out some useful things for plotting
tud = [];
if ~isempty(ud.tableptr) & isvalid(ud.tableptr)
    axesptrs = ud.tableptr.get('axesptrs');
    axes = ud.tableptr.get('axes');
    if ~iscell(axes)
        % Need to set up dummy second axis for plot routine
        axes = [{axes} {1}];
    end
    tud.axes = axes;
    tud.axesptrs = axesptrs;
    % Attempt to match against xfactors
    tud.xfactor_i = repmat(0,1,length(axesptrs));
    tud.tfactor_i = repmat(0,1,length(ud.xfactors));
    for i = 1:length(axesptrs)
        axname = axesptrs(i).getname;
        ind = strmatch(axname,ud.xfactors,'exact');
        if length(ind)==1
            tud.xfactor_i(i) = ind;
            tud.tfactor_i(ind) = i;
        end
    end
    tud.values = ud.tableptr.get('values');
    tud.locks = ud.tableptr.get('vlocks');
end
set(gr.xfactor,'userdata',tud);
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_menu  -  insert context menu into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_menu(gr,menu);

ud = get(gr.axes,'userdata');
ud.contextmenu = menu;
set(gr.axes,'userdata',ud);
hextras=get(gr.axes,'children');
hndls=[gr.xtext;gr.xfactor;gr.ytext;gr.yfactor;...
        gr.axes;gr.patch];
if isempty(menu)
    gmenu = 0;
else
    gmenu = menu;
end
set(hndls,'uicontextmenu',gmenu);
set(hextras(:),'uicontextmenu',menu);
set(gr.colorbar,'uicontextmenu',menu);
drawreqs=[0 0 0 0];
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_fillmask  -  insert fillmask into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_fillmask(gr,mask);

ud = get(gr.axes,'userdata');
ud.fillmask = mask;
set(gr.axes,'userdata',ud);
drawreqs=[0 0 1 1];
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_marker  -  insert marker types into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_marker(gr,marker);

ud = get(gr.axes,'userdata');
if ischar(marker)
    marker = cellstr(marker(:));
end
ud.marker = marker;
set(gr.axes,'userdata',ud);
drawreqs=[0 0 0 1];
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_callback  -  insert callback types into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_callback(gr,cb,type);

ud=get(gr.axes,'userdata');
switch type
case 'factor'
    ud.callback=cb;
case 'single'
    ud.singlecallback=cb;
case 'multi'
    ud.multicallback=cb;
end
drawreqs=[0 0 0 0];
set(gr.axes,'userdata',ud);
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_excludestyle  -  insert limit exlusion style into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_excludestyle(gr,style);

style = lower(style);
drawreqs = [0 0 0 0];
if ~isempty(strmatch(style,{'color','blank','exclude'}))
    ud = get(gr.axes,'userdata');
    ud.excludestyle = style;
    set(gr.axes,'userdata',ud);
    drawreqs=[0 0 1 0];
end
return






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_yunitstring  -  insert display string into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_yunitstring(gr,yunit);

if ischar(yunit)
    ud = get(gr.axes,'userdata');
    ud.yunitstring = yunit;
    set(gr.axes,'userdata',ud);
    drawreqs=[1 0 1 0];
end
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_tableindex  -  insert table point index into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_tableindex(gr,index);

ud = get(gr.axes,'userdata');
ud.tableindex = index;
set(gr.axes,'userdata',ud);
drawreqs=[0 0 1 0];
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_settitle  -  insert title into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_settitle(gr,new);
drawreqs =[0 0 0 0];
ud=get(gr.axes,'userdata');
ud.title=new;
set(gr.axes,'userdata',ud);
if ~isempty(ud.title)
    set(get(gr.axes,'title'),'string',ud.title,'interpreter','none');
else
    drawreqs(3) = 1;
end
