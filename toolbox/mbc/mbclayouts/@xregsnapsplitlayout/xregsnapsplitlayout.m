function obj=xregsnapsplitlayout(varargin)
%XREGSNAPSPLITLAYOUT Splitlayout variant
% 
%  XREGSNAPSPLITLAYOUT([FIG],prop, arg) constructs a splitlayout that
%  offers the option of fully closing one side of the split.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:37:00 $

fig = [];
if nargin
   if ~ischar(varargin{1}) ...
           && ishandle(varargin{1}) ...
           && strcmp(get(varargin{1},'type'),'figure')
      fig = varargin{1};
      varargin(1) = [];
   end
end
if isempty(fig)
    fig = gcf;
end

c = xregcontainer(fig);

ud.split = [0.5 0.5];
ud.splitmem = [0.5 0.5];
ud.orientation = 0;  % left-right orientation by default
ud.behaviour = 1;    % allow snap left/right by default
ud.state = 0;        % current bar position: either snapped at left, right or just dragging in the middle
ud.snapposition = 0; % flag to indicate whether to snap to edge (0) or to minimum split position (1)
ud.callbackstr = '';
ud.innerborders = [0 0 0 0; 0 0 0 0];
ud.visible = 1;      % main visibility flag
ud.minwidth = [0 0];
ud.minwidthunits = 'pixels';
ud.oldptr = 'arrow';
ud.barstyle = 0;

% attempt to pre-parse barstyle property to avoid making the wrong one
bstyle = strcmp('barstyle',lower(varargin(1:2:end)));
if any(bstyle)
    ind = find(bstyle);
    ud.barstyle = varargin{2*ind};
    varargin(2*ind-1:2*ind) = [];
end
if ud.barstyle==0
    ud.rsbutton = xregGui.SplitterBar('parent',fig,'visible','off', ...
        'orientation','lr','style','lr');
else
    ud.rsbutton = xregGui.SplitterBar2('parent',fig,'visible','off', ...
        'orientation','lr','style','lr');
end
connectdata(c, ud.rsbutton);

set(c,'userdata',ud);
obj = class(struct([]),'xregsnapsplitlayout',c);

% look for a visible set in remaining args
if ~any(strcmp('visible',lower(varargin(1:2:end))))
    % set ui objects to visible
    set(ud.rsbutton,'visible','on');
end
if length(varargin)
    obj = set(obj,varargin{:});
end

set(ud.rsbutton,'ButtonDownFcn',{@i_bdown,obj,0},...
    'MoveToTopFcn',{@i_bdown,obj,1},...
    'MoveToBottomFcn',{@i_bdown,obj,2},...
    'MoveToLeftFcn',{@i_bdown,obj,3},...
    'MoveToRightFcn',{@i_bdown,obj,4});



function i_bdown(srcobj,evt,obj,src)
% Execute buttondown dragging
dragcallback(obj,'start',src);
