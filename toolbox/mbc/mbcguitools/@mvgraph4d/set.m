function gr=set(gr,varargin)
%SET   Set interface for the graph4d object
%   Provides a set interface to the graph4d object.  
%
%   Valid properties are:
%     'Position'  -  4 element position vector in pixels
%     'Visible'   -  'on' or 'off'
%     'Data'      -  matrix of data with a column for each factor
%     'Factors'   -  cell array of strings corresponding to each factor
%     'Parent'    -  change parent figure (useful for saving a copy of graph)
%     'Limits'    -  set explicit limits for each factor
%     'Factorselection - 'exclusive' or 'normal'
%     'Userange'  -  toggle on the range on the colormap variable
%     'Type'      -  'scatter', 'mesh', 'surface'
%     'Backgroundcolor' - color for background patch
%     'Frame'     -  On/off: turn bounding frame on/off
%
%   Plus a load of other properties that are visible by getting the handles

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/20 23:18:56 $


% Bail if we've not been given a graph4d object
if ~isa(gr,'mvgraph4d')
    error('Cannot set properties: not a mvgraph4d object!')
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
            set([gr.axes;gr.xfactor;gr.xtext;gr.yfactor;gr.ytext],'parent',varargin{n+1});
            drawreqs=[0 0 0 0];
        case 'type'
            [gr,drawreqs] = i_type(gr,varargin{n+1});
        case 'colormap'
            [gr,drawreqs] = i_cmap(gr,varargin{n+1});
        case 'frame'
            [gr,drawreqs] = i_frame(gr,varargin{n+1});
        case 'userange'
            switch lower(varargin{n+1});
                case 'on'
                    set(gr.colorbar.userange,'value',1);
                case 'off'
                    set(gr.colorbar.userange,'value',0);
            end
            chboxcb(gr);
        case 'factorselection'
            [gr,drawreqs] = i_seltype(gr,varargin{n+1});
        case 'limits'
            [gr,drawreqs] = i_limits(gr,varargin{n+1});
        case 'backgroundcolor'
            [gr,drawreqs] = i_backclr(gr,varargin{n+1});
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
function [gr,drawreqs] = i_position(gr,newpos)
drawreqs=[0 0 0 0];
ud = gr.DataPointer.info;
% decide whether object is set to invisible
vis = ud.visible;

mnsz = minsize(gr);
if newpos(3)<mnsz(1) || newpos(4)<mnsz(2)
    % go to blackout mode
    set([gr.axes;gr.xfactor;gr.yfactor;gr.xtext;gr.ytext;gr.zfactor;gr.ztext;...
        gr.ctext;gr.cfactor;gr.colorbar.axes;gr.colorbar.bar;gr.surf;gr.colorbar.frame1;...
        gr.colorbar.frame2;gr.colorbar.minrange;gr.colorbar.midrange;gr.colorbar.maxrange;...
        gr.colorbar.userange],'visible','off');
    set(ud.datataghandles, 'visible', 'off');
    
    % need to calc position of icon
    impos=[max(floor(newpos(1:2)+newpos(3:4).*0.5)-15,newpos(1:2)), min([32 32],newpos(3:4))];
    set([gr.patch;gr.badim],{'position'},{newpos;impos},'visible',vis);
