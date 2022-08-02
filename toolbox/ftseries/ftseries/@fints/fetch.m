function ftsnew = fetch(fts,fromdat,fromtim,todat,totim,varargin)
%@FINTS/FETCH Overloaded for FINTS object: requests data from a
%   FINTS object.
%
%   FTSNEW = FETCH(FTS,SD,ST,ED,ET,DELTA,DMY_SPECIFIER) requests
%   data from the FINTS object beginning from the Starting Date (SD)
%   and/or Starting Time (ST) to the Ending Date (ED) and/or Ending 
%   Time (ET) skipping DELTA Days, Months, or Years depending on the
%   DMY_SPECIFIER. 
%   
%   DELTA can be any positive integer.
% 
%   DMY_SPECIFIER's include: 
%                           D,d = Days
%                           M,m = Months
%                           Y,y = Years
%
%   NOTE: If specific times are not necessary or if there is no time 
%   information, replace Starting Time (ST) and Ending Time (ET) with []. 
%   If there is time information, the use of [] will result in FETCH 
%   returning all instances of a specific date. However, if a Starting Time
%   (ST) is specified, an ending time must also be specified, and vice versa. 
%
%   For example:
%
%      %% Create the FINTS object %%
%      dates = ['01-Jan-2001';'01-Jan-2001'; '02-Jan-2001'; ...
%              '02-Jan-2001'; '03-Jan-2001';'03-Jan-2001'];
%      times = ['11:00';'12:00';'11:00';'12:00';'11:00';'12:00'];
%      dates_times = cellstr([dates, repmat(' ',size(dates,1),1), times]);
%      myFts = fints(dates_times,(1:6)',{'Data1'},1,'My first FINTS')
%      %% Create the FINTS object %%
%
%   Syntax to fetch every date (and time):
%
%      fetch(myFts,'01-Jan-2001',[],'03-Jan-2001',[],1,'d')
%
%      or
%
%      fetch(myFts,'01-Jan-2001','11:00','03-Jan-2001','12:00',1,'d')
%
%      ans = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%      '01-Jan-2001'    '11:00'          [          1]
%      '     "     '    '12:00'          [          2]
%      '02-Jan-2001'    '11:00'          [          3]
%      '     "     '    '12:00'          [          4]
%      '03-Jan-2001'    '11:00'          [          5]
%      '     "     '    '12:00'          [          6]
%
%   Syntax to fetch data every 2 days:
%
%      fetch(myFts,'01-Jan-2001',[],'03-Jan-2001',[],2,'d')
%
%      ans = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (4)'    'times:  (4)'    'Data1:  (4)'
%      '01-Jan-2001'    '11:00'          [          1]
%      '     "     '    '12:00'          [          2]
%      '03-Jan-2001'    '11:00'          [          5]
%      '     "     '    '12:00'          [          6]
%   
%   FTSNEW = FETCH(FTS,SD,ST,ED,ET,DELTA,DMY_SPECIFIER,TIME_REF) requests
%   data from the FINTS object beginning from the Starting Date (SD) and/or
%   Starting Time (ST) to the Ending Date (ED) and/or Ending Time (ET) at
%   specific Time Reference (TIME_REF) intervals or at specific times.
%   NOTE: DELTA must be set to one (1) and the DMY_SPECIFIER must be set to
%   'd' in this specific function call. 
%
%   Valid TIME_REF intervals are 1 min, 5 min, 15 min, or 60 min (hourly).
%
%   The only valid TIME_REF time form is 'hh:mm'. Specific dates can only be
%   entered as a row/column cell array.
%
%   For example, to fetch data every 5 minutes:
%
%      %% Create the FINTS object %%
%      dates2 = ['01-Jan-2001';'01-Jan-2001'; '01-Jan-2001'; ...
%              '02-Jan-2001'; '02-Jan-2001';'02-Jan-2001'];
%      times2 = ['11:00';'11:05';'11:06';'12:00';'12:05';'12:06'];
%      dates_times2 = cellstr([dates2, repmat(' ',size(dates2,1),1), times2]);
%      myFts2 = fints(dates_times2,(1:6)',{'Data1'},1,'My second FINTS')
%      %% Create the FINTS object %%
%
%      fetch(myFts2,'01-Jan-2001',[],'02-Jan-2001',[],1,'d',5)
% 
%      ans = 
% 
%      desc:  My second FINTS
%      freq:  Daily (1)
%
%      'dates:  (4)'    'times:  (4)'    'Data1:  (4)'
%      '01-Jan-2001'    '11:00'          [          1]
%      '     "     '    '11:05'          [          2]
%      '02-Jan-2001'    '12:00'          [          4]
%      '     "     '    '12:05'          [          5]
%   
%   To specify specific times please use the syntax:
%
%   FTSNEW = FETCH(FTS,SD,ST,ED,ET,DELTA,DMY_SPECIFIER,{'Time1','Time2',...})
%
%   For example, to fetch data only at '11:06' and '12:06' from myFts2:
%
%      fetch(myFts2,'01-Jan-2001',[],'02-Jan-2001',[],1,'d',{'11:06';'12:06'})
% 
%      ans = 
% 
%      desc:  My second FINTS
%      freq:  Daily (1)
%
%      'dates:  (2)'    'times:  (2)'    'Data1:  (2)'
%      '01-Jan-2001'    '11:06'          [          3]
%      '02-Jan-2001'    '12:06'          [          6]
%
%    See also @FINTS/EXTFIELD, @FINTS/FTSBOUND, @FINTS/GETFIELD, @FINTS/SUBSREF.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.9.2.4 $   $Date: 2004/04/06 01:08:16 $

% Constants
msgFlag = 0;
firstDelta = 0;

% Check number of arguments
error(nargchk(7,8,nargin));

% Determine version and if there is time info
try
    [ftsVersion,timeData] = fintsver(fts);
catch
    error('Ftseries:ftseries_fints_fetch:NonFintsObject', ...
        'The first input must be a FINTS object.');
end

% Convert old fts object to new object
% Although ftsold2new calls fintsver, I still needed to call fintsver(above)
% to get the version number 
w = warning('off');
fts = ftsold2new(fts);
warning(w);

% Turn off backtrace
wb = warning('off','backtrace');

% Warn of object conversion
if ftsVersion == 1
    warning('Ftseries:ftseries_fints_fetch:ObjVerConverted', ...
        sprintf(['The FINTS object being referenced is an object\n' ...
            'from an earlier version of the Financial Time Series\n', ...
            'Toolbox (1.0 or 1.1), and the object being displayed\n', ...
            'has been converted to an object compatible with the\n', ...
            'Financial Time Series Toolbox Version 2.0. Please\n', ...
            'save and use this new object instead of the older\n', ...
            'object. If you would like to update any existing old\n', ...
            'objects, please see the functions @FINTS/FINTSVER and\n', ...
            '@FINTS/FTSOLD2NEW.\n']));
end

% Check to see if all the dates and times are monotonically increasing
w2 = warning('off'); % This is necessary due to a duplicate warning msg in ISSORTED
monoD = issorted(fts);
warning(w2);

% Turn it off again (was turned on by the previous warning call)
wb = warning('off','backtrace');

if monoD ~= 1
    fts = sortfts(fts);
    warning('Ftseries:ftseries_fints_fetch:NonMonotonic', ...
        sprintf(['The dates and/or times in the referenced object\n', ...
            'were not monotonically increasing. It is recommended that\n', ...
            'all dates and/or times be in chronological order.\n']));
end

% Warn of duplicate dates
% Note: Keep this warning as the last warning displayed.
if timeData == 0
    % No time information
    if ftsuniq(fts.data{3}) == 0
        warning('Ftseries:ftseries_fints_fetch:DuplicateDates', ...
            sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                'exist. FINTS objects must not contain duplicate dates. The\n', ...
                'function FTSUNIQ may be of assistance in determining which\n', ...
                'dates are duplicates.\n']));
    end
else
    % Contains time information
    if ftsuniq(fts.data{3}+fts.data{end}) == 0
        warning('Ftseries:ftseries_fints_fetch:DuplicateDatesAndTimes', ...
            sprintf(['The dates and times in this object are not unique and\n', ...
                'duplicate dates and times exist. FINTS objects must not\n', ...
                'contain duplicate dates and times. The function FTSUNIQ\n', ...
                'may be of assistance in determining which dates and\n', ...
                'times are duplicates.\n']));
    end
end

% Restore old backtrace state 
warning(wb)

% Do not allow for time inputs if there is no time data
if (timeData == 0) & (~isempty(fromtim) | ~isempty(totim))
    error('Ftseries:ftseries_fints_fetch:NoTimeInfo', ...
        sprintf(['Time information does not exist in the object. Please\n', ...
            'use [] as place holders for the time inputs.']));
end

% Check starting date (fromdat) and ending date (todat)
if isempty(fromdat)
    error('Ftseries:ftseries_fints_fetch:NoStartingDate',...
        'Please enter a starting date. A starting and ending date must exist.');
elseif isempty(todat)
    error('Ftseries:ftseries_fints_fetch:NoEndingDate',...
        'Please enter an ending date. A starting and ending date must exist.');
elseif ~ischar(fromdat)
    error('Ftseries:ftseries_fints_fetch:StartingDateMustBeString',...
        'The starting date must be a string.');
elseif ~ischar(todat)
    error('Ftseries:ftseries_fints_fetch:EndingDaterMustBeString',...
        'The ending date must be a string.');
end

% Check starting time (fromtim) and ending time (totim) for objects w/ time data
if (timeData ~= 0) & (~isempty(fromtim) | ~isempty(totim))
    if ~isempty(fromtim) & isempty(totim)
        if ~ischar(totim)
            error('Ftseries:ftseries_fints_fetch:NoEndingTime', ...
                sprintf(['An ending time is required since there exists a starting time.\n', ...
                    'The time must be entered as a string.']));
        else
            error('Ftseries:ftseries_fints_fetch:NoEndingTime', ...
                'An ending time is required since there exists a starting time.');
        end
    elseif isempty(fromtim) & ~isempty(totim)
        if ~ischar(fromtim)
            error('Ftseries:ftseries_fints_fetch:NoStartingTime', ...
                sprintf(['A starting time is required since there exists an ending time.\n', ...
                    'The time must be entered as a string.']));
        else
            error('Ftseries:ftseries_fints_fetch:NoStartingTime', ...
                'A starting time is required since there exists an ending time.');
        end
    elseif ~ischar(fromtim)
        error('Ftseries:ftseries_fints_fetch:StartingTimeMustBeString', ...
            'The starting time must be a string.');
    elseif ~ischar(totim)
        error('Ftseries:fetch:EndingTimeMustBeString', ...
            'The ending time must be a string.');
    end
end

% Set varargin's to variables and check
if nargin >= 6
    delta = varargin{1};        % nargin == 6
    
    % Check type
    if ~isnumeric(delta)
        error('Ftseries:ftseries_fints_fetch:DeltaMustBeNumeric', ...
            'The entry for the ''DELTA'' field must be an integer.');
    elseif ((rem(delta,1)) ~= 0 | (delta < 0)) 
        % Must be integer values greater than 1
        error('Ftseries:ftseries_fints_fetch:DeltaMustBeIntegerLargerThanOne', ...
            'The entry for the ''DELTA'' field must be an integer greater than or equal to one.');
    elseif isempty(delta)
        error('Ftseries:ftseries_fints_fetch:EnterADelta', ...
            'Please enter a value for ''DELTA''.');
    end    
end

if nargin >= 7
    dmySpecifier = varargin{2}; % nargin == 7
    
    % Check type
    if ~ischar(dmySpecifier)
        error('Ftseries:ftseries_fints_fetch:DmyspecifierMustBeString', ...
            'The entry for the Day, Month, and Year Specifier must be a string.');
    end
    
    dmySpecifier = lower(strtrim(dmySpecifier));
end

if nargin >= 8
    timeRef = varargin{3};      % nargin == 8
    
    % Check type
    if ~iscell(timeRef) & ~isnumeric(timeRef)
        error('Ftseries:ftseries_fints_fetch:TimerefMustBeCellOrNumeric', ...
            sprintf(['The ''Time References'' must be a cell array of string ', ...
                'times or the numbers 1, 5, 15, 60.']));
    elseif isempty(timeRef)
        error('Ftseries:ftseries_fints_fetch:EnterTimes', ...
            'Please enter times to be fetched.');        
    end
end

% Get the starting date/time
try
    startDateNum = datenum(fromdat);
catch
    error('Ftseries:ftseries_fints_fetch:InvalidStartingDate', ...
        'The starting date string may be invalid. Please check the date.');
end

if isempty(fromtim) % Date reference and no time reference
    % Find the min data row idx
    datarowStart = min(find(startDateNum == fts.data{3}));
    % Find all the rows that contain this date
    datarowStartAll = find(startDateNum == fts.data{3});
else                % Date reference with time reference
    % Find data row idx'es
    daterowS = find(startDateNum == fts.data{3});
    
    % Check to see if the from date exists
    if isempty(daterowS)
        error('Ftseries:ftseries_fints_fetch:FromDateNotInObject', ...
            sprintf(['The starting date may be invalid, not in the object,\n', ...
                'or may not correspond to the starting date.']));
    end
    
    % This function will only allow entries without sec. thus no need to
    % convert S = all zeros.
    % Get the correct datarows by comparing the serial dates/times.
    % Comparing via a tolerance of 0.001 seconds.
    try
        serStartTime = datenum(fromtim) - datenum('00:00:00');
    catch
        error('Ftseries:ftseries_fints_fetch:StartTimeInvalid', ...
            'The starting time may be invalid. Please check its syntax.');
    end
    
    tDiff = abs(serStartTime - fts.data{5}(daterowS));
    wantedDatarowsLocation = tDiff < (0.001/60/60/24);  
    
    datarowStart = daterowS(logical(wantedDatarowsLocation));
    datarowStartAll = daterowS;
end

% Does the date or date/time exist
if isempty(datarowStart)
    error('Ftseries:ftseries_fints_fetch:InfoNotInObject', ...
        'The starting date or date and time does not exist in the object.');
end

% Get the ending date/time
try
    endDateNum = datenum(todat);
catch
    error('Ftseries:ftseries_fints_fetch:InvalidEndingDate', ...
        'The ending date string may be invalid. Please check the date.');
end

if isempty(totim)   % Date reference and no time reference
    % Find the min data row idx
    datarowEnd = max(find(endDateNum == fts.data{3}));
    % Find all the rows that contain this date
    datarowEndAll = max(find(endDateNum == fts.data{3}));
else                % Date reference with time reference
    % Find data row idx'es
    daterowE = find(endDateNum == fts.data{3});
    
    % Check to see if the to date exists
    if isempty(daterowE)
        error('Ftseries:ftseries_fints_fetch:ToDateNotInObject', ...
            sprintf(['The ending date may be invalid, not in the object,\n', ...
                'or may not correspond to the ending date.']));
    end
    
    % This function will only allow entries without sec. thus no need to
    % convert S = all zeros.
    % Get the correct datarows by comparing the serial dates/times.
    % Comparing via a tolerance of 0.001 seconds.
    try
        serEndTime = datenum(totim) - datenum('00:00:00');
    catch
        error('Ftseries:ftseries_fints_fetch:EndTimeInvalid', ...
            'The ending time may be invalid. Please check its syntax.');
    end
    
    tDiff = abs(serEndTime - fts.data{5}(daterowE));
    wantedDatarowsLocation = tDiff < (0.001/60/60/24);  
    
    datarowEnd = daterowE(logical(wantedDatarowsLocation));
    datarowEndAll = daterowE;
end

% Does the date or date/time exist
if isempty(datarowEnd)
    error('Ftseries:ftseries_fints_fetch:InfoNotInObject', ...
        'The ending date or date and time does not exist in the object.');
end

% Number dates with the delta specification 
numElements = (datarowEnd - datarowStart) + 1;

dataIdx = 2;

% Process delta for days, months, and years
switch dmySpecifier
case{'d'}   % Days
    if nargin == 7
        % w/o individual time specifiers
        % Create a list of wanted dates
        datesWanted = (fts.data{3}(datarowStart):delta:fts.data{3}(datarowEnd))';
        
        % Get data rows of the wanted dates from the superlist of dates
        intersectingDates = intersect(fts.data{3}(datarowStart:datarowEnd),datesWanted);
        members = ismember(fts.data{3}(datarowStart:datarowEnd),intersectingDates);
        superDatarowList = (datarowStart:datarowEnd)';
        
        datarowOut = superDatarowList(members);
    elseif nargin == 8  % w/ individual time specifiers
        % delta must be 1 to search by 1, 5, 15, or 60 min
        % Some checks
        if delta ~= 1
            error('Ftseries:ftseries_fints_fetch:DeltaMustBe1', ...
                'The ''DELTA'' option must be set to 1.');
        elseif timeData == 0
            error('Ftseries:ftseries_fints_fetch:NoTimeInfo', ...
                'There is no time information in the object. Please do not specify a ''Time Specifier''.');
        end
        
        % Retreiving time intervals
        % i.e. time = datestr(now:5/60/24:now+5/24,15)
        if isnumeric(timeRef)   % delta must be 1 to search by 1, 5, 15, or 60 min
            if timeRef == 1
                datarowOut = datarowStart:datarowEnd;
            else
                if timeRef == 5
                    timeChange = 5/60/24;   % 5 seconds
                elseif timeRef == 15
                    timeChange = 15/60/24;  % 15 seconds
                elseif timeRef == 60
                    timeChange = 60/60/24;  % 60 seconds / 1 hour
                else
                    error('Ftseries:ftseries_fints_fetch:InvalidTimeReference', ...
                        'The ''Time Reference'' can only be 1 min, 5 min, 15 min, or 60 min (hourly).');
                end
                
                if ~isempty(fromtim)
                    startingDateNTime = datenum(fromdat) + (datenum(fromtim) - datenum('00:00:00'));
                else
                    startingDateNTime = datenum(fromdat) + datenum(fts.data{5}(min(datarowStartAll)));
                end
                if ~isempty(fromtim)
                    endingDateNTime = datenum(todat) + (datenum(totim) - datenum('00:00:00'));
                else
                    endingDateNTime = datenum(todat) + datenum(fts.data{5}(max(datarowEndAll)));
                end
                
                % Create a list of wanted times and dates
                wantedDatesNTime = startingDateNTime:timeChange:endingDateNTime;
                
                % Create a list of dates and times out of the user data that do not have seconds.
                % The S in this case is "== 0" already
                timesWithNoSec = fts.data{5}(datarowStart:datarowEnd);
                
                % Get date/time serial numbers and the indices of where these serial dates are 
                ourDatesNTimeSerial = (fts.data{3}(datarowStart:datarowEnd) + timesWithNoSec);
                ourDatesNTimeIdx = (datarowStart:datarowEnd)';
                
                datarowOut = [];
                % Find the dates/times wanted in our list of dates/times
                for idxWT = 1:length(wantedDatesNTime)
                    % Get the correct datarows by comparing the serial dates/times.
                    % Comparing via a tolerance of 0.001 seconds.
                    dtDiff = abs(wantedDatesNTime(idxWT) - ourDatesNTimeSerial);
                    wantedDatarowsLocation = dtDiff < (0.001/60/60/24);
                    datarowOut = [datarowOut; ourDatesNTimeIdx(logical(wantedDatarowsLocation))];
                end 
            end % end of 'if timeRef == 1'
        else    % specifying specific times; i.e. fetch(fts,....,1,'d',{'9:30';'10:30';...})
            
            % Remove all second data from the time Ref and get its serial nums
            try
                [Y,M,D,H,MI,S] = datevec(timeRef);
            catch
                error('Ftseries:ftseries_fints_fetch:InvalidTimeReference', ...
                    'The ''Time Reference'' may contain invalid times.');
            end
            
            roundedS = round(S);
            loc60 = find(roundedS == 60);
            S = zeros(length(Y),1);
            S(loc60) = 60;
            
            %timeRefSerial = datenum([Y,M,D,H,MI,S]);
            timeRefSerial = datenum([S,S,S,H,MI,S]);
            
            % Check to see if there are any duplicate dates
            lenBeforeUniq = length(timeRef);
            lenAfterUniq = length(unique(timeRef));
            if (lenBeforeUniq ~= lenAfterUniq)
                error('Ftseries:ftseries_fints_fetch:DuplicateTimeReferences', ...
                    'Please remove any duplicate ''Time Reference'' dates.');
            end
            
            % Get serial time numbers and the indices of where these serial dates are 
            ourTimeSerial = fts.data{5}(datarowStart:datarowEnd);
            ourTimeSerialIdx = (datarowStart:datarowEnd)';
            
            datarowOut = [];
            % Find the dates/times wanted in our list of dates/times
            for idxT = 1:length(timeRefSerial)
                % Get the correct datarows by comparing the serial dates/times.
                % Comparing via a tolerance of 0.001 seconds.
                tDiff = abs(timeRefSerial(idxT) - ourTimeSerial);
                wantedDatarowsLocation = tDiff < (0.001/60/60/24);
                datarowOut = [datarowOut; ourTimeSerialIdx(logical(wantedDatarowsLocation))];
                % Make sure all the dates appear in the right order
                datarowOut = sort(datarowOut);
            end 
        end % end of 'if ~iscell(timeRef)'
    end % end of 'if nargin == 7'
case{'m'}   % Months
    % Check to see if a time reference is specified
    if nargin == 8
        error('Ftseries:ftseries_fints_fetch:ErrorUsingTimeref', ...
            'A ''Time Reference'' should not be specified when the ''Monthly Specifier'' is used.');
    end
    
    % Check for valid deltas
    if (rem(delta,1) ~= 0) | (delta < 1) 
        error('Ftseries:ftseries_fints_fetch:InvalidMonthlySpecifier', ...
            'The ''Monthly Specifier'' must be an integer between 1 and 11 inclusive.');
    elseif delta > 11
        error('Ftseries:ftseries_fints_fetch:UseYearlySpecifier', ...
            'The ''Yearly Specifier'' must be used in this case.');
    end
    
    % Months of the dates wanted; first column contains the months, second column
    % contains the actual row indices of the data in the object
    currentMonths(:,1) = month(fts.data{3}(datarowStart:datarowEnd));
    currentMonths(:,2) = (datarowStart:datarowEnd)';
    
    % Get every "delta" months
    minMonth = min(currentMonths(:,1));
    maxMonth = max(currentMonths(:,1));
    deltaMonths = minMonth:delta:maxMonth;
    
    % Determine months wanted 
    largerThan12 = deltaMonths > 12;
    adjMonths = deltaMonths(largerThan12) - 12;
    deltaMonths(largerThan12) = adjMonths;
    monthsWanted = deltaMonths;
    
    % Get the data rows for the months wanted
    datarowOut = [];
    for idxMW = 1:length(monthsWanted)
        holdDatarowMW = find(currentMonths(:,1) == monthsWanted(idxMW));
        datarowOut = [datarowOut ; currentMonths(holdDatarowMW,2)];
    end
    
case{'y'}   % Years
    % Check to see if a time reference is specified
    if nargin == 8
        error('Ftseries:ftseries_fints_fetch:ErrorUsingTimeref', ...
            'A ''Time Reference'' should not be specified when the ''Yearly Specifier'' is used.');
    end
    
    % Check for valid deltas
    if (rem(delta,1) ~= 0) | (delta < 1) 
        error('Ftseries:ftseries_fints_fetch:InvalidyearlySpecifier', ...
            'The ''Yearly Specifier'' must be an integer greater than one.');
    end
    
    % Years of the dates wanted; first column contains the years, second column
    % contains the actual row indices of the data in the object
    currentYears(:,1) = year(fts.data{3}(datarowStart:datarowEnd));
    currentYears(:,2) = (datarowStart:datarowEnd)';
    
    % Get every "delta" years
    minYear = min(currentYears(:,1));
    maxYear = max(currentYears(:,1));
    deltaYears = minYear:delta:maxYear;
    
    % Get the data rows for the years wanted
    datarowOut = [];
    for idxYW = 1:length(deltaYears)
        holdDatarowYW = find(currentYears(:,1) == deltaYears(idxYW));
        datarowOut = [datarowOut ; currentYears(holdDatarowYW,2)];
    end
otherwise
    error('Ftseries:ftseries_fints_fetch:DMYSpecifierIncorrect', ...
        sprintf(['''', '%s' ,''' is not a valid Day, Month, or Year Specifier.'], dmySpecifier));
end % End of 'switch dmySpecifier'

% Create new empty object
ftsnew = fints;

% Fill new object
ftsnew.names      = fts.names;    
ftsnew.data{1}    = fts.data{1};                % Description
ftsnew.data{2}    = fts.data{2};                % Frequency
ftsnew.data{3}    = fts.data{3}(datarowOut);    % Dates  
ftsnew.data{4}    = fts.data{4}(datarowOut, :); % Data

% Check to see if there is time
if timeData == 0
    ftsnew.data{5}= fts.data{5};                % Time
else
    ftsnew.data{5}= fts.data{5}(datarowOut);    % Time
end

ftsnew.datacount  = size(ftsnew.data{3},1);
ftsnew.serscount  = fts.serscount;

% Restore old backtrace state 
warning(wb)

% [EOF]
