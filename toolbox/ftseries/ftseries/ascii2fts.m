function fts = ascii2fts(fname, varargin)
%ASCII2FTS generate a FINTS object from an ASCII data file.
%
%   FTS = ASCII2FTS(FILENAME, DESCROW, COLHEADROW, SKIPROWS) creates
%   a financial time series object FTS from the ASCII file named
%   FILENAME.  DESCROW, COLHEADROW, and SKIPROWS are optional input
%   arguments which can be substituted with []'s. 
%   
%   NOTE: This specific function call will only read a data file
%   WITHOUT time information and create an object without time
%   information.
%
%   DESCROW (optional) indicates the row number in the data file
%   that contains the description to be used for the description field
%   of the financial time series object.
%
%   COLHEADROW (optional) indicates the row number that has the column
%   headers/names.
%
%   SKIPROWS (optional) is a scalar or vector of row numbers to be 
%   skipped in the data file.
%
%   For example:
%                 dis = ascii2fts('DISNEY.dat', 1, 3, 2);
%
%   FTS = ASCII2FTS(FILENAME, TIMEDATA, DESCROW, COLHEADROW, SKIPROWS)
%   is similar to the above except that it can create an object with
%   time information. TIMEDATA is a string indicating whether there is
%   time information in the data file. TIMEDATA should be set to 'T' if
%   time exists in the data file and 'NT' if there is no time data in
%   data file. FTS = ASCII2FTS(FILENAME, 'NT', DESCROW, COLHEADROW, SKIPROWS)
%   is equal to FTS = ASCII2FTS(FILENAME, DESCROW, COLHEADROW, SKIPROWS).
%   
%   NOTE: If time data exists in the data file, it must be the second
%   column of data.
%
%   A data file with time data could look as follows:
%
%      My FTS with time
%      dates 	    times 	Data1 	    Data2
%      01-Jan-2001 	11:00 	4.000000 	1.000000
%      01-Jan-2001 	12:00 	3.000000 	0.000000
%      ...
%   
%   For example:
%
%      % Create a data file with time information
%      dates = ['01-Jan-2001';'01-Jan-2001'; '02-Jan-2001'; ...
%              '02-Jan-2001'; '03-Jan-2001';'03-Jan-2001'];
%      times = ['11:00';'12:00';'11:00';'12:00';'11:00';'12:00'];
%      serial_dates_times = [datenum(dates), datenum(times)];
%      data = round(10*rand(6,2));
% 
%      stat = fts2ascii('myfts_file2.txt',serial_dates_times,data, ...
%             {'dates';'times';'Data1';'Data2'},'My FTS with time');
%
%      % Read the data file back and create a FINTS object
%      myFts = ascii2fts('myfts_file2.txt','t',1,2,1)
%
%   See also FINTS.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.15.2.1 $   $Date: 2003/01/16 12:51:12 $

% Defaults
timeData = 0;
descrow  = 0;
headrrow = 0;
skiprows = 0;

% Check inputs.
switch nargin
case 1
    % do nothing
case 2
    % Set the varargins to variables
    if ischar(varargin{1})
        timeChar = lower(varargin{1});
        if strcmp(timeChar,'t')
            timeData = 1;
        elseif strcmp(timeChar,'nt')
            % timeData = 0;
        else
            error('Ftseries:ascii2fts:TIMEDATAInvalid', ...
                sprintf(['TIMEDATA must be either ''T'' if there is time, or ''NT''\,', ...
                    'if there is no time.']));
        end
        %timeData = 1;
    elseif isnumeric(varargin{1})
        descrow = varargin{1};
        if isempty(descrow)
            descrow = 0;
        end
    else
        error('Ftseries:ascii2fts:Invalid2ndInput', ...
            'Invalid second input.');
    end
case {3, 4}
    % Set the varargins to variables
    if ischar(varargin{1})
        timeChar = lower(varargin{1});
        if strcmp(timeChar,'t')
            timeData = 1;
        elseif strcmp(timeChar,'nt')
            % timeData = 0;
        else
            error('Ftseries:ascii2fts:TIMEDATAInvalid', ...
                sprintf(['TIMEDATA must be either ''T'' if there is time, or ''NT''\,', ...
                    'if there is no time.']));
        end
        %timeData = 1;
        tFlag = 1;
    elseif isnumeric(varargin{1})
        descrow = varargin{1};
        tFlag = 0; 
        if isempty(descrow)
            descrow = 0;
        end
    else
        error('Ftseries:ascii2fts:Invalid2ndInput', ...
            'Invalid second input.');
    end
    
    numVarargin = nargin - 1;
    
    switch numVarargin
    case 2
        % Depending on the inclusion of timeinfo create the right variables
        if tFlag
            descrow = varargin{2};
            if isempty(descrow)
                descrow = 0;
            end
        else
            headrrow = varargin{2};
            if isempty(headrrow)
                headrrow = 0;
            end
        end
    case 3
        % Depending on the inclusion of timeinfo create the right variables
        if tFlag
            descrow = varargin{2};
            if isempty(descrow)
                descrow = 0;
            end
            
            headrrow = varargin{3};
            if isempty(headrrow)
                headrrow = 0;
            end 
        else
            headrrow = varargin{2};
            if isempty(headrrow)
                headrrow = 0;
            end
            
            skiprows = varargin{3};
            if isempty(skiprows)
                skiprows = 0;
            end
        end
    otherwise
        % Should never reach here
        error('Ftseries:ascii2fts:InvalidNumOfInputs', ...
            'Invalid number of input aruments.')
    end
case 5
    if ischar(varargin{1})
        timeChar = lower(varargin{1});
        if strcmp(timeChar,'t')
            timeData = 1;
        elseif strcmp(timeChar,'nt')
            % timeData = 0;
        else
            error('Ftseries:ascii2fts:TIMEDATAInvalid', ...
                sprintf(['TIMEDATA must be either ''T'' if there is time, or ''NT''\,', ...
                    'if there is no time.']));
        end
        %timeData = 1;
    else
        error('Ftseries:ascii2fts:Invalid2ndInput', ...
            'The second input must be either ''T'' or ''NT''.');
    end
    
    descrow = varargin{2};
    if isempty(descrow)
        descrow = 0;
    end
    
    headrrow = varargin{3};
    if isempty(headrrow)
        headrrow = 0;
    end 
    
    skiprows = varargin{4};
    if isempty(skiprows)
        skiprows = 0;
    end
otherwise
    error('Ftseries:ascii2fts:InvalidNumOfInputs', ...
        'Invalid number of input arguments.');
end

% Open file and check if file exists.
fid = fopen(fname);
if isempty(fid) | (fid < 0)
    error('Ftseries:ascii2fts:NotInPath', ...
        ['File ', fname, ' does not exist on the MATLAB Path.']);
end

% Determine the state of the informational inputs (DESCROW, COLHEADROW, SKIPROWS).
instat = sprintf('%i', [descrow, headrrow, max(skiprows)] ~= 0);

% Based on input state, do the right thing.
switch instat
case '111'
case '110'
    skiprows = 0;
case '101'
    headrrow = 0;
case '100'
    headrrow = 0;
    skiprows = 0;
case '011'
    descrow  = 0;
case '010'
    descrow  = 0;
    skiprows = 0;
case '001'
    descrow  = 0;
    headrrow = 0;
case '000'
    descrow  = 0;
    headrrow = 0;
    skiprows = 0;
end

% Set or get description information.
if ~descrow
    desctxt = fname;
else
    ldx = 1;
    while ~feof(fid)
        linedata = fgetl(fid);
        if ldx == descrow
            desctxt = linedata;
        end
        ldx = ldx + 1;
        if ldx > descrow,
            frewind(fid);
            break;
        end
    end
end

% Set or get column headers.
colcount = 0;
datfmt   = '';
if ~headrrow
    sdx = 1;
    if skiprows
        while sdx <= max(skiprows),
            firstdataline = fgetl(fid);
            sdx = sdx + 1;
        end
    end

    % This check is used to move the file pointer to the right place in the
    % text file because of the frewind that was done above.
    if ~descrow
        firstdataline = fgetl(fid);
        frewind(fid);
    else
        % Skip descrow row
        skippedRow = fgetl(fid);
        firstdataline = fgetl(fid);
        frewind(fid);
    end
    
    % Count columns.
    letterflag = zeros(size(firstdataline));
    
    % Check to see if letterflag is empty.
    % If it is, it could mean that there is an empty line
    % and the user forgot to specify 'skiprows'
    if isempty(letterflag)
        error('Ftseries:ascii2fts:PossibleFcnParamError', ...
            sprintf(['SKIPROWS may be incorrectly specified. Please check\n', ...
                'to make sure the number of skipped rows is correct.']));
    end
    
    letterflag(find(firstdataline~=' ' & firstdataline~=char(9))) = 1;
    
    % Find the last 1 which means the last character in the line.
    lastOne = max(find(letterflag == 1));
    % Find the number of -1's (number of words) and add 1 since
    % the last word is not found this way.
    colcount = length(find(diff(letterflag(1:lastOne)) == -1)) + 1;
    
    % Generate default column names
    sersnames = sprintf('''series%i'',', 1:colcount-1);
    colname   = [{'dates'}; cellstr(eval(['char(', sersnames(1:end-1), ')']))];
    
    % Generate format; first one must always be date strings,
    % the rest are doubles.
    if ~timeData
        datfmt = ['%s',  repmat(' %f', 1, colcount-1)];
    else
        datfmt = ['%s %s',  repmat(' %f', 1, colcount-2)];
    end
else
    ldx = 1;
    while ~feof(fid)
        linedata = fgetl(fid);
        if ldx == headrrow
            headr = deblank(linedata);
            
            % Count columns.
            letterflag = zeros(size(headr));
            letteridx = find(headr~=' ' & headr~=char(9));
            letterflag(letteridx) = 1;
            colcount = ceil(sum(abs(diff(letterflag))) / 2);
            if ~strcmp(headr(1), ' ')
                colcount = colcount + 1;
                p0 = 0;
            else
                p0 = [];
            end
            
            % Parse column names
            p1 = [p0, find(diff(letterflag) ==  1)];
            m1 = [find(diff(letterflag) == -1), length(headr)];
            for ii=1:colcount
                colname{ii}=headr(p1(ii)+1:m1(ii)); 
            end
            
            % Generate format; first one must always be date strings,
            % the rest are doubles.
            if ~timeData
                datfmt = ['%s',  repmat(' %f', 1, colcount-1)];
            else
                datfmt = ['%s %s',  repmat(' %f', 1, colcount-2)];
            end
        end
        ldx = ldx + 1;
        if ldx > headrrow
            frewind(fid);
            break
        end
    end
end

% Close the file so that TEXTREAD below can read it.
fclose(fid);

% Headerlines to skip is the total of descrow, headrrow, and skiprows.
tskiprows = max([descrow, headrrow, skiprows]);

% Read data from file.
% Thanks to Nicholas Pescatello and Nabeel Azar of Technical Support Group, 04/14/2000
if timeData
    sersnames = sprintf('series%i ', 1:colcount-2);
    vars = ['[dates timetime ',sersnames , ']']; 
    tempnames = ['[dates times ',sersnames , ']'];
    try
        eval([vars, '=textread(''', fname, ''', ''', datfmt, ''', ''headerlines'',' num2str(tskiprows), ');']);
    catch
        msg = lasterror;
        error('Ftseries:ascii2fts:CannotReadDataFile', ...
            sprintf(['Either the data in the text file is incorrect, or file\n', ...
                'contents do not correspond to the input information.\n\n', ...
                'The actual error generated when reading the text file via\n', ...
                'TEXTREAD is:\n\n', ...
                msg.message]));
    end
    
    % Create a cell array of date and time strings
    dates_times = cellstr([char(dates), repmat(' ',size(dates,1),1), char(timetime)]);
    
    % Create the FINTS object.
    try
        fts = feval('fints', dates_times, eval(['[', sersnames, ']']), colname(3:end), 0, desctxt);
    catch
        msg = lasterror;
        error('Ftseries:ascii2fts:CannotReadDataFile', ...
            sprintf(['Either the data in the text file is incorrect, or file\n', ...
                'contents do not correspond to the input information.\n\n', ...
                'The actual error generated when creating the FINTS object is:\n\n', ...
                msg.message]));
    end
else
    sersnames = sprintf('series%i ', 1:colcount-1);
    tempnames = ['[dates ',sersnames , ']'];
    try
        eval([tempnames, '=textread(''', fname, ''', ''', datfmt, ''', ''headerlines'',' num2str(tskiprows), ');']);
    catch
        msg = lasterror;
        error('Ftseries:ascii2fts:CannotReadDataFile', ...
            sprintf(['Either the file contents do not correspond to the input\n', ...
                'information, or the file contents contain time information\n', ...
                'which was not indicated in the function call.\n\n', ...
                'The actual error generated when reading the text file via\n', ...
                'TEXTREAD is:\n\n', ...
                msg.message]));
    end
    
    % Create the FINTS object.
    try
        fts = feval('fints', dates, eval(['[', sersnames, ']']), colname(2:end), 0, desctxt);
    catch
        msg = lasterror;
        error('Ftseries:ascii2fts:CannotReadDataFile', ...
            sprintf(['Either the file contents do not correspond to the input\n', ...
                'information, or the file contents contain time information\n', ...
                'which was not indicated in the function call.\n\n', ...
                'The error generated when creating the FINTS object is:\n\n', ...
                msg.message]));
    end
end

% [EOF]
