function hlines = polar(varargin)
%POLAR Plot the parameters on polar plane.
%   HLINES = POLAR(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters on the polar plane. The first input is the handle to the
%   data object, and the other inputs PARAMETER1, ..., PARAMETERN are the
%   parameters to be visualized.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   Type LISTPARAM(H) to see the valid parameters for the data object. 

%   Copyright 2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2004/03/24 20:45:40 $

% Set the default
hlines = [];

% Get the data object
h = varargin{1};

% Check the input number
if nargin < 2
    id = sprintf('rf:%s:polar:NotEnoughInput', strrep(class(h),'.',':'));
    error(id, 'You must provide at least one parameter in order to plot');
end

% Check the input format
switch upper(varargin{end})
case {'ABS' 'DB' 'MAGNITUDE (DECIBELS)' 'MAG' 'MAGNITUDE (LINEAR)' ...
        'ANGLE' 'ANGLE (DEGREES)' 'ANGLE (RADIANS)' 'REAL' 'IMAG' ...
        'IMAGINARY' 'DBM' 'DBW' 'W' 'WATTS' 'MW' 'OHMS' 'DBC/HZ' 'NONE'}
    id = sprintf('rf:%s:polar:FormatNotNeeded', strrep(class(h),'.',':'));
    error(id, 'Do not need to input format for polar plot');
end        

format = 'None';
% Calculate the data 
[ydata, ynames] = calculate(varargin{1:end}, format);
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
    % Call POLAR to plot the complex data on the polar plane
    for k=1:numalltrace
        [th,r] = cart2pol(real(ydata{k}),imag(ydata{k}));
        hlines = polar(th,r);
        hold on;
    end
    % Show the legend
    addlegend(h, hlines, reqdata); 
    if ~hold_state; hold off; end;
elseif numtrace ==  numalltrace
    % Plot the other data
    yydata = [];
    for i = 1:numtrace
        yydata(:, i) = ydata{i};
    end
    % Call POLAR to plot the complex data on the polar plane
    if length(xdata) == 1
        hlines = ones(numtrace,1);
        for i = 1:numtrace
            [th,r] = cart2pol(real(yydata(1,i)),imag(yydata(1,i)));
            hlines(i,1) = polar(th,r);
            hold on;
        end
    else
        [th,r] = cart2pol(real(yydata),imag(yydata));
        hlines = polar(th,r);
    end
    % Show the legend
    addlegend(h, hlines, ynames); 
    if ~hold_state; hold off; end;
end
grid on;