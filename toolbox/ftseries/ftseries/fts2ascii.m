function stat = fts2ascii(fname, dates, data, colheads, desc, exttext)
%FTS2ASCII writes elements of time series data into a text (ASCII) file.
%
%   STAT = FTS2ASCII(FNAME, TSOBJ, EXTTEXT) writes the financial time
%   series object TSOBJ into an ASCII file named FNAME. The data in the
%   file will be tab-delimited. Please be sure to include an extension.
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
%      stat = fts2ascii('myfts_file.txt', myFts, 'My first text file saved')
%
%   STAT = FTS2ASCII(FNAME, DATES/TIMES, DATA) writes into an ASCII file
%   named FNAME the dates (and/or times) and data contained in the column
%   vector (or matrix) DATES/TIMES and column-oriented matrix DATA (each
%   column is a series).  DATES will be the first column (TIMES the second,
%   if time information exists) and the columns of DATA will be the subsequent
%   columns.
%
%   Please note that if times are to be written to the ASCII file, the 
%   DATE/TIMES input must be a matrix where the first column contains the
%   serial dates and the second column contains the serial times.
%
%   STAT = FTS2ASCII(FNAME, DATES/TIMES, DATA, COLHEADS, DESC, EXTTEXT) does
%   as described previously with the added feature of including some
%   header information such as description, column headers, and extra
%   description.  COLHEADS is a cell array of column headers (names); 
%   if supplied, first cell MUST always be the one for the DATES column.
%   COLHEADS will be written to the file just before the data themselves.
%   DESC is the description string which will be the first line in the
%   file.  EXTTEXT is an extra string which, if included, will be
%   written after the description line (i.e. line 2 in the file).
%
%   STAT indicates whether it's successful (1) or not (0).
%
%   The data in the file will be TAB-delimited.
%
%   For example:
%
%      dates = ['01-Jan-2001';'01-Jan-2001'; '02-Jan-2001'; ...
%              '02-Jan-2001'; '03-Jan-2001';'03-Jan-2001'];
%      times = ['11:00';'12:00';'11:00';'12:00';'11:00';'12:00'];
%      serial_dates_times = [datenum(dates), datenum(times)];
%      data = round(10*rand(6,2));
%
%      stat = fts2ascii('myfts_file2.txt',serial_dates_times,data, ...
%             {'dates';'times';'Data1';'Data2'},'My second text file saved')
%
%   See also @FINTS/FTS2ASCII.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.11.2.3 $   $Date: 2004/04/06 01:09:21 $

stat = 0;
timeData = 0;
monoWarnFlag = 0;

% Check input arguments.
switch nargin
case 1
    error('Ftseries:fints_fts2ascii:MinNumOfArgs', ...
        sprintf(['The minimum number of allowed inputs is as follows:\n', ...
            '1) Filename, Dates, and Data\n', ...
            '2) Filename and tsobj']));
case 2
    % 2 inputs require that the 2nd input be a tsobj 
    if ~isa(dates,'fints')
        error('Ftseries:fints_fts2ascii:TsobjMustBe2ndInput', ...
            'Either there are too few inputs or the second input is not a ''tsobj''.');
    end
case 3
    colheads = {''}; desc = ''; exttext = ''; stat = 1;
case 4
    % Check colheads
    if isempty(colheads)
        % Do nothing
    elseif ~iscell(colheads)
        error('Ftseries:fints_fts2ascii:ColHeadInvalid', ...
            'Column header names need to be in a cell array.');
    end
    
    desc = ''; exttext = ''; stat = 1;
case 5
    % Check colheads
    if isempty(colheads)
        % Do nothing
    elseif ~iscell(colheads)
        error('Ftseries:fints_fts2ascii:ColHeadInvalid', ...
            'Column header names need to be in a cell array.');
    end
    
    exttext = ''; stat = 1;
case 6
    % Check colheads
    if isempty(colheads)
        % Do nothing
    elseif ~iscell(colheads)
        error('Ftseries:fints_fts2ascii:ColHeadInvalid', ...
            'Column header names need to be in a cell array.');
    end
    
    stat = 1;
otherwise
    error('Ftseries:fints_fts2ascii:InvalidNumArgs', ...
        'Invalid number of input arguments.');
end

% Dates must be in the from of serial dates 
if ischar(dates) | iscell(dates)
    error('Ftseries:fints_fts2ascii:SerialDatesRequired', ...
        sprintf(['Please use DATENUM to convert the dates and/or times\n', ...
            'to serial dates and/or times.']));
end

% Sizes must be correct
if size(dates, 1) ~= size(data, 1)
    error('Ftseries:fints_fts2ascii:InvalidSize', ...
        'Number of dates and/or times does not match the number of rows of data.');
end 

% Check to see if dates include time info.
% If there is time info, separate the two
if size(dates,2) > 2
    error('Ftseries:fints_fts2ascii:TooManyColOrDatesNotAColVec', ...
        sprintf(['Either there are too many columns of dates and/or times\n', ... 
            'or dates is not a column vector.']));
elseif size(dates,2) == 2
    timeData = 1;
    times = dates(:,2);
    dates = dates(:,1);
elseif ~isempty(find(double(floor(dates) == dates) == 0))
    % If dates and times are one serial number (floats)
    error('Ftseries:fints_fts2ascii:SeparateDatesAndTimes', ...
        sprintf(['Dates must be the first column of the DATES/TIMES matrix\n', ...
            'and Times must be the second column of the DATES/TIMES matrix.']));
elseif size(dates,2) == 1
    % If dates is a column of serial numbers without times (integers)
    timeData = 0;
else
    error('Ftseries:fints_fts2ascii:IncorrectDatesAndTimes', ...
        'The DATES/TIMES input is incorrect.');
end

% Check the column hearder for correct order
if isempty(colheads)
    colheads = {''};
end
if ~isempty(colheads{1})
    if timeData == 1 % There is time data
        % Make sure 'dates' is first and then 'times' in colheads
        whereDates = strcmp(colheads,'dates');
        first = find(whereDates == 1);
        if isempty(first)
            error('Ftseries:fints_fts2ascii:ColHeaderDatesMustBe1st', ...
                'You must have a column header named DATES, and it must come first.');
        elseif first ~= 1
            error('Ftseries:fints_fts2ascii:DatesStrNotPresent', ...
                'The first string in the column header cell array must be DATES.');
        end
        whereTimes = strcmp(colheads,'times');
        second = find(whereTimes == 1);
        if isempty(second)
            error('Ftseries:fints_fts2ascii:ColHeaderTimesMustBe2nd', ...
                'You must have a column header named TIMES, and it must come second.');
        elseif second ~= 2
            error('Ftseries:fints_fts2ascii:TimesStrNotPresent', ...
                'The second string in the column header cell array must be TIMES.');
        end
        
        % Check to see that the # of column headings for the data is correct
        if (length(colheads)-2) ~= size(data, 2)
            error('Ftseries:fints_fts2ascii:Dates1stThenTimes2nd', ...
                sprintf(['The first name must be the name for the DATES column\n', ...
                    'and the second name must be the name for the TIMES.\n', ...
                    'column. The number of column headers (not including\n', ...
                    '''dates'' and ''times'') does not match the number\n', ...
                    'of data columns.']));
        end
    else % No time data
        % Make sure 'dates' is first and no 'times' in colheads
        whereDates = strcmp(colheads,'dates');
        first = find(whereDates == 1);
        if isempty(first)
            error('Ftseries:fints_fts2ascii:ColHeaderDatesMustBe1st', ...
                'You must have a column header named DATES, and it must come first.');
        elseif first ~= 1
            error('Ftseries:fints_fts2ascii:DatesStrNotPresent', ...
                'The first string in the column header cell array must be DATES.');
        end
        whereTimes = strcmp(colheads,'times');
        second = find(whereTimes == 1);
        if ~isempty(second)
            error('Ftseries:fints_fts2ascii:NoTimePresent', ...
                'There is no time information thus there cannot be a TIMES column header.');
        end
        
        % Check to see that the # of column headings for the data is correct
        if (length(colheads)-1) ~= size(data, 2)
            error('Ftseries:fints_fts2ascii:DatesMustCome1st', ...
                sprintf(['The first name must be the name for the DATES column.\n', ...
                    'The number of column headers (not including DATES)\n', ...
                    'does not match number of data columns.']));
        end
        
    end
    colheads = colheads(:);
end % end of 'if ~isempty(colheads{1})'

% Check to see if dates and times are monotonically increasing
if timeData == 0
    % No time data
    theSame = prod(double((dates == sort(dates))));
else
    % There is time data
    theSame = prod(prod((double((dates+times) == sort(dates+times)))));
end

% Turn off backtrace
wb = warning('off','backtrace');

% Warn of non-monotonically increasing dates
if theSame ~= 1
    warning('Ftseries:fints_fts2ascii:NonMonotonicDatesAndTimes', ...
        sprintf(['The dates and/or times in the referenced object\n', ...
            'were not monotonically increasing. It is recommended that\n', ...
            'all dates and/or times be in chronological order.\n']));
end

% Warn of duplicate dates
% Note: Keep this warning as the last warning displayed.
if timeData == 0
    % No time information
    if ftsuniq(dates) == 0
        warning('Ftseries:fints_fts2ascii:DuplicateDates', ...
            sprintf(['The dates in the object being written are not unique\n', ...
                'and duplicate dates exist. FINTS objects must not\n', ...
                'contain duplicate dates. The function FTSUNIQ may be\n', ...
                'of assistance in determining which dates are duplicates.\n']));
    end
else
    % Contains time information
    if ftsuniq(dates+times) == 0
        warning('Ftseries:fints_fts2ascii:DuplicateDatesAndTimes', ...
            sprintf(['The dates and times in the object being written are not\n', ...
                'unique and duplicate dates and times exist. FINTS\n', ...
                'objects must not contain duplicate dates and times.\n', ...
                'FTSUNIQ may be of assistance in determining which\n', ...
                'dates and times are duplicates.\n']));
    end
end

% Restore old backtrace state 
warning(wb)

% Open a text (ASCII) file for writing.
fid = fopen(fname, 'wt');

% Write description and extra text, if supplied.
if ~isempty(desc)
    cnt = fprintf(fid, '%s\n', desc);
end
if ~isempty(exttext)
    cnt = fprintf(fid, '%s\n', exttext);
end

% Write column headers, if supplied.
if ~isempty(colheads{1})
    strfmt = ['%s \t', repmat('%s \t', 1, length(colheads)-2), '%s\n'];
    cnt = fprintf(fid, strfmt, colheads{:});
end

% Write the data into the file.
if timeData == 0
    % No time data
    for idx = 1:size(data, 1)
        strfmt = ['%s \t', repmat('%f \t', 1, size(data, 2)-1), '%f\n'];
        cnt = fprintf(fid, strfmt, datestr(dates(idx)), data(idx, :));
    end
else
    % There is time data
    for idx = 1:size(data, 1)
        strfmt = ['%s \t','%s \t',repmat('%f \t', 1, size(data, 2)-1), '%f\n'];
        cnt = fprintf(fid, strfmt, datestr(dates(idx)),datestr(times(idx),15), data(idx, :));
    end
end

% Close the file.
fclose(fid);

% [EOF]
