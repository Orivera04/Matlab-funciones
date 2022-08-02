function varargout = chartfts(varargin)
%CHARTFTS Interactive display of FINTS object data.
%
%   CHARTFTS(FTS) produces an interactive chart that contains one or more
%   plots.  The data at any particular point on each plot can be viewed
%   via the mouse. Furthermore, the plots can be combined and/or zoomed in
%   or out. Please refer to the 'Using CHARTFTS' section of the
%   documentation and/or the application help for more details on these
%   tools.
%
%   [HAXES, HFIG] = CHARTFTS(FTS) is similar to the above with the addition
%   of returning the handles to the Axes and the Figure of the chart. HAXES
%   is the variable containing the handle(s) to the multiple plots in the
%   chart and HFIG is the handle to the figure window. HAXES and HFIG are
%   optional output arguments.
%
%   Example:   ibmfts = ascii2fts('ibm9599.dat', 1, 3, 2);
%              chartfts(ibmfts);
%
%   See also FINTS/CANDLE, FINTS/HIGHLOW, FINTS/PLOT.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.20.2.4 $   $Date: 2004/04/06 01:08:13 $

% Get FINTS object and check it
if nargin ~= 1
    error('Ftseries:chartfts:tooManyInputs', ...
        'Too many inputs.');
else
    fts = varargin{1};

    % Get version and if there is time data
    [ftsVersion, timeData] = fintsver(fts);
    if ftsVersion
        fts = ftsold2new(fts); % This sorts the fts too.
    elseif ~issorted(fts)
        fts = sortfts(fts);
    end
end

% Default parameters
spacing     = 0.055;        % Spacing between plots
plotArea    = 0.66;         % Plottable area
topMargin   = 0.070;        % Margin above top most plot (0.08)
leftMargin  = 0.13;         % Margin left of plots
width       = 0.775;        % Width of all plots

h.colorScheme = get(0,'defaultfigurecolor');

% Get FINTS object information and do some calculations
[fts, fts3DT, namelen, xyscale] = getfintsinfo(fts, timeData);

% Create a new figure if none exist; use same one if one does.
ftsName = deblank(fts.data{1});
findfig = findall(0, 'Tag', ['chartfts: ', ftsName]);

if ~isempty(findfig)
    % Make this figure the active one.
    h.hfig = figure(findfig);
    clf(h.hfig, 'reset');

    set(h.hfig, 'Tag', ['chartfts: ', ftsName], ...
        'Name', ['Interactive Chart: ', ftsName], ...
        'Toolbar', 'no', ...
        'NumberTitle', 'off', ...
        'Visible', 'on', ...
        'color', h.colorScheme, ...
        'DoubleBuffer' ,'on');
else
    SCR = get(0,'screensize');
    h.hfig = figure('Tag', ['chartfts: ', ftsName], ...
        'Name', ['Interactive Chart: ', ftsName], ...
        'Position', [(SCR(3)*.2), (SCR(4)*.2), (SCR(3)*.56), (SCR(4)*.51)], ...
        'Toolbar', 'no', ...
        'NumberTitle', 'off', ...
        'Visible', 'on', ...
        'color', h.colorScheme, ...
        'DoubleBuffer', 'on');

    % Center the gui when creating new figure
    movegui(h.hfig, 'center');
end

% No need for a Tool's uimenu.
delete(findall(h.hfig, 'tag', 'figMenuTools'));

% Set the time series to the figures appdata
setappdata(h.hfig, 'FINTS', fts);

% Set the name of the GUI when created into appdata
setappdata(h.hfig, 'FigureNameBase', get(h.hfig, 'Name'));

%-----------------
% Set up subplots
%-----------------
[h, numplot, errMsg] = setsubplot(h, fts, ftsName, namelen, fts3DT, xyscale, ...
    spacing, plotArea, topMargin, leftMargin, width, timeData);

% Limit the number of plots
if errMsg
    chartftsError = errordlg(sprintf(['An error occured when attempting to display %d series (subplots).\n', ...
        'Please reduce the number of series to be displayed.'], numplot), ...
        'Chartfts error', 'modal');

    delete(h.hfig)
    return
end
%----------------

% Populate main gui
h = mainframe(h);                   % main frame
h = butfrm1(h);                     % button frame
h = slider1(h, numplot);            % slider
h = datetxt(h, timeData, fts3DT);   % lower left date box
h = butfrm2(h, numplot);            % info boxes
h = infotxt(h, fts, numplot);       % info box text
h = zoomonbtn(h);                   % zoom on button
h = zoomresetbtn(h);                % zoom reset button
h = combinechkbox(h, numplot);      % combine axes check boxes
h = combineallchkboxframes(h);      % combine all frames etc
h = combineallchkbox(h);            % combine all checkbox
h = combineplotbtn(h);              % combine plots button
h = createmenu(h, fts, numplot, ...
    fts3DT, timeData);              % chart tools menu

% Set callbacks
setcallbacks(h, fts, timeData, fts3DT, numplot, spacing, ...
    plotArea, topMargin, leftMargin, width);

% Save/set original XLim info
hax1_XLim.orig  = get(findall(h.hfig, 'Tag', 'Axis1'), 'XLim'); % Original limits
hax1_XLim.left  = [];   % zoom left limit
hax1_XLim.right = [];   % zoom right limit
setappdata(findall(h.axes, 'Tag', 'Axis1'), 'Axis1', hax1_XLim);

% Turn everything on
set(h.hfig,'visible','on');

% Dont lose control of figure
set(h.hfig, 'handlevisibility', 'off');

% Pass out handles only when requested
if nargout
    varargout = {h.axes, h.hfig};
end


%------------------------------------------------------------------------------
% UICONTROLS
%------------------------------------------------------------------------------
function h = mainframe(h)
% Main frame at bottom

h.mainframe = uicontrol('parent', h.hfig, ...
    'Style', 'pushbutton', ...
    'Enable', 'off', ...
    'Units', 'normal', ...
    'Position', [0 0 1 0.175], ...
    'Tag', 'MainFrame', ...
    'backgroundcolor', h.colorScheme);

%-----------------------------------------------------------
function h = butfrm1(h)
% Button frame

h.butfrm1 = uicontrol('parent', h.hfig, ...
    'Style', 'pushbutton', ...
    'Enable', 'off', ...
    'Units', 'normal', ...
    'Position', [0 0 0.2 0.175], ...
    'Tag', 'ButtonFrame1', ...
    'backgroundcolor', h.colorScheme);

%-----------------------------------------------------------
function h = slider1(h, numplot)
% Slider

h.slider1 = uicontrol('parent', h.hfig, ...
    'Style', 'slider', ...
    'Enable', 'off', ...
    'Units', 'normal', ...
    'Position', [0.975 0 0.025 0.177], ...
    'Value', -1, ...
    'Min', -2, ...
    'Max', -1, ...
    'SliderStep', [0.5 1], ...
    'Tag', 'Slider1');

if ceil(numplot/4) > 2
    set(h.slider1, 'Min', -ceil(numplot/4), ...
        'Enable', 'on');
end


%----------
% Callback
%----------
function slider1_cb(hcbo, eventStruct, h, numplot)
% Callback for slider1

hslider_val = -1 * get(h.slider1, 'Value');

% Turn on/off disabled pushbuttons to simulate scrolling
for iidx = 1:numplot
    if hslider_val > 2
        validinfonum = (round(hslider_val)-2) * 4;
    else
        validinfonum = 0;
    end
    if iidx <= validinfonum
        set(h.infotxt(iidx), 'Visible', 'off');
    else
        txtpos = [0.205  0.0945] + ...
            [mod((iidx-1), 4)*0.19375  -(floor((iidx-1-validinfonum)/4)*0.0880)];
        set(h.infotxt(iidx), 'Position', [txtpos 0.175 0.0725], ...
            'Visible', 'on');
    end
end

%-----------------------------------------------------------
function h = datetxt(h, timeData, fts3DT)
% 'Date' box at bottom left corner.

if timeData
    h.datetxt = uicontrol('parent', h.hfig, ...
        'Style', 'text', ...
        'String', {'Dates:'; datestr(min(fts3DT))}, ...
        'HorizontalAlignment', 'center', ...
        'FontUnits', 'normal', ...
        'FontSize', 0.3, ...
        'Units', 'normal', ...
        'Position', [0.01 0.05 0.175 0.075], ...
        'Tag', 'DateText', ...
        'backgroundcolor', h.colorScheme);
else
    h.datetxt = uicontrol('parent', h.hfig, ...
        'Style', 'text', ...
        'String', {'Dates:'; datestr(min(fts3DT))}, ...
        'HorizontalAlignment', 'center', ...
        'FontUnits', 'normal', ...
        'FontSize', 0.4, ...
        'Units', 'normal', ...
        'Position', [0.01 0.065 0.175 0.075], ...
        'Tag', 'DateText', ...
        'backgroundcolor', h.colorScheme);
end

%-----------------------------------------------------------
function h = butfrm2(h, numplot)
% Boxes for values at the bottom of chart, to the right of 'Date'.
% Button frames need to be created first to obtain a specific stacking order.

h.butfrm2 = zeros(numplot, 1);
h.infottl = zeros(numplot, 1);
h.infotxt = zeros(numplot, 1);
for iidx = 1:numplot
    frm2pos = [0.2  0.0875] + ...
        [mod((iidx-1), 4)*0.19375,  -(floor((iidx-1)/4)*0.0875)];

    h.butfrm2(iidx) = uicontrol('parent', h.hfig, ...
        'Style', 'pushbutton', ...
        'Enable', 'off', ...
        'Units', 'normal', ...
        'Position', [frm2pos 0.19375 0.0875], ...
        'Tag', ['ButtonFrame2', num2str(iidx)], ...
        'backgroundcolor', h.colorScheme);
end

%-----------------------------------------------------------
function h = infotxt(h, fts, numplot)
%Info box text

for iidx = 1:numplot
    txtpos = [0.205  0.0945] + ...
        [mod((iidx-1), 4)*0.19375, -(floor((iidx-1)/4)*0.0880)];
    data_info = [{[fts.names{iidx+3}, ':']}; cellstr(num2str(fts.data{4}(1, iidx)))];

    h.infotxt(iidx) = uicontrol('parent', h.hfig, ...
        'Style', 'text', ...
        'String', data_info, ...
        'HorizontalAlignment', 'left', ...
        'FontUnits', 'normal', ...
        'FontSize', 0.3, ...
        'Units', 'normal', ...
        'Position', [txtpos 0.1825 0.0725], ...
        'Tag', ['InfoText', num2str(iidx)], ...
        'backgroundcolor', h.colorScheme);

    % Set fts.names to appdata of specific plot
    setappdata(h.infotxt(iidx), 'ftsName', fts.names{iidx+3});
end

%-----------------------------------------------------------
function h = createmenu(h, fts, numplot, fts3DT, timeData)
% Create Chart Tool Menu item.

% Make the menu item list
menuItems = {
    '&Chart Tools'     , '' , 'ChartToolsMenuItem';                 % 1
    '>&Zoom'           , '' , 'ChartToolsZoomMenuItem';             % 2
    '>>&On'            , '' , 'ChartToolsZoomOnMenuItem' ;          % 3 cb
    '>>O&ff'           , '' , 'ChartToolsZoomOffMenuItem';          % 4 cb
    '>>-----'          , '' , '';
    '>>&Help'          , '' , 'ChartToolsZoomHelpMenuItem';         % 5 cb
    '>&Combine Axes'   , '' , 'ChartToolsCombineAxesMenuItem';      % 6 cb
    '>>&On'            , '' , 'ChartToolsCombineAxesOnMenuItem';    % 7 cb
    '>>O&ff'           , '' , 'ChartToolsCombineAxesOffMenuItem';   % 8 cb
    '>>-----'          , '' , '';
    '>>&Reset Axes'    , '' , 'ChartToolsCombineAxesResetMenuItem'; % 9 cb
    '>>-----'          , '' , '';
    '>>&Help'          , '' , 'ChartToolsCombineAxesHelpMenuItem';  % 10 cb
    '>-----'           , '' , '';
    '>Chart Tool &Help', '' , 'ChartToolsHelpMenuItem'};            % 11 cb

h.hChartToolsMenu = makemenu(h.hfig, str2mat(menuItems{:, 1}), ...
    str2mat(menuItems{:, 2}), str2mat(menuItems{:, 3}));

% Disable Combine Axes if there is one plot
if numplot == 1
    set(h.hChartToolsMenu(6), 'Enable', 'off'); % ChartToolsCombineAxesMenuItem
end

% Set the 'Off' position for ZOOM and Combine Axes as default; Set the flags to off.
set(h.hChartToolsMenu(3), 'Checked', 'off', ...
    'callback', {@zoom_menu_on_cb, h, fts, numplot, fts3DT, timeData}); % ChartToolsZoomOnMenuItem
set(h.hChartToolsMenu(4), 'Checked', 'on', ...
    'callback', {@zoom_menu_off_cb, h});                 % ChartToolsZoomOffMenuItem
set(h.hChartToolsMenu(7), 'Checked', 'off', ...
    'callback', {@combine_axes_on_cb, h});               % ChartToolsCombineAxesOnMenuItem
set(h.hChartToolsMenu(8), 'Checked', 'on', ...
    'callback', {@combine_axes_off_cb, h, fts, numplot, fts3DT, timeData}); % ChartToolsCombineAxesOffMenuItem

% Disable Reset Axes for now
set(h.hChartToolsMenu(9), 'Enable', 'off', ...
    'callback', {@reset_axes_cb, h, fts}); % ChartToolsCombineAxesResetMenuItem

set(h.hChartToolsMenu(5), 'callback', {@zoom_menu_help_cb, h});     % ChartToolsZoomHelpMenuItem
set(h.hChartToolsMenu(10), 'callback', {@combine_axes_help_cb, h}); % ChartToolsCombineAxesHelpMenuItem
set(h.hChartToolsMenu(11), 'callback', {@chart_tool_help_cb, h});   % ChartToolsHelpMenuItem

% Set zoom status to appdata
setappdata(h.hfig, 'ZoomStatus', 'off');

% Set zoom status to appdata
setappdata(h.hfig, 'CombineAxesStatus', 'off');

%-----------------------------------------------------------
function h = zoomonbtn(h)
% ZOOM On pushbutton

gcfcallbacks = cell(4, 1);
gcfcallbacks{1} = 0;

h.zoomonbtn = uicontrol('parent', h.hfig, ...
    'Style', 'pushbutton', ...
    'Enable', 'off', ...
    'String', 'ZOOM In', ...
    'Units', 'normal', ...
    'Position', [0.025 0.177 0.125 0.04], ...
    'Visible', 'off', ...
    'Tag', 'DoZoomButton');

% Set the gcfcallbacks to appdata
setappdata(h.zoomonbtn, 'gcfcallbacks', gcfcallbacks);

%----------
% Callback
%----------
function zoomonbtn_cb(hcbo, eventStruct, h, numplot)
% Callback for zoomonbtn

% Turn off the zoom limit lines
hl_left = findall(h.hfig, 'Tag', 'LeftBlueLine');
if ~isempty(hl_left)
    delete(hl_left);
end
hl_right = findall(h.hfig, 'Tag', 'RightRedLine');
if ~isempty(hl_right)
    delete(hl_right);
end

xlim = getappdata(findall(h.hfig, 'Tag', 'Axis1'), 'Axis1');

