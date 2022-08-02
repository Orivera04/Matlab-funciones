function h = candle(ftsa, color, dateform, varargin)
%CANDLE Overloaded for FINTS object: plots Candle plot.
%
%   CANDLE(FTS) generates a Candle plot of the data in the FINTS object 
%   FTS.  FTS must contain at least 4 (four) data series representing the 
%   High, Low, Close, and Open Prices.  These series must have the names 
%   'High', 'Low', 'Close', and 'Open' (case-insensitive).
%
%   CANDLE(FTS, COLOR) does a similar operation as above with the same 
%   requirements with regards to the contents of FTS.  The difference is 
%   the color of the box of the candle is specified in COLOR.  COLOR can 
%   be a 3-element row vector representing RGB or the color identifier 
%   discussed in the help entry of the PLOT command (do 'help plot').
%
%   CANDLE(FTS, COLOR, DATEFORM) adds the flexibility of specifying the 
%   date string format to be used as the X-axis tick labels; this format 
%   is specified in DATEFORM.  For a list of available date string format,
%   please see the help entry of DATETICK (do 'help datetick').
%
%   NOTE: DATEFORM can only be used when FTS does not contain time
%   information. If FTS contains time information the DATEFORM will be
%   'dd-mmm-yyyy HH:MM'.
%
%   CANDLE(FTS, COLOR, DATEFORM, ParameterName, ParameterValue, ... ) has 
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
%   HCDL = CANDLE(FTS, COLOR, DATEFORM, ParameterName, ParameterValue, ... ) 
%   is identical to the above syntax except that it returns the handle to the 
%   patch objects and the line object that makes up the Candle plot.  HCDL 
%   is a 3-element column vector representing the handles to the 2 (two) 
%   patches and 1 (one) line.
%
%   Example:   load disney
%              candle(dis('28-May-1998::18-Jun-1998'))
%
%   See also BAR, BAR3, CANDLE, HIGHLOW.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11 $   $Date: 2002/02/11 09:14:39 $

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
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:fints_candle:InvalidParameterName', ...
                'Invalid Parameter Name.');
        end
    end
otherwise
    error('Ftseries:fints_candle:InvalidNumOfArgs', ...
        'Invalid number of input arguments.');
end

% Get the names indexes.  if not exist, give error.
snames = {highnm lownm opennm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:fints_candle:SeriesNotFound', ...
        'One or more required series is not found.  Please check the series names.');
end

% Extract data series of object structure.
highp  = ftsa.data{4}(:, snameidx(1)-3);
lowp   = ftsa.data{4}(:, snameidx(2)-3);
openp  = ftsa.data{4}(:, snameidx(3)-3);
closep = ftsa.data{4}(:, snameidx(4)-3);

% Plot Candle chart by calling Financial Toolbox CANDLE command.
candle(highp, lowp, closep, openp, color);

dateset = ftsdates;

hcdl_vl = findobj(gca, 'Type', 'line');
hcdl_bx = findobj(gca, 'Type', 'patch');

% The CANDLE plot is made up of patch(es) and a line.  hcdl_vl is the 
% handle to the vertical lines; it's actually only 1 line object.  
% hcdl_bx contains the handle(s) of the patch object(s) that make up the 
% empty and filled boxes.  The XData of those objects need to be changed 
% to dates so that ZOOM works correctly.
line_xdata = get(hcdl_vl, 'XData');
set(hcdl_vl, 'XData', dateset(line_xdata));
for pidx=1:length(hcdl_bx)   % Need to do loop since there can be 1 or 2 patches.
    patch_xdata = get(hcdl_bx(pidx), 'XData');
    if length(ftsa) == 1
        offset = [-.25; -.25; .25; .25];
    else
        offset = [-0.25*ones(2, size(patch_xdata, 2)); ...
                +0.25*ones(2, size(patch_xdata, 2))] * min(abs(diff(dateset)));
    end
    set(hcdl_bx(pidx), 'XData', dateset(round(patch_xdata))+offset);
end   

% Change XTickLabel to date string format.
if isempty(dateform)
    relabel(gca,ftsdates,timeData);
else
    datetick('x',dateform);
end

% Turn GRID on.
grid on;

% Turn the interpreter off
interpre = findobj(gcf,'type','text');
set(interpre,'interpreter','none');

% Return handle to PATCH & LINE objects, if requested.
if nargout == 1
    h = [hcdl_vl(:); hcdl_bx(:)];
elseif nargout > 1
    error('Ftseries:fints_candle:TooManyOutputs', ...
        'Too many output arguments.');
end

% [EOF]
