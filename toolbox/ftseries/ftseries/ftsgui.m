function ftsgui
%FTSGUI Financial Time Series Graphical User Interface.
%

%   Author: P. N. Secakusuma, 01-10-2000
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.6.2.3 $   $Date: 2004/04/06 01:09:26 $

% Check existence of prior FTSGUI.
hfig = findall(0, 'Type', 'figure', 'Tag' , 'FTSGUIMainWindow');
if isempty(hfig),
    % Setup the main figure window settings.
    % Figure will be invisible until all components are setup.
    figbgcolor = get(0, 'DefaultUIControlBackgroundColor');
    hfig = figure('MenuBar', 'none', ...
        'NumberTitle', 'off', ...
        'Units', 'normal', ...
        'Position', [0.05 0.80 0.50 0.10], ...
        'Name', 'Financial Time Series GUI', ...
        'CloseRequestFcn', 'ftsfilemenu(9);', ...
        'UserData', 1, ...
        'Resize', 'off', ...
        'Visible', 'off', ...
        'HandleVisibility', 'off', ...
        'color', figbgcolor, ...
        'Tag', 'FTSGUIMainWindow');
    setappdata(hfig, 'MainFigureName', get(hfig, 'Name'));

    % Setup a structure in FTS_Data of Main Figure Window to store FTS data.
    infostorage.itemcount = 0;
    infostorage.itemnames = [];
    infostorage.itemdesc  = [];
    infostorage.items     = [];
    infostorage.itemtypes = [];
    infostorage.activefts = [];
    infostorage.activefig = [];
    setappdata(hfig, 'FTS_Data', infostorage);

    % Initiate Figure Window Handles collection.
    setappdata(hfig, 'ChildrenFigures', []);

    % Setup the FILE menu item.
    hFileMenu = ftsfilemenu;

    % Setup the DATA menu item.
    hDataMenu = ftsdatamenu;

    % Setup the ANALYSIS menu item.
    hAnalysisMenu = ftsanalysismenu;

    % Setup the GRAPHS menu item.
    hGraphsMenu = ftsgraphsmenu;

    % Setup the WINDOW menu item.
    hWindowMenu = ftswindowmenu;

    % Setup the HELP menu item.
    hHelpMenu = ftshelpmenu;

    % Setup the status list.
    hStatusList = uicontrol('parent', hfig, 'Style', 'listbox', ...
        'Units', 'normal', ...
        'Enable', 'on', ...
        'Max', 2, ...
        'Value', [], ...
        'String', 'Started: Main FTS GUI Window', ...
        'Position', [0 0.15 1 0.85], ...
        'Tag', 'ftsguiStatusList');

    % Turn the main FTS GUI on to make it visible.
    set(hfig, 'Visible', 'on');

end

return
