function h = bar(ftsa, varargin)
%BARH   Overloaded for FINTS object: plots horizontal bar chart.
%
%   BARH(FTS) draws the columns of data series of the object FTS.  The
%   number of data series dictates the number of vertical bars per group.  
%   Each group is the data for one particular date.  
%
%   BARH(FTS, WIDTH) specifies the width of the bars. Values of WIDTH > 1, 
%   produce overlapped bars.  The default value is WIDTH = 0.8.
%
%   BARH( ... , 'grouped') produces the default vertical grouped bar chart.
%   BARH( ... , 'stacked') produces a vertical stacked bar chart.
%   BARH( ... , LINECOL) uses the line color specified (one of 'rgbymckw').
%
%   HBARH = BARH(...) returns a vector of surface handles.
%
%   Use SHADING FACETED to put edges on the bars.  Use SHADING FLAT to
%   turn them off.
%
%   Example:   load disney
%              barh(q_dis)
%
%   See also BAR, BAR3, BARH, BAR3H, CANDLE, HIGHLOW.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.4.2.1 $   $Date: 2003/01/16 12:50:48 $

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
switch nargin
case 1
    hbarh = barh(ftsdates, ftsdata);
case 2
    switch class(varargin{1})
    case {'char', 'double'}
        hbarh = barh(ftsdates, ftsdata, varargin{1});
    otherwise
        error('Ftseries:fints_barh:InvalidInputType', ...
            'Invalid input argument type.');
    end
case 3
    switch class(varargin{1})
    case 'char'
        error('Ftseries:fints_barh:StackedGroupedMustBeLast', ...
            '''stacked'', ''grouped'', or LINECOL must come last.');
    case 'double'
        switch lower(varargin{2})
        case {'stacked', 'stack', 'grouped', 'group', 'r', 'g', 'b', 'w', 'c', 'm', 'y', 'k'},
            hbarh = barh(ftsdates, ftsdata, varargin{1}, varargin{2});
        otherwise
            error(['''', varargin{2}, ''' is an invalid input.']);
        end
    otherwise
        error('Ftseries:fints_barh:InvalidInputType', ...
            'Invalid input argument type.');
    end
otherwise
    error('Ftseries:fints_barh:InvalidNumOfInputs', ...
        'Invalid number of input arguments.');
end

% Add x axis tick marks
relabel(gca,ftsdates,timeData,'y');

% Find correct x scale, then rescale
xLims = get(gca,'xlim');
yLims = get(gca,'ylim');

daySpan = abs(yLims(1) - yLims(2));

if daySpan > 365
    % scale out 2 months
    axis([xLims, (yLims(1) - 60), (yLims(2) + 60)]);
elseif daySpan > 30 & daySpan <= 365
    % scale out 1 month
    axis([xLims, (yLims(1) - 30), (yLims(2) + 30)]);
elseif daySpan <= 30
    % do nothing
end

% Provide the appropriate Legends to the plot.
sersnames = fieldnames(ftsa);
legend(sersnames{4:end-1}, -1);

% Turn GRID on.
grid on;

% Turn the interpreter off
interpre = findobj(gcf,'type','text');
set(interpre,'interpreter','none');

% Return handle to LINE plot, if requested.
if nargout == 1
    h = hbarh;
elseif nargout > 1
    error('Ftseries:fints_barh:TooManyOutputs', ...
        'Too many output arguments.');
end

% [EOF]
