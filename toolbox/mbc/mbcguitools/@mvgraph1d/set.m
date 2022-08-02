function gr=set(gr,varargin)
%GRAPH1D/SET.  SET interface for the Graph1D object.
%   Set interface for the graph1d object
%   Valid properties are:
%     'Position'         -  4 element position vector in pixels
%     'Visible'          -  'on' or 'off'
%     'Data'             -  matrix of data with a column for each factor
%     'Factors'          -  cell array of strings corresponding to each factor
%     'Title'            -  set title on plot
%     'Parent'           -  change parent figure (useful for saving a copy of graph)
%     'Histogram'        -  'on' or 'off'
%     'Histogramcolor'   -  Change colour of bars on histogram:
%                            2*3 double for shaded bars from top to bottom,
%                            1*3 double for solid colour bars.
%
%   Plus a load of other HG properties that are visible by getting the handles.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%  $Revision: 1.2.2.3 $  $Date: 2004/04/20 23:18:50 $


% Bail if we've not been given a graph1d object
if ~isa(gr,'mvgraph1d')
    error('Cannot set properties: not a mvgraph1d object!')
end

redraws=[0 0 0 0];  % flags to signal a factorsort, graphlim, plot and histplot

% loop over varargin
for n=1:2:(nargin-2)
    switch lower(varargin{n})
        case 'position'
            [gr,drawreqs]=i_position(gr,varargin{n+1});      
        case 'visible'
            [gr,drawreqs]=i_visible(gr,varargin{n+1}); 
        case {'data','value','number'}
            [gr,drawreqs]=i_data(gr,varargin{n+1}); 
        case 'factors'
            [gr,drawreqs]=i_factors(gr,varargin{n+1});
        case 'title'
            set(get(gr.axes,'xlabel'),'string',varargin{n+1});
            drawreqs=[0 0 0 0];
        case 'parent'
            set([gr.axes;gr.factortext;gr.factorsel;gr.hist.axes],'parent',varargin{n+1});
            drawreqs=[0 0 0 0];
        case 'histogram'
            [gr,drawreqs]=i_hist(gr,varargin{n+1});
        case 'histogramcolor'
            [gr,drawreqs]=i_histcolor(gr,varargin{n+1});
        case 'histogrambars'
            [gr,drawreqs]=i_histbars(gr,varargin{n+1});
        case 'backgroundcolor'
            [gr,drawreqs]=i_backclr(gr,varargin{n+1});
        case 'limits'
            [gr,drawreqs]=i_limits(gr,varargin{n+1});
        case 'frame'
            [gr,drawreqs]=i_frame(gr,varargin{n+1});
        case 'datatags'
            % 1D Graph does not support this property
            drawreqs = [0 0 0 0];
        case 'customdatatags'
            % 1D Graph does not support this property
            drawreqs = [0 0 0 0];
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
    pr_histplot(gr);
end
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_position  -  alter position of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_position(gr,newpos)

% decide whether object is set to invisible
vis=get(gr.badim,'userdata');
% set objects invisible
% set([gr.badim;gr.axes;gr.line;gr.patch;gr.factorsel;gr.factortext;gr.hist.axes;gr.hist.patch],'visible','off');
set(gr.axes,'userdata',newpos);

drawreqs=[0 0 0 0];
% if position is too small, display an image indicating this!
mnsz=minsize(gr);
if newpos(3)<mnsz(1) | newpos(4)<mnsz(2)
    % go to blackout mode
    % need to calc position of icon
    impos=[max(floor(newpos(1:2)+newpos(3:4).*0.5)-15,newpos(1:2)), min([32 32],newpos(3:4))];
    
    set([gr.axes;gr.line;gr.factorsel;gr.factortext;gr.hist.axes;gr.hist.patch],'visible','off');
    set([gr.patch;gr.badim],{'position'},{newpos;impos},'visible',vis);
else
    usehist=get(gr.hist.axes,'userdata');
    if ~usehist
        newpos(2)=newpos(2)+newpos(4)/2-75;
        newpos(4)=150;
    end
    cellpos=cell(4,1);
    % work out positions
    % axes
    pos(1)=newpos(1)+30;
    pos(3)=newpos(3)-60;
    pos(2)=newpos(2)+100;
    pos(4)=5;
    cellpos{1}=pos;
    
    %ui's
    % text
    pos(1)=(newpos(1)+newpos(3)/2)-70;
    pos(2)=newpos(2)+30;
    pos(3)=70;
    pos(4)=16;
    cellpos{2}=pos;
    % popupmenu
    pos(1)=(newpos(1)+newpos(3)/2);
    pos(2)=newpos(2)+30;
    pos(3)=70;
    pos(4)=20;
    cellpos{3}=pos;
    
    % patch
    cellpos{4}=newpos;
    
    
    set([gr.axes;gr.factortext;gr.factorsel;gr.patch],{'position'},cellpos);
    
    if usehist
        % histogram
        % axes
        pos(1)=newpos(1)+28;
        pos(3)=newpos(3)-56;
        pos(2)=newpos(2)+130;
        pos(4)=newpos(4)-160;
        set(gr.hist.axes,'position',pos);
        drawreqs(4)=1;
    end
    
    set(gr.badim,'visible','off');

    % Set objects back to original visibility
    set([gr.axes;gr.line;gr.patch;gr.factorsel;gr.factortext],'visible',vis);
    if usehist
        set([gr.hist.axes;gr.hist.patch],'visible',vis);
    end
end
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_visible  -  alter visibility of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]= i_visible(gr,vis)

drawreqs=[0 0 0 0];

mnsz=minsize(gr);
pos=get(gr.axes,'userdata');
if strcmp(vis,'off')
    normvis='off';
    badvis='off';
    backvis='off';
else
    if pos(3)<mnsz(1) | pos(4)<mnsz(2)
        normvis='off';
        badvis='on';
    else
        normvis='on';
        badvis='off'; 
    end
    backvis='on';
end


set([gr.axes;gr.line;gr.patch;gr.factorsel;gr.factortext],'visible',normvis);
set([gr.patch;gr.badim],{'visible'},{backvis;badvis});


usehist=get(gr.hist.axes,'userdata');
if usehist
    set([gr.hist.axes;gr.hist.patch],'visible',normvis);
end

set(gr.badim,'userdata',vis);
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_data  -  insert data into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_data(gr,data)
% interesting one.  Need to plot nth column of data if there are labels
% defined and they don't go outside the defined data

set(gr.line,'userdata',data);
drawreqs=[1 1 1 0];

usehist=get(gr.hist.axes,'userdata');
if usehist
    drawreqs(4)=1;
end
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_factors  -  insert factors into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_factors(gr,factors)

set(gr.factorsel,'userdata',factors);

drawreqs=[1 0 1 0];

usehist=get(gr.hist.axes,'userdata');
if usehist
    drawreqs(4)=1;
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_hist  -  turn histogram on and off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_hist(gr,status)

% convert to 0/1
if strcmp(status,'on')
    status=1;
elseif strcmp(status,'off')
    status=0;
else 
    return
end

drawreqs=[0 0 0 0];

usehist=get(gr.hist.axes,'userdata');

if usehist==status
    return
else
    set(gr.hist.axes,'userdata',status);
    if status
        drawreqs(4)=1;
    end
    % Need to reposition everything
    [gr req]=i_position(gr,get(gr.axes,'userdata'));
    drawreqs= (drawreqs | req);
    if ~status
        set([gr.hist.axes;gr.hist.patch],'visible','off');
    else
        [gr,req]= i_visible(gr,get(gr.badim,'userdata'));
        drawreqs= (drawreqs | req);
    end
end
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_histcolor  -  change color of histogram bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_histcolor(gr,col)

% place color in patch userdata, update histogram
if size(col,2)~=3 | size(col,1)>2 | ~isnumeric(col)
    return
end

ud=get(gr.hist.patch,'userdata');
ud.colours=col;
set(gr.hist.patch,'userdata',ud);

drawreqs=[0 0 0 1];
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_histbars  -  change number of histogram bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_histbars(gr,n)

if ~isempty(n)
    if ischar(n)
        if strcmp(n,'auto')
            n=[];
        else
            error('Number of bars must be a positive integer');
        end
    elseif ~isnumeric(n) | n<0 | floor(n)~=n
        error('Number of bars must be a positive integer');
    end
end
ud=get(gr.hist.patch,'userdata');
ud.numbars=n;
set(gr.hist.patch,'userdata',ud);

drawreqs=[0 0 0 1];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_backclr  -  change background colour
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gr,drawreqs]=i_backclr(gr,col)

set(gr.patch,'facecolor',col);
ud=get(gr.hist.patch,'userdata');
if ~ud.frameon
    set(gr.patch,'edgecolor',col);
end
set(gr.factortext,'backgroundcolor',col);
drawreqs=[0 0 0 0];
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_limits  -  set explicit limits on the factors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[ gr,drawreqs]=i_limits(gr,lim)

if iscell(lim)
    set(gr.factortext,'userdata',lim);
end

drawreqs=[0 1 0 0];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_frame  -  turn bounding frame on/off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[ gr,drawreqs]=i_frame(gr,state)
ud=get(gr.hist.patch,'userdata');
if strcmp(state,'on')
    set(gr.patch,'edgecolor',[0 0 0]);
    ud.frameon=1;
else
    set(gr.patch,'edgecolor',gr.patch.facecolor);
    ud.frameon=0;
end
set(gr.hist.patch,'userdata',ud);
drawreqs=[0 0 0 0];
return