function hlines = plot(varargin)
%PLOT Plot the parameters on X-Y plane.
%   HLINES = PLOT(H, PARAMETER) plots the specified parameter on X-Y plane
%   in the default format. The first input H is the handle to the data
%   object, and the second input PARAMETER is the parameter to be
%   visualized.
%
%   HLINES = PLOT(H, PARAMETER, FORMAT) plots the PARAMETER on X-Y plane in
%   the specified FORMAT.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified parameter. The first listed format is the default format for
%   the specified parameter.
%
%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN) plots the parameters
%   PARAMETER1, ..., PARAMETERN on X-Y plane using the default format. All
%   the parameters must have same default format.

%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN, FORMAT) plots the
%   parameters PARAMETER1, ..., PARAMETERN on X-Y plane using the specified
%   FORMAT. FORMAT must be a valid format for all the parameters.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   Type LISTPARAM(H) to see the valid parameters for the data object.

%   Copyright 2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2004/03/24 20:45:39 $

% Set the default
hlines = [];

% Get the data object
h = varargin{1};

% Check the input number
if nargin < 2
    id = sprintf('rf:%s:plot:NotEnoughInput', strrep(class(h),'.',':'));
    error(id, 'You must provide at least one parameter in order to plot');
end

% Get the format
format = varargin{end};
yformat = modifyformat(format);

% Calculate the data 
if isempty(yformat)
    fromats = listformat(h, varargin{2});
    format = fromats{1};
    for i = 3:nargin
        fromats = listformat(h, varargin{i});
        dformat = fromats{1};
        if ~strcmp(format, dformat)
            id = sprintf('rf:%s:plot:NotConsistenDefaulFormat',strrep(class(h),'.',':'));
            error(id, 'All the parameters must have same default format.');
        end
    end    
    yformat = modifyformat(format);
    [ydata, ynames] = calculate(varargin{1:end}, format);
else
    [ydata, ynames] = calculate(varargin{1:end});
end
numtrace = length(ynames);
numalltrace = length(ydata);

% If no data, don't plot
if isempty(ynames) || isempty(ydata); return; end;

% Get the data type
dtype = category(h, varargin{2});

% Get the information of X-axis
[xname, xdata, xunit] = xaxis(h, dtype, format);

% Get the figure for plot
fig = findfigure(h);
hold_state = false;
if ~(fig==-1); hold_state = ishold; end;

% Plot the data
if strcmp(dtype, 'Power Parameters') || strcmp(dtype, 'AMAM/AMPM Parameters')
    % Plot pout/phase data
    % Get the information of PFreq
    [fname, pfreq, funit] = xaxis(h, dtype, format,'Pfreq');
    kk = 0;
    pout = {};
    reqdata = {};
    for j=1:numtrace
        for k=1:numalltrace/numtrace
            jk = (j-1)*numalltrace/numtrace + k;
            pout{2*jk-1} = xdata{k};
            pout{2*jk} = ydata{jk};
            reqdata{jk} = strcat(ynames{j}, sprintf('(%s=%s%s)', fname, ...
                num2str(pfreq(k)), funit));
        end
    end
    % Call PLOT to plot the data on X-Y plane
    hlines = builtin('plot', pout{1:2*numalltrace});
    if ~hold_state
        % Set labels
        if ~strcmp(yformat, 'None')
            ylabel(yformat);
        end
        set(get(gca,'YLabel'),'Rotation',90.0);
        xlabel(sprintf('%s %s', xname, xunit));
        hold off; 
    end
    % Show the legend
    addlegend(h, hlines, reqdata);
elseif strcmp(dtype, 'Phase Noise')
    % Plot Phase Noise
    yydata = [];
    for i = 1:numtrace
        yydata(:, i) = ydata{i};
    end
    % Call SEMILOGX to plot the data on X-Y plane
    if length(xdata) == 1
        hlines = ones(numtrace,1);
        for i = 1:numtrace
           hlines(i,1) = builtin('semilogx', xdata, yydata(1,i));
           hold on;
        end
    else
        hlines = builtin('semilogx', xdata, yydata);
    end
    if ~hold_state
        % Set labels
        if ~strcmp(yformat, 'None')
            ylabel(yformat);
        end
        set(get(gca,'YLabel'),'Rotation',90.0);
        xlabel(sprintf('%s %s', xname, xunit));
        hold off; 
    end
    % Show the legend
    addlegend(h, hlines, ynames); 
elseif numtrace ==  numalltrace
    % Plot the other data
    yydata = [];
    for i = 1:numtrace
        yydata(:, i) = ydata{i};
    end
    % Call PLOT to plot the data on X-Y plane
    if length(xdata) == 1
        hlines = ones(numtrace,1);
        for i = 1:numtrace
           hlines(i,1) = builtin('plot', xdata, yydata(1,i));
           hold on;
        end
    else
        hlines = builtin('plot', xdata, yydata);
    end
    if ~hold_state
        % Set labels
        if ~strcmp(yformat, 'None')
            ylabel(yformat);
        end
        set(get(gca,'YLabel'),'Rotation',90.0);
        xlabel(sprintf('%s %s', xname, xunit));
        hold off; 
    end
    % Show the legend
    addlegend(h, hlines, ynames); 
end
grid on;


function out = modifyformat(in)
% Modify the format
switch upper(in)
case {'DB' 'MAGNITUDE (DECIBELS)'}
    out = 'Magnitude (decibels)';
case {'DBC/HZ'}
    out = 'dBc/Hz';
case 'REAL'
    out = 'Real';
case {'IMAG' 'IMAGINARY'}
    out = 'Imaginary';
case {'ABS' 'MAG' 'MAGNITUDE (LINEAR)'}
    out = 'Magnitude (linear)';
case {'ANGLE' 'ANGLE (DEGREES)'}
    out = 'Angle (degrees)';
case 'ANGLE (RADIANS)'
    out = 'Angle (radians)';
case 'NONE'
    out = 'None';
case 'DBM'
    out = 'dBm';
case 'DBW'
    out = 'dBW';
case {'W' 'WATTS'}
    out = 'W';
case 'MW'
    out = 'mW';
otherwise
    out = '';
end