else
    cellpos=cell(14,1);
    
    % work out positions
    % axes
    pos(1)=newpos(1)+55;
    pos(3)=newpos(3)-150;
    pos(2)=newpos(2)+100;
    pos(4)=newpos(4)-125;
    cellpos{1}=pos;
    
    % patch
    cellpos{2}=newpos;
    
    % decide uiwidth
    uihs=70;
    if newpos(3)<288
        uihs=(newpos(3)-8)*0.25;
    end
    halfuihs=uihs*0.5;
    
    % ui's
    % xtext
    pos(1)=newpos(1)+newpos(3).*0.125-halfuihs;  
    pos(2)=newpos(2)+32;
    pos(3)=uihs;
    pos(4)=16;
    cellpos{3}=pos;
    
    % xfactor
    pos(1)=newpos(1)+newpos(3).*0.125-halfuihs;   
    pos(2)=newpos(2)+10;
    pos(3)=uihs;
    pos(4)=20;
    cellpos{4}=pos;
    
    % ytext
    pos(1)=newpos(1)+newpos(3).*0.375-halfuihs;  
    pos(2)=newpos(2)+32;
    pos(3)=uihs;
    pos(4)=16;
    cellpos{5}=pos;
    
    % yfactor
    pos(1)=newpos(1)+newpos(3).*0.375-halfuihs;   
    pos(2)=newpos(2)+10;
    pos(3)=uihs;
    pos(4)=20;
    cellpos{6}=pos;
    
    % ztext
    pos(1)=newpos(1)+newpos(3).*0.625-halfuihs;  
    pos(2)=newpos(2)+32;
    pos(3)=uihs;
    pos(4)=16;
    cellpos{7}=pos;
    
    % zfactor
    pos(1)=newpos(1)+newpos(3).*0.625-halfuihs;   
    pos(2)=newpos(2)+10;
    pos(3)=uihs;
    pos(4)=20;
    cellpos{8}=pos;
    
    % ctext
    pos(1)=newpos(1)+newpos(3).*0.875-halfuihs;  
    pos(2)=newpos(2)+32;
    pos(3)=uihs;
    pos(4)=16;
    cellpos{9}=pos;
    
    % cfactor
    pos(1)=newpos(1)+newpos(3).*0.875-halfuihs;   
    pos(2)=newpos(2)+10;
    pos(3)=uihs;
    pos(4)=20;
    cellpos{10}=pos;
    
    % colorbar
    % axes
    pos(1)=newpos(1)+newpos(3)-60;
    pos(2)=newpos(2)+100;
    pos(3)=20;
    pos(4)=newpos(4)-125;
    cellpos{11}=pos;
    
    drawreqs(2)=1;
    
    % bar
    % no resize necessary
    
    % range bars
    ylim=get(gr.colorbar.axes,'ylim');
    clen=ylim(2)-ylim(1);
    delta=2*(clen)/(newpos(4)-125);
    barval = ud.rangepositions(1);
    set(gr.colorbar.minrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
            0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
    barval = ud.rangepositions(2);
    set(gr.colorbar.midrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
            0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
    barval = ud.rangepositions(3);
    set(gr.colorbar.maxrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
            0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
    
    
    % extra frame bits
    pos(1)=newpos(1)+newpos(3)-51;
    pos(2)=newpos(2)+90;
    pos(3)=2;
    pos(4)=10;
    cellpos{12}=pos;
    
    pos(1)=newpos(1)+newpos(3)-86;
    pos(2)=newpos(2)+85;
    pos(3)=72;
    pos(4)=5;
    cellpos{13}=pos;
    
    % range checkbox
    pos(1)=newpos(1)+newpos(3)-85;
    pos(2)=newpos(2)+65;
    pos(3)=70;
    pos(4)=24;
    cellpos{14}=pos;
    set([gr.axes; gr.patch; gr.xtext; gr.xfactor; gr.ytext; gr.yfactor; gr.ztext; gr.zfactor;...
            gr.ctext; gr.cfactor; gr.colorbar.axes; gr.colorbar.frame1; gr.colorbar.frame2; gr.colorbar.userange],...
        {'position'},cellpos);
    
    
    if ~strcmp(vis,'off')
        set(gr.badim, 'visible', 'off');
        hndls=[gr.axes;gr.patch;gr.xtext;gr.xfactor;gr.ytext;gr.yfactor;gr.ztext;gr.zfactor;...
                gr.ctext;gr.cfactor;gr.colorbar.axes;gr.colorbar.bar;gr.surf;gr.colorbar.frame1;...
                gr.colorbar.frame2;gr.colorbar.userange];
        if get(gr.colorbar.userange,'value')
            hndls=[hndls;gr.colorbar.minrange;gr.colorbar.midrange;gr.colorbar.maxrange];
        end
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
function [gr,drawreqs]=i_visible(gr,vis)
drawreqs=[0 0 0 0];

hndls=gr.patch;
mnsz=minsize(gr);
ud = gr.DataPointer.info;
pos = ud.position;
if pos(3)<mnsz(1) || pos(4)<mnsz(2)
    hndls=[hndls;gr.badim];
else
    hndls=[hndls;gr.axes;gr.xfactor;gr.yfactor;gr.xtext;gr.ytext;gr.ztext;gr.zfactor;...
            gr.ctext;gr.cfactor;gr.surf;gr.colorbar.axes;gr.colorbar.bar;gr.colorbar.frame1;...
            gr.colorbar.frame2;gr.colorbar.userange; handle(ud.datataghandles(:))];
    if get(gr.colorbar.userange,'value')
        hndls=[hndls;gr.colorbar.minrange;gr.colorbar.midrange;gr.colorbar.maxrange];
    end
end
switch lower(vis)
    case 'on'
        mv_rotate3d(double(gr.axes),'ON');
    case 'off'
        mv_rotate3d(double(gr.axes),'OFF');
    otherwise
        vis = ud.visible;
end
ud.visible = vis;
set(hndls, 'visible', vis);
gr.DataPointer.info = ud;
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_data  -  insert data into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_data(gr,data)
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
function [gr,drawreqs] = i_type(gr,tp)
drawreqs=[0 0 0 0];
ud = gr.DataPointer.info;
if ~strcmp(tp,ud.type)
    % only redraw for a change of type
    ud.type = tp;
    gr.DataPointer.info = ud;
    drawreqs(3)=1;
end
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_cmap  -  insert new colormap for image view
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_cmap(gr,cmap)
ud = gr.DataPointer.info;

oldylim=get(gr.colorbar.axes,'ylim');
% update colorbar
set(gr.colorbar.axes,'ylim',[0.5 size(cmap,1)+0.5]);
pr_cbarfaces(gr.colorbar.bar,cmap);

% Update range bars on colorbar
cbpos=get(gr.colorbar.axes,'position');
clen = size(cmap,1);
delta = 2*(clen)/(cbpos(4));

barval = ud.rangepositions(1);
barval = 0.5+(clen).*(barval-oldylim(1))./(oldylim(2)-oldylim(1));
set(gr.colorbar.minrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
        0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
ud.rangepositions(1) = barval;

barval = ud.rangepositions(2);
barval=0.5+(clen).*(barval-oldylim(1))./(oldylim(2)-oldylim(1));
set(gr.colorbar.midrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
        0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
ud.rangepositions(2) = barval;

barval = ud.rangepositions(3);
barval=0.5+(clen).*(barval-oldylim(1))./(oldylim(2)-oldylim(1));
set(gr.colorbar.maxrange,'vertices',[0 barval+delta/4; 0.5 barval+2*delta; 1 barval+delta/4;...
        0 barval-delta/4; 0.5 barval-2*delta; 1 barval-delta/4]);
ud.rangepositions(3) = barval;
gr.DataPointer.info = ud;

drawreqs=[0 1 1 0];
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_seltype  -  change behaviour of lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs] = i_seltype(gr,selset)
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
function [gr,drawreqs] = i_backclr(gr,col)
drawreqs=[0 0 0 0];
ud = gr.DataPointer.info;
set(gr.patch,'facecolor',col);
if ~ud.frame
    set(gr.patch,'edgecolor',col);
end
set([gr.xtext;gr.ytext;gr.ztext;gr.ctext;gr.colorbar.userange],'backgroundcolor',col);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_frame  -  turn bounding frame on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,drawreqs]=i_frame(gr,state)
ud = gr.DataPointer.info;
if strcmp(state,'on')
    set(gr.patch,'edgecolor',[0 0 0]);
    ud.frame = 1;
else
    set(gr.patch,'edgecolor',gr.patch.facecolor);
    ud.frame = 0;
end
gr.DataPointer.info = ud;
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