function display(fts)
%@FINTS/DISPLAY displays the financial time series object.  
%
%   This is the overloaded display method for the financial 
%   time series objects.  It inherits the MATLAB FORMAT setting. 
%   All, but HEX, +, and RAT, are supported by this display 
%   method.  The three unsupported FORMATS default to SHORT 
%   (the MATLAB default FORMAT).
%
%   If there is no Time data in the FINTS object, time will not
%   appear in the display of the object.
%
%   If Time data does exist and the dates and times are in 
%   chronological order, duplicate dates will appear as 
%   double quotes (") following the first instance of that date.
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
%      myFts = 
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
%   However, if Time data is not in chronological order, the dates
%   will be displayed without the double quotes (").
%
%   For example:
%
%      %% Create the FINTS object %%
%      dates2 = ['01-Jan-2001';'01-Jan-2001'; '02-Jan-2001'; ...
%              '02-Jan-2001'; '03-Jan-2001';'03-Jan-2001'];
%      times2 = ['11:00';'12:00';'11:00';'12:00';'11:00';'12:00'];
%      dates_times2 = cellstr([dates2, repmat(' ',size(dates2,1),1), times2]);
%      myFts2 = fints(dates_times2,(1:6)',{'Data1'},1,'My second FINTS')
%      %% Create the FINTS object %%
%
%      %% Reverse the time for '01-Jan-2001'
%
%      disp('Rearranging the time...')
%      disp(' ')
%      myFts2.times(1:2) = {'12:00','11:00'}
%
%   NOTE: Although the contents of the object is displayed as 
%         cells of a cell array, the object itself is NOT a cell 
%         array.  

%   Author: P. Wang, Raymond Norris
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.16.2.4 $   $Date: 2004/04/06 01:08:15 $

%-Main----------------------------------------------------------------------

% Check to see if the FTS object is new or old.
[ftsVersion,timeFlag] = fintsver(fts);

% Turn off backtrace
wb = warning('off','backtrace');

theLastWarning = lower(lastwarn);

% Warn if old object is being displayed and convert the object to a new object
if ftsVersion == 1
    warning('Ftseries:fints_display:OldVerOfFINTS', ...
        sprintf(['The FINTS object being displayed is an object of an old\n', ...
            'version of the Financial Time Series Toolbox. Some functionality\n', ...
            'of this version of the Financial Time Series Toolbox may not apply\n', ...
            'to this object. Please convert the object to a compatible version\n', ...
            'and use it when using the Financial Time Series Toolbox Version 2.0.\n', ...
            'Please see the function @FINTS/FTSOLD2NEW.\n']));
    
    % Convert from old to new only for display purposes. The actual object displayed
    % and the object in the workspace memory is still a version 1.0/1.1 object.
    w = warning('off');
    fts = ftsold2new(fts);
    warning(w);
end

% Check to see if all the dates and times are monotonically increasing
w2 = warning('off'); % This is necessary due to a duplicate warning msg in ISSORTED
monoD = issorted(fts);
warning(w2);

% Turn it off again (was turned on by the previous warning call)
wb = warning('off','backtrace');

if monoD ~= 1
    warning('Ftseries:fints_display:NonMonotonic', ...
        sprintf(['The dates and/or times in this object are not\n', ...
            'monotonically increasing. It is recommended that all\n', ...
            'dates and/or times be in chronological order. To sort\n', ...
            'the object please use the function @FINTS/SORTFTS.\n']));
end

% Display duplicate dates warning only if the last warning from before was not
% also a duplicate dates warning.
dupWarnMsg = strfind(theLastWarning,lower('FTSUNIQ'));
if isempty(dupWarnMsg)
    % Warn duplicate dates
    % Note: Keep this warning as the last warning displayed.
    if isempty(fts.data{5})
        % No time information
        if ftsuniq(fts.data{3}) == 0
            warning('Ftseries:fints_display:DuplicateDates', ...
                sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                    'exist. FINTS objects must not contain duplicate dates. The\n', ...
                    'function FTSUNIQ may be of assistance in determining which\n', ...
                    'dates are duplicates.\n']));
        end
    else
        % Contains time information
        if ftsuniq(fts.data{3}+fts.data{5}) == 0
            warning('Ftseries:fints_display:DuplicateDatesAndTimes', ...
                sprintf(['The dates and times in this object are not unique and\n', ...
                    'duplicate dates and times exist. FINTS objects must not\n', ...
                    'contain duplicate dates and times. The function FTSUNIQ\n', ...
                    'may be of assistance in determining which dates and times\n', ...
                    'are duplicates.\n']));
        end
    end
end
% Reset lastwarn
lastwarn('')

% Restore old backtrace state 
warning(wb)

% Setup display for output variable (i.e. ans = ... or fts = ... or etc)
disp(' ');
disp([inputname(1), ' = ']);
disp(' ');

% Setup description information
descdata = cell(1, length(fts.names)-2);
descdata(:) = {''};
if isempty(fts.data{1})
    descdata = '(none)';
else
    descdata = fts.data{1};
end

% Setup frequncy information
freqdata = cell(1, length(fts.names)-2);
freqdata(:) = {''};
if isempty(fts.data{2})
    freqdata = '(none)';
else
    freqdata = [freqstr(fts.data{2}), ' (', num2str(fts.data{2}),')'];
end

% Set up header information
if timeFlag == 1 % If there is time, make extra header label (time)
    headdata = cell(1, length(fts.names)-2);                        % -2 b/c need 3+ columns
    headdata{1} = ['dates:  (', num2str(size(fts.data{3},1)), ')']; % First column = dates header
    headdata{2} = ['times:  (', num2str(size(fts.data{3},1)), ')']; % Second column = times header
    for idx = 1:length(fts.names)-4                                 % >= Third column = data header
        if isempty(fts.data{4})
            headdata{idx+2} = [fts.names{idx+3}, ':  (0)'];         % idx+2 b/c data in 3rd column 
        else
            headdata{idx+2} = [fts.names{idx+3}, ':  (', ...
                    num2str(size(fts.data{4}(:, idx), 1)), ')'];
        end
    end
else
    headdata = cell(1, length(fts.names)-3);                        % -3 b/c need 2+ columns
    headdata{1} = ['dates:  (', num2str(size(fts.data{3},1)), ')']; % First column = dates header
    for idx = 1:length(fts.names)-4                                 % >= second column = data header
        if isempty(fts.data{4})
            headdata{idx+1} = [fts.names{idx+3}, ':  (0)'];         % idx+1 b/c data in 2nd column
        else
            headdata{idx+1} = [fts.names{idx+3}, ':  (', ...
                    num2str(size(fts.data{4}(:, idx), 1)), ')'];
        end
    end
end

% Split headers if there are long data series names
headdata = splitHeaders(headdata);

% Setup component data  
sersdata = num2cell(fts.data{4});   % Convert data into cell's

if length(fts) == 0 % If there fts object is empty, just display the header and warning                                                        
    ftscontent = headdata;
    compdata = '';
    warning('Ftseries:fints_display:ObjectEmpty', ...
        'Need at least 2 columns: The DATES and DATA columns.')
elseif timeFlag == 1
    compdata = cell(fts.datacount, length(fts.names)-2);    % Setup empty cell array
    if monoD == 1
        % If dates and times are in chronologic order, allow for the "dittoing" display
        compdata(:, 1) = takeout(fts);                      % Fill cell array column 1 with dates
    else
        % If dates and times are not in chronologic order, show all dates and times
        compdata(:, 1) = cellstr(datestr(fts.data{3},1));   % Fill cell array column 1 with dates
    end
    compdata(:, 2) = cellstr(datestr(fts.data{end}, 15));   % Fill cell array column 2 with times 
    compdata(:, 3:end) = sersdata;                          % Fill rest of cell array with data
elseif timeFlag == 0
    compdata = cell(fts.datacount, length(fts.names)-3);    % Setup empty cell array
    compdata(:, 1) = cellstr(datestr(fts.data{3}, 1));      % Fill cell array column 1 with dates
    compdata(:, 2:end) = sersdata;                          % Fill rest of cell array with data            
end

% Display everything
filler = cell(1, length(fts.names)-2);
filler(:) = {''};
ftscontent = [headdata; compdata];

% Convert desc to char. This allows for desc to be a cell array.
descdata = char(descdata);

% Try to display object, error out if unable.
try
    fprintf('    desc:  %s\n',   descdata);
    fprintf('    freq:  %s\n\n', freqdata);
    disp(ftscontent)
catch
    errMsg = lasterror;
    errMsg = cleanerrormsg(errMsg.message);
    error('Ftseries:fints:display:DisplayError', 'Display error.');
end

% -Take out duplicate dates--------------------------------------
function newCompdata2 = takeout(fts)
%NEWCOMPDATA2 takes out duplicate dates if different times exist 
%             for that date.

uniqDates = unique(fts.data{3});        % Find unique dates
lenUniqDates = length(uniqDates);       % Number of unique dates

if lenUniqDates == size(fts.data{3},1)  % If no repeated dates, show all
    newCompdata2 = cellstr(datestr(fts.data{3}, 1));
else                                    % Else take out the duplicates
    
    % Where the first instance of each unique name exists
    for uniqNameCount = 1:lenUniqDates
        uniqHere(uniqNameCount) = min(find(fts.data{3} == (uniqDates(uniqNameCount)))); 
    end
    
    % Preallocate empty array
    holdUniq = (zeros(1,size(fts.data{3},1)))';
    
    % Place unique names
    for count2 = 1:lenUniqDates
        holdUniq(uniqHere(count2)) = (uniqDates(count2));
    end
    
    % Create cellstr out of array of unique names
    % All repeated dates are converted to '00-Jan-0000'.
    Compdata2 = cellstr(datestr(holdUniq,1));
    
    % Replace the "repeated dummy" dates (0 == 00-Jan-0000) with "
    newCompdata2 = strrep(Compdata2,'00-Jan-0000','     "     ');
end


% -Split Headers------------------------------------------------
function headdata = splitHeaders(headdata)
%SPLITHEADERS allows for long headers by splitting each header
%             into rows of 19 characters.

% Contributed by Raymond Norris

% Short names
%headdata = ({'dates:  (3)' 'times:  (3)' 'series1:  (3)'})
% Long names
%headdata = ({'dates:  (3)xxxxxxxxx' 'times:  (3)' 'series1:  (3)'})

% Align the headers over each other
header = strvcat(headdata{:});

% Maximum number of rows
maxRows = ceil(size(header,2)/19);

% If long names exist, split headers
if maxRows > 1
    
    % Pad headers to be a multiple of 19
    header(:,(end+1):(19*maxRows)) = ' ';
    
    % Number of columns
    numCols = length(headdata);
    
    % Pre allocate new  
    holdNewHeader = cell(maxRows,numCols);
    
    % Loop through rows of headers, parsing characters into
    % temporary header
    for idx = 1:maxRows
        for jdx = 1:numCols
            holdNewHeader{idx,jdx} = header(jdx, (idx-1)*19+1:idx*19);
        end
    end
    headdata = holdNewHeader;
end

% [EOF]
