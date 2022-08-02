function [hlines, hsm] = smith(varargin)
%SMITH Plot the parameters on the Smith chart.
%   [HLINES, HSM] = SMITH(H, PARAMETER1, ..., PARAMETERN) plots the
%   specified parameters on the Z Smith chart. The first input is the
%   handle to the data object, and the other inputs PARAMETER1, ...,
%   PARAMETERN are the parameters to be visualized.
%
%   [HLINES, HSM] = SMITH(H, PARAMETER1, ..., PARAMETERN, TYPE) plots the
%   specified parameters on the specified TYPE of Smith chart. TYPE could
%   be 'Z', 'Y', or 'ZY'.
%
%   Type LISTPARAM(H) to see the valid parameters for the data object. 
%
%   This method has two outputs. The first is a column vector of handles to
%   lineseries objects, one handle per plotted line. The second output is
%   the handle to the Smith chart. The properties of the Smith chart
%   include,
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

%   Copyright 2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.3 $  $Date: 2004/03/30 13:11:44 $

% Set the default
hsm = [];

% Get the data object
h = varargin{1};

% Check the input number
if nargin < 2
    id = sprintf('rf:%s:smith:NotEnoughInput', strrep(class(h),'.',':'));
    error(id, 'You must provide at least one parameter in order to do Smith chart plot');
end

% Check the input format
switch upper(varargin{end})
case {'ABS' 'DB' 'MAGNITUDE (DECIBELS)' 'MAG' 'MAGNITUDE (LINEAR)' ...
        'ANGLE' 'ANGLE (DEGREES)' 'ANGLE (RADIANS)' 'REAL' 'IMAG' ...
        'IMAGINARY' 'DBM' 'DBW' 'W' 'WATTS' 'MW' 'OHMS' 'DBC/HZ' 'NONE'}
    id = sprintf('rf:%s:smith:FormatNotNeeded', strrep(class(h),'.',':'));
    error(id, 'Do not need to input format for Smith chart plot');
end

% Check and find the smith chart format
if isempty(charttype(varargin{end}))
    N = nargin;
    type = 'z';
else 
    N = nargin - 1;
    type = varargin{end};
end        

format = 'None';
% Calculate the data 
[ydata, ynames] = calculate(varargin{1:N}, format);
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
hsm = [];
hold_state = false;
if ~(fig==-1)
    hold_state = ishold;
    % Create the chart
    if ~hold_state; hsm = rfchart.smith('Type', type); end;
else
    hsm = rfchart.smith('Type', type);
end
hold on;
linesinfo = {};

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
    % Call PLOT to plot the data on Smith chart
    hlines = builtin('plot', pout{1:2*numalltrace});
    % Show the legend
    addlegend(h, hlines, reqdata); 
    if ~hold_state; hold off; end;
elseif numtrace ==  numalltrace
    % Plot the other data
    yydata = [];
    for i = 1:numtrace
        yydata(:, i) = ydata{i};
    end
    % Call PLOT to plot the complex data on Smith chart
    if length(xdata) == 1
        hlines = ones(numtrace,1);
        for i = 1:numtrace
           hlines(i,1) = builtin('plot', xdata, yydata(1,i));
           hold on;
        end
    else
        hlines = builtin('plot', yydata);
    end
    % Show the legend
    addlegend(h, hlines, ynames); 
    % Add datatip 
    if hold_state
        for k=1:length(hlines)
            linesinfo = h.LinesInformation;
            k0 = length(linesinfo);
            linesinfo{k0+k} = currentlineinfo(hlines(k), dtype, type, varargin{1+k}, ...
            yydata(:,k), 'Freq', format);
        end
    else
        for k=1:length(hlines)
            linesinfo{k} = currentlineinfo(hlines(k), dtype, type, varargin{1+k}, ...
            yydata(:,k), 'Freq', format);
        end
    end
    set(h, 'LinesInformation', linesinfo);
    datatip(h, fig, hlines);
    if ~hold_state; hold off; end;
end


function returntype = charttype(type)
% Set the default result

% Set the default
returntype = [];

% Check the type
if nargin == 1
    switch upper(type)
    case {'Z', 'Y', 'YZ', 'ZY'}
        returntype = type;
    otherwise
        returntype = '';
    end
end


function result = modifiytype(type)
% Get the type
switch type
case 'z'
    result = 'Z Smith chart';
case 'y'
    result = 'Y Smith chart';
case 'zy'
    result = 'ZY Smith chart';
case 'yz'
    result = 'YZ Smith chart';
otherwise
    result = 'Z Smith chart';
end


function result = currentlineinfo(hline, dtype, type, name, data, xname, format)
% Get the current line information

result = [];
result.LineHandle = hline;
result.PType = dtype;
result.Name = name;
result.Data = data;
result.Xname = xname;
result.Format = format;
result.Type = modifiytype(type);