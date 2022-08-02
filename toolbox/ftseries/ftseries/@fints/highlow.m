function h = highlow(ftsa, color, dateform, varargin)
%HIGHLOW Overloaded for FINTS object: plots High-Low chart.
%
%   HIGHLOW(FTS) generates a High-Low plot of the data in the FINTS object 
%   FTS.  FTS must contain at least 4 (four) data series representing the 
%   High, Low, Close, and Open Prices.  These series must have the names 
%   'High', 'Low', 'Close', and 'Open' (case-insensitive).
%
%   HIGHLOW(FTS, COLOR) does a similar operation as above with the same 
%   requirements with regards to the contents of FTS.  The difference is 
%   the color of the plot is specified in COLOR.  COLOR can be a 3-element 
%   row vector representing RGB or the color identifier discussed in the 
%   help entry of the PLOT command (do 'help plot').
%
%   HIGHLOW(FTS, COLOR, DATEFORM) adds the flexibility of specifying the 
%   date string format to be used as the X-axis tick labels; this format 
%   is specified in DATEFORM.  For a list of available date string format,
%   please see the help entry of DATETICK (do 'help datetick').
%
%   NOTE: DATEFORM can only be used when FTS does not contain time
%   information. If FTS contains time information the DATEFORM will be
%   'dd-mmm-yyyy HH:MM'.
%
%   HIGHLOW(FTS, COLOR, DATEFORM, ParameterName, ParameterValue, ... ) has 
%   additional input arguments that are used to indicate the actual name(s) 
%   of the required data series.  This syntax should be used if the data 
%   series representing the required data do not have the required name(s) 
%   as mentioned above.  ParameterName can be one of the following:
%
%          'HighName'  :  high prices series name
%          'LowName'   :  low prices series name
%          'OpenName'  :  open prices series name
%          'CloseName' :  closing prices series name
%
%   Open prices are optional and can be specified as optional by providing
%   the ParameterName, 'OpenName', and the ParameterValue, '' (empty string).
%   
%   For example:
%      HIGHLOW(FTS, COLOR, DATEFORM, 'OpenName', '');
%
%   HHLL = HIGHLOW(FTS, COLOR, DATEFORM, ParameterName, ParameterValue, ... ) 
%   is identical to the above syntax except that it returns the handle to the 
%   line object that makes up the High-Low plot.  HHLL is the handle to the 
%   line object.
%
%   Example:   load disney
%              highlow(dis('28-May-1998::18-Jun-1998'))
%
%   See also BAR, BAR3, CANDLE, HIGHLOW.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8.2.1 $   $Date: 2003/01/16 12:50:57 $

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Get the dates etc.
if timeData
    ftsdates = ftsa.data{3} + ftsa.data{5};
else
    ftsdates = ftsa.data{3};
end

% Check input arguments.
highnm  = 'high';
lownm   = 'low';
opennm  = 'open';
closenm = 'close';
switch nargin
case 1
    color = 'b';
    dateform = [];
case 2
    if isempty(color)
        color = 'b';
    end
    dateform = [];
case 3
    if isempty(color)
        color = 'b';
    end
    if isempty(dateform)
        dateform = [];
    end
case {5, 7, 9, 11}
    for nidx = 1:2:nargin-3
        switch lower(varargin{nidx}(1))
        case 'h'   % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l'   % 'LowName'
            lownm = lower(varargin{nidx+1});
        case 'o'   % 'OpenName'
            opennm = lower(varargin{nidx+1});
            
            % Input checks
            if isnumeric(opennm)
                error('Ftseries:fints_highlow:InvalidOpenName', ...
                    'Invalid OpenName Parameter Value.');
            end
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:fints_highlow:InvalidParameterName', ...
                'Invalid Parameter Name.');
        end
    end
otherwise
    error('Ftseries:fints_highlow:IncalidNumOfInputs', ...
        'Invalid number of input arguments.');
end

% Get the names indexes.  if not exist, give error.
snames = {highnm lownm opennm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);

% If any of the names are not present or (if openname exists and not
% found in the names vector of the FTS).
if any(~snameidx(1) || ~snameidx(2) || ~snameidx(4)) || ((~isempty(opennm)) && (snameidx(3) == 0))
    error('Ftseries:fints_highlow:SeriesNotFound', ...
        'One or more required series are not found.  Check names, please.');
end

% Extract data series of object structure.
highp  = ftsa.data{4}(:, snameidx(1)-3);
lowp   = ftsa.data{4}(:, snameidx(2)-3);
% Check to make sure user specifically said open price is optional
if snameidx(3) ~= 0
    openp  = ftsa.data{4}(:, snameidx(3)-3);
else
    openp = [];
end
closep = ftsa.data{4}(:, snameidx(4)-3);

% Plot High-Low chart by calling Financial Toolbox HIGHLOW command.
hhll = highlow(highp, lowp, closep, openp, color);

% Replace default X-axis data with dates.
% Generate the 3 sections of dates: INDHILO, CLT, OPT. (Refer to FinTbx's HIGHLOW).
dateset1 = ftsa.data{3}(:, ones(1,3))';
dateset1 = dateset1(:);
dateset2 = dateset1;
dateset2(3:3:end) = NaN * ones(size(3:3:length(dateset1)));
dateset3 = dateset2;
% Generate the horizontal tick size for open and close price indicators.
offsetsize = mean(diff(ftsdates));
offset = zeros(size(dateset1));
offset(2:3:end) = (0.4 * offsetsize) * ones(size(2:3:length(dateset1)));
% Generate the offset dates for the open and close price indicators.
dateset2 = dateset2 + offset;
dateset3 = dateset3 - offset;
% Combine all three DATESETs to make the new X-axes data.
newdtaxis = [dateset1', dateset2', dateset3'];

% Set the XData of the plot to the new dates.
set(hhll, 'XData', newdtaxis);

% Change XTickLabel to date string format.
if isempty(dateform)
    relabel(gca,ftsdates,timeData);
else
    datetick('x', dateform);
end

% Turn GRID on.
grid on;

% Return handle to LINE plot, if requested.
if nargout == 1
    h = hhll;
elseif nargout > 1
    error('Ftseries:fints_highlow:TooManyOutputs', ...
        'Too many output arguments.');
end

% [EOF]
