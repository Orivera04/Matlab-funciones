function gr=set(gr,varargin)
%SET Set interface for mvgraph2d object
%
%   Provides a set interface to the mvgraph2d object.  This object has two
%   modes of operation:  if a factors list is specified then it plots ones
%   column against another.  If row and column headings are specified then
%   it plots a 2D image of the entire data matrix.
%
%   Valid properties are:
%     'Position'  -  4 element position vector in pixels
%     'Visible'   -  'on' or 'off'
%     'Data'      -  matrix of data with a column for each factor
%     'Factors'   -  cell array of strings corresponding to each factor
%     'Parent'    -  change parent figure (useful for saving a copy of graph)
%     'Type'      -  one of 'graph', 'sparse' or 'image'
%     'Transparentcolor' - color to set ui item backgrounds to when the overalll
%                          background is set to 'none' by prefsgui
%     'Backgroundcolor' - color for background patch
%     'Callback'  -  Callback string to execute when a different factor is chosen.
%                    The string may contain the tokens %OBJECT%, %XVALUE% and %YVALUE%
%                    which are replaced with copies of the object, the x-factor popup
%                    value and the y-factor popup value respectively.
%     'Userdata'  -  Userdata field for general use by user.
%     'Grid'      -  Turn grid on or off.
%     'Markersize'-  Set the scatter plot line to use the given markersize
%     'Frame'     -  On/off: turn the bounding box on and off
%
%   Plus a load of other properties that are visible by getting the handles

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/20 23:18:52 $

% Bail if we've not been given a graph2d object
if ~isa(gr,'mvgraph2d')
    error('Cannot set properties: not a mvgraph2d object!')
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
        case {'data','value','number'}
            [gr,drawreqs]=i_data(gr,varargin{n+1}); 
        case 'factors'
            [gr,drawreqs]=i_factors(gr,varargin{n+1});
        case 'parent'
            set([gr.axes;gr.xfactor;gr.xtext;gr.yfactor;gr.ytext],'parent',varargin{n+1});
            drawreqs=[0 0 0 0];
        case 'type'
            [gr,drawreqs]=i_type(gr,varargin{n+1});
        case 'colormap'
            [gr,drawreqs]=i_cmap(gr,varargin{n+1});
        case 'grid'
            [gr,drawreqs]=i_grid(gr,varargin{n+1});
        case 'currentxfactor'
            [gr,drawreqs]=i_select(gr,varargin{n+1},'x');
        case 'currentyfactor'
            [gr,drawreqs]=i_select(gr,varargin{n+1},'y');
        case 'limits'
            [gr,drawreqs]=i_limits(gr,varargin{n+1});
        case 'factorselection'
            [gr,drawreqs]=i_seltype(gr,varargin{n+1});
        case 'transparentcolor'
            [gr,drawreqs]=i_transclr(gr,varargin{n+1});
        case 'backgroundcolor'
            [gr,drawreqs]=i_backclr(gr,varargin{n+1});
        case 'callback'
            ud = gr.DataPointer.info;
            ud.callback = varargin{n+1};
            gr.DataPointer.info = ud;
            drawreqs = [0 0 0 0];
        case 'frame'
            [gr,drawreqs]=i_frame(gr,varargin{n+1});
        case 'userdata'
            ud = gr.DataPointer.info;
            ud.userdata = varargin{n+1};
            gr.DataPointer.info = ud;
            drawreqs = [0 0 0 0];
        case 'markersize'
            set(gr.line,'markersize',varargin{n+1});
        case 'hittest'
            set([gr.axes;gr.line],'hittest',varargin{n+1});
        case 'datatags'
            [gr,drawreqs] = i_datatagtype(gr,varargin{n+1});
        case 'customdatatags'
            [gr,drawreqs] = i_customtags(gr,varargin{n+1});
    end
    redraws= (redraws | drawreqs);
end

if redraws(1)
    pr_factorsort(gr);
end
if redraws(2)
    pr_graphlim(gr);
end
if redraws(3)
    pr_plot(gr);
end
if redraws(4)
    pr_cbarfaces(gr.colorbar.bar,get(gr.colorbar.bar,'facevertexcdata'));
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_position  -  alter position of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_position(gr,newpos)