% Set the Zoom limits to the Xlim
for pidx = 1:numplot
    set(h.axes(pidx), 'XLim', [xlim.left(1) xlim.right(1)]);
end
xlim.left  = [];
xlim.right = [];
setappdata(findall(h.hfig, 'Tag', 'Axis1'), 'Axis1', xlim);

% Update the properties of the zoom buttons
set(h.zoomonbtn, 'Enable', 'off');
set(h.zoomresetbtn, 'Enable', 'on');

%-----------------------------------------------------------
function h = zoomresetbtn(h)
% Reset pushbutton

gcfcallbacks = cell(4, 1);
gcfcallbacks{1} = 0;

h.zoomresetbtn = uicontrol('parent', h.hfig, ...
    'Style', 'pushbutton', ...
    'Enable', 'off', ...
    'String', 'Reset ZOOM', ...
    'Units', 'normal', ...
    'Position', [0.850 0.177 0.125 0.04], ...
    'Visible', 'off', ...
    'Tag', 'ZoomResetButton');

% Set the gcfcallbacks to appdata
setappdata(h.zoomresetbtn, 'gcfcallbacks', gcfcallbacks);

%----------
% Callback
%----------
function zoomresetbtn_cb(hcbo, eventStruct, h, numplot)
% Callback for zoomresetbtn

% Get the zoomed Xlims
xlim = getappdata(findall(h.hfig, 'Tag', 'Axis1'), 'Axis1');
for pidx = 1:numplot
    set(h.axes(pidx), 'XLim', xlim.orig);
end

xlim.left  = [];
xlim.right = [];
setappdata(findall(h.hfig, 'Tag', 'Axis1'), 'Axis1', xlim);

% Set the zoom button to reflect changes
set(h.zoomresetbtn, 'Enable', 'off');

% Find any residual zoom lines (blue and red) and erase them if they exist.
hl_left = findall(h.hfig, 'Tag', 'LeftBlueLine');
if ~isempty(hl_left)
    delete(hl_left);
end
hl_right = findall(h.hfig, 'Tag', 'RightRedLine');
if ~isempty(hl_right)
    delete(hl_right);
end

%-----------------------------------------------------------
function h = combinechkbox(h, numplot)
% Check boxes for combining graphs.

% Create a checkbox for every subplot
h.combinechkbox = zeros(numplot, 1);
for cbidx = 1:numplot
    ax_pos = get(h.axes(cbidx), 'Position');

    h.combinechkbox(cbidx) = uicontrol('parent', h.hfig, ...
        'Style', 'checkbox', ...
        'Units', 'normal', ...
        'Position', [0.945 ax_pos(2)+(ax_pos(4)/2)-.017 0.023 0.03], ...
        'Visible', 'off', ...
        'Tag', 'IndividualPlotCheckbox', ...
        'backgroundcolor', h.colorScheme, ...
        'userdata', [cbidx h.axes(cbidx)]);
end

%----------
% Callback
%----------
function combinechkbox_cb(hcbo, eventStruct, h)
% Callback for combinechkbox

% Turn on/off combine all plots button if 2 or more checkboxes are selected
combinechkboxVal = get(h.combinechkbox, 'Value');
if sum([combinechkboxVal{:}]) >= 2
    set(h.combineplotbtn, 'Visible', 'on');
elseif all(~[combinechkboxVal{:}]) | sum([combinechkboxVal{:}]) < 2
    set(h.combineplotbtn, 'Visible', 'off');
end

% Set on/off the select all plots checkbox
if all([combinechkboxVal{:}])
    set(h.combineallchkbox, 'Value', 1);
else
    set(h.combineallchkbox, 'Value', 0);
end

%-----------------------------------------------------------
function h = combineallchkbox(h)
% Check box selecting all graphs to be combined.
h.combineallchkbox = uicontrol('parent', h.hfig, ...
    'Style', 'checkbox', ...
    'FontUnit', 'normal', ...
    'Units', 'normal', ...
    'Position', [0.945 0.185 0.023 0.03], ...
    'Visible', 'off', ...
    'Tag', 'AllPlotsCheckbox', ...
    'backgroundcolor', h.colorScheme);

%----------
% Callback
%----------
function combineallchkbox_cb(hcbo, eventStruct, h)
% Callback for combineallchkbox

% Check/uncheck checkboxes depending on the state of select all plots checkbox
if get(h.combineallchkbox, 'Value') == 1
    set(h.combinechkbox, 'Value', 1);
    set(h.combineplotbtn, 'Visible', 'on');
elseif get(h.combineallchkbox, 'Value') == 0
    set(h.combinechkbox, 'Value', 0);
    set(h.combineplotbtn, 'Visible', 'off');
end

%-----------------------------------------------------------
function h = combineallchkboxframes(h)
% Check boxes for combining graphs.

h.combinechkboxallframeborder = uicontrol('parent', h.hfig, ...
    'Style', 'frame', ...
    'FontUnit', 'normal', ...
    'Units', 'Normal', ...
    'Position', [0.780 0.1815 0.195 0.0425], ...
    'Visible', 'off', ...
    'backgroundcolor', h.colorScheme, ...
    'Tag', 'AllPlotsCheckboxFrameBorder');

h.combinechkboxalltext = uicontrol('parent', h.hfig, ...
    'Style','Text', ...
    'FontUnit', 'normal', ...
    'String', 'Select all plots', ...
    'Units', 'Normal', ...
    'Position', [0.783 0.189 0.13 0.025], ...
    'Visible', 'off', ...
    'Tag', 'AllPlotsCheckboxText', ...
    'backgroundcolor',  h.colorScheme);

%-----------------------------------------------------------
function h = combineplotbtn(h)
% Pushbutton to combine selected plot(s)/graph(s).

h.combineplotbtn = uicontrol('parent', h.hfig, ...
    'Style', 'Pushbutton', ...
    'FontUnit', 'normal', ...
    'String', 'Combine Selected Graphs', ...
    'Units', 'Normal', ...
    'Position', [0.35 0.179 0.3 0.047], ...
    'Visible', 'off', ...
    'Tag', 'CombineGraphsButton');

%----------
% Callback
%----------
function combineplotbtn_cb(hcbo, eventStruct, h, fts, fts3DT, numplot, timeData, ...
    spacing, plotArea, topMargin, leftMargin, width)
% Callback for combineplotbtn

% Reference numbers
% spacing = 0.055;      % Spacing between plots
% plotArea = 0.66;      % Plottable area
% topMargin = 0.08;     % Margin above top most plot
% leftMargin = 0.13;    % Margin left of plots
% width = 0.775;        % Width of all plots

if get(h.combineallchkbox, 'Value') == 1
    % If select all plots is checked
    set(h.axes(1:end-1), 'Visible', 'off');
    set(h.axes(end), 'Position', [leftMargin 0.27 width 0.65]);
    set(get(h.axes(end), 'YLabel'), 'Visible', 'off');

    axesColorOrder = get(h.axes(end), 'ColorOrder');
    ha_achd = get(h.axes(1:end), 'Children');
    ha_lchd = findall(cat(1, ha_achd{:}), 'Tag', 'LinePlot');
    set(cat(1, ha_achd{:}), 'Visible', 'off');

    % Find all text objects
    hinfotxt = findall(h.hfig, 'Type', 'uicontrol', 'Style', 'text');
    hinfotxt = flipud(hinfotxt(1:end-1));

    % Set the color of the lines
    for pidx = 1:length(ha_lchd)
        set(ha_lchd(pidx), ...
            'Color', axesColorOrder(mod(pidx-1, size(axesColorOrder, 1))+1, :));
        set(hinfotxt(pidx), 'BackgroundColor', ...
            axesColorOrder(mod(pidx-1, size(axesColorOrder, 1))+1, :), ...
            'ForegroundColor', 'w');
    end

    % Copy all existing objects onto one axes (reuse last axes)
    copyobj(cat(1, ha_lchd(1:end-1)), h.axes(end));

    set(get(h.axes(end), 'Children'), 'Visible', 'on');

    % Set some properties of the original plots to the combined plots
    hTitle = get(get(h.axes(1), 'Title'));
    set(get(h.axes(end), 'Title'), ...
        'String', hTitle.String, ...
        'Color', hTitle.Color, ...
        'FontUnits', hTitle.FontUnits, ...
        'FontSize', hTitle.FontSize/length(ha_lchd),...
        'Fontweight', 'bold');
else
    % If some axes are slected to be combined
    ha_pos  = get(h.axes, 'Position');
    ha_pos  = cat(1, ha_pos{:});
    ha_chd  = get(h.axes, 'Children');
    ha_chd  = cat(1, ha_chd{:});

    set([h.axes'; ha_chd], 'Visible', 'off');
    axesColorOrder = get(h.axes(end), 'ColorOrder');

    hinfotxt = findall(h.hfig, 'Type', 'uicontrol', 'Style', 'text');
    hinfotxt = flipud(hinfotxt(1:end-1));
    set(hinfotxt, 'Visible', 'off');

    % Move the checked plots to the top of the chart.
    hNCA = h.axes;
    hinfotxtNCA = hinfotxt;
    hCA_udata = flipud(get(findall(h.hfig, 'Style', 'check', 'Value', 1), 'userdata'));

    % Total 'plottable' area not including area between subplots
    totalSpace = (plotArea - ((numplot-1)*spacing));

    % Figure height
    figHeight = totalSpace / numplot;

    % Number of combined plots
    numCombPlots = size(hCA_udata, 1);

    % Combined plot's figure height
    combHeight = (figHeight*numCombPlots) + ((numCombPlots-1)*spacing);

    for pidx = 1:numCombPlots
        blx = ha_pos(1, 1);
        bly = ha_pos(1, 2) - (pidx-1)*ha_pos(1, 4);
        xwd = ha_pos(1, 3);
        yht = ha_pos(1, 4);

        set(hCA_udata{pidx}(2), 'Position', [blx bly xwd yht]);
        set([hCA_udata{pidx}(2); get(hCA_udata{pidx}(2), 'Children')], 'Visible', 'on');
        hNCA = hNCA(hNCA ~= hCA_udata{pidx}(2));

        % The one that becomes the top plot gets the Title.
        if pidx == numCombPlots
            hTitle = get(get(h.axes(1), 'Title'));
            set(get(hCA_udata{pidx}(2), 'Title'), ...
                'String', hTitle.String, ...
                'Color', hTitle.Color, ...
                'FontUnits', hTitle.FontUnits, ...
                'FontSize', hTitle.FontSize/numCombPlots,...
                'FontWeight', 'bold');
        end

        hCA_achd = get(hCA_udata{pidx}(2), 'Children');
        hCA_lchd = findall(hCA_achd, 'Tag', 'LinePlot');
        set(hCA_lchd, 'Color', axesColorOrder(mod(pidx-1, size(axesColorOrder, 1))+1, :));

        txtpos = [0.205  0.0945] + ...
            [mod((pidx-1), 4)*0.19375  -(floor((pidx-1)/4)*0.0880)];
        set(hinfotxt(hCA_udata{pidx}(1)), ...
            'BackgroundColor', axesColorOrder(mod(pidx-1, size(axesColorOrder, 1))+1, :), ...
            'Position', [txtpos 0.1825 0.0725], 'foregroundcolor','w');
        hinfotxtNCA = hinfotxtNCA(hinfotxtNCA ~= hinfotxt(hCA_udata{pidx}(1)));
    end

    hCA = cat(1, hCA_udata{:});
    set(hCA(1:end-1, 2), 'Visible', 'off');
    set(get(hCA(end, 2), 'YLabel'), 'Visible', 'off');

    hCA_achd = get(hCA(:, 2), 'Children');
    hCA_lchd = findall(cat(1, hCA_achd{:}), 'Tag', 'LinePlot');
    set(cat(1, hCA_achd{:}), 'Visible', 'off');

    % Copy all existing objects onto one axes (reuse last axes)
    copyobj(cat(1, hCA_lchd(1:end-1)), hCA(end, 2));

    % Postion of top "combined" plot
    set(hCA(end, 2), 'Position', [leftMargin ha_pos(numCombPlots, 2) width combHeight], ...
        'FontSize', get(hCA(end, 2), 'FontSize')/numCombPlots);

    set(get(hCA(end, 2), 'Children'), 'Visible', 'on');

    % Move the unchecked plots to the bottom of the chart.
    for pidx = (numCombPlots+1):(numCombPlots+length(hNCA))
        % Position rest of plots
        set(hNCA(pidx-numCombPlots), ...
            'Position', [leftMargin ha_pos(pidx,2) width figHeight]);
        set([hNCA(pidx-numCombPlots); get(hNCA(pidx-numCombPlots), 'Children')], ...
            'Visible', 'on');

        if hNCA(pidx-numCombPlots) == h.axes(1)
            set(get(h.axes(1), 'Title'), 'String', '');
        end

        txtpos = [0.205  0.0945] + ...
            [mod((pidx-1), 4)*0.19375  -(floor((pidx-1)/4)*0.0880)];
        set(hinfotxtNCA(pidx-numCombPlots), 'Position', [txtpos 0.1825 0.0725]);
    end

    set(hinfotxt, 'Visible', 'on');
end

% Enable Reset Axes for now.
set(h.hChartToolsMenu(9), 'Enable', 'on'); % ChartToolsCombineAxesResetMenuItem

% Disable Combine Axes On/Off.
set(h.hChartToolsMenu(7),  'Enable', 'off'); % ChartToolsCombineAxesOnMenuItem
set(h.hChartToolsMenu(8), 'Enable', 'off'); % ChartToolsCombineAxesOffMenuItem

% Turn the 'Combine Axes' checkboxes Off afterwards.
combine_axes_off_cb([], [], h, fts, numplot, fts3DT, timeData);


% -------------------------------------------------------------------------
% callbacks
% -------------------------------------------------------------------------
function h = setcallbacks(h, fts, timeData, fts3DT, numplot, spacing, plotArea, ...
    topMargin, leftMargin, width)
% Set callbacks for buttons and mouse buttons/movement

set(h.hfig, 'WindowButtonMotionFcn', {@windowbtnmotionfcn_cb, h, fts, timeData, ...
    fts3DT, numplot});
set(h.hfig, 'WindowButtonDownFcn', {@windowbtndownfcn_cb, h, fts, fts3DT, timeData});
set(h.hfig, 'WindowButtonUpFcn', {@windowbtnupfcn_cb, h});

set(h.slider1, 'callback', {@slider1_cb, h, numplot});
set(h.zoomonbtn, 'callback', {@zoomonbtn_cb, h, numplot});
set(h.zoomresetbtn, 'callback', {@zoomresetbtn_cb, h, numplot});
set(h.combinechkbox, 'callback', {@combinechkbox_cb, h});
set(h.combineallchkbox, 'callback', {@combineallchkbox_cb, h});
set(h.combineplotbtn, 'callback', {@combineplotbtn_cb, h, fts, fts3DT, numplot, ...
    timeData, spacing, plotArea, topMargin, leftMargin, width});


%------------------------------------------------------------------------------
% ZOOM_Menu_On_Callback
%------------------------------------------------------------------------------
function zoom_menu_on_cb(hcbo, eventdata, h, fts, numplot, fts3DT, timeData)
% Callback for zoom on menu option

% Set status flag for 'Zoom' to On.
setappdata(h.hfig, 'ZoomStatus', 'on');
set(h.hfig, 'Name', [getappdata(h.hfig, 'FigureNameBase'), ', Zoom ON']);

% Turn 'Combine Axes' Off, if it is On.
combineAxesStatus = getappdata(h.hfig, 'CombineAxesStatus');
if strcmpi(combineAxesStatus, 'on')
    combine_axes_off_cb([], [], h, fts, numplot, fts3DT, timeData);
    setappdata(h.hfig, 'CombineAxesStatus', 'on')
end

% Turn 'Zoom' On
% Set the menu items to reflect Zoom on state
set(h.hChartToolsMenu(3), 'Checked', 'on'); % ChartToolsZoomOnMenuItem
set(h.hChartToolsMenu(4), 'Checked', 'off'); % ChartToolsZoomOffMenuItem

% Turn 'Zoom' buttons on
set([h.zoomonbtn; h.zoomresetbtn], 'Visible', 'on');

% Set the states of gcfcallbacks and set it in appdata
gcfcallbacks = cell(4, 1);
gcfcallbacks{1} = 1;
gcfcallbacks{2} = get(h.hfig, 'WindowButtonDownFcn');
gcfcallbacks{3} = get(h.hfig, 'WindowButtonMotionFcn');
gcfcallbacks{4} = get(h.hfig, 'WindowButtonUpFcn');

setappdata(h.zoomonbtn, 'gcfcallbacks', gcfcallbacks);

% Set callbacks for zoomed in window area
set(h.hfig, 'WindowButtonDownFcn',   {@zoomwindowbtndownfcn_cb, h, fts, numplot});
set(h.hfig, 'WindowButtonMotionFcn', {@zoomwindowbtnmotionfcn_cb, h, fts, fts3DT, numplot, timeData});
set(h.hfig, 'WindowButtonUpFcn',     {@zoomwindowbtnupfcn_cb, h, fts});


%------------------------------------------------------------------------------
% ZOOM_Menu_Off_Callback
%------------------------------------------------------------------------------
function zoom_menu_off_cb(hcbo, eventdata, h)
% Callback for zoom off menu option

% Set status flag for 'Zoom' to Off.
setappdata(h.hfig, 'ZoomStatus', 'off');
set(h.hfig, 'Name', getappdata(h.hfig, 'FigureNameBase'));

% Restore state of 'Combine Axes'.
combineAxesStatus = getappdata(h.hfig, 'CombineAxesStatus');
if strcmpi(combineAxesStatus, 'on')
    combine_axes_on_cb([], [], h);
end

% Turn Zoom limit lines off.
h1_left = findall(h.hfig, 'Tag', 'LeftBlueLine');
if ~isempty(h1_left)
    delete(h1_left);
end
hl_right = findall(h.hfig, 'Tag', 'RightRedLine');
if ~isempty(hl_right)
    delete(hl_right);
end

xlim = getappdata(findall(h.hfig, 'Tag', 'Axis1'), 'Axis1');
xlim.left  = [];
xlim.right = [];
setappdata(findall(h.hfig, 'Tag', 'Axis1'), 'Axis1', xlim);

% Set the menu items to reflect Zoom on state
set(h.hChartToolsMenu(3), 'Checked', 'off'); % ChartToolsZoomOnMenuItem
set(h.hChartToolsMenu(4), 'Checked', 'on'); % ChartToolsZoomOffMenuItem

% Turn 'Zoom' buttons off
set([h.zoomonbtn; h.zoomresetbtn], 'Visible', 'off');

% Set the states of gcfcallbacks and set it in appdata
gcfcallbacks = getappdata(h.zoomonbtn, 'gcfcallbacks');
set(h.hfig, 'WindowButtonDownFcn', gcfcallbacks{2});
set(h.hfig, 'WindowButtonMotionFcn', gcfcallbacks{3});
set(h.hfig, 'WindowButtonUpFcn', gcfcallbacks{4});


%------------------------------------------------------------------------------
% ZOOM_Menu_Help_Callback
%------------------------------------------------------------------------------
function zoom_menu_help_cb(hcbo, eventdata, h)
% Callback for zoom help menu option

zoomhlpmsg = {'ChartFTS ZOOM:'; ...
    ' '; ...
    'Zoom/unzoom all plots simultaneously.'; ...
    ' '; ...
    '1. Click on ''Chart Tools'' in the menu bar.'; ...
    '    Select ''Zoom'' and then click on ''On''.'; ...
    '2. Click anywhere in the chart to set the'; ...
    '    left boundary.  A BLUE vertical line will'; ...
    '    denote this boundary.'; ...
    '3. Click anywhere a second time to set the right'; ...
    '    boundary.  A RED vertical line will denote'; ...
    '    this one.'; ...
    '4. Click on the ''Zoom In'' button, which is now'; ...
    '    enabled, to zoom in into the selected boundaries.'; ...
    '5. Once zoomed in, the ''Reset Zoom'' button is'; ...
    '    enabled.  Click it to reset the plots to their'; ...
    '    original limits.'; ...
    '6. The zoom mode can be disabled by selecting ''Off'''; ...
    '    from the ''Chart Tools/Zoom'' menu.'; ...
    ' '; ...
    'NOTE: If you choose to set the right boundary'; ...
    '           to the left of an existing left boundary,'; ...
    '           the zoom will AUTOMATICALLY reverse'; ...
    '           (exchange) them.'};

hzoomhlpdlg = helpdlg(zoomhlpmsg, ...
    'ChartFTS ZOOM Help');


%------------------------------------------------------------------------------
% Combine_Axes_On_Callback
%------------------------------------------------------------------------------
function combine_axes_on_cb(hcbo, eventdata, h)
% Callback for combine axes on menu option

% Set status flag for 'Combine Axes' to On.
setappdata(h.hfig, 'CombineAxesStatus', 'on');
set(h.hfig, 'Name', [getappdata(h.hfig, 'FigureNameBase'), ', Combine Axes ON']);

% Turn 'Zoom' off.
zoomStatus = getappdata(h.hfig, 'ZoomStatus');
if strcmpi(zoomStatus, 'on')
    zoom_menu_off_cb([], [], h);
    setappdata(h.hfig, 'ZoomStatus', 'on')
end

% Turn 'Combine Axes' on.
set(h.combinechkbox, 'Visible', 'on');
set(h.combinechkboxallframeborder,'Visible','on');
set(h.combineallchkbox,'Visible', 'on');
set(h.combinechkboxalltext, 'Visible', 'on');

% Set the uimenu options to reflect changes
set(h.hChartToolsMenu(7),  'Checked', 'on' );
set(h.hChartToolsMenu(8), 'Checked', 'off');


%------------------------------------------------------------------------------
% Combine_Axes_Off_Callback
%------------------------------------------------------------------------------
function combine_axes_off_cb(hcbo, eventdata, h, fts, numplot, fts3DT, timeData)
% Callback for combine axes off menu option

% Set status flag for 'Combine Axes' to Off.
setappdata(h.hfig, 'CombineAxesStatus', 'off');
set(h.hfig, 'Name', getappdata(h.hfig, 'FigureNameBase'));

% Restore state of 'Zoom'.
zoomStatus = getappdata(h.hfig, 'ZoomStatus');
if strcmpi(zoomStatus, 'on')
    zoom_menu_on_cb([], [], h, fts, numplot, fts3DT, timeData);
end

% Turn 'Combine Axes' Off.
set(h.combinechkbox,'Value', 0);    % Uncheck check boxes when 'off' is selected
set(h.combinechkbox, 'Visible', 'off');
set(h.combineallchkbox,'Value', 0);  % Uncheck check boxes when 'off' is selected
set(h.combineallchkbox,'Visible', 'off');
set(h.combinechkboxallframeborder,'Visible','off');
set(h.combinechkboxalltext, 'Visible', 'off');
set(h.combineplotbtn, 'Visible', 'off');

% Set the uimenu options to reflect changes
set(h.hChartToolsMenu(7),  'Checked', 'off');
set(h.hChartToolsMenu(8), 'Checked', 'on' );


%------------------------------------------------------------------------------
% Reset_Axes_Callback
%------------------------------------------------------------------------------
function reset_axes_cb(hcbo, eventdata, h, fts)
% Callback for reset axes menu option

% Replot
chartfts(fts);


%------------------------------------------------------------------------------
% Combine_Axes_Help_Callback
%------------------------------------------------------------------------------
function combine_axes_help_cb(hcbo, eventdata, h)
% Callback for combine azes help menu option

zoomhlpmsg = {'ChartFTS Combine Axes:'; ...
    ' '; ...
    'Combine multiple axes into one.'; ...
    ' '; ...
    '1. Click on ''Chart Tools'' in the menu bar.'; ...
    '    Select ''Combine Axes'' and then click'; ...
    '    on ''On''.'; ...
    '2. Check any checkboxes next to the'; ...
    '    axes that are to be combined. To select'; ...
    '    all the plots, check the ''Select all plots'''; ...
    '    checkbox.'; ...
    '3. Press the ''Combine Selected Graphs'''; ...
    '    button to combine the selected plots.'; ...
    '    The button will appear after two or'; ...
    '    more plots are selected.'; ...
    '4. To reset all the axes to their original state'; ...
    '    click on ''Chart Tools'', select ''Combine Axes'''; ...
    '    and click on ''Reset Axes'''; ...
    '5. Combine axes may be disabled from the'; ...
    '    ''Chart Tools/Combine Axes'' menu bar.'; ...
    ' '};

hzoomhlpdlg = helpdlg(zoomhlpmsg, ...
    'ChartFTS Combine Axes Help');


%------------------------------------------------------------------------------
% Chart_Tool_Help_Callback
%------------------------------------------------------------------------------
function chart_tool_help_cb(hcbo, eventdata, h)
% Callback for chart tool help menu option

zoomhlpmsg = {'Chart Tools:'; ...
    ''; ...
    'Zoom'; ...
    ''; ...
    '   Zoom/unzoom all plots simultaneously by'; ...
    '   selecting a starting date and an ending date.'; ...
    ''; ...
    'Combine Axes'; ...
    ''; ...
    '   Combine multiple axes into one.'; ...
    ''; ...
    'The status of each tool is displayed in the '; ...
    'figure title bar.  If the tools are off, no tool'; ...
    'status will be displayed in the figure''s title'; ...
    'bar.'; ...
    ''; ...
    'Please see each individual tool''s ''Help'''; ...
    'for more details.'};

hzoomhlpdlg = helpdlg(zoomhlpmsg, 'ChartFTS Chart Tool Help');


%------------------------------------------------------------------------------
% WindowButtonMotionFcn
%------------------------------------------------------------------------------
function windowbtnmotionfcn_cb(hcbo, eventdata, h, fts, timeData, fts3DT, numplot)
% Callback for chart tool help menu option

hl = findall(h.hfig, 'Tag', 'VerticalLines');

if isempty(hl)
    flag = 0;
else
    flag = 1;
end

currentAx = get(h.hfig, 'currentaxes');

acp = get(currentAx, 'CurrentPoint');
xlim = get(currentAx, 'XLim');

% Dont go out of bounds
if acp(1) < xlim(1)
    acp(:, 1) = xlim(1);
elseif acp(1) > xlim(2)
    acp(:, 1) = xlim(2);
end

axl = get(currentAx, 'XLim');
ayl = zeros(numplot, 2);

if flag == 0
    % Draw the line
    hl = zeros(1, numplot);

    % Draw the vertical line on all plots
    for pidx = 1:numplot
        ayl(pidx, :) = get(h.axes(pidx), 'YLim');
        hl(pidx) = line(acp(:, 1), ayl(pidx, :), 'Color', 'k', ...
            'parent', h.axes(pidx));
    end

    % Make it so the line redraws at each new location on the
    % graph
    set(hl, 'EraseMode', 'xor', 'Tag', 'VerticalLines');

    drawnow;
else
    % Update the text in the infomation boxes
    if (acp(1) > 0) & (acp(1) >= axl(1)) & (acp(1) <= axl(2))
        for pidx = 1:numplot
            ayl(pidx, :) = get(h.axes(pidx), 'YLim');
            set(hl(pidx), 'Xdata', acp(:, 1)', 'YData', ayl(pidx, :), ...
                'parent', h.axes(pidx));
        end

        % Find the correct date and time idx depending on existance of time info.
        if timeData
            dataidx = dtfind(acp(1), fts.data{3}, fts.data{5});
        else
            dataidx = datefind(round(acp(1)), fts.data{3});
        end

        if isempty(fts3DT(dataidx))
            date_info = '(none)';
        else
            date_info = datestr(fts3DT(dataidx));
            if timeData
                colLoc = strfind(date_info, ':');
                date_info = date_info(1:colLoc(2)-1);
            end
        end

        % Set the lower left text box string
        set(h.datetxt, 'String', {'Dates:', date_info});

        % Update the plot info text boxes at the bottom
        for iidx = 1:numplot
            if isempty(fts.data{4}(dataidx, iidx))
                data_info = [{[fts.names{iidx+3}, ':']}; ...
                    {'(none)'}];
            else
                data_info = [{[fts.names{iidx+3}, ':']}; ...
                    cellstr(num2str(fts.data{4}(dataidx, iidx)))];
            end
            set(h.infotxt(iidx), 'String', data_info);
        end

        drawnow;
    else
        delete(hl);
    end
end

%------------------------------------------------------------------------------
% WindowButtonDownFcn
%------------------------------------------------------------------------------
function windowbtndownfcn_cb(hcbo, eventdata, h, fts, fts3DT, timeData)
% Callback for creation of information popup box

currentAx = get(h.hfig, 'currentaxes');

acp = get(currentAx, 'CurrentPoint');
axl = get(currentAx, 'XLim');
fcp = get(h.hfig, 'CurrentPoint');

if acp(1) > 0 & acp(1) >= axl(1) & acp(1) <= axl(2)
    % Find the correct date and time idx depending on existance of time info.
    if timeData
        dataidx = dtfind(acp(1), fts.data{3}, fts.data{5});
    else
        dataidx = datefind(round(acp(1)), fts.data{3});
    end
    if isempty(fts3DT(dataidx))
        date_info = {'Date: (none)'};
    else
        date_info = {['Date: ', datestr(fts3DT(dataidx))]};
        if timeData
            date_info = char(date_info);
            colLoc = strfind(date_info, ':');
            date_info = date_info(1:colLoc(3)-1);
            date_info = cellstr(date_info);
        end
    end
    data_info = cell(fts.serscount, 1);
    for fidx = 1:fts.serscount
        sersname = fts.names{fidx+3};
        sersdata = fts.data{4}(dataidx, fidx);
        if isempty(sersdata)
            data_info{fidx} = [sersname, ': (none)'];
        else
            data_info{fidx} = [sersname, ': ', num2str(sersdata)];
        end
    end
    all_info = [date_info; data_info];

    % Create a make shift data information box
    hborder = uicontrol('parent', h.hfig, ...
        'Visible', 'on', ...
        'Style', 'text', ...
        'Position', [fcp(1)-1 fcp(2)-21 82 22], ...
        'Tag', 'InfoBorder', ...
        'backgroundcolor','k');
    htxt = uicontrol('parent', h.hfig, ...
        'Visible', 'off', ...
        'Style', 'text', ...
        'String', all_info, ...
        'HorizontalAlignment', 'left', ...
        'Position', [fcp(1) fcp(2)-20 80 20], ...
        'Tag', 'DataLabel', ...
        'backgroundcolor', h.colorScheme);
    htxt_extent = get(htxt, 'Extent');

    set(hborder, 'Position', [fcp(1)+14 fcp(2)-21-htxt_extent(4)/2 htxt_extent([3, 4])+2], ...
        'Visible', 'on');
    set(htxt, 'Position', [fcp(1)+15 fcp(2)-20-htxt_extent(4)/2 htxt_extent([3, 4])], ...
        'Visible',  'on');
end

drawnow;


%------------------------------------------------------------------------------
% WindowButtonUpFcn
%------------------------------------------------------------------------------
function windowbtnupfcn_cb(hcbo, eventdata, h)
% Callback for mouse button up fcn to erase the popup information box

% Delete the makeshift info boxes
hborder = findall(h.hfig, 'Tag', 'InfoBorder');
delete(hborder);

htxt = findall(h.hfig, 'Tag', 'DataLabel');
delete(htxt);


%------------------------------------------------------------------------------
% ZOOM_WindowButtonDownFcn_Callback
%------------------------------------------------------------------------------
function zoomwindowbtndownfcn_cb(hcbo, eventdata, h, fts, numplot)
% Callback for zoomed in window button down fcn

hl_left  = findall(h.hfig, 'Tag', 'LeftBlueLine');
hl_right = findall(h.hfig, 'Tag', 'RightRedLine');

ax1_appdata = getappdata(findall(h.axes, 'Tag', 'Axis1'), 'Axis1');

if ~isempty(hl_left) & ~isempty(hl_right)
    ax1_appdata = getappdata(findall(h.axes, 'Tag', 'Axis1'), 'Axis1');
    ax1_appdata.left  = [];
    ax1_appdata.right = [];

    setappdata(findall(h.axes, 'Tag', 'Axis1'), 'Axis1', ax1_appdata);
    delete(hl_left);
    delete(hl_right);

    set(h.zoomonbtn, 'Enable', 'off');
end

% Get the axes information
currentAx = get(h.hfig, 'currentaxes');
acp = get(currentAx, 'CurrentPoint');

% Update Zoom limit lines
if isempty(ax1_appdata.left) & isempty(ax1_appdata.right)
    ax1_appdata.left = acp(1, 1:2);

    hl_left = zeros(1, numplot);
    for pidx = 1:numplot
        ayl(pidx, :) = get(h.axes(pidx), 'YLim');
        hl_left(pidx) = line(acp(:, 1), ayl(pidx, :), ...
            'Color', [0 0 1], ...
            'Tag', 'LeftBlueLine', ...
            'parent', h.axes(pidx));
    end
elseif isempty(ax1_appdata.right)
    ax1_appdata.right = acp(1, 1:2);

    hl_right = zeros(1, numplot);
    for pidx = 1:numplot
        ayl(pidx, :) = get(h.axes(pidx), 'YLim');
        hl_right(pidx) = line(acp(:, 1), ayl(pidx, :), ...
            'Color', [1 0 0], ...
            'Tag', 'RightRedLine', ...
            'parent', h.axes(pidx));
    end
end

setappdata(findall(h.axes, 'Tag', 'Axis1'), 'Axis1', ax1_appdata);


%------------------------------------------------------------------------------
% ZOOM_WindowButtonMotionFcn_Callback
%------------------------------------------------------------------------------
function zoomwindowbtnmotionfcn_cb(hcbo, eventdata, h, fts, fts3DT, numplot, timeData)
% Callback for zoomed in window button motion fcn

hl = findall(h.hfig, 'Tag', 'VerticalLines');

if isempty(hl)
    flag = 0;
else
    flag = 1;
end

% Get the axes information
currentAx = get(h.hfig, 'currentaxes');
acp = get(currentAx, 'CurrentPoint');
xlim = get(currentAx, 'XLim');

if acp(1) < xlim(1)
    acp(:, 1) = xlim(1);
elseif acp(1) > xlim(2)
    acp(:, 1) = xlim(2);
end

axl = get(currentAx, 'XLim');
ayl = zeros(numplot, 2);

if flag == 0
    hl = zeros(1, numplot);
    for pidx = 1:numplot
        ayl(pidx, :) = get(h.axes(pidx), 'YLim');
        hl(pidx) = line(acp(:, 1), ayl(pidx, :), ...
            'Color', 'k', ...
            'parent', h.axes(pidx));
    end
    set(hl, 'EraseMode', 'xor', 'Tag', 'VerticalLines');

    drawnow;
else
    if acp(1) > 0 & acp(1) >= axl(1) & acp(1) <= axl(2)
        for pidx = 1:numplot
            ayl(pidx, :) = get(h.axes(pidx), 'YLim');
            set(hl(pidx), 'Xdata', acp(:, 1)','YData' , ayl(pidx, :), ...
                'parent', h.axes(pidx));
        end

        % Find the correct date and time idx depending on existance of time
        % info.
        if timeData
            dataidx = dtfind(acp(1), fts.data{3}, fts.data{5});
        else
            dataidx = datefind(round(acp(1)), fts.data{3});
        end

        if isempty(fts3DT(dataidx))
            date_info = '(none)';
        else
            date_info = datestr(fts3DT(dataidx));
            if timeData
                colLoc = strfind(date_info, ':');
                date_info = date_info(1:colLoc(2)-1);
            end
        end
        hdatetxt = findall(h.hfig, 'Tag', 'DateText');
        set(hdatetxt, 'String', {'Dates:', date_info});

        for iidx = 1:numplot
            hinfotxt = findall(h.hfig, 'Tag', ['InfoText', num2str(iidx)]);
            if isempty(fts.data{4}(dataidx, iidx))
                data_info = [{[fts.names{iidx+3}, ':']}; ...
                    {'(none)'}];
            else
                data_info = [{[fts.names{iidx+3}, ':']}; ...
                    cellstr(num2str(fts.data{4}(dataidx, iidx)))];
            end
            set(hinfotxt, 'String', data_info);
        end

        drawnow;
    else
        delete(hl);
    end
end


%------------------------------------------------------------------------------
% ZOOM_WindowButtonUpFcn_Callback
%------------------------------------------------------------------------------
function zoomwindowbtnupfcn_cb(hcbo, eventdata, h, fts)
% Callback for zoomed in window button up fcn

hl_left = findall(h.hfig, 'Tag', 'LeftBlueLine');
hl_right = findall(h.hfig, 'Tag', 'RightRedLine');

if ~isempty(hl_left) & ~isempty(hl_right)
    ZOOMLim = getappdata(findall(h.axes, 'Tag', 'Axis1'), 'Axis1');
    if ZOOMLim.left(1) > ZOOMLim.right(1)
        set(hl_left, 'Color', [1 0 0]);
        set(hl_right, 'Color', [0 0 1]);
        tmpZOOMLim    = ZOOMLim.left;
        ZOOMLim.left  = ZOOMLim.right;
        ZOOMLim.right = tmpZOOMLim;
        setappdata(findall(h.axes, 'Tag', 'Axis1'), 'Axis1', ZOOMLim);
    end

    set(h.zoomonbtn, 'Enable', 'on');
end


%------------------------------------------------------------------------------
% FINTS object manipulation and pre setup info
%------------------------------------------------------------------------------
function [fts, fts3DT, namelen, xyscale, ticklbls] = getfintsinfo(fts, timeData)
%GETFINTSINFO get information regarding time series object.

% Get the right dates and times depending on the kind of FINTS
if timeData
    % Create a new object only if time data exists. This new object will allow
    % for intraday data to be plotted correctly (gaps between data points when
    % the "market is closed"). This section of code can be removed to allow for
    % 24 hour trading (a continuous plot).
    if timeData
        % Determine number of unique days since intraday data will have
        % duplicate dates
        [y,m,d] = datevec(fts.data{3});

        [b,idx,j] = unique(datenum([y m d]));
        numUniq = length(idx);

        % Create the "space" between unique days by placing NaN's at time 00:01.
        newDates = datenum([y(idx), m(idx), d(idx)]);
        newTimes = ones(numUniq, 1) * 0.0009;
        newData = repmat(NaN, numUniq, fts.serscount);

        % Create new object by combining the dates, times, and data.
        combDates = [fts.data{3}; newDates];
        combTimes = [fts.data{5}; newTimes];
        combData = [fts.data{4}; newData];

        newObj = fints((combDates + combTimes), combData);

        % Fix the description (vertcat will add the || to the desc).
        newObj.data{1} = fts.data{1};

        % Fix the field names
        newObj.names = fts.names;

        % Rename the new object.
        fts = newObj;

        % Get the right dates and times
        fts3DT = fts.data{3} + fts.data{5};
    end
else
    fts3DT = fts.data{3};
end

namelen = length(fts.names);      % Number of elements in fts.names

% Scaling factor for labels
if namelen <= 5
    % If there is one plot only, scale labels.
    xyscale = 0.045;
    ticklbls = 0.05;
elseif namelen == 6
    % If there are multiple plots, scale labels.
    xyscale = 0.1;
    ticklbls = xyscale;
elseif namelen == 7
    xyscale = 0.15;
    ticklbls = 0.15;
else
    xyscale = 0.225;
    ticklbls = 0.23;
end

% Reorganize the names and data columns so that volume is last in the list.
isvolexist = getnameidx(lower(fts.names), 'volume');
if isvolexist
    fts.names = [fts.names(1:isvolexist-1), ...
        fts.names(isvolexist+1:end-1), ...
        fts.names(isvolexist), cellstr('times')];
    fts.data{4} = [fts.data{4}(:, 1:(isvolexist-3)-1), ...
        fts.data{4}(:, (isvolexist-3)+1:end), ...
        fts.data{4}(:, isvolexist-3)];
end


%------------------------------------------------------------------------------
% Create subplots
%------------------------------------------------------------------------------
function [h, numplot, errMsg] = setsubplot(h, fts, ftsName, namelen, fts3DT, ...
    xyscale, spacing, plotArea, topMargin, leftMargin, width, timeData)
% SETSUBPLOT creates the individual plots in CHARTFTS

% Default
errMsg = 0;

% Setup screen/figure for multiple plots.
numplot = fts.serscount;

% Handles to axes
h.axes = zeros(1, numplot);

% Handles to plots
h.plots = h.axes;
multAxCounter = 0;

% Create the plots
for pidx = 1:numplot
    % Create a generic axes to store each plot.
    % The final position will be specified later.
    h.axes(pidx) = axes('position', [.1 .5 .5 .5], ...
        'visible', 'off', ...
        'box', 'on', ...
        'parent', h.hfig);

    % Plot data
    if strcmpi(fts.names{pidx+3}, 'volume')
        % Plot volume data if it exists
        h.plots(pidx) = bar(h.axes(pidx), fts3DT, fts.data{4}(:, pidx), 'b');
        set(h.plots(pidx), 'visible', 'on');

        % Set data to UserData
        set(h.plots(pidx), 'Tag', 'FilledPatch', 'UserData', pidx);

        % Set ylabel on volume plot
        h.ylabel(pidx) = ylabel(fts.names{pidx+3}, 'Color', 'k', ...
            'tag', 'ylabel', ...
            'FontUnits', 'normal', ...
            'FontSize', xyscale, ...
            'Interpreter', 'none', ...
            'parent', h.axes(pidx));

        % Create context menu
        h = createcontmenu(h, pidx, fts);
    else
        % Plot everything except volume data and set data to UserData
        h.plots(pidx) = line(fts3DT, fts.data{4}(:, pidx), ...
            'color', 'magenta', ...
            'parent', h.axes(pidx), ...
            'Tag', 'LinePlot', ...
            'UserData', pidx, ...
            'visible', 'on');

        % Format long field names
        if (length(fts.names{pidx+3}) > 16)
            % Long Name(>16 char)
            newName = [fts.names{pidx+3}(1:8) '...'];
            h = createylabel(fts, h, pidx, newName, xyscale);
        elseif (length(fts.names{pidx+3}) > 8) & (get(gca,'ytick') >= 1000)
            % If ytick>1000: add '...' to name
            newName = [fts.names{pidx+3}(1:8) '...'];
            h = createylabel(fts, h, pidx, newName, xyscale);
        elseif length(fts.names{pidx+3}) > 8
            % Check length of ylabels; put on two lines if needed
            newName = [fts.names{pidx+3}(1:8) '\n' fts.names{pidx+3}(9:end)];
            h = createylabel(fts, h, pidx, newName, xyscale);
        else
            % Place ylabel on rest of plots
            h.ylabel(pidx) = ylabel(fts.names{pidx+3}, ...
                'Color', 'k', ...
                'tag', 'ylabel', ...
                'FontUnits', 'normal', ...
                'FontSize', xyscale, ...
                'Interpreter', 'none', ...
                'parent', h.axes(pidx));
        end

        % Create context menu
        h = createcontmenu(h, pidx, fts);
    end

    % Add title when first axis is generated.
    if pidx == 1
        h.title = title(ftsName, ...
            'Color', 'k', ...
            'FontSize', 0.49, ...
            'Tag', 'ChartFTSTitle', 'FontWeight', 'bold');
    end

    set(h.axes(pidx), 'Tag', ['Axis', num2str(pidx)]);

    % Position single axis or create a "flag" for multiple axes.
    if namelen <= 4
        set(h.axes(pidx), 'Position', [leftMargin 0.25 width 0.67]);
    else
        multAxCounter = multAxCounter + 1;
    end

    % Position first axes and calculate some stats, then position rest.
    if multAxCounter == 1
        % Total 'plottable' area not including area between subplots
        totalSpace = (plotArea - ((numplot-1)*spacing));

        % Figure height
        figHeight = totalSpace/numplot;

        % Check to make sure there arent too many plots.
        if totalSpace <= 0
            errMsg = 1;
            return
        end

        set(h.axes(pidx), 'Position', [leftMargin (1-(figHeight + topMargin)) width figHeight], ...
            'visible', 'on');
    elseif pidx ~= 1
        pa_pos = get(h.axes(pidx-1), 'Position');
        set(h.axes(pidx), 'Position', [leftMargin (pa_pos(2)-(spacing + figHeight)) width figHeight], ...
            'visible', 'on');
    end

    grid on

    % Add x axis tick marks on last plot
    relabel(h.axes(pidx), fts3DT, timeData);

    % Clear all XTickLabels on axes except the bottom/last axis.
    if pidx ~= numplot
        set(h.axes(pidx), 'XTickLabel', '');
    end
end

% Turn everything on
set([h.plots h.axes], 'visible', 'on');


%------------------------------------------------------------------------------
% Ylabel Setup function
%------------------------------------------------------------------------------
function h = createylabel(fts, h, pidx, newName, xyscale)
%CREATEYLABEL sets up all the plot properties for Ylabels.

h.ylabel(pidx) = ylabel(sprintf(newName), ...
    'Color', 'k', ...
    'tag', 'ylabel', ...
    'FontUnits', 'normal', ...
    'FontSize', xyscale, ...
    'units','normal', ...
    'Interpreter','none', ...
    'parent', h.axes(pidx));
set(h.ylabel(pidx), 'position', [-.105, .5, .5]);


%------------------------------------------------------------------------------
% Context Menu Creation function
%------------------------------------------------------------------------------
function h = createcontmenu(h, pidx, fts)
%CREATECONTMENU creates a context menu for the Ylabels for every plot.
%   It displays the string for Ylabels in full length.

h.hContMenuV(pidx) = uicontextmenu('parent', h.hfig);
set(h.ylabel(pidx), 'uicontextmenu', h.hContMenuV(pidx));
h.hUiContMenuName(pidx) = uimenu('parent', h.hContMenuV(pidx), ...
    'label', fts.names{pidx+3});


% [EOF]
