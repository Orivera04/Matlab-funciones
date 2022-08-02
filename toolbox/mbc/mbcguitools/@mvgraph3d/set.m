function gr=set(gr,varargin)
%SET   Set interface for graph3d objects
%   Provides a set interface to the graph3d object.  
%
%   Valid properties are:
%     'Position'  -  4 element position vector in pixels
%     'Visible'   -  'on' or 'off'
%     'Data'      -  matrix of data with a column for each factor
%     'Factors'   -  cell array of strings corresponding to each factor
%     'Parent'    -  change parent figure (useful for saving a copy of graph)
%     'Type'      -  set to 'scatter', 'mesh', 'surface'
%     'Colormap'  -  define colormap for object
%     'Grid'      -  turn the grid on/off on the axes
%     'XGrid'    \
%     'YGrid'     -  turn the grid on/off for each direction
%     'ZGrid'    /
%     'Factorselection' - 'exclusive'/'normal'
%     'Limits'    -  explicitly set limits for each variable
%     'Backgroundcolor' - color for background patch
%     'Frame'     -  On/off: turn the bounding frame on or off.
%
%   Plus a load of other properties that are visible by getting the handles

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/20 23:18:54 $



% Bail if we've not been given a graph2d object
if ~isa(gr,'mvgraph3d')
    error('Cannot set properties: not a mvgraph3d object!')
end
redraws=[0 0 0 0];  % flags to signal a factorsort, graphlim, plot and cbarfaces
% loop over varargin
for n=1:2:(nargin-2)
    switch lower(varargin{n})
        case 'position'
            [gr,drawreqs] = i_position(gr,varargin{n+1});      
        case 'visible'
            [gr,drawreqs] = i_visible(gr,varargin{n+1}); 
        case {'data','value','number'}
            [gr,drawreqs] = i_data(gr,varargin{n+1}); 
        case 'factors'
            [gr,drawreqs] = i_factors(gr,varargin{n+1});
        case 'parent'
            set([gr.axes; gr.xfactor; gr.xtext; gr.yfactor; ...
                    gr.ytext; gr.zfactor; gr.ztext],'parent',varargin{n+1});
            drawreqs = [0 0 0 0];
        case 'type'
            [gr,drawreqs] = i_type(gr,varargin{n+1});
        case 'colormap'
            [gr,drawreqs] = i_cmap(gr,varargin{n+1});
        case 'grid'
            [gr,drawreqs] = i_grid(gr,'xyz',varargin{n+1});
        case 'xgrid'
            [gr,drawreqs] = i_grid(gr,'x',varargin{n+1});
        case 'ygrid'
            [gr,drawreqs] = i_grid(gr,'y',varargin{n+1});
        case 'zgrid'
            [gr,drawreqs] = i_grid(gr,'z',varargin{n+1});
        case 'factorselection'
            [gr,drawreqs] = i_seltype(gr,varargin{n+1});
        case 'limits'
            [gr,drawreqs] = i_limits(gr,varargin{n+1});
        case 'backgroundcolor'
            [gr,drawreqs] = i_backclr(gr,varargin{n+1});
        case 'frame'
            [gr,drawreqs] = i_frame(gr,varargin{n+1});
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
vis = ud.visible;

% if position is too small, display an image indicating this
mnsz=minsize(gr);
if newpos(3)<mnsz(1) || newpos(4)<mnsz(2)
    % go to blackout mode
    set([gr.axes;gr.xfactor;gr.yfactor; ...
        gr.xtext;gr.ytext;gr.zfactor;gr.ztext; ...
        gr.colorbar.axes;gr.colorbar.bar;gr.surf],'visible','off');
    set(ud.datataghandles, 'visible', 'off');

    % need to calc position of icon   
    impos=[max(floor(newpos(1:2)+newpos(3:4).*0.5)-15,newpos(1:2)), min([32 32],newpos(3:4))];
    set([gr.patch;gr.badim],{'position'},{newpos;impos},'visible',vis);
else
    cellpos=cell(9,1);
    % work out positions
    % patch
    cellpos{1}=newpos;
    
    % axes
    pos(1)=newpos(1)+55;
    pos(3)=newpos(3)-150;
    pos(2)=newpos(2)+100;
    pos(4)=newpos(4)-125;
    cellpos{2}=pos;
    
    % decide ui size
    uihs=70;
    if newpos(3)<216
        uihs=floor((newpos(3)-6)./3); 
    end
    halfuihs=0.5.*uihs;
    
    % ui's
    % xtext
    pos(1)=newpos(1)+newpos(3)/6-halfuihs;  
    pos(2)=newpos(2)+32;
    pos(3)=uihs;
    pos(4)=16;
    cellpos{3}=pos;
    
    % xfactor
    pos(1)=newpos(1)+newpos(3)/6-halfuihs;   
    pos(2)=newpos(2)+10;
    pos(3)=uihs;
    pos(4)=20;
    cellpos{4}=pos;
    
    % ytext
    pos(1)=newpos(1)+newpos(3)/2-halfuihs;  
    pos(2)=newpos(2)+32;
    pos(3)=uihs;
    pos(4)=16;
    cellpos{5}=pos;
    
    % yfactor
    pos(1)=newpos(1)+newpos(3)/2-halfuihs;   
    pos(2)=newpos(2)+10;
    pos(3)=uihs;
    pos(4)=20;
    cellpos{6}=pos;
    
    % ztext
    pos(1)=newpos(1)+5*newpos(3)/6-halfuihs;  
    pos(2)=newpos(2)+32;
    pos(3)=uihs;
    pos(4)=16;
    cellpos{7}=pos;
    
    % zfactor
    pos(1)=newpos(1)+5*newpos(3)/6-halfuihs;   
    pos(2)=newpos(2)+10;
    pos(3)=uihs;
    pos(4)=20;
    cellpos{8}=pos;
    
    % colorbar
    % axes
    pos(1)=newpos(1)+newpos(3)-60;
    pos(2)=newpos(2)+90;
    pos(3)=20;
    pos(4)=newpos(4)-115;
    cellpos{9}=pos;
    
    set([gr.patch; gr.axes; gr.xtext; gr.xfactor; gr.ytext; ...
            gr.yfactor; gr.ztext; gr.zfactor; gr.colorbar.axes],{'position'},cellpos);
    
    drawreqs(2)=1;
    
    if ~strcmp(vis,'off')
        set(gr.badim, 'visible', 'off');
        hndls=[gr.axes;gr.patch;gr.xtext;gr.xfactor;gr.ytext; ...
                gr.yfactor;gr.ztext;gr.zfactor;gr.colorbar.axes;gr.colorbar.bar;gr.surf];
        set(hndls,'visible','on');
        set(ud.datataghandles, 'visible', 'on');
    end
