function obj=set(obj,varargin)
%  xreglegend/SET   Set interface for xreglegend object
%
%   Valid properties are:
%     'Position'  -  4 element position vector in pixels
%     'Visible'   -  'on' or 'off'
%     'Items'     -  cell array of item names
%     'Handles'   -  vector of line handles to match to items
%                     Line and marker properties are copied to the legend
%                    NB. Items and Handles must be the same length, or no
%                        plotting occurs.
%     'gapy'      -  y gap between items, in pixels
%     'gapx'      -  x gap between line and text, and between items horizontally
%     'linex'     -  width of marker/line display, in pixels
%     'fontsize','fontweight','fontunits','fontname' - set text item properties
%     'parent'    -  change figure parent of object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:32:00 $


% Bail if we've not been given an xreglegend object
if ~isa(obj,'xreglegend')
   error('Cannot set properties: not a xreglegend object!')
end

redraws=[0];  % flags to signal a redraw

% loop over varargin
for n=1:2:(nargin-2)
    drawreqs=[0];
    switch lower(varargin{n})
        case 'position'
            [obj,drawreqs]=i_position(obj,varargin{n+1});
        case 'visible'
            [obj,drawreqs]=i_visible(obj,varargin{n+1});
        case {'items','names','elements'}
            [obj,drawreqs]=i_items(obj,varargin{n+1});
        case {'handles','lines'}
            [obj,drawreqs]=i_handles(obj,varargin{n+1});
        case {'marker','markers'}
            [obj,drawreqs]=i_marker(obj,varargin{n+1});
        case 'markeredgecolor'
            [obj,drawreqs]=i_markerprops(obj,varargin{n+1},'edgecolor');
        case 'markerfacecolor'
            [obj,drawreqs]=i_markerprops(obj,varargin{n+1},'facecolor');
        case {'markersize'}
            [obj,drawreqs]=i_markerprops(obj,varargin{n+1},'size');
        case 'linecolor'
            [obj,drawreqs]=i_lineprops(obj,varargin{n+1},'linecolor');
        case 'linewidth'
            [obj,drawreqs]=i_lineprops(obj,varargin{n+1},'linewidth');
        case 'linestyle'
            [obj,drawreqs]=i_lineprops(obj,varargin{n+1},'linestyle');
        case {'ygap','gapy'}
            [obj,drawreqs]=i_SetParam(obj,'gapy',varargin{n+1});
        case {'xgap','gapx'}
            [obj,drawreqs]=i_SetParam(obj,'gapx',varargin{n+1});
        case {'linegap','linex','gapline','xline'}
            [obj,drawreqs]=i_SetParam(obj,'linex',varargin{n+1});
        case {'fontsize','fontweight','fontunits','fontname'}
            [obj,drawreqs]=i_SetFont(obj,varargin{n},varargin{n+1});
        case 'parent'
            set([gr.axes],'parent',varargin{n+1});
        case 'userdata'
            obj=get(obj.axes,'userdata');
            obj.ud=varargin{n+1};
            builtin('set',obj.axes,'userdata',obj);
        case 'backgroundcolor'
            set(obj.axes, 'color', varargin{n+1}, ...
                'xcolor', varargin{n+1}, ...
                'ycolor', varargin{n+1}, ...
                'zcolor', varargin{n+1});
            drawreqs = 0;
    end
    redraws= (redraws | drawreqs);
end

if redraws(1)
   pr_plot(obj);
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_position  -  alter position of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_position(obj,newpos);

drawreqs=[0];

% decide whether object is set to invisible
vis=get(obj.axes,'visible');

switch vis
case 'off'
    obj = get(obj.axes,'userdata');
    obj.pos = newpos;
    builtin('set',obj.axes,'userdata',obj);
case 'on'
    set(obj.axes,'position',newpos);
    obj = get(obj.axes,'userdata');
    obj.pos = [];
    builtin('set',obj.axes,'userdata',obj);
    drawreqs = [1];
end
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_visible  -  alter visibility of object in figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_visible(obj,vis);

drawreqs=[0];

% decide whether object is set to invisible
cur_vis=get(obj.axes,'visible');
% need to get handles of text objects
obj = get(obj.axes,'userdata');

switch vis
case 'off'
    set(obj.axes,'visible','off');
    set(obj.text,'visible','off');
    set([obj.lines obj.markers],'visible','off');
case 'on'
    switch cur_vis
    case 'on'
        % already visible - do nothing
    case 'off'
        obj = get(obj.axes,'userdata');
        if length(obj.pos)==4
            % position changed whilst invisible - redraw
            set(obj.axes,'position',obj.pos,'visible','on');
            set(obj.text,'visible','on');
            set([obj.lines obj.markers],'visible','on');
            obj.pos = [];
            builtin('set',obj.axes,'userdata',obj);
            drawreqs = [1];
        else
            % make visible
            set(obj.axes,'visible','on');
            set(obj.text,'visible','on');
            set([obj.lines obj.markers],'visible','on');
        end
    end
