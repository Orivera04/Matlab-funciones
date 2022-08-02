function fts = fints(varargin)
%@FINTS/FINTS constructs a financial time series object, FINTS.
%  
%    A financial time series object is a MATLAB object that minimally
%    contains a date series, time series (if one exists), data series, and
%    a frequency indicator.  The frequency indicator is set to 'Unknown',
%    (0), if it is not explicitly specified.  In addition to those four
%    items (date, time, data, and frequency) the financial time series can
%    also contain a text description.  If the description is not explicitly
%    set, a default description of ' ' is specified.
%
%   There are multiple ways that you can instantiate a financial time series 
%   using the constructor.  They are:
%
%      FTS = fints(DATES_AND_DATA);
%      FTS = fints(DATES_TIMES_AND_DATA);
%
%      FTS = fints(DATES, DATA);
%      FTS = fints(DATES_TIMES,DATA);
%
%      FTS = fints(DATES, DATA, DATANAMES);
%      FTS = fints(DATES_TIMES, DATA, DATANAMES);
%
%      FTS = fints(DATES, DATA, DATANAMES, FREQ);
%      FTS = fints(DATES_TIMES, DATA, DATANAMES, FREQ);
%
%      FTS = fints(DATES, DATA, DATANAMES, FREQ, DESC);
%      FTS = fints(DATES_TIMES, DATA, DATANAMES, FREQ, DESC);
%
%   FTS = FINTS(DATES_AND_DATA) generates a financial time series object, 
%   FTS, and obtains the dates and data from the matrix DATES_AND_DATA.  
%   The dates and data in the input matrix must be oriented column-wise
%   (i.e.  the date series and each data series are columns in the input
%   matrix). In addition, the dates entered MUST be in the serial date
%   format (i.e. 01-Jan-2001 is 730852).  You can also use the function
%   TODAY to enter in  date information.  The names of the series will
%   default to  'series1', ..., 'seriesN' where N is the total number of
%   columns in  DATES_AND_DATA less 1 (that is the number of data columns).
%   The  default contents of the DESC and FREQ fields are '' and  'Unknown'
%   (0), respectively.
%
%   For example:
%
%      f = fints([(today:today+2)', (1:3)'])
%
%   FTS = FINTS(DATES_TIMES_AND_DATA) is exactly the same as
%   FTS = FINTS(DATES_AND_DATA), but with time information.  It generates a
%   a financial time series object, FTS, that contains the dates, times, 
%   and data from the matrix DATES_TIMES_AND_DATA.  The dates and times
%   entered must be in the serial date and time format (i.e.
%   01-Jan-2001 13:00 is 7.308525416666666e+005).  You can also use the
%   function NOW to enter in date and time information.
%
%   For example:
%
%         f = fints(now,1)
%
%   Please note that the Financial Time Series Toolbox ONLY supports hourly
%   and minute time series. Seconds are not supported and will be
%   disregarded when the FINTS object is created (i.e. 01-jan-2001 12:00:01
%   will be considered as 01-jan-2001 12:00). If there are duplicate dates
%   and times, the FINTS constructor will sort the dates and times and
%   choose the first instance of the duplicate dates and times. The other
%   duplicate dates and times will be removed from the object along with
%   their corresponding DATA. 
%
%   FTS = FINTS(DATES, DATA) generates the financial time series object, 
%   FTS, that contains the dates from the DATES column vector of dates and
%   data from the matrix DATA.  The DATA matrix must be column oriented
%   such that each column in the matrix is a data series.  The names of the
%   series will default to 'series1', ..., 'seriesN' where N is the total 
%   number of columns in DATA.  The default contents of the DESC and FREQ 
%   fields are '' and 'Unknown' (0), respectively.
%
%   For example:
%
%      f = fints((today:today+2)', [2; 4; 6])
%
%   FTS = FINTS(DATES_TIMES,DATA) is exactly the same as
%   FTS = FINTS(DATES, DATA), but with time information.  It generates the 
%   financial time series object, FTS, that contains the dates and times
%   from the DATES_TIMES column vector of dates and times, and data from
%   the matrix DATA.  The dates and times can be separate column oriented
%   date and time series, but they must be concatenated together to produce
%   the DATES_TIMES column oriented matrix before being entered as the
%   first input. 
%
%   DATES_TIMES can be:
%      Serial Date and Time format: 7.308525416666666e+005
%      Date and Time String format: 01-Jan-2001 12:00
%
%   Valid Date and Time String formats are:
%      'ddmmmyy hh:mm' or 'ddmmmyyyy hh:mm'
%      'mm/dd/yy hh:mm' or 'mm/dd/yyyy hh:mm'
%      'dd-mmm-yy hh:mm' or 'dd-mmm-yyyy hh:mm'
%      'mmm.dd,yy hh:mm' or 'mmm.dd,yyyy hh:mm'
%
%   If more than one Serial Date and Time is entered, the entry must be in
%   the  form of a column oriented matrix. In addition, if more than one
%   String Date and Time is entered, the entry must be a column oriented
%   cell array of  dates and times.
%
%   For example:
%
%      f = fints([now;now+1],(1:2)')
%
%      or
%
%      f = fints({'01-Jan-2001 12:00';'02-Jan-2001 12:00'},(1:2)')
%
%      or
%
%      dates = ['01-Jan-2001'; '02-Jan-2001'; '03-Jan-2001']
%      times = ['12:00';'12:00';'12:00']
%      dates_times = cellstr([dates, repmat(' ',size(dates,1),1), times])
%      f = fints(dates_times,(1:3)')
% 
%   FTS = FINTS(DATES, DATA, DATANAMES) and
%   FTS = FINTS(DATES_TIMES, DATA, DATANAMES) generates the financial time
%   series object, FTS, similarly as before with the addition of being able
%   to specify the data series name(s).  The name(s) is(are) specified in 
%   DATANAMES as a row/column cell array.  The number of strings contained
%   in DATANAMES must correspond to the number of columns in DATA.  The
%   default contents of the DESC and FREQ fields are '' and 'Unknown' (0),
%   respectively. A [] can be used as a place holder for DATANAMES.
%
%   FTS = FINTS(DATES, DATA, DATANAMES, FREQ) and
%   FTS = FINTS(DATES_TIMES, DATA, DATANAMES, FREQ) generates the financial
%   time series object, FTS, similarly as before with the addition of being
%   able to add a frequency indicator, FREQ.  You can specify the frequency
%   indicator, FREQ, using these valid frequency indicators:
%
%      UNKNOWN,    Unknown,    unknown,    U, u, 0
%      DAILY,      Daily,      daily,      D, d, 1
%      WEEKLY,     Weekly,     weekly,     W, w, 2
%      MONTHLY,    Monthly,    monthly,    M, m, 3
%      QUARTERLY,  Quarterly,  quarterly,  Q, q, 4
%      SEMIANNUAL, Semiannual, semiannual, S, s, 5
%      ANNUAL,     Annual,     annual,     A, a, 6
%
%   For example:
%
%      f = fints((now:now+3)',(1:4)',[],1)
%
%      or
%
%      f = fints((now:now+3)',(1:4)',[],'D')
%
%   If a [] is used as a place holder for the frequency, the frequency is 
%   defaulted to 'Unknown' (0). 
%
%   FTS = FINTS(DATES, DATA, DATANAMES, FREQ, DESC) and
%   FTS = FINTS(DATES_TIMES, DATA, DATANAMES, FREQ, DESC) generates the
%   financial time series object, FTS, similarly as before with the
%   addition of  being able to add a description field, DESC.  You can
%   enter a descriptive  text string in the field DESC.
%
%   IMPORTANT:  It is your responsibility to match the values with the 
%   correct dates appropriately.  
%
%   See also DATENUM, DATESTR, NOW, TODAY.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.24.2.2 $   $Date: 2004/04/06 01:08:19 $

% -Main---------------------------------------------------------------

msg = '';

% Distribute inputs to the right function
switch nargin
case 0          % If input is empty, create default empty object
    fts = noInput;
case 1          % Input: dates_and_data or dates_time_and_data
    timeSeries = varargin{1};
    [fts,msg] = oneInput(timeSeries);
case{2, 3, 4, 5}   % Input: other combinations of dates, times, and data
    [fts,msg] = multInput(varargin{:});
otherwise
    error('Ftseries:fints_fints:TooManyInputs', ...
        'Too many input arguments.');
end

% If an error 'msg' occurs, error out immediatly.
error(msg);

% Create object
fts = class(fts, 'fints');


% Turn off backtrace
wb = warning('off','backtrace');

% Check to see if all the dates and times are monotonically increasing
w2 = warning('off'); % This is necessary due to a duplicate warning msg in ISSORTED
monoD = issorted(fts);
warning(w2);

% Turn it off again (was turned on by the previous warning call)
wb = warning('off','backtrace');

if monoD ~= 1
    fts = sortfts(fts);
    warning('Ftseries:fints_fints:NonMonotonic', ...
        sprintf(['The dates and/or times in this object were not\n', ...
            'monotonically increasing when created. The object being\n', ...
            'displayed has been sorted. It is recommended that all\n', ...
            'dates and/or times be in chronological order.\n']));
end

% Warn duplicate dates
% Note: Keep this warning as the last warning displayed.
if isempty(fts.data{5})
    % No time information
    if ftsuniq(fts.data{3}) == 0
        warning('Ftseries:fints_fints:DuplicateDates', ...
            sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                'exist. FINTS objects must not contain duplicate dates. The\n', ...
                'function FTSUNIQ may be of assistance in determining which\n', ...
                'dates are duplicates.\n']));
    end
else
    % Contains time information
    if ftsuniq(fts.data{3}+fts.data{5}) == 0
        warning('Ftseries:fints_fints:DuplicateDatesAndTimes', ...
            sprintf(['The dates and times in this object are not unique and\n', ...
                'duplicate dates and times exist. FINTS objects must not\n', ...
                'contain duplicate dates and times. The function FTSUNIQ\n', ...
                'may be of assistance in determining which dates and times\n', ...
                'are duplicates.\n']));
    end
end

% Restore old backtrace state 
warning(wb)


% -NoInput------------------------------------------------------------
function fts = noInput
%NOINPUT creates a default FINTS object if no input arguments are
%   specified.

fts.names = {'desc', 'freq', 'dates', 'series1','times'};
fts.data  = {'', 0, [], [],[]};
fts.datacount = 0;
fts.serscount = 0;


% -OneInput-----------------------------------------------------------
function [fts,msg] = oneInput(timeSeries)
%ONEINPUT parses the dates,times, and data information for a single
%   input into @FINTS/FINTS. 
%
%   Dates and times can ONLY be entered together in the form of a serial 
%   number.
%   
%   For example, the below is a valid date and time entry:
%
%      date_time=now;
%      data=1;
%      date_time_data=[date_time data];
%      f=fints(date_time_data)
%
%   If a time is not entered, time is considered to be [] and not
%   displayed in the output.
%
%   For example:
%
%      date=today;
%      data=1;
%      date_data=[date data];
%      f=fints(date_data)

msg = '';
idxNST = []; % otherwise stated

% Check input matrix. At least two columns must exist.
if size(timeSeries,2) < 2
    msg = 'Need at least 2 columns: The DATES and DATA columns.';
    fts = [];
    return
end

% Check to see if input matrix is a serial date
if ~isnumeric(timeSeries)
    msg = 'The DATES and TIME must be in serial date format.';
    fts = [];
    return
end

% DATES/TIMES
[dt,dates,timetime,idxNST,msg] = datetime(timeSeries(:,1));

if ~isempty(msg)    % Pass error from datetime to main
    dt = []; dates = []; timetime = []; fts = [];
    return
end

% DATA
if isempty(idxNST)
    data = timeSeries(:,2:end)
else
    data = timeSeries(idxNST,2:end);
end

% DATANAMES
nseries = size(data, 2);
datanames = (cellstr([repmat('series', nseries, 1) num2str((1:nseries)', '%0d')]))';

% FREQ
freqdata = 0;

% DESC
descdata = '';

% Setup the object structure
seriesnames = [{'desc', 'freq', 'dates'}, datanames,{'times'}];
seriesdata  = [{descdata}, {freqdata}, num2cell(dates, 1),{data}, ...
        {timetime}];
fts.names = seriesnames;
fts.data  = seriesdata;
fts.datacount = size(data, 1);
fts.serscount = size(datanames, 2);


% -MultInput-----------------------------------------------------------------
function [fts,msg] = multInput(varargin)
%MULTINPUT parses the date, time, and data information for multiple inputs into
%   @FINTS/FINTS. 

msg = '';
idxNST = []; % otherwise stated

% Assigned it in case I need to use it later.
numMainArgIn = nargin;

% Check to see how many inputs to @FINTS?FINTS there are
if numMainArgIn == 2
    timeSeries      = varargin{1};
    dataSeries      = varargin{2};
elseif numMainArgIn == 3
    timeSeries      = varargin{1};
    dataSeries      = varargin{2};
    dataseriesNames =varargin{3};
elseif numMainArgIn == 4
    timeSeries      = varargin{1};
    dataSeries      = varargin{2};
    dataseriesNames = varargin{3};
    freqncy         = varargin{4};
elseif numMainArgIn == 5
    timeSeries      = varargin{1};
    dataSeries      = varargin{2};
    dataseriesNames = varargin{3};
    freqncy         = varargin{4};
    descrip         = varargin{5};
end

% DATES/TIMES
% NOTE: Concatenated strings (timeSeries=[{'DATES'} {' '} {'DATES'}]) will
% be allowed through if a space is added between the DATES and TIMES, but
% will error out if this is not done. Also possible confusion could result
% if timeSeries = [DATES TIMES] due to the fact that TIMES are floats and
% could also represent data. This is however up tp the user to specify
% during the callign sequence for the function.
tssize = size(timeSeries);

% timeSeries can only have 2 columns max. Date and Time
if tssize(2) > 2
    msg = 'DATES and/or TIMES must be column oriented cell arrays. Please see HELP.';
    fts = [];
    return
elseif tssize(2) == 2 % If input is a matrix or cell array (size x by 2) of dates and times
    if tssize(1) ~= size(dataSeries,1)
        msg = sprintf(['Please check the inputs. A possible error could be that\n', ...
                'the dates and times are not in separate columns of the\n', ...
                'date and time matrix, or the lengths of the dates/times\n', ...
                'and data vectors are not equal.']);  
        fts = [];
        return
    end
    % Check for the one case where it is size 1x2. Unless timeSeries 2 is a time, do not let
    % this case go through
    if (tssize(1) == 1) & (tssize(2) == 2)
        if floor(timeSeries(1,2)) == timeSeries(1,2)    % time data are only floats
            msg = 'DATES and/or TIMES must be column vector. Please see HELP.';
            fts = [];
            return
        end
    end
    
    if isnumeric(timeSeries)% i.e. a=[date;date2;...]; b=[time;time2;...]; fints([a b],(1:x)') 
        % timeSeries(:,1) are floats --> invalid entry
        if rem(timeSeries(:,1),1) ~= 0
            msg = 'Invalid DATE and/or TIME.';
            fts = [];
            return
        end
        
        % Set up dates and times
        [timetimeAndDates,idxNST,msg2] = rmvsec(timeSeries(:,1)+timeSeries(:,2));
        
        [Y,M,D,H,MI,S] = datevec(timetimeAndDates);
        allZeros = zeros(length(Y),1);
        
        roundedS = round(S);
        loc60 = find(roundedS == 60);
        S = allZeros;
        S(loc60) = 60;
        
        timetime = datenum([allZeros,allZeros,allZeros,H,MI,S]);    % Get time serial number
        dates = datenum([Y,M,D,allZeros,allZeros,allZeros]);        % Get date serial number
    elseif iscell(timeSeries)% i.e. a={'date';'date2';...}; b={'time';'time2';...}; fints([a b],(1:x)')
        
        % Locate ':' and determine how many there are
        charTimeSeries = char(timeSeries);
        colonLoc = find(charTimeSeries == ':');
        numColonLoc = length(colonLoc);
        
        % Invalid time input if there are no ': the length of 
        if isempty(colonLoc) | (numColonLoc < length(timeSeries))
            msg = 'Invalid or no TIME input. Please see HELP for correct syntax.';
            fts = [];
            return
        end
        
        % Remove second data, find the first instance of the date/time, return idx
        serialDT = datenum([char(timeSeries(:,1)), repmat(' ',length(timeSeries),1), char(timeSeries(:,2))]);
        
        [timetimeAndDates,idxNST,msg2] = rmvsec(serialDT);
        
        [Y,M,D,H,MI,S] = datevec(timetimeAndDates);
        allZeros = zeros(length(Y),1);
        
        roundedS = round(S);
        loc60 = find(roundedS == 60);
        S = allZeros;
        S(loc60) = 60;
        
        timetime = datenum([allZeros,allZeros,allZeros,H,MI,S]);    % Get time serial number
        dates = datenum([Y,M,D,allZeros,allZeros,allZeros]);        % Get date serial number
    end
else% If input is a column vector or cell array (size x by 1) of dates and times
    if tssize(1) ~= size(dataSeries,1)
        msg = sprintf(['Please check the inputs. A possible error could be that\n', ...
                'the dates and times are not in separate columns of the\n', ...
                'date and time matrix, or the lengths of the dates/times\n', ...
                'and data vectors are not equal.']);  
        fts = [];
        return
    end
    if isnumeric(timeSeries) % i.e. a=(now:now+2)'; b=(1:3)'; f=fints(a,b)
        % Pass off to datetime to parse
        [dt,dates,timetime,idxNST,msg] = datetime(timeSeries);
        if ~isempty(msg)
            dt = []; dates = []; timetime = []; fts = [];
            return
        end
    elseif iscell(timeSeries) % i.e. fints({'01-jan-2001 13:00';...},(1:x)')
        % Pass off to datetime to parse
        [dt,dates,timetime,idxNST,msg] = datetime(timeSeries);
        if ~isempty(msg)
            dt = []; dates = []; timetime = []; fts = [];
            return
        end
    else
        msg = 'Invalid input data type. Please see documentation for acceptable data types.';
        dt = []; dates = []; timetime = []; fts = [];
        return
    end % end 'if isnumeric(timeSeries)'
end % end 'if tssize(2) > 2'

% DATA
if isempty(idxNST)
    data = dataSeries;
else
    data = dataSeries(idxNST,:);
end

% Check to see if sizes of dates and data match up
if size(dates, 1) > size(data, 1),
    msg = 'Not enough DATA points for the number of DATES specified.';
    fts = [];
    return
elseif size(dates, 1) < size(data, 1),
    msg = 'Too many DATA points for the number of DATES specified.';
    fts = [];
    return
end

% DATANAMES
nseries = size(data, 2);
% Due to the constraint of having to be backward compatible, a single data name
% string must be allowed through even though the help says only cell arrays are allowed.
if (numMainArgIn >= 3) & ~isempty(dataseriesNames)  % If DATANAMES input is accessed
    if any(strcmp('',dataseriesNames))
        msg = 'One or more of the DATANAMES may be missing.';
        fts = [];
        return
    elseif ~iscell(dataseriesNames) & (ischar(dataseriesNames) & size(dataseriesNames,1) ~= 1)
        msg = 'DATANAMES must be a row/column cell array of data names.';
        fts = [];
        return
    end
    [datanames,msg] = dataNamesFcn(nseries,dataseriesNames);
    
    % Error out if there is a message.
    if ~isempty(msg)
        fts = [];
        return
    end
else                    
    datanames = (cellstr([repmat('series', nseries, 1) num2str((1:nseries)', '%0d')]))';
end

% FREQ
if (numMainArgIn >= 4)  & ~isempty(freqncy)         % If FREQ input is accessed
    [freqdata,msg] = freqDataFcn(freqncy);
    
    % Error out if there is a message.
    if ~isempty(msg)
        fts = [];
        return
    end
else                    
    freqdata = 0;
end

% DESC
if numMainArgIn >= 5    % if DESC input is accessed
    descdata = descrip; 
else                    
    descdata = ''; 
end 

% Setup the object structure
seriesnames = [{'desc', 'freq', 'dates'}, datanames,{'times'}];
seriesdata  = [{descdata}, {freqdata}, num2cell(dates, 1),{data}, ...
        {timetime}];
fts.names = seriesnames;
fts.data  = seriesdata;
fts.datacount = size(data, 1);
fts.serscount = size(datanames, 2);


% -Datanamesfcn-------------------------------------------------------------
function [datanames,msg] = dataNamesFcn(nseries,dataseriesNames)
%DATANAMESFCN creates data header names if they are specified as inputs to 
%   @FINTS/FINTS.

msg = '';

if any(~islegalname(dataseriesNames))
    msg = 'Illegal name(s) detected. Please check the name(s).';
    datanames = [];
    return
end
if ~iscell(dataseriesNames) & (size(dataseriesNames, 1)~=1),
    msg = 'DATANAMES must be a cell array of names.';
    datanames = [];
    return
elseif iscell(dataseriesNames)
    datanames = dataseriesNames(:)';
else
    datanames = {dataseriesNames};
end
if (size(datanames, 1)~=1)
    msg = 'DATANAMES must be a vector (row/column) cell array of strings.';
    datanames = [];
    return
else
    if (size(datanames, 2) < nseries)
        msg = 'Not enough DATANAMES for the number of data series.';
        datanames = [];
        return
    elseif (size(datanames, 2) > nseries)
        msg = 'Too many DATANAMES for the number of data series.';
        datanames = [];
        return
    end
end
if length(datanames) ~= length(unique(datanames))
    msg = 'DATANAMES must be unique.';
    datanames = [];
    return
else
    check = getnameidx(datanames, 'desc');
    if check
        msg = 'DATANAMES cannot be ''desc''.';
        datanames = [];
        return
    end
    check = getnameidx(datanames, 'freq');
    if check
        msg = 'DATANAMES cannot be ''freq''.';
        datanames = [];
        return
    end
    check = getnameidx(datanames, 'dates');
    if check
        msg = 'DATANAMES cannot be ''dates''.';
        datanames = [];
        return
    end
end


% -Freqdatafcn------------------------------------------------------------
function [freqdata,msg] = freqDataFcn(freqncy)
%FREQDATAFCN assigns a frequency to the FINTS object if it is specified as 
%   an input to @FINTS/FINTS.

msg = '';

if ischar(freqncy),
    switch lower(freqncy),
    case {'daily', 'd'},
        freqdata = 1;
    case {'weekly', 'w'},
        freqdata = 2;
    case {'monthly', 'm'},
        freqdata = 3;
    case {'quarterly', 'q'},
        freqdata = 4;
    case {'semiannual', 's'},
        freqdata = 5;
    case {'annual', 'a'},
        freqdata = 6;
    case {'unknown', 'u'},
        freqdata = 0;
    otherwise,
        msg = 'Invalid FREQ indicator. Please refer to the HELP screen for valid ones.';
        freqdata = [];
        return
    end
elseif isnumeric(freqncy),
    if (freqncy < 0) | (freqncy > 6),
        msg = 'Valid numeric FREQ indicator is between 0 and 6, inclusive.';
        freqdata = [];
        return
    end
    freqdata = freqncy;
else
    msg = 'Invalid FREQ indicator format. Please look at the HELP screen.';
    freqdata = [];
    return
end

% [EOF]
