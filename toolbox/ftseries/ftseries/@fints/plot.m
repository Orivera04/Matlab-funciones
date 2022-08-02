function varargout = plot(varargin)
%PLOT   Overloaded for FINTS object: plots data series.
%
%   PLOT(FTS) plots the data series contained in the object FTS.  Each
%   data series will be a line.  It uses the default color order as if
%   plotting a matrix.  It automatically generates a legend as well as
%   dates on the X-axis.  Grid is turned on by default.
%
%   PLOT(FTS, LINEFMT) plots the data series in the object FTS using
%   format specified by LINEFMT instead of the default linetype.  For
%   a list of possible line format LINEFMT, please look at the help
%   entry for the MATLAB PLOT function.
%
%   NOTE: When you specify LINEFMT, the format will be applied to all
%         data series; that is, all data series will have the same
%         line type.
%
%   PLOT(FTS, LINEFMT, VOLSERNAME) is the same as above except for the
%   ability to specify which data series is the volume via VOLSERNAME.
%   The VOLSERNAME must be the exact data series name for the volume column.
%   The volume will be plotted in a subplot below the other data series.
%   Please note that the VOLSERNAME is case sensitive.
%
%   PLOT(FTS, LINEFMT, VOLSERNAME, BAR) is the same as above except for
%   the ability to plot the volume as a Bar Chart.  BAR can be either
%   0 (default) or 1.  If BAR is 0, the volume will be plotted as a line.
%   If BAR is 1, the volume will be a Bar Chart.  The width of each bar
%   is the same as the default in BAR (see 'help bar').
%
%   HP = PLOT(FTS), HP = PLOT(FTS, LINEFMT),
%   HP = PLOT(FTS, LINEFMT, VOLSERNAME), and
%   HP = PLOT(FTS, LINEFMT, VOLSERNAME, BAR) are similar to their
%   counterparts above except that the handle(s) to the object(s) inside
%   can be retrieved.  If there are multiple lines in the plot, handles
%   for each line will be retuned.  If the BAR option is chosen, the
%   handle to the patch for the bars with also be returned.
%
%   If you have a legend and want to turn it off, issue the following
%   command at the MATLAB prompt:
%
%      legend off
%
%   However, once you turned it off, it is essentially deleted; so,
%   to turn it back on, you have to recreate it using the LEGEND
%   command as if you are creating it for the very first time.  If
%   you want to have more control over the legend, use the LEGEND
%   command manually.
%
%   To turn the grid off, issue:
%
%      grid off
%
%   and, to turn it back on, issue:
%
%      grid on
%
%   For more info on the GRID command, refer its help entry.
%
%   See also FINTS/CHARTFTS.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.16.2.5 $   $Date: 2004/04/06 01:08:26 $

hp  = [];
hph = [];

warnstat = warning;
warning('off');

ftsa = varargin{1};

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Determine if there is time data and then create a data matrix
if timeData
    ftsa_dates = ftsa.data{3} + ftsa.data{5};
else
    ftsa_dates = ftsa.data{3};
end
ftsa_data  = fts2mtx(ftsa);