end
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_items  -  insert items into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_items(obj,items);
obj = get(obj.axes,'userdata');
obj.items = items;
builtin('set',obj.axes,'userdata',obj);
drawreqs=[1];
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_handles  -  insert handles into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_handles(obj,handles);
obj = get(obj.axes,'userdata');
obj.handles = handles;
% build list of marker properties, so that legend only changes
%  when specifically refreshed with a list of handles.
% (Otherwise, if handle properties change then legend is redrawn,
%  legend markers may change)
for i = 1:length(handles)
    if ishandle(handles(i))
        obj.d.markersize(i) = get(handles(i),'markersize');
        obj.d.marker{i} = get(handles(i),'marker');
        obj.d.markeredgecolor{i} = get(handles(i),'markeredgecolor');
        obj.d.markerfacecolor{i} = get(handles(i),'markerfacecolor');
        obj.d.linecolor(i,:) = get(handles(i),'color');
        obj.d.linestyle{i} = get(handles(i),'linestyle');
        obj.d.linewidth(i) = get(handles(i),'linewidth');
    else
        obj.d.markersize{i} = [];
        obj.d.marker{i} = 'none';
        obj.d.markeredgecolor{i} = 'none';
        obj.d.markerfacecolor{i} = 'none';
        obj.d.linecolor(i,:) = [0 0 0];
        obj.d.linestyle{i} = 'none';
        obj.d.linewidth(i) = 0.5;
    end
end
builtin('set',obj.axes,'userdata',obj);
drawreqs=[1];
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_marker  -  insert markers into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_marker(obj,marker);
obj = get(obj.axes,'userdata');
if ischar(marker)
    marker = cellstr(marker(:));
end
obj.d.marker = marker;
builtin('set',obj.axes,'userdata',obj);
drawreqs=[1];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_markerprops  -  insert marker properties into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_markerprops(obj,value,prop);
obj = get(obj.axes,'userdata');
switch prop
case 'edgecolor'
    if isnumeric(value) & size(value,2)==3
        % Needs to be cell to cope with color = 'none'
        value = num2cell(value,2);
    elseif ischar(value)
        % Entry may be 'rkym' etc
        value = cellstr(value(:));
    end
    obj.d.markeredgecolor = value;
case 'facecolor'
    if isnumeric(value) & size(value,2)==3
        % Needs to be cell to cope with color = 'none'
        value = num2cell(value,2);
    elseif ischar(value)
        % Entry may be 'rkym' etc
        value = cellstr(value(:));
    end
    obj.d.markerfacecolor = value;
case 'size'
    obj.d.markersize = value;
end
builtin('set',obj.axes,'userdata',obj);
drawreqs=[1];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_lineprops  -  insert line properties into object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_lineprops(obj,value,prop);
obj = get(obj.axes,'userdata');
if ischar(value)
    value = cellstr(value(:));
end
switch prop
case 'linecolor'
    obj.d.linecolor = value;
case 'linewidth'
    obj.d.linewidth = value;
case 'linestyle'
    obj.d.linestyle = value;
end
builtin('set',obj.axes,'userdata',obj);
drawreqs=[1];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_setparam  -  set various parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_SetParam(obj,param,value);
obj=get(obj.axes,'userdata');
switch param
case 'gapy'
    obj.d.gapy = value;
    drawreqs = [1];
case 'gapx'
    obj.d.gapx = value;
    drawreqs = [1];
case 'linex'
    obj.d.linex = value;
    drawreqs = [1];
end

% something changed? 
if drawreqs(1)
    builtin('set',obj.axes,'userdata',obj);
end

% check visibility - no redraw required if invisible
vis=get(obj.axes,'visible');
if strcmp(vis,'off')
    drawreqs = [0];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  i_setfont  -  set various font parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,drawreqs]=i_SetFont(obj,param,value);
obj=get(obj.axes,'userdata');
switch param
case 'fontname'
    obj.d.fontname = value;
    drawreqs = [1];
case 'fontweight'
    obj.d.fontweight = value;
    drawreqs = [1];
case 'fontunits'
    obj.d.fontunits = value;
    drawreqs = [1];
case 'fontsize'
    obj.d.fontsize = value;
    drawreqs = [1];
end

% something changed? 
if drawreqs(1)
    builtin('set',obj.axes,'userdata',obj);
    % update existing objects
    set(obj.text,param,value);
end

% check visibility - no redraw required if invisible
vis=get(obj.axes,'visible');
if strcmp(vis,'off')
    drawreqs = [0];
end