drawreqs=[0 0 0 0];
ud = gr.DataPointer.info;
% decide whether object is set to invisible
vis = ud.visible;

% if position is too small, display an image indicating this
mnsz=minsize(gr);
if newpos(3)<mnsz(1) || newpos(4)<mnsz(2)
    % go to blackout mode
    % need to calc position of icon
    cp=max(newpos(1:2),floor(newpos(1:2)+newpos(3:4).*0.5)-15);
    wd=min([32 32],newpos(3:4));
    wd=max(wd,[1 1]);
    ptchpos=newpos+[0 -1 0 0];
    ptchpos(3:4)=max(ptchpos(3:4),[1 1]);
    
    set([gr.image;gr.axes; ...
        gr.xfactor;gr.yfactor;gr.xtext;gr.ytext; ...
        gr.line;gr.colorbar.bar;gr.colorbar.axes],'visible','off');
    set(ud.datataghandles, 'visible', 'off');
    set(gr.patch,'position',ptchpos,'visible',vis);
    set(gr.badim,'xdata',[cp(1) cp(1)+wd(1)],'ydata',[cp(2) cp(2)+wd(2)],'visible',vis);
else
    % work out positions
    % axes
    if strcmp(ud.type,'graph')  
        if newpos(4)<250
            delta=max(60,(80-0.5*(250-newpos(4))));
        else
            delta=80;
        end
        pos(2)=newpos(2)+delta;
        pos(4)=newpos(4)-delta-25;
        pos(1)=newpos(1)+50;
        pos(3)=newpos(3)-80;
    elseif strcmp(ud.type,'image')
        pos(2)=newpos(2)+90;
        pos(4)=newpos(4)-115;
        pos(1)=newpos(1)+50;
        pos(3)=newpos(3)-80;
    else
        pos(2)=newpos(2)+30;
        pos(4)=newpos(4)-55;
        pos(1)=newpos(1)+50;
        pos(3)=newpos(3)-80;
    end
    set(gr.axes,'position',pos);
    
    % patch
    ptchpos=newpos+[0 -1 0 0];
    ptchpos(3:4)=max(ptchpos(3:4),[1 1]);
    set(gr.patch,'position',ptchpos)
    
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
    
    % colorbar axes
    pos(1)=newpos(1)+newpos(3)/10;
    pos(2)=newpos(2)+25;
    pos(3)=0.8*newpos(3);
    pos(4)=20;
    set(gr.colorbar.axes,'position',pos);
    
    drawreqs(2)=1;
    
    if strcmp(vis,'on')
        set(gr.badim, 'visible', 'off');
        hextras=get(gr.axes,'children');
        if length(hextras)
            remv=ismember(hextras,[gr.line;gr.image]);
            hextras(remv)=[];
        end
        hndls=[gr.axes;gr.patch];        
        switch lower(ud.type)
            case 'graph'
                hndls=[hndls;gr.line;gr.xtext;gr.xfactor;gr.ytext;gr.yfactor; hextras(:)];
            case 'sparse'
                hndls=[hndls;gr.line];
            case 'image'
                hndls=[hndls;gr.image;gr.colorbar.axes;gr.colorbar.bar];
        end
        set(hndls,'visible','on');
    end
end
ud.position = newpos;
gr.DataPointer.info = ud;
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_visible  -  alter visibility of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_visible(gr,vis)
drawreqs=[0 0 0 0];

ud = gr.DataPointer.info;
if strcmp(vis,'off');
    hextras=get(gr.axes,'children');
    if length(hextras)
        remv=ismember(hextras,[gr.line;gr.image]);
        hextras(remv)=[];
    end
    set([gr.badim;gr.xfactor;gr.yfactor;gr.xtext;gr.ytext;...
            gr.colorbar.bar;gr.colorbar.axes;gr.axes; ...
            gr.patch;gr.line;gr.image;hextras(:)], 'visible', vis);
    ud.visible = 'off';
