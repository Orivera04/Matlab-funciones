function h = smith(varargin)
%SMITH Constructor.
% H = RFCHART.SMITH('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns the
% handle to a Smith chart, H, based on the specified properties. The
% properties include,
%
%             Type: 'Z', 'Y', 'ZY', or 'YZ'
%           Values: 2*N matrix for the circles
%            Color: Color for the main chart
%        LineWidth: Line width for the main chart
%         LineType: Line type for the main chart
%         SubColor: Color for the sub chart
%     SubLineWidth: Line width for the sub chart
%      SubLineType: Line type for the sub chart
%     LabelVisible: 'on' or 'off'
%        LabelSize: Label size
%       LabelColor: Label color
%
% Properties you do not specify retain their default values.
%
%   See also RFCHART.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/12 23:36:04 $

h = rfchart.smith;
set(h, 'Name', 'Smith chart');

% Set user-specified properties
set(h,varargin{:});

% Use current axes if Axes is not provided
if isempty(h.Axes)
    h.Axes = gca;
end

% Draw a white circle
M = 128;
t = 0:M;
X = [sin(t*2*pi/M)];
Y = [cos(t*2*pi/M)];
hh = fill(X,Y,[1 1 1]);

% Set some axes properties for the Smith chart
set(h.Axes, 'DataAspectRatio',[1 1 1], 'PlotBoxAspectRatio',[1 1 1], ...
    'XScale','linear','YScale','linear', 'XDir','normal','YDir','normal', ...
    'XLim',[-1.015 1.015],'YLim',[-1.015 1.015], 'XTick',[],'YTick',[], ...
    'XGrid','off','YGrid','off', 'Box','on');

% Create AdmittanceGrid and ImpedanceGrid objects
h.AdmittanceGrid = line('Parent',h.Axes,'XData',[0],'YData',[0],...
    'Visible','off','Clipping','on', 'HandleVis','off','HitTest','off');
h.ImpedanceGrid = line('Parent',h.Axes,'XData',[0],'YData',[0],...
    'Visible','off','Clipping','on','HandleVis','off','HitTest','off');

% Create StaticGrid object (X=0 & R=0)
t = 0:M;
h.StaticGrid = line('Parent',h.Axes,'Color',h.Color,'LineWidth',h.LineWidth,...
    'XData',[-1 1 NaN sin(t*2*pi/M)],'YData',[ 0 0 NaN cos(t*2*pi/M)],...
    'Visible','on','Clipping','on','HandleVis','off','HitTest','off');

% Prevent datatips from appearing on line using the behavior object API
hBehavior = hggetbehavior(hh,'DataCursor');
set(hBehavior,'Enable',false);
hBehavior = hggetbehavior(h.AdmittanceGrid,'DataCursor');
set(hBehavior,'Enable',false);
hBehavior = hggetbehavior(h.ImpedanceGrid,'DataCursor');
set(hBehavior,'Enable',false);
hBehavior = hggetbehavior(h.StaticGrid,'DataCursor');
set(hBehavior,'Enable',false);

% Draw a Smith chart
draw(h);

% Activate listeners
L(1) = handle.listener(h,h.findprop('Type'),'PropertyPostSet',@draw);
set(L(1),'CallbackTarget',h);
L(2) = handle.listener(h,h.findprop('Values'),'PropertyPostSet',@draw);
set(L(2),'CallbackTarget',h);
L(3) = handle.listener(h,h.findprop('Color'),'PropertyPostSet',@draw);
set(L(3),'CallbackTarget',h);
L(4) = handle.listener(h,h.findprop('SubColor'),'PropertyPostSet',@draw);
set(L(4),'CallbackTarget',h);
L(5) = handle.listener(h,h.findprop('LineWidth'),'PropertyPostSet',@draw);
set(L(5),'CallbackTarget',h);
L(6) = handle.listener(h,h.findprop('SubLineWidth'),'PropertyPostSet',@draw);
set(L(6),'CallbackTarget',h);
L(7) = handle.listener(h,h.findprop('LineType'),'PropertyPostSet',@draw);
set(L(7),'CallbackTarget',h);
L(8) = handle.listener(h,h.findprop('SubLineType'),'PropertyPostSet',@draw);
set(L(8),'CallbackTarget',h);
L(9) = handle.listener(h,h.findprop('LabelVisible'),'PropertyPostSet',@label);
set(L(9),'CallbackTarget',h);
L(10) = handle.listener(h,h.findprop('LabelSize'),'PropertyPostSet',@label);
set(L(10),'CallbackTarget',h);
L(11) = handle.listener(h,h.findprop('LabelColor'),'PropertyPostSet',@label);
set(L(11),'CallbackTarget',h);
L(12) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(12),'CallbackTarget',h);
L(13) = handle.listener(handle(h.Axes),'ObjectBeingDestroyed',@destroy);
set(L(13),'CallbackTarget',h);
h.Listeners = L;

% Store object handle in ApplicationData of axes
SmithChart = getappdata(h.Axes,'SmithChart');
if isa(SmithChart,'rfchart.smith')
   delete(SmithChart);
end
setappdata(h.Axes,'SmithChart',h);