% Check for NaNs in the data set and remove them temporarily to calculate
% the "dec_scale"
theNans = [];
for idx = 1:size(ftsa_data,2)
    check4NaN =  isnan(ftsa_data(:,idx));
    check4NaNIdx = find(check4NaN); 
    theNans = [theNans; check4NaNIdx];
    theNans = unique(theNans);
    allIdx = 1:size(ftsa_data, 1);
    nonNans = setdiff(allIdx',theNans);
    if isempty(nonNans)
        nonNans = allIdx;
    end
end

% Determine if subplots are needed
if ftsa.datacount ~= 1
    dec_scale = floor(mean(log10(ftsa_data(nonNans',:)), 1));
else
    dec_scale = ones(1,size(ftsa,2));
end

% Create a new object only if time data exists. This new object will allow
% for intraday data to be plotted correctly (gaps between data points when
% the "market is closed"). This section of code can be removed to allow for
% 24 hour trading (a continuous plot).
if timeData
    % Determine number of unique days
    [y,m,d] = datevec(ftsa.data{3});
    
    [b,idx,j] = unique(d);
    numUniq = length(idx);
    
    % Create the "space" between unique days by placing NaN's at time 00:01.
    newDates = datenum([y(idx),m(idx),d(idx)]);
    newTimes = ones(numUniq,1) * 0.0009;
    newData = ones(numUniq, ftsa.serscount) * NaN;
   
    % Create new object by combining the dates,times, and data.
    combDates = [ftsa.data{3}; newDates];
    combTimes = [ftsa.data{5}; newTimes];
    combData = [ftsa.data{4}; newData];
    
    newObj = fints((combDates + combTimes), combData);
    
    % Fix the description (vertcat will add the || to the desc).
    newObj.data{1} = ftsa.data{1};
            
    % Fix the field names
    newObj.names = ftsa.names;
    
    % Rename the new object.
    ftsa = newObj;
    
    % Create a data matrix, again.
    ftsa_dates = ftsa.data{3} + ftsa.data{5};
    ftsa_data  = fts2mtx(ftsa);
end

switch nargin
case 1
    if any(dec_scale <= 4) & any(dec_scale > 4)
        hsub1 = subplot(2, 1, 1);
        try
            hp = plot(ftsa_dates, ftsa_data(:, (dec_scale<=4)));
        catch
            rethrow(lasterror);
        end
        legend(ftsa.names{4+(find(dec_scale<=4)-1)});
        grid on;
        
        % Add x axis tick marks
        relabel(gca,ftsa_dates,timeData);
        
        set(hsub1, 'XTickLabel', '', ...
            'CreateFcn', ['hbp = findobj(gcf, ''Tag'',''BottomPlot'');', ...
                'disp(''There is a BOTTOMPLOT...'')', ...
                ''], ...
            'Tag', 'TopPlot');
        
        hsub2 = subplot(2, 1, 2);
        try
            hph = plot(ftsa_dates, ftsa_data(:, (dec_scale>4)));
        catch
            rethrow(lasterror);
        end
        set(hsub2, 'YAxisLocation', 'right', ...
            'Position', [0.130 0.110 0.775 0.250], ...
            'Tag', 'BottomPlot');
        legend(ftsa.names{4+(find(dec_scale>4)-1)});
        grid on;
        
        % Add x axis tick marks
        relabel(gca,ftsa_dates,timeData);
        
        set(hsub1, 'Position', [0.130 0.360 0.775 0.565]);
        
        % Add listener for ZOOM event.
        hAllPlots = handle([hsub1, hsub2]);
        hL        = handle.listener(hAllPlots, ...
            hAllPlots(1).findprop('XLim'), ...
            'PropertyPostSet', {@updateaxes, hAllPlots});
        setappdata(get(hsub1, 'Parent'), 'SubPlotXLimListener', hL);
        
        % Make top plot current
        set(gcf, 'currentaxes', hsub1);
    else
        if any(dec_scale > 4)
            ftsa_plotdata = ftsa_data(:, (dec_scale>4));
            plot_legend = ftsa.names(4+(find(dec_scale>4)-1));
        elseif any(dec_scale <= 4)
            ftsa_plotdata = ftsa_data(:, (dec_scale<=4));
            plot_legend = ftsa.names(4+(find(dec_scale<=4)-1));
        else
            ftsa_plotdata = ftsa_data(:, :);
            plot_legend = ftsa.names(4:end-1);
        end		
        
        try
            hp = plot(ftsa_dates, ftsa_plotdata);
        catch
            rethrow(lasterror);
        end
        hsub = get(hp, 'Parent');
        legend(plot_legend);
        grid on;
        
        % Add x axis tick marks
        relabel(gca,ftsa_dates,timeData);
    end	
case 2
    if ~ischar(varargin{2})
        error('Ftseries:fints_plot:LINEFMTMustBeStr', ...
            'LINEFMT must be string.  Look at HELP PLOT for possible ones.');
    end
    linefmt = varargin{2};
    
    if any(dec_scale <= 4) & any(dec_scale > 4)
        hsub1 = subplot(2, 1, 1);
        try
            hp = plot(ftsa_dates, ftsa_data(:, (dec_scale<=4)), linefmt);
        catch
            rethrow(lasterror);
        end
        legend(ftsa.names{4+(find(dec_scale<=4)-1)});
        grid on;
        
        % Add x axis tick marks
        relabel(gca,ftsa_dates,timeData);
        set(hsub1, 'XTickLabel', '');
        
        hsub2 = subplot(2, 1, 2);
        try
            hph = plot(ftsa_dates, ftsa_data(:, (dec_scale>4)), linefmt);
        catch
            rethrow(lasterror);
        end
        set(hsub2, 'YAxisLocation', 'right', ...
            'Position', [0.130 0.110 0.775 0.250]);
        legend(ftsa.names{4+(find(dec_scale>4)-1)});
        grid on;
        
        % Add x axis tick marks
        relabel(gca,ftsa_dates,timeData);
        
        set(hsub1, 'Position', [0.130 0.360 0.775 0.565]);
        
        % Add listener for ZOOM event.
        hAllPlots = handle([hsub1, hsub2]);
        hL        = handle.listener(hAllPlots, ...
            hAllPlots(1).findprop('XLim'), ...
            'PropertyPostSet', {@updateaxes, hAllPlots});
        setappdata(get(hsub1, 'Parent'), 'SubPlotXLimListener', hL);
        
        % Make top plot current
        set(gcf, 'currentaxes', hsub1);
    else
        if any(dec_scale > 4)
            ftsa_plotdata = ftsa_data(:, (dec_scale>4));
            plot_legend = ftsa.names(4+(find(dec_scale>4)-1));
        elseif any(dec_scale <= 4)
            ftsa_plotdata = ftsa_data(:, (dec_scale<=4));
            plot_legend = ftsa.names(4+(find(dec_scale<=4)-1));
        else
            ftsa_plotdata = ftsa_data(:, :);
            plot_legend = ftsa.names(4:end-1);
        end	
        
        try
            hp = plot(ftsa_dates, ftsa_plotdata, linefmt);
        catch
            rethrow(lasterror);
        end
        hsub = get(hp, 'Parent');
        legend(plot_legend);
        grid on;
        
        % Add x axis tick marks
        relabel(gca,ftsa_dates,timeData);
    end
case {3, 4}
    % Default
    barChart = 0;
    
    % Varargin{2}
    linefmt = varargin{2};
    if isnumeric(linefmt) & isempty(linefmt)
        linefmt =  '-';
    elseif ~ischar(varargin{2})
        error('Ftseries:fints_plot:LINEFMTMustBeStr', ...
            'LINEFMT must be string.  Please see ''help plot'' for possible line formats.');
    end
    if strcmp(linefmt,'') | strcmp(linefmt,' ')
        linefmt = '-';
    end
    
    % Varargin{3}
    volName = varargin{3};
    if ~ischar(volName)
        error('Ftseries:fints_plot:VolSerNameMustBeStr', ...
            'The volume series name must be a string.');
    elseif size(volName,1) > 1
        error('Ftseries:fints_plot:VolSerNameMustBeASingleStr', ...
            'The volume series name must be a single string.');
    elseif strcmp(volName,'times') | strcmp(volName,'dates')
        error('Ftseries:fints_plot:DatesAndTimesCannotBePlottedAsVolume', ...
            '''dates'' and ''times'' cannot be plotted as the volume.');
    end
    
    % Varargin{4}
    if nargin == 4
        barChart = varargin{4};
        
        % Check the input
        if (~isnumeric(barChart)) | (barChart < 0) | (barChart > 1) | (mod(barChart,1) ~= 0)
            error('Ftseries:fints_plot:IncorrectBarInput', ...
                'BAR can only be 0 (Line Plot) or 1 (Bar Chart).');
        end
    end
    
    volCol = getnameidx(ftsa.names,volName) - 3;
    
    if volCol <= 0
        error(sprintf(['''',volName, ''' is not a correct data series name.']));
    end
    
    nonVolData = ftsa_data(:,setdiff(1:size(ftsa_data,2),volCol));
    VolData = ftsa_data(:,volCol);
    
    % Get series names
    if timeData
        names = ftsa.names(4:end-1);
        names = names(setdiff(1:size(ftsa_data,2),volCol));
    else
        names = ftsa.names(4:end);
        names = names(setdiff(1:size(ftsa_data,2),volCol));
    end
    
    hsub1 = subplot(2, 1, 1);
    try
        hp = plot(ftsa_dates, nonVolData, linefmt);
    catch
        rethrow(lasterror);
    end
    legend(names);
    grid on;
    
    % Add x axis tick marks
    relabel(gca,ftsa_dates,timeData);
    set(hsub1, 'XTickLabel', '');
    
    hsub2 = subplot(2, 1, 2);
    if barChart
        hph = bar(ftsa_dates, VolData);
    else
        try
            hph = plot(ftsa_dates, VolData, linefmt);
        catch
            rethrow(lasterror);
        end
    end
    set(hsub2, 'YAxisLocation', 'right', ...
        'Position', [0.130 0.110 0.775 0.250]);
    legend(volName);
    grid on;
    
    % Add x axis tick marks
    relabel(gca,ftsa_dates,timeData);
    
    set(hsub1, 'Position', [0.130 0.360 0.775 0.565]);
    
    % Add listener for ZOOM event.
    hAllPlots = handle([hsub1, hsub2]);
    hL        = handle.listener(hAllPlots, ...
        hAllPlots(1).findprop('XLim'), ...
        'PropertyPostSet', {@updateaxes, hAllPlots});
    setappdata(get(hsub1, 'Parent'), 'SubPlotXLimListener', hL);
otherwise
    error('Ftseries:fints_plot:InvalidNumInputs', ...
        'Invalid number of inputs');
end

% Turn the interpreter off
interpre = findobj(gcf,'type','text');
set(interpre,'interpreter','none');

% Return handles requested
if nargout
    hp = [hp; hph];
    varargout = {hp};
end

% Set warning status back.
warning(warnstat);

% [EOF]