else
    mnsz = minsize(gr);
    hndls = [];
    pos = ud.position;
    if pos(3)<mnsz(1) || pos(4)<mnsz(2)
        hndls=[hndls; gr.badim;gr.patch];
    else
        hextras=get(gr.axes,'children');
        if length(hextras)
            remv=ismember(hextras,[gr.line;gr.image]);
            hextras(remv)=[];
            hndls=[hndls;hextras(:)];
        end
        switch ud.type
            case 'graph'
                objvis={'off';'on'};
                hndls=[hndls;gr.xtext;gr.xfactor;gr.ytext;gr.yfactor];
            case 'sparse'
                objvis={'off';'on'};
            case 'image'
                objvis={'on';'off'};
                hndls=[hndls;gr.colorbar.axes;gr.colorbar.bar];
        end
        set([gr.image;gr.line],{'visible'},objvis);
        hndls=[hndls;gr.axes;gr.patch];
    end
    set(hndls,'visible','on');
    ud.visible = 'on';
end
gr.DataPointer.info = ud;
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_data  -  insert data into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_data(gr,data)
% interesting one.  Need to plot nth column of data if there are labels
% defined and they don't go outside the defined data
ud = gr.DataPointer.info;
ud.data = data;
gr.DataPointer.info = ud;
drawreqs=[1 1 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_factors  -  insert factors into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_factors(gr,factors)
if size(factors,1)==1 && size(factors,2)>2
    factors=factors(:);
end
ud = gr.DataPointer.info;
ud.factors = factors;
gr.DataPointer.info = ud;
drawreqs=[1 0 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_type  -  change type of 2d graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_type(gr,tp)
tp=lower(tp);
drawreqs=[0 0 0 0];
if ~any(strcmp(tp,{'graph','sparse','image'}))
    return
end
ud = gr.DataPointer.info;
if ~strcmp(tp,ud.type)
    ud.type = tp;    
    drawreqs([2 3])=1;
    
    % Decide what to turn on and where it should be
    newpos = ud.position;
    switch lower(tp)
        case 'graph'
            if newpos(4)<250
                delta=max(60,(80-0.5*(250-newpos(4))));
            else
                delta=80;
            end
            pos(2)=newpos(2)+delta;
            pos(4)=newpos(4)-delta-25;
            pos(1)=newpos(1)+50;
            pos(3)=newpos(3)-80;
        case 'image'
            pos(2)=newpos(2)+90;
            pos(4)=newpos(4)-115;
            pos(1)=newpos(1)+50;
            pos(3)=newpos(3)-80;
        case 'sparse'
            pos(2)=newpos(2)+30;
            pos(4)=newpos(4)-55;
            pos(1)=newpos(1)+50;
            pos(3)=newpos(3)-80;
    end
    pos(3:4)=max(pos(3:4),[1 1]);
    set(gr.axes,'position',pos);
    
    if ~strcmp(get(gr.axes,'visible'),'off')
        hndls = gr.axes;
        switch lower(tp)
            case 'graph'
                hndls=[hndls;gr.line;gr.xtext;gr.xfactor;gr.ytext;gr.yfactor; ...
                        ud.datataghandles(:)];
            case 'sparse'
                hndls=[hndls;gr.line];
            case 'image'
                hndls=[hndls;gr.image;gr.colorbar.axes;gr.colorbar.bar];
        end
        set([gr.axes;gr.patch;gr.xfactor;gr.yfactor;gr.xtext;gr.ytext; ...
                gr.line;gr.image;gr.colorbar.axes;gr.colorbar.bar],'visible','off');
        set(ud.datataghandles, 'visible','off');
        hndls=[hndls;gr.patch];
        set(hndls,'visible','on');
    end
end
gr.DataPointer.info = ud;
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_cmap  -  insert new colormap for image view
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_cmap(gr,cmap)
% update colorbar
set(gr.colorbar.axes,'xlim',[0.5 size(cmap,1)+0.5]);
pr_cbarfaces(gr.colorbar.bar,cmap);

% update colorbar labelling
clim = get(gr.colorbar.axes,'clim');
labpoints = get(gr.colorbar.axes,'xtick');
actpoints = clim(1)+(labpoints-0.5).*(clim(2)-clim(1))./(size(cmap,1));
actpoints = cellstr(num2str(actpoints',2));
set(gr.colorbar.axes,'xticklabel',actpoints);

% Will need to replot data to ensure new colormap is carried into data
drawreqs=[0 0 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_grid  -  turn grid on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_grid(gr,grd)
if strcmp(grd,'on')
    val=1;
else
    val=0;
end
ud = gr.DataPointer.info;
ud.grid = val;
gr.DataPointer.info = ud;
drawreqs=[0 0 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_select  -  change factor selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_select(gr,sel,ax)
switch ax
    case 'x'
        obj=gr.xfactor;
    case 'y'
        obj=gr.yfactor;
end
set(obj,'value',sel);
drawreqs=[0 0 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_limits  -  set explicit limits on the factors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_limits(gr,lim)
if iscell(lim)
    ud = gr.DataPointer.info;
    ud.limits = lim;
    gr.DataPointer.info = ud;
    drawreqs=[0 1 0 0];
else
    drawreqs=[0 0 0 0];
end
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_seltype  -  change behaviour of lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_seltype(gr,selset)
drawreqs=[0 0 0 0];
ud = gr.DataPointer.info;
switch lower(selset)
    case 'exclusive'
        % check settings
        lbls=get(gr.xfactor,'string');
        if ~iscell(lbls)
            lmax=1;
        else
            lmax=length(lbls);
        end
        vals=get([gr.xfactor;gr.yfactor],{'value'});
        vals=cat(1,vals{:});
        
        ch=0;
        used=vals(1);
        for n=2
            if any(vals(n)==used)
                % find lowest unused
                srch=1:(length(used)+1);
                new=setxor(used,srch);
                new=min(new(1),lmax);
                vals(n)=new;
                ch=1;
            end
            used=[used vals(n)];
        end
        if ch
            set([gr.xfactor;gr.yfactor],{'value'},num2cell(vals));
            drawreqs([2 3])=1;
        end
        ud.factorselection = 1;
    case 'normal'
        % just change flag
        ud.factorselection = 0;
end
gr.DataPointer.info = ud;
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_transclr  -  change transparency colour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_transclr(gr,col)
ud = gr.DataPointer.info;
ud.transcolor = col;
gr.DataPointer.info = ud;

% update if patch is set to none.
cnow=get(gr.patch,'facecolor');
if ischar(cnow) && strcmp(cnow,'none')
    set([gr.xtext;gr.ytext],'backgroundcolor',col);
end
drawreqs=[0 0 0 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_backclr  -  change background colour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_backclr(gr,col)
ud = gr.DataPointer.info;
if ischar(col) && strcmp(col,'none')
    bgcol  = ud.transcolor;
else
    bgcol = col;
end
set(gr.patch,'facecolor',col);
set([gr.xtext;gr.ytext],'backgroundcolor',bgcol);
drawreqs=[0 0 0 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_frame  -  turn bounding frame on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_frame(gr,state)
if strcmp(state,'on')
    set(gr.patch,'edgecolor','k');
else
    set(gr.patch,'edgecolor','none');
end
drawreqs=[0 0 0 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_datatagtype  -  set data tag type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_datatagtype(gr,tagtype)
ud = gr.DataPointer.info;
switch lower(tagtype)
    case 'none'
        tp = 0;
    case 'enumerate'
        tp = 1;
    case 'custom'
        tp = 2;
    case 'coincident'
        tp = 3;
    otherwise
        tp = 0;
end

if tp~=ud.datatags
    ud.datatags = tp;
    if tp==0
        delete(ud.datataghandles);
        ud.datataghandles = [];
        drawreqs = [0 0 0 0];
    else
        drawreqs = [0 0 1 0];
    end
    gr.DataPointer.info = ud;
else
    drawreqs = [0 0 0 0];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_customtags  -  set custom tag strings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_customtags(gr,sTags)
if iscell(sTags)
    ud = gr.DataPointer.info;
    ud.customdatatags = sTags;
    gr.DataPointer.info = ud;
    if ud.datatags==2
        drawreqs = [0 0 1 0];
    else
        drawreqs = [0 0 0 0];
    end
end