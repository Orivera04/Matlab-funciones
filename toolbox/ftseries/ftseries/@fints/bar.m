function h = bar(ftsa, varargin)
%@FINTS/BAR Overloaded for FINTS object: plots Bar chart.
%
%   BAR(FTS) draws the columns of data series of the object FTS.  The
%   number of data series dictates the number of vertical bars per group.  
%   Each group is the data for one particular date.  
%
%   BAR(FTS, WIDTH) specifies the width of the bars. Values of WIDTH > 1, 
%   produce overlapped bars.  The default value is WIDTH = 0.8.
%
%   BAR( ... , 'grouped') produces the default vertical grouped bar chart.
%   BAR( ... , 'stacked') produces a vertical stacked bar chart.
%   BAR( ... , LINECOL) uses the line color specified (one of 'rgbymckw').
%
%   HBAR = BAR(...) returns a vector of surface handles.
%
%   Use SHADING FACETED to put edges on the bars.  Use SHADING FLAT to
%   turn them off.
%
%   Example:   load disney
%              bar(q_dis)
%
%   See also BAR, BAR3, BARH, BAR3H, CANDLE, HIGHLOW.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.4.2.1 $   $Date: 2003/01/16 12:50:45 $

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Extract time series data from object.
ftsmtx = fts2mat(ftsa, 1);
if timeData
    ftsdates = ftsa.data{3} + ftsa.data{5};
else
    ftsdates = ftsmtx(:, 1);
end
ftsdata = ftsmtx(:, 2:end);

% Do the right thing based on VARARGIN.
switch nargin
case 1
    hbar = bar(ftsdates, ftsdata);
case 2
    switch class(varargin{1})
    case {'char', 'double'}
        hbar = bar(ftsdates, ftsdata, varargin{1});
    otherwise
        error('Ftseries:fints_bar:InvalidInputType', ...
            'Invalid input argument type.');
    end
case 3
    switch class(varargin{1})
    case 'char'
        error('Ftseries:fints_bar:StackedGroupedMustBeLast', ...
            '''stacked'', ''grouped'', or LINECOL must come last.');
    case 'double'
        switch lower(varargin{2})
        case {'stacked', 'stack', 'grouped', 'group', 'r', 'g', 'b', 'w', 'c', 'm', 'y', 'k'}
            hbar = bar(ftsdates, ftsdata, varargin{1}, varargin{2});
        otherwise
            error(['''', varargin{2}, ''' is an invalid input.']);
        end
    otherwise
        error('Ftseries:fints_bar:InvalidInputType', ...
            'Invalid input argument type.');
    end
otherwise
    error('Ftseries:fints_bar:InvalidNumOfInputs', ...
        'Invalid number of input arguments');
end

% Add x axis tick marks
relabel(gca,ftsdates,timeData);

% Find correct x scale, then rescale
xLims = get(gca,'xlim');
yLims = get(gca,'ylim');

daySpan = abs(xLims(1) - xLims(2));

if daySpan > 365
    % scale out 2 months
    axis([(xLims(1) - 60), (xLims(2) + 60), yLims]);
elseif daySpan > 30 & daySpan <= 365
    % scale out 1 month
    axis([(xLims(1) - 30), (xLims(2) + 30), yLims]);
elseif daySpan <= 30
    % do nothing
end

% Provide the appropriate Legends to the plot.
sersnames = fieldnames(ftsa);
legend(sersnames{4:end-1});

% Turn GRID on.
grid on;

% Turn the interpreter off
interpre = findobj(gcf,'type','text');
set(interpre,'interpreter','none');

% Return handle to LINE plot, if requested.
if nargout == 1
    h = hbar;
elseif nargout > 1
    error('Ftseries:fints_bar:TooManyOutputs', ...
        'Too many output arguments.');
end

% [EOF]