end
ud.position = newpos;
gr.DataPointer.info = ud;
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_visible  -  alter visibility of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_visible(gr,vis)
drawreqs = [0 0 0 0];

ud = gr.DataPointer.info;
hndls = gr.patch;
switch lower(vis)
    case 'on'
        mv_rotate3d(double(gr.axes),'ON');
        % check size
        mnsz = minsize(gr);
        pos = ud.position;
        if pos(3)<mnsz(1) || pos(4)<mnsz(2)
            hndls = [hndls;gr.badim];
        else
            hndls = [hndls;gr.axes;gr.xfactor;gr.yfactor;gr.xtext;gr.ytext;...
                    gr.ztext;gr.zfactor;gr.surf;gr.colorbar.axes;gr.colorbar.bar; ...
                    handle(ud.datataghandles(:))];
        end
    case 'off'
        mv_rotate3d(double(gr.axes),'OFF');
        hndls = [hndls;gr.badim;gr.axes;gr.xfactor;gr.yfactor;gr.xtext;gr.ytext;...
                gr.ztext;gr.zfactor;gr.surf;gr.colorbar.axes;gr.colorbar.bar; ...
                handle(ud.datataghandles(:))];
    otherwise
        vis = get(gr.badim,'userdata');
end
ud.visible = vis;
gr.DataPointer.info = ud;
set(hndls,'visible',vis);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_data  -  insert data into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_data(gr,data)
if size(data,1)==1
    % replicate to ensure point is drawn
    data = [data;data;data];
elseif size(data,1)==2
    data(end+1,:) = data(1,:);
end
ud = gr.DataPointer.info;
ud.data = data;
gr.DataPointer.info = ud;
drawreqs=[1 1 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_factors  -  insert factors into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_factors(gr,factors)
if ischar(factors)
    factors={factors};
end
ud = gr.DataPointer.info;
ud.factors = factors;
gr.DataPointer.info = ud;
drawreqs=[1 0 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_type  -  change type of 3d graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_type(gr,tp)
drawreqs = [0 0 0 0];
ud = gr.DataPointer.info;
if ~strcmp(tp,ud.type)
    ud.type = tp;
    gr.DataPointer.info = ud;
    drawreqs(3)=1;
end
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_cmap  -  insert new colormap for image view
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_cmap(gr,cmap)
% update colorbar
set(gr.colorbar.axes,'ylim',[0.5 size(cmap,1)+0.5]);
pr_cbarfaces(gr.colorbar.bar,cmap);
drawreqs=[0 1 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_grid  -  turn grid on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_grid(gr,dir,grd)
drawreqs=[0 0 0 0];

% parse out dir string to get axes to turn grid on in.
if ~isempty(findstr(dir,'x'))
    set(gr.axes,'xgrid',grd);
end
if ~isempty(findstr(dir,'y'))
    set(gr.axes,'ygrid',grd);
end
if ~isempty(findstr(dir,'z'))
    set(gr.axes,'zgrid',grd);
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
        vals=get([gr.xfactor;gr.yfactor;gr.zfactor],{'value'});
        vals=cat(1,vals{:});
        
        ch=0;
        used=vals(1);
        for n=2:3
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
            set([gr.xfactor;gr.yfactor;gr.zfactor],{'value'},num2cell(vals));
            drawreqs([2 3])=0;
        end
        ud.factorselection = 1;
    case 'normal'
        % just change flag
        ud.factorselection = 0;
end
gr.DataPointer.info = ud;
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_limits  -  set explicit limits on the factors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_limits(gr,lim)

if iscell(lim)
    ud = gr.DataPointer.info;
    ud.limits = lim;
    gr.DataPointer.info = ud;
end
drawreqs=[0 1 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_backclr  -  change background colour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_backclr(gr,col)
drawreqs=[0 0 0 0];
ud = gr.DataPointer.info;

set(gr.patch,'facecolor',col);
if ~ud.frame
    set(gr.patch,'edgecolor',col);
end
set([gr.xtext;gr.ytext;gr.ztext],'backgroundcolor',col);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_frame  -  turn bounding frame on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_frame(gr,state)
drawreqs=[0 0 0 0];
ud = gr.DataPointer.info;
if strcmp(state,'on')
    ud.frame = 1;
    set(gr.patch,'edgecolor',[0 0 0]);
else
    ud.frame = 0;
    set(gr.patch,'edgecolor',gr.patch.facecolor);
end
gr.DataPointer.info = ud;
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