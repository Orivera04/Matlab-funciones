function h = bar3(ftsa, varargin)
%BAR3H  Overloaded for FINTS objects: Horizontal 3-D bar graph.
%
%   BAR3H(FTS) draws the columns of data series of the object FTS.  The
%   number of data series dictates the number of vertical bars per group.  
%   Each group is the data for one particular date.  
%
%   BAR3H(FTS, WIDTH) specifies the width of the bars. Values of WIDTH > 1, 
%   produce overlapped bars.  The default value is WIDTH = 0.8.
%
%   BAR3H(..., 'detached') produces the default detached bar chart.
%   BAR3H(..., 'grouped') produces a grouped bar chart.
%   BAR3H(..., 'stacked') produces a stacked bar chart.
%   BAR3H(..., LINECOL) uses the line color specified (one of 'rgbymckw').
%
%   HBAR3H = BAR3H(...) returns a vector of surface handles.
%
%   Example:   load disney
%              bar3h(q_dis)
%
%   See also BAR, BAR3, BARH, BAR3H, CANDLE, HIGHLOW.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.4.2.1 $   $Date: 2003/01/16 12:50:47 $

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Extract time series data from object.
ftsmtx   = fts2mat(ftsa, 1);
if timeData
    ftsdates = ftsa.data{3} + ftsa.data{5};
else
    ftsdates = ftsmtx(:, 1);
end
ftsdata  = ftsmtx(:, 2:end);

% Do the right thing based on VARARGIN.
b3type = 'detached';
switch nargin
case 1
    hbar3h = bar3h(ftsdates, ftsdata);
case 2
    switch class(varargin{1})
    case 'double'
        hbar3h = bar3h(ftsdates, ftsdata, varargin{1});
    case 'char'
        hbar3h = bar3h(ftsdates, ftsdata, varargin{1});
        switch varargin{1}
        case {'detached', 'detach', 'stacked', 'stack', 'grouped', 'group'}
            b3type = lower(varargin{1});
        end
    otherwise
        error('Ftseries:fints_bar3h:InvalidInputType', ...
            'Invalid input argument type.');
    end
    
case 3
    switch class(varargin{1})
    case 'char'
        error('Ftseries:fints_bar3h:DetachedStackedGroupedMustBeLast', ...
            '''detached'', ''stacked'', ''grouped'', or LINECOL must come last.');
    case 'double'
        switch lower(varargin{2})
        case {'detached', 'detach', 'stacked', 'stack', 'grouped', 'group', 'r', 'g', 'b', 'w', 'c', 'm', 'y', 'k'}
            hbar3h = bar3h(ftsdates, ftsdata, varargin{1}, varargin{2});
            switch varargin{2}
            case {'detached', 'detach', 'stacked', 'stack', 'grouped', 'group'}
                b3type = lower(varargin{1});
            end
        otherwise
            error(['''', varargin{2}, ''' is an invalid input.']);
        end
    otherwise
        error('Ftseries:fints_bar3h:InvalidInputType', ...
            'Invalid input argument type.');
    end
otherwise
    error('Ftseries:fints_bar3h:InvalidNumOfInputs', ...
        'Invalid number of input arguments.');
end

% Add x axis tick marks
relabel(gca,ftsdates,timeData,'z');

% Find correct x scale, then rescale
xLims = get(gca,'xlim');
yLims = get(gca,'ylim');
zLims = get(gca,'zlim');

daySpan = abs(zLims(1) - zLims(2));

if daySpan > 365
    % scale out 2 months
    axis([xLims, yLims ,(zLims(1) - 60), (zLims(2) + 60)]);
elseif daySpan > 30 & daySpan <= 365
    % scale out 1 month
    axis([xLims, yLims, (zLims(1) - 30), (zLims(2) + 30), zLims]);
elseif daySpan <= 30
    % do nothing
end

% Provide the appropriate Legends to the plot.
sersnames = fieldnames(ftsa);
switch b3type(1)
case {'g', 's'}
    legend(sersnames{4:end-1});
case 'd'
    set(gca, 'XTickLabel', sersnames(4:end-1))
end

% Turn GRID on.
grid on;

% Turn the interpreter off
interpre = findobj(gcf,'type','text');
set(interpre,'interpreter','none');

% Return handle to LINE plot, if requested.
if nargout == 1
    h = hbar3h;
elseif nargout > 1
    error('Ftseries:fints_bar3h:TooManyOutputs', ...
        'Too many output arguments.');
end

% {EOF]
