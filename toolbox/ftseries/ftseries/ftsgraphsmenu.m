function varargout = ftsgraphsmenu(varargin)
%FTSGRAPHSMENU The Graphs menu item of FTS GUI.
%
%   FTSGRAPHSMENU generates the Graphs menu item of the
%   financial time series GUI, ftsgui.  Please start the GUI 
%   from the MATLAB command line using
%
%      ftsgui
%
%   See also FTSGUI.
%

%
%   NOTE: Need to be called from ftsgui.m.
%

%   Author: P. N. Secakusuma, 01-10-2000
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $   $Date: 2004/04/06 01:09:25 $

% Find main FTSGUI figure
mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
    'Tag', 'FTSGUIMainWindow');

switch nargin,
    case 0,
        MenuItems = {'&Graphs'                  , ''                , 'graphsMenuItem'        ;
            '>&Line Plot'              , 'ftsgraphsmenu(1)', 'graphsPlotMenuItem'    ;
            '>&Bar Chart'              , 'ftsgraphsmenu(2)', 'graphsBarMenuItem'     ;
            '>&Horizontal Bar Chart'   , 'ftsgraphsmenu(3)', 'graphsBarHMenuItem'    ;
            '>&3D Bar Chart'           , 'ftsgraphsmenu(4)', 'graphsBar3MenuItem'    ;
            '>H&orizontal 3D Bar Chart', 'ftsgraphsmenu(5)', 'graphsBar3HMenuItem'   ;
            '>&Candle Plot'            , 'ftsgraphsmenu(6)', 'graphsCandleMenuItem'  ;
            '>&High-Low Plot'          , 'ftsgraphsmenu(7)', 'graphsHighLowMenuItem' ;
            '>-----'                   , ''                , ''                      ;
            '>&Interactive Chart'      , 'ftsgraphsmenu(8)', 'graphsChartFTSMenuItem'};
        hGraphsMenuItems = makemenu(mainFTSGUIWindow, str2mat(MenuItems{:, 1}), str2mat(MenuItems{:, 2}), str2mat(MenuItems{:, 3}));

        varargout{1} = hGraphsMenuItems;

    case 1,
        switch varargin{1},
            case 1,   % Line plot
                [MAT_data, data_names, data_info] = getftsguidata;
                infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');
                if isempty(infostorage.activefts),
                    errordlg('No data loaded or no active FTS is selected.', 'No Active FTS');
                    return
                else,
                    fts_idx = find(strcmp(infostorage.activefts, infostorage.itemnames));

                    hpfig = figure('NumberTitle', 'off', ...
                        'Name', ['Line Plot: ', deblank(MAT_data{fts_idx}.desc)], ...
                        'Units', 'normal', ...
                        'Position', [0.0375+(fts_idx)*0.02 0.475-(fts_idx-1)*0.02 0.3 0.3], ...
                        'Visible', 'off', ...
                        'Tag', ['LinePlot_', data_names{fts_idx}]);
                    hobj = plot(MAT_data{fts_idx});
                    set(hpfig, 'Visible', 'on');
                end
                set(hpfig, 'CloseRequestFcn', 'ftsgraphsmenu([], 1)');
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag', 'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', [hChildrenFigs, hpfig]);

                updateftsguistatus(1, ['Line Plot: ', deblank(MAT_data{fts_idx}.desc)]);
                drawnow;

            case 2,   % Bar chart
                [MAT_data, data_names, data_info] = getftsguidata;
                infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');
                if isempty(infostorage.activefts),
                    errordlg('No data loaded or no active FTS is selected.', 'Active FTS');
                    return
                else,
                    fts_idx = find(strcmp(infostorage.activefts, infostorage.itemnames));

                    hpfig = figure('NumberTitle', 'off', ...
                        'Name', ['Bar Chart: ', deblank(MAT_data{fts_idx}.desc)], ...
                        'Units', 'normal', ...
                        'Position', [0.0375+(fts_idx)*0.02 0.475-(fts_idx-1)*0.02 0.3 0.3], ...
                        'Visible', 'off', ...
                        'Tag', ['BarPlot_', data_names{fts_idx}]);
                    hobj = bar(MAT_data{fts_idx});
                    set(hpfig, 'Visible', 'on');
                end
                set(hpfig, 'CloseRequestFcn', 'ftsgraphsmenu([], 1)');
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag', 'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', [hChildrenFigs, hpfig]);

                updateftsguistatus(1, ['Bar Chart: ', deblank(MAT_data{fts_idx}.desc)]);
                drawnow;

            case 3,   % Horizontal Bar Chart
                [MAT_data, data_names, data_info] = getftsguidata;
                infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');
                if isempty(infostorage.activefts),
                    errordlg('No data loaded or no active FTS is selected.', 'Active FTS');
                    return
                else,
                    fts_idx = find(strcmp(infostorage.activefts, infostorage.itemnames));

                    hpfig = figure('NumberTitle', 'off', ...
                        'Name', ['Horizontal Bar Chart: ', deblank(MAT_data{fts_idx}.desc)], ...
                        'Units', 'normal', ...
                        'Position', [0.0375+(fts_idx)*0.02 0.475-(fts_idx-1)*0.02 0.3 0.3], ...
                        'Visible', 'off', ...
                        'Tag', ['BarHPlot_', data_names{fts_idx}]);
                    hobj = barh(MAT_data{fts_idx});
                    set(hpfig, 'Visible', 'on');
                end
                set(hpfig, 'CloseRequestFcn', 'ftsgraphsmenu([], 1)');
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag', 'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', [hChildrenFigs, hpfig]);

                updateftsguistatus(1, ['Horz. Bar Chart: ', deblank(MAT_data{fts_idx}.desc)]);
                drawnow;

            case 4,   % 3D Bar chart
                [MAT_data, data_names, data_info] = getftsguidata;
                infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');
                if isempty(infostorage.activefts),
                    errordlg('No data loaded or no active FTS is selected.', 'Active FTS');
                    return
                else,
                    fts_idx = find(strcmp(infostorage.activefts, infostorage.itemnames));

                    hpfig = figure('NumberTitle', 'off', ...
                        'Name', ['3D Bar Chart: ', deblank(MAT_data{fts_idx}.desc)], ...
                        'Units', 'normal', ...
                        'Position', [0.0375+(fts_idx)*0.02 0.475-(fts_idx-1)*0.02 0.3 0.3], ...
                        'Visible', 'off', ...
                        'Tag', ['Bar3DPlot_', data_names{fts_idx}]);
                    hobj = bar3(MAT_data{fts_idx});
                    set(hpfig, 'Visible', 'on');
                end
                set(hpfig, 'CloseRequestFcn', 'ftsgraphsmenu([], 1)');
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag', 'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', [hChildrenFigs, hpfig]);

                updateftsguistatus(1, ['3D Bar Chart: ', deblank(MAT_data{fts_idx}.desc)]);
                drawnow;

            case 5,   % Horizontal 3D Bar Chart
                [MAT_data, data_names, data_info] = getftsguidata;
                infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');
                if isempty(infostorage.activefts),
                    errordlg('No data loaded or no active FTS is selected.', 'Active FTS');
                    return
                else,
                    fts_idx = find(strcmp(infostorage.activefts, infostorage.itemnames));

                    hpfig = figure('NumberTitle', 'off', ...
                        'Name', ['horizontal 3D Bar Chart: ', deblank(MAT_data{fts_idx}.desc)], ...
                        'Units', 'normal', ...
                        'Position', [0.0375+(fts_idx)*0.02 0.475-(fts_idx-1)*0.02 0.3 0.3], ...
                        'Visible', 'off', ...
                        'Tag', ['Bar3HPlot_', data_names{fts_idx}]);
                    hobj = bar3h(MAT_data{fts_idx});
                    set(hpfig, 'Visible', 'on');
                end
                set(hpfig, 'CloseRequestFcn', 'ftsgraphsmenu([], 1)');
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag', 'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', [hChildrenFigs, hpfig]);

                updateftsguistatus(1, ['Horz. 3D Bar Chart: ', deblank(MAT_data{fts_idx}.desc)]);
                drawnow;

            case 6,   % Candle plot
                [MAT_data, data_names, data_info] = getftsguidata;
                infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');
                if isempty(infostorage.activefts),
                    errordlg('No data loaded or no active FTS is selected.', 'Active FTS');
                    return
                else,
                    fts_idx = find(strcmp(infostorage.activefts, infostorage.itemnames));

                    hpfig = figure('NumberTitle', 'off', ...
                        'Name', ['Candle Plot: ', deblank(MAT_data{fts_idx}.desc)], ...
                        'Units', 'normal', ...
                        'Position', [0.0375+(fts_idx)*0.02 0.475-(fts_idx-1)*0.02 0.3 0.3], ...
                        'Visible', 'off', ...
                        'Tag', ['CandlePlot_', data_names{fts_idx}]);
                    hobj = candle(MAT_data{fts_idx});
                    set(hpfig, 'Visible', 'on');
                end
                set(hpfig, 'CloseRequestFcn', 'ftsgraphsmenu([], 1)');
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag', 'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', [hChildrenFigs, hpfig]);

                updateftsguistatus(1, ['Candle Plot: ', deblank(MAT_data{fts_idx}.desc)]);
                drawnow;

            case 7,   % High-Low plot
                [MAT_data, data_names, data_info] = getftsguidata;
                infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');
                if isempty(infostorage.activefts),
                    errordlg('No data loaded or no active FTS is selected.', 'Active FTS');
                    return
                else,
                    fts_idx = find(strcmp(infostorage.activefts, infostorage.itemnames));

                    hpfig = figure('NumberTitle', 'off', ...
                        'Name', ['HighLow Plot: ', deblank(MAT_data{fts_idx}.desc)], ...
                        'Units', 'normal', ...
                        'Position', [0.0375+(fts_idx)*0.02 0.475-(fts_idx-1)*0.02 0.3 0.3], ...
                        'Visible', 'off', ...
                        'Tag', ['HiLoPlot_', data_names{fts_idx}]);
                    hobj = highlow(MAT_data{fts_idx});
                    set(hpfig, 'Visible', 'on');
                end
                set(hpfig, 'CloseRequestFcn', 'ftsgraphsmenu([], 1)');
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag', 'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', [hChildrenFigs, hpfig]);

                updateftsguistatus(1, ['High-Low Plot: ', deblank(MAT_data{fts_idx}.desc)]);
                drawnow;

            case 8,   % Interactive Chart, CHARTFTS
                [MAT_data, data_names, data_info] = getftsguidata;
                infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');
                if isempty(infostorage.activefts),
                    errordlg('No data loaded or no active FTS is selected.', 'Active FTS');
                    return
                else,
                    fts_idx = strcmp(infostorage.activefts, infostorage.itemnames);
                    [hax, hpfig] = chartfts(MAT_data{fts_idx});
                end
                set(hpfig, 'CloseRequestFcn', 'ftsgraphsmenu([], 1)');
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag', 'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', [hChildrenFigs, hpfig]);

            otherwise,
                error('Valid flags are 1 thru 5.  Thank you...');

        end   % End of SWITCH VARARGIN{1} block.

    case 2,
        switch varargin{2},
            case 1,   % Callback for Plot Figure's CloseRequestFcn.
                mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
                    'Tag',  'FTSGUIMainWindow');
                hChildrenFigs = getappdata(mainFTSGUIWindow, 'ChildrenFigures');
                hCurrentFigs = find(hChildrenFigs ~= gcf);
                setappdata(mainFTSGUIWindow, 'ChildrenFigures', hChildrenFigs(hCurrentFigs));
                closereq;
        end

end   % End of SWITCH NARGIN block.

return
