function ftso = subsasgn(fts, s, b)
%@FINTS/SUBSASGN implements assignment into a FINTS object.
%
%   SUBSASGN allows for the indexing into a FINTS object using integer,
%   date, or date and time string indexing and assign value(s) to the
%   appropriate elements.  Serial Dates CANNOT be used as indices.
%
%   The syntax for integer indexing is the same as for any other MATLAB 
%   matrix.
%   
%   For example:
%
%      %% Create the FINTS object %%
%      dates = ['01-Jan-2001';'01-Jan-2001'; '02-Jan-2001'; ...
%              '02-Jan-2001'; '03-Jan-2001';'03-Jan-2001']
%      times = ['11:00';'12:00';'11:00';'12:00';'11:00';'12:00']
%      dates_times = cellstr([dates, repmat(' ',size(dates,1),1), times])
%      myFts = fints(dates_times,(1:6)',{'Data1'},1,'My first FINTS')
%      %% Create the FINTS object %%
%
%      myFts(1) = 999
% 
%      myFts = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%      '01-Jan-2001'    '11:00'          [        999]
%      '     "     '    '12:00'          [          2]
%      '02-Jan-2001'    '11:00'          [          3]
%      '     "     '    '12:00'          [          4]
%      '03-Jan-2001'    '11:00'          [          5]
%      '     "     '    '12:00'          [          6]
%
%
%   The syntax for date and/or string indexing is similar to that of integer 
%   indexing.  The only difference is that the date and/or time string must
%   be enclosed in single quotes.
%
%   If there is one date with multiple times, indexing with only the date
%   and assigning a value will result in every element of that date taking on
%   the assigned value.
%
%   For example:   
%
%      myFts('01-Jan-2001') = 0.5
% 
%      myFts = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%      '01-Jan-2001'    '11:00'          [     0.5000]
%      '     "     '    '12:00'          [     0.5000]
%      '02-Jan-2001'    '11:00'          [          3]
%      '     "     '    '12:00'          [          4]
%      '03-Jan-2001'    '11:00'          [          5]
%      '     "     '    '12:00'          [          6]
%
%   To access the individual components of the financial time series object,
%   please use the structure syntax.
%
%   For example:
%
%      myFts.Data1= (0:.1:.5)'
% 
%      myFts = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%      '01-Jan-2001'    '11:00'          [          0]
%      '     "     '    '12:00'          [     0.1000]
%      '02-Jan-2001'    '11:00'          [     0.2000]
%      '     "     '    '12:00'          [     0.3000]
%      '03-Jan-2001'    '11:00'          [     0.4000]
%      '     "     '    '12:00'          [     0.5000]
%
%   More examples:
%
%      myFts('02-Jan-2001') = 2.2222
% 
%      myFts = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%     'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%     '01-Jan-2001'    '11:00'          [          0]
%     '     "     '    '12:00'          [     0.1000]
%     '02-Jan-2001'    '11:00'          [     2.2222]
%     '     "     '    '12:00'          [     2.2222]
%     '03-Jan-2001'    '11:00'          [     0.4000]
%     '     "     '    '12:00'          [     0.5000]
%
%      myFts('01-Jan-2001 11:00::02-Jan-2001 12:00') = (9:-1:6)'
%
%      myFts = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%      '01-Jan-2001'    '11:00'          [          9]
%      '     "     '    '12:00'          [          8]
%      '02-Jan-2001'    '11:00'          [          7]
%      '     "     '    '12:00'          [          6]
%      '03-Jan-2001'    '11:00'          [     0.4000]
%      '     "     '    '12:00'          [     0.5000]
%
%   See also DATESTR, @FINTS/SETFIELD, @FINTS/SUBSREF.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.40.4.3 $   $Date: 2004/04/06 01:09:35 $ 

%-Main----------------------------------------------------------------------

% Set up some variables
msg = '';
slen = length(s);

% Check to see if fts is a fints. If not, call the 'builtin' subsasgn.
% i.e. s.type='.'; s.subs='b'; a=subsasgn([],s,fints(1,1))
if ~isa(fts, 'fints')                                                      
    ftso = builtin('subsasgn', fts, s, b);                                     
    return
end

% Check to see that the input to freq is not a cell array. 
if strcmp(s(end).subs, 'freq') & ~isnumeric(b) & ~ischar(b)
    error('Ftseries:fints_subsasgn:FreqIndMustBeInt', ...
        'Frequency indicator must be an integer or a string.');
end

% If input is a FINTS object, extract columns & order them as in 'fts'.
if isa(b, 'fints'),
    bnameidx = getnameidx(b.names(4:end-1), fts.names(4:end-1));
    b = b.data{4}(:, bnameidx);
end

% Check and convert old fts object from old to new
% Although ftsold2new calls fintsver, I still need to call fintsver
% to get the version number 
ftsVersion = fintsver(fts);
w = warning('off');
fts = ftsold2new(fts);
warning(w);

% Turn off backtrace
wb = warning('off','backtrace');

% Warn of object conversion
if ftsVersion == 1
    warning('Ftseries:fints_subsasgn:ObjConverted', ...
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
    ftso = sortfts(fts);
    warning('Ftseries:fints_subsasgn:NonMonotonic', ...
        sprintf(['The dates and/or times in the referenced object\n', ...
            'were not monotonically increasing. It is recommended that\n', ...
            'all dates and/or times be in chronological order.\n']));
end

% Warn of duplicate dates
% Note: Keep this warning as the last warning displayed.
if isempty(fts.data{5})
    % No time information
    if ftsuniq(fts.data{3}) == 0
        warning('Ftseries:fints_subsasgn:DuplicateDates', ...
            sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                'exist. FINTS objects must not contain duplicate dates. The\n', ...
                'function FTSUNIQ may be of assistance in determining which\n', ...
                'dates are duplicates.\n']));
    end
else
    % Contains time information
    if ftsuniq(fts.data{3}+fts.data{5}) == 0
        warning('Ftseries:fints_subsasgn:DuplicateDatesAndTimes', ...
            sprintf(['The dates and times in this object are not unique and\n', ...
                'duplicate dates and times exist. FINTS objects must not\n', ...
                'contain duplicate dates and times. The function FTSUNIQ\n', ...
                'may be of assistance in determining which dates and times\n', ...
                'are duplicates.\n']));
    end
end

% Restore old backtrace state 
warning(wb)

% Loop if input calls specific dates and a specific column.
% i.e. fts.series1({date1,date2,...})
for sidx = 1:slen
    switch s(sidx).type
    case '{}'   % Reference into a cell array
        error('Ftseries:fints_subsasgn:CannotUseCurlyBraces', ...
            '{} cannot be used with this object. Use () instead.');
    case '()'   % Reference into a matrix
        % On the second pass, make fts == to the new obj. ftso.
        if sidx > 1
            fts = ftso;
        end
        
        [ftso,msg] = referenceMatrix(fts,s,sidx,slen,b);
    case '.'    % Reference into a structure field
        [ftso,b,msg] = referenceStructure(fts,s,sidx,slen,b);
    end
    
    % Display any error 'msg'
    error(msg);
end


% -ReferenceMatrix----------------------------------------------------------
function [ftso,msg] = referenceMatrix(fts,s,sidx,slen,b);
%REFERENCEMATRIX allows for referencing into a matrix via conventional matrix
%   referencing syntax. 
%   
%   For Example, if fts is a time series object:
%      fts(1)

% Setup some variables
msg = '';
lookForType = 0; % Used to determine the type of input
datafld = 0; % Used to determine fields in the object structure
numidxflag = 0;
datacol=[];

% Check input dimensioning
if length(s(sidx).subs) ~= 1
    msg = 'Please use 1-dimensional indexing.';
    ftso = [];
    return
end

% Check input types
if ischar(s(sidx).subs{:})
    % Check to see if input is a column oriented string matrix.
    % i.e. f(['01-Jan-2001 13:05';'02-Jan-2001 00:03'])
    % If it is, loop through each date/time string to determine
    % the correct data to extract.
    if size(s(sidx).subs{:},1) ~= 1
        
        % Temp. hold of info. in S
        holdSubs = s(sidx).subs{:};
        
        % Number of different dates/times in S
        numDT = size(s(sidx).subs{:},1);
        
        % Initialize datarow to empty
        datarow = [];
        
        % Find each datarow separately
        for idxS = 1:numDT
            % Work with each date individually so that parseDateNTime 
            % can catch errors in each date.            
            passName = holdSubs(idxS,:);
            
            % Remove any leading & trailing spaces, as well as multiple spaces.
            % rmvSpaces also converts the cell array into a char array.
            [s(sidx).subs{:},msg] = rmvspaces(passName);
            if ~isempty(msg)
                ftso = [];
                return
            end
            
            % Pass back 'pseudodatarow' b/c there datarow is a combination of calls
            % to parseDateNTime. datarow is created in the next line
            [pseudodatarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
            
            % UNDOCUMENTED "multiple spanning dates" call.
            % i.e. f(['01-Jan-2001 13:05::01-Jan-2001 05:03';'02-Jan-2001 09:03::02-Jan-2001 00:03'])
            if (size(pseudodatarow,2) ~= 1)
                pseudodatarow = reshape(pseudodatarow,size(pseudodatarow,2),1);
                % or
                % msg = 'Invalid to index with DATE/TIME string range.';
                % ftso = [];
                % return
            end
            
            % Combine the separate pseudodatarows into one real datarow
            datarow = [datarow;pseudodatarow];
            
            % Error out if there is a 'msg'
            if ~isempty(msg)
                ftso = [];
                return
            end
        end % end 'for idxS = 1:numDT'
    else % If there is a single date/time string or range
        
        % Remove any leading & trailing spaces, as well as multiple spaces.
        passName = s(sidx).subs{:};
        [s(sidx).subs{:},msg] = rmvspaces(passName);
        if ~isempty(msg)
            ftso = [];
            return
        end
        
        % Get the data row numbers
        [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
        if ~isempty(msg)    % Error out if there is a 'msg' 
            ftso = [];
            return
        end
    end % end 'if size(s(sidx).subs{:},1) ~= 1'
elseif iscell(s(sidx).subs{:})
    % Check to see if input is not a row or column vector cell array.
    if (size(s(sidx).subs{:}, 1) ~= 1) & (size(s(sidx).subs{:}, 2) ~= 1)
        msg = 'Input must be a column vector or cell array.';
        ftso = [];
        return
    end
    
    % Check to see if input is one string (one date/time) or many strings (many
    % dates/times)
    if (size(s(sidx).subs{:}, 1) == 1) & (size(s(sidx).subs{:}, 2) == 1)
        % Remove any leading & trailing spaces, as well as multiple spaces.
        % rmvSpaces also converts the cell array into a char array.
        passName = s(sidx).subs{:};
        [s(sidx).subs{:},msg] = rmvspaces(passName);
        if ~isempty(msg)
            ftso = [];
            return
        end
        
        [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
        if ~isempty(msg)    % Error out if there is a 'msg' 
            ftso = [];
            return
        end
    else % many dates/times
        % Temp. hold of info. in S
        holdSubs = s(sidx).subs{:};
        
        % Number of different dates/times in S
        numDT = length(s(sidx).subs{:}); %size(s(sidx).subs{:},2);
        
        % Initialize datarow to empty
        datarow = [];
        
        % Find each datarow separately
        for idxS = 1:numDT
            % Work with each date individually so that parseDateNTime 
            % can catch errors in each date.            
            passName = holdSubs(idxS);
            
            % Remove any leading & trailing spaces, as well as multiple spaces.
            % rmvSpaces also converts the cell array into a char array.
            [s(sidx).subs{:},msg] = rmvspaces(passName);
            if ~isempty(msg)
                ftso = [];
                return
            end
            
            % Pass back 'pseudodatarow' b/c there datarow is a combination of calls
            % to parseDateNTime. datarow is created in the next line
            [pseudodatarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
            
            % UNDOCUMENTED "multiple spanning dates" call.
            % i.e. f({'01-Jan-2001 13:05::01-Jan-2001 05:03','02-Jan-2001 09:03::02-Jan-2001 00:03'})
            if (size(pseudodatarow,2) ~= 1)
                pseudodatarow = reshape(pseudodatarow,size(pseudodatarow,2),1);
                % or
                % msg = 'Invalid to index with DATE/TIME string range.';
                % ftso = [];
                % return
            end
            
            % Combine the separate pseudodatarows into one real datarow
            datarow = [datarow;pseudodatarow];
            
            % Error out if there is a 'msg'
            if ~isempty(msg)
                ftso = [];
                return
            end
        end
    end % end 'if (size(s(sidx).subs{:}, 1) == 1) & (size(s(sidx).subs{:}, 2) == 1)'
elseif islogical(s(sidx).subs{:})% Index is logical vector of 0's and/or 1's.
    lookForType = 1;
    [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
    if ~isempty(msg)    % Error out if there is a 'msg' 
        ftso = [];
        return
    end
elseif isnumeric(s(sidx).subs{:})% Index are integer value(s).
    lookForType = 2;
    [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
    if ~isempty(msg)    % Error out if there is a 'msg' 
        ftso = [];
        return
    end
else
    msg = 'Invalid date and/or time.';
    ftso = [];
    return
end

% Check to see if user entered in fts(1:2).series1 and etc.
% This is now not allowed. It does not make sense because it
% could also mean that you could do fts(1:2).series1(3:4) which
% defiantely is incorrect.
if (sidx == 1) & (isnumeric(s(sidx).subs{:})) & (slen > 1)
    msg = sprintf(['Invalid referencing syntax. Please refer to the section\n', ...
            'in the Financial Time Series manual called ''Indexing a\n', ...
            'Financial Time Series Object.']);
    ftso = [];
    return
end

% Check to see if reference into matrix and structure is both called. If so,
% get the data column in question. Note, data series names are do not apply
% in this IF statement. 
% i.e. fts.dates(1)
if slen > 1
    % datafld set to = 4 here b/c if you reference data series(n), it jumps 
    % right out of this IF and goes on. 
    datafld = 4;
    
    % Find column idx for the name specified in the input, besides the data
    % series names.
    datacol = getnameidx(fts.names, s(1).subs);
    
    % Check if the column actually exists. Again, data series names are not
    % dealt with here.
    switch datacol
    case 0                  % Invalid and non existent header name
        msg = ['''', s(1).subs, ''' is a non-existent object component.'];
        ftso = [];
        return
    case {1, 2}             % Description or Frequency
        msg = ['The ','''', s(1).subs, ...
                ''' object component cannot be referenced this way.'];
        ftso = [];
        return
    case 3                  % Dates
        datafld = 3;
    case length(fts.names)  % Times
        datafld = 5;
    end
end % end of 'if slen > 1'

% Pass to function to make fts object
[ftso,msg] = makeFts(fts,datafld,datarow,numidxflag,datacol,b);

if ~isempty(msg)    % Error out if there is a 'msg' 
    ftso = [];
    return
end


% -ReferenceStructure-------------------------------------------------------
function [ftso,b,msg] = referenceStructure(fts,s,sidx,slen,b)
%REFERENCESTRUCTURE allows for referencing into a matrix via conventional
%   structure referencing syntax. 
%   
%   For Example, if fts is a time series object:
%      fts.dates

% Set up some variables
msg = '';
numidxflag = 0;
nameidx = getnameidx(fts.names, s(sidx).subs);
datarow = 1:fts.datacount;
datacol = [];

% Number of header names
numNames = length(fts.names);

% Check to see which field is being accessed
if isempty(nameidx) | ~nameidx
    % If the series name does not exist, create a new series with the 
    % entered series name
    datafld = 4;
    datacol = numNames + 1;
    
    % Create new header after last series
    fts.names = [fts.names(1:datacol-2), {s(sidx).subs}, fts.names(end)];
    
    % Fill it with NaN's temporarily. makefts (below) will fill it with data. 
    fts.data{4}(:, datacol-4) = NaN;
    
    % Recheck number of header names and redetermine the datacol
    numNames = length(fts.names);
    datacol = numNames - 1;
    
elseif (nameidx >= 4) & (nameidx < numNames)
    % The data series.
    datafld = 4;
    datacol = nameidx;
    
    % If referencing into a particular field AND particular dates 
    % (i.e. fts.dates(1:2)=[#;#]), return to the main to find the data 
    % rows that correspond to the referenced dates.
    % In addition, the below IF statement needs to come after the checks
    % b/c input b needs to be converted to serial dates before returning
    % to the main.
    if (sidx == 1) & (slen == 2)
        ftso = fts;
        return
    end
elseif (nameidx < 4)
    % The DESC, FREQ, and DATES fields.
    switch s(sidx).subs
    case 'desc'
        datafld = 1;
        % Check input for desciption.
        if isnumeric(b)
            msg = 'Description must be a string.';
            ftso = []; b = [];
            return
        end
    case 'freq'
        datafld = 2;
        if ischar(b)
            if isempty(b)
                msg = 'Please specify a frequency indicator.';
                ftso = []; b = [];
                return
            end
            
            % Try and Catch the error from FREQNUM. This way, the error msg is
            % displayed cleanly w/o a stack trace.
            try
                b = freqnum(b);
            catch
                errmsg = lasterror;
                % Display the error and not the function name portion.
                msg = cleanerrormsg(errmsg.message);
                ftso = []; b = [];
                return
            end % end of try/catch
        elseif isnumeric(b)
            if ((b < 0) | (b > 6)) | (mod(b,1) ~= 0) 
                msg = 'Invalid numeric frequency indicator.';
                ftso = []; b = [];
                return
            end
        end % end of 'if ischar(b)'
    case 'dates'
        datafld = 3;
        
        % Check input b validity
        if ischar(b)
            % It is very difficult to determine if a char matrix is column
            % oriented or row oriented. Thus, using try catch to check for known
            % error messages is one option.
            try
                % Convert b into serial dates.
                b = datenum(b);
                
                % Check if time is is part of the date (It is if datenum
                % produces a float)
                if (sum(rem(b,1)) ~= 0)
                    msg = 'Invalid right hand side argument. Please specify only dates.';
                    ftso = []; b = [];
                    return
                end
            catch
                % If b is entered as a comma separated list of dates, datevec
                % (a function called by datenum) will error out with something
                % like this:
                % 'Too many date fields in 01-jan-200101-jan-2001'
                % The below attempts to catch this error and display a more
                % meaningfull error. If any other invalid input is entered,
                % a default message is generated.
                msg = lasterror;
                errmsg = lower(msg.message);
                knownError = lower(sprintf('Too many date fields in %s', b));
                if ~isempty(strfind(errmsg,knownError))
                    msg = sprintf(['Either the dates being assigned are invalid, or the dates\n' ...
                            'are not in a column vector or cell array.']);
                    ftso = []; b = [];
                    return
                else
                    msg = 'Invalid right hand side argument.';
                    ftso = []; b = [];
                    return
                end
            end
        elseif iscell(b)
            % Check for correct syntax of input b
            % Cell arrays can be either comma separated lists or semi-colon
            % separated lists
            if ((size(b,1) > 1) & (size(b,2) > 1))
                msg = sprintf(['The right hand side argument must be a column vector or\n', ...
                        'cell array of dates.']);
                ftso = []; b = [];
                return
            end
            
            % Use try catch in this case to catch any non-meaningful errors.
            try
                % Convert b into serial dates
                b = datenum(char(b));
                
                % Check if time is is part of the date (It is if datenum
                % produces a float)
                if (sum(rem(b,1)) ~= 0)
                    msg = 'Invalid right hand side argument. Please specify only dates.';
                    ftso = []; b = [];
                    return
                end
            catch
                % Convert all errors to meaningful errors.
                msg = 'Invalid right hand side argument. Please specify only dates.';
                ftso = []; b = [];
                return
            end
        elseif isnumeric(b)
            % Check for correct syntax of input b
            if ((size(b,1) == 1) & (size(b,2) > 1)) | ((size(b,1) > 1) & (size(b,2) > 1))
                % Input b can only be a column oriented matrix
                msg = sprintf(['The right hand side argument must be a column vector of\n', ...
                        'dates or cell array.']);
                ftso = []; b = [];
                return
            elseif (sum(rem(b,1)) ~= 0) | (prod(double(b >= 0)) ~= 1)
                % DATES must always be positive integers in the F.T.S. Toolbox
                msg = sprintf(['Serial dates (right hand side argument) must be positive\n', ...
                        'integers.']);
                ftso = []; b = [];
                return 
            end
        end
        
        % If referencing into a particular field AND particular dates 
        % (i.e. fts.dates(1:2)=[#;#]), return to the main to find the data 
        % rows that correspond to the referenced dates.
        % In addition, the below IF statement needs to come after the checks
        % b/c input b needs to be converted to serial dates before returning
        % to the main.
        if (sidx == 1) & (slen == 2)
            ftso = fts;
            return
        end
    end % end of 'switch s(sidx).subs' for the DESC, FREQ, and DATES fields.
elseif (nameidx == numNames)
    % The TIMES field
    datafld = 5;
    
    % Check input b validity
    
    % Check for row oriented vector of times. Row oriented char arrays not
    % allowed. Note: the longest length for a single time string is 5 characters.
    if (size(b,1) == 1) & (length(b) > 5)
        % Remove leading and lagging spaces
        b = strtrim(b);
        
        % Check to see if the length is still greater than 5. It could be
        % that the spaces were the cause for it to be greater than 5.
        if length(b) > 5
            msg = sprintf(['Either the times being assigned are invalid, or the times\n' ...
                    'are not in a column vector or cell array.']);
            ftso = []; b= [];
            return
        end
    end
    
    if ischar(b)
        % It is very difficult to determine if a char matrix is column
        % oriented or row oriented. Thus, using try catch to check for known
        % error messages is one option.
        try
            % Convert b into serial dates.
            b = datenum(b) - datenum('00:00:00');
            
            % Check to see if time info is really time info. (serial time
            % must always be positive floats less than one in the F.T.S.
            % Toolbox)
            if (sum(rem(b,1)) < 0) | (prod(double(b >= 0)) ~= 1) | (prod(double(b < 1)) == 0)
                msg = sprintf(['Times (right hand side argument) must be floats that\n', ...
                        'are less than 1 and greater than or eqaul to 0.']);
                ftso = []; b = [];
                return
            end
        catch
            % If b is entered as a comma separated list of times, datevec
            % (a function called by datenum) will error out with something
            % like this:
            % 'Too many date fields in 01-jan-200101-jan-2001'
            % The below attempts to catch this error and display a more
            % meaningfull error. If any other invalid input is entered,
            % a default message is generated.
            % ** Most likely the "else" will be hit in the below if-else
            msg = lasterror;
            errmsg = lower(msg.message);
            knownError = lower(sprintf('Too many time fields in %s', b));
            if ~isempty(strfind(errmsg,knownError))
                msg = sprintf(['Either the times being assigned are invalid, or the times\n' ...
                        'are not in a column vector or cell array.']);
                ftso = []; b = [];
                return
            else
                msg = 'Invalid right hand side argument.';
                ftso = []; b = [];
                return
            end
        end
    elseif iscell(b)
        % Check for correct syntax of input b
        % Cell arrays can be either comma separated lists or semi-colon
        % separated lists
        if ((size(b,1) > 1) & (size(b,2) > 1))
            msg = sprintf(['The right hand side argument must be a column vector or\n', ...
                    'cell array of times.']);
            ftso = []; b = [];
            return
        end
        
        % Use try catch in this case to catch any non-meaningful errors.
        try
            % Convert b into serial dates
            b = datenum(char(b));
            
            % Check to see if time info is really time info. (serial time
            % must always be positive floats less than one in the F.T.S.
            % Toolbox)
            if (sum(rem(b,1)) < 0) | (prod(double(b >= 0)) ~= 1) | (prod(double(b < 1)) == 0)
                msg = sprintf(['Times (right hand side argument) must be floats that\n', ...
                        'are less than 1 and greater than or eqaul to 0.']);
                ftso = []; b = [];
                return
            end
        catch
            % Convert all errors to meaningful errors.
            msg = 'Invalid times (right hand side argument).';
            ftso = []; b = [];
            return
        end
    elseif isnumeric(b)
        % Check for correct syntax of input b
        if ((size(b,1) == 1) & (size(b,2) > 1)) | ((size(b,1) > 1) & (size(b,2) > 1))
            % Input b can only be a column oriented matrix
            msg = sprintf(['The right hand side argument must be a column oriented matrix\n', ...
                    'of appropriate size.']);
            ftso = []; b = [];
            return 
        elseif (sum(rem(b,1)) < 0) | (prod(double(b >= 0)) ~= 1) | (prod(double(b < 1)) == 0)
            % TIMES must always be positive floats less than one in the F.T.S.
            % Toolbox
            msg = sprintf(['Times (right hand side argument) must be floats that\n', ...
                    'are less than 1 and greater than or eqaul to 0.']);
            ftso = []; b = [];
            return
        end    
    end
    
    % If referencing into a particular field AND particular times 
    % (i.e. fts.times(1:2)=[#;#]), return to the top to find the data 
    % rows that are correspond to the particular times in question.
    % In addition, this IF statement needs to come after the checks b/c
    % input b needs to be converted to serial dates before returning.
    if (sidx == 1) & (slen == 2)
        ftso = fts;
        return
    end
end % end of 'if isempty(nameidx) | ~nameidx'

% Check for appropriate number of data points if assigning to data series.
if ~isempty(nameidx) & (nameidx > 3) & (nameidx < length(fts.names))
    if size(b, 2)~=1
        msg = 'The right hand side argument must be a column vector.';
        ftso = []; b = [];
        return
    else
        if fts.datacount
            if size(b, 1) ~= 1
                if  size(b, 1)>length(datarow)
                    msg = 'Too many data points (right hand side) being entered.';
                    ftso = []; b = [];
                    return
                elseif size(b, 1)<length(datarow)
                    msg = 'Too few data points (right hand side) being entered.';
                    ftso = []; b = [];
                    return
                end
            end
        else
            fts.datacount = size(b, 1);
        end
    end
end

% Pass to function to make fts object.
% Pass in sidx and nameidx if slen ~= 1 and nameidx == 0 or []
% Pass in nameidx only if slen == 1 and nameidx == 0 or []
if ((nameidx == 0) | isempty(nameidx)) & slen ~= 1
    [ftso,msg] = makeFts(fts,datafld,datarow,numidxflag,datacol,b,sidx,nameidx);
elseif ((nameidx == 0) | isempty(nameidx)) & slen == 1
    [ftso,msg] = makeFts(fts,datafld,datarow,numidxflag,datacol,b,nameidx);
else
    [ftso,msg] = makeFts(fts,datafld,datarow,numidxflag,datacol,b);
end
if ~isempty(msg)    % Error out if there is a 'msg' 
    ftso = [];
    return
end


% -ParseChar----------------------------------------------------------------
function [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx)
%PARSECHAR parses the input and returns the index (datarow) where the 
%   date/time/data can be found in the object

% Set up some variables
msg = '';
numidxflag = 0;

% Check what kind of input is entered
% lookForType = 0 -> cell/char
% lookForType = 1 -> logical
% lookForType = 2 -> integer
switch lookForType
case 0  % Entered in a char or cell
    % Input entered is one date or one date range.
    if size(s(sidx).subs{:}, 1) == 1
        % String entered for date/time
        entry = (char(s(sidx).subs{:}));        
        
        % Look for a space delimiter
        %spaceIdx = strfind(s(sidx).subs{:},' ');
        spaceIdx = strfind(entry,' ');
        numSpace = length(spaceIdx);
        
        % Check to see how many : there are ('::' = ':' 2x)
        %colonIdx = strfind(s(sidx).subs{:},':');
        colonIdx = strfind(entry,':');
        numColon = length(colonIdx);
        
        % Check for improper usage of ':'
        %if strcmp(s(sidx).subs{:}, ':') 
        if strcmp(entry, ':') 
            % If string passed in is only ':'
            % i.e. ':'
            msg = 'Please use ''::'' operator instead of '':'' operator.';
            datarow = []; numidxflag = [];
            return
        end
        
        % Check to see where the :: is
        %dblColonIdx = findstr(s(sidx).subs{:}, '::');
        dblColonIdx = findstr(entry, '::');
        
        % Check validity of input string for general cases
        if length(dblColonIdx) > 1
            % Invalid to have > 1 '::'
            % i.e. '01-Jan-2001::13::04' etc.
            msg = sprintf(['Improper syntax or usage of :: operator. Please see\n', ...
                    '''help fints/subsasgn'' for correct syntax.']);
            datarow = []; numidxflag = [];
            return
        elseif (length(dblColonIdx) == 1) & (numSpace == 1) & (numColon < 3)
            % i.e. '01-Jan-2001 13::05' or '01-Jan-2001 ::' etc.
            msg = sprintf(['Improper syntax or usage of :: operator. Please see\n', ...
                    '''help fints/subsasgn'' for correct syntax.']);
            datarow = []; numidxflag = [];
            return
        end
        
        % If there is only ONE date and/or date/time
        if isempty(dblColonIdx)
            
            % Check delimiters for input validity
            if numColon >= 2
                % Incorrect if more than 2 ':' for THIS case
                % i.e. '01-Jan-2001:13:05' or ['01-Jan-2001 13:05','01-Jan-2001 13:05'] etc.
                msg = sprintf(['Either the dates/times search entry (left hand side)\n', ...
                        'is invalid (possibly wrong usage of : operator), or\n', ...
                        'the search entry is not a row vector or cell array.']);
                datarow = []; numidxflag = [];
                return    
            elseif (numColon == 1) & isempty(spaceIdx)
                % Incorrect if there is 1 ':' and no spaces for THIS case
                % i.e. '01-Jan-200113:05' or '13:05' etc.
                msg = sprintf(['Either there is an improper usage of the : operator\n', ...
                        '(please see ''help fints/subsref'' for correct syntax),\n', ...
                        'or the times (left hand side) must be entered with\n', ...
                        'accompanying dates.']);
                datarow = []; numidxflag = [];
                return
            end
            
            % Parse string for date/time and find the data associated with that 
            % date and time via the row index.
            % Note: a space in the date/time string indicates there is time info.
            if isempty(spaceIdx)        % When there isn't a space in the string
                % Use try catch to filter out known errors that result from 
                % datenum/datevec that are not informative to the user.
                try
                    % Get serial date number
                    dates = datenum(entry);
                catch
                    msg = sprintf(['Invalid dates being referenced (left hand side). One\n', ...
                            'possiblity could be that the dates are not in column\n', ... '
                            'vector or cell array.']);
                    datarow = []; numidxflag = [];
                    return
                end
                
                % No time info
                timetime = [];
                
                % Check to see if date is valid
                if (dates < min(fts.data{3})) | (dates > max(fts.data{3}))
                    msg = 'One or more dates does not exist in object.';
                    datarow = []; numidxflag = [];
                    return
                end
                
                % Find the data row index (or indices) by finding the date
                datarow = find(dates == fts.data{3});
                %if isempty(datarow)
                %    msg = 'One or more dates does not exist in object.';
                %    numidxflag = [];
                %    return
                %end
            else    % When there is a space in the string
                
                % Find the index (datarow) for where the data is located via the time.
                d = 0; t = 0;
                [pseudoDateRow,theDate,msg] = getDateFromTime(fts,entry,spaceIdx,dblColonIdx,d,t);
                datarow = pseudoDateRow;
                
                % Error out immediately if there is a 'msg'
                if ~isempty(msg)
                    % datarow is returned by getDateFromTime fcn as [] already
                    return
                end
            end % end of 'if isempty(spaceIdx)'
        else % dblColonIdx is not empty
            
            % Check delimiters for input validity
            % Incorrect if more than 4 ':' ('::' = 2) for THIS case
            % and incorrect if more than 2 spaces for THIS case
            if numColon > 4 | length(spaceIdx) > 2
                msg = 'Invalid date/time search entry (left hand side argument).';
                datarow = []; numidxflag = [];
                return
            elseif isempty(spaceIdx) & ~isempty(dblColonIdx) & (numColon >= 3)
                % i.e. cases like - '13:00::' or '::00:00' or '01-Jan-200113:05::' etc.
                msg = 'Invalid input. Please see ''help fints/subsref'' for correct syntax.';
                datarow = []; numidxflag = [];
                return
            end
            
            % Check for different types of inputs
            % Type of acceptable inputs via subsref
            % (1) ::        (2) ::date      (3) ::date time
            % (4) date::    (5) date time:: (6) date::date
            % (7) date time::date   (8) date::date time
            % (9) date time::date time 
            % Breakdown via space delimiter
            % 0 spaces -> (1),(2),(4), and (6); no time info
            % 1 space  -> (3),(5),(7), and (8); time info
            % 2 spaces -> (9); time info
            
            switch numSpace
            case 0 % 0 spaces -> (1),(2),(4), and (6); no time info
                if strcmp(entry,'::') 
                    % Input (1)
                    startDate = fts.data{3}(1);
                    endDate = fts.data{3}(end);
                elseif dblColonIdx == 1 
                    % Input (2)
                    
                    % Invalid to have a colon in THIS case
                    if numColon > 2
                        msg = sprintf(['Invalid DATE and TIME entry. Please see\n', ... 
                                '''help fints/subsref'' for correct syntax.']);
                        datarow = [];
                        return
                    end
                    
                    startDate = fts.data{3}(1);
                    
                    % Catch errors from datenum
                    try
                        endDate = datenum(entry(dblColonIdx+2:end));
                    catch
                        msg = 'Invalid date being referenced (left hand side argument).';
                        datarow = [];
                        return
                    end
                    
                elseif strfind(entry,'::') == length(entry)-1
                    % Input (4)
                    
                    % Invalid to have a colon in THIS case
                    if numColon > 2
                        msg = sprintf(['Invalid DATE and TIME entry. Please see\n', ... 
                                '''help fints/subsref'' for correct syntax.']);                        
                        datarow=[];
                        return
                    end
                    
                    % Catch errors from datenum
                    try
                        startDate = datenum(entry(1:(dblColonIdx-1)));
                    catch
                        msg = 'Invalid date being referenced (left hand side argument).';
                        datarow = [];
                        return
                    end
                    
                    endDate = fts.data{3}(end);
                elseif (strfind(entry,'::') ~= 1) & (strfind(entry,'::') ~= length(entry)-1)
                    % Input (6)
                    
                    % Catch errors from datenum
                    try
                        startDate = datenum(entry(1:(dblColonIdx-1)));
                        endDate = datenum(entry(dblColonIdx+2:end));
                    catch
                        msg = 'Invalid date being referenced (left hand side argument).';
                        datarow = [];
                        return
                    end
                else
                    msg = 'Invalid date/time entry (left hand side argument).';
                    datarow = []; numidxflag = [];
                    return
                end
            case 1 % 1 space  -> (3),(5),(7), and (8); time info
                % For each type of input, get the integer index of the
                % 'start date/time' and the 'end date/time/
                if dblColonIdx == 1 
                    % Inputs (3)
                    startDate = 1;
                    
                    % Determine endDate via time
                    d = 1;t = 0;
                    [pseudoDateRow,theDate,msg] = getDateFromTime(fts,entry,spaceIdx,dblColonIdx,d,t);
                    if ~isempty(msg)% Error out immediately if there is a 'msg'
                        datarow = [];
                        return
                    end
                    endDate = pseudoDateRow;% Int idx of ending date%theDate;
                elseif strfind(entry,'::') == length(entry)-1
                    % Input (5)
                    % Determine startDate via time
                    d = 0;t = 1;
                    [pseudoDateRow,theDate,msg] = getDateFromTime(fts,entry,spaceIdx,dblColonIdx,d,t);
                    if ~isempty(msg)% Error out immediately if there is a 'msg'
                        datarow = [];
                        return
                    end
                    startDate = pseudoDateRow;
                    endDate = length(fts.data{3});
                elseif (spaceIdx < dblColonIdx) & (strfind(entry,'::') ~= length(entry)-1)
                    % Input (7)
                    % Invalid to have a colon in THIS case
                    % i.e. f('01-Jan-2001 13:05::02-Jan-2001:') etc.
                    if numColon == 4
                        msg = sprintf(['Invalid DATE and TIME entry. Please see\n', ... 
                                '''help fints/subsref'' for correct syntax.']); 
                        datarow=[];
                        return
                    end
                    
                    % Determine startDate via time
                    d = 0;t = 1;
                    [pseudoDateRow,theDate,msg] = getDateFromTime(fts,entry,spaceIdx,dblColonIdx,d,t);
                    if ~isempty(msg)% Error out immediately if there is a 'msg'
                        datarow = [];
                        return
                    end
                    startDate = pseudoDateRow;
                    
                    % Catch errors from datenum
                    try
                        endDate = max(find(datenum(entry(dblColonIdx+2:end)) == fts.data{3}));
                    catch
                        msg = 'Invalid date being referenced (left hand side argument).';
                        datarow = [];
                        return
                    end
                elseif (spaceIdx > dblColonIdx) & (strfind(entry,'::') ~= 1)
                    % Input (8)
                    % Invalid to have a colon in THIS case
                    % i.e. f(':01-Jan-2001::02-Jan-2001 13:05') etc.
                    if numColon == 4
                        msg = sprintf(['Invalid DATE and TIME entry. Please see\n', ... 
                                '''help fints/subsref'' for correct syntax.']); 
                        datarow=[];
                        return
                    end
                    
                    try
                        startDate = min(find(datenum(entry(1:(dblColonIdx-1))) == fts.data{3}));
                    catch
                        msg = 'Invalid date being referenced (left hand side argument).';
                        datarow = [];
                        return
                    end
                    
                    % Determine endDate via time
                    d = 1;t = 0;
                    [pseudoDateRow,theDate,msg] = getDateFromTime(fts,entry,spaceIdx,dblColonIdx,d,t);
                    if ~isempty(msg)% Error out immediately if there is a 'msg'
                        datarow = [];
                        return
                    end
                    endDate = pseudoDateRow;
                else
                    msg = 'Invalid date/time entry (left hand side argument).';
                    datarow = []; numidxflag = [];
                    return
                end
            case 2 % 2 spaces -> (9); time info
                % Determine startDate via time
                d = 2;t = 2;
                [pseudoDateRow,theDate,msg] = getDateFromTime(fts,entry,spaceIdx,dblColonIdx,d,t);
                if ~isempty(msg)% Error out immediately if there is a 'msg'
                    datarow = [];
                    return
                end
                startDate = pseudoDateRow;%theDate;
                
                % Determine endDate via time
                d = 3;t = 3;
                [pseudoDateRow,theDate,msg] = getDateFromTime(fts,entry,spaceIdx,dblColonIdx,d,t);
                if ~isempty(msg)% Error out immediately if there is a 'msg'
                    datarow = [];
                    return
                end
                endDate = pseudoDateRow;%theDate;
            end % end 'switch numSpace'
            
            % Get integer idx # for data between (and including) the startdate and enddate
            if numSpace == 0   
                % stratDate and endDate are serial numbers
                % Check to see if startDate is valid, cannot be outside date ranges
                if (startDate < min(fts.data{3})) | (startDate > max(fts.data{3}))
                    msg = 'Date does not exist in object OR invalid input string format.';
                    datarow = []; numidxflag = [];
                    return
                elseif (endDate < min(fts.data{3})) | (endDate > max(fts.data{3}))
                    % Check to see if endDate is valid, cannot be outside date ranges
                    msg = 'Date does not exist in object OR invalid input string format.';
                    datarow = []; numidxflag = [];
                    return
                end
                datarow = find(fts.data{3} >= startDate & fts.data{3} <= endDate);
            else          
                % stratDate = idx and endDate = idx
                if isempty(startDate) 
                    msg = 'Starting date does not exist in the object.';
                    datarow = []; numidxflag = [];
                    return
                elseif isempty(endDate)
                    msg = 'Ending date does not exist in the object.';
                    datarow = []; numidxflag = [];
                    return
                end
                datarow = (startDate:endDate); % Integer idx of wanted data
            end
        end % end of 'if isempty(dblColonIdx)'
    else % should not reach here.
        msg = 'Invalid date or date range.';
        datarow = []; numidxflag = [];
    end % end of 'if size(s(sidx).subs{:}, 1)==1'
    
case 1 % Entered logical vector of 0's and/or 1's.
    if length(s(sidx).subs{:}) ~= fts.datacount,
        msg = 'Length of logical index must be equal to length of object.';
        datarow = []; numidxflag = [];
        return
    end
    datarow = find(s(sidx).subs{:});
case 2 % Entered integer values
    numidxflag = 1;
    datarow = s(sidx).subs{:};
    if any(datarow <= 0)
        msg = 'Index into matrix is negative or zero.';
        datarow = []; numidxflag = [];
        return
    elseif any(datarow > fts.datacount)
        msg = 'Index exceeds object dimension.';
        datarow = []; numidxflag = [];
        return
    end
otherwise
    msg = 'Invalid indexing procedure. Please see ''help fints/subsref'' for correct indexing syntax.'
    datarow = []; numidxflag = [];
end % end of 'switch lookForType'


% -GetDateFromTime----------------------------------------------------------
function [pseudoDateRow,theDate,msg] = getDateFromTime(fts,entry,spaceIdx,dblColonIdx,d,t)
%GETDATEFROMTIME finds the date in the object with the matching time from
%   the input 
%
%   When there is time data we need to first find all occurances of the input 
%   date (ignoring the input time) in the FTS. Second, we need to find the 
%   existing times in the FTS associated with the occurances of the input date.
%   After that, we can compare the input time with the time in the FTS object 
%   and determine the day in the FTS that is associated with this time. Once 
%   we find a match, the date and time entered will be the same date and time
%   in the FTS object, consequently leading us to the data associated with the
%   date and time. This method is needed because there could be multiple times 
%   of the same value throughout the FTS object. 

% Set up some variables
msg = '';

% Check to see where the date is.
% dates is the Date input from user
% Use try catch to weed out non-informative errors from datenum/datevec
% and provide better errors.
if d == 0
    enteredStringdate = entry(1:spaceIdx-1);
elseif d == 1
    enteredStringdate = entry(dblColonIdx+2:spaceIdx-1);
elseif d == 2
    enteredStringdate = entry(1:spaceIdx(1)-1);
elseif d == 3
    enteredStringdate = entry(dblColonIdx+2:spaceIdx(2)-1);
end % end of 'if d == 0'

% Check to see if date is valid, cannot be outside date ranges
try
    dates = datenum(enteredStringdate);
catch
    msg = 'Invalid date/time entry (left hand side argument).';
    pseudoDateRow = [];theDate = [];
    return
end

if (dates < min(fts.data{3})) | (dates > max(fts.data{3}))
    msg = 'Date does not exist in object OR invalid input string format.';
    pseudoDateRow = [];theDate = [];
    return
end

dateRowNum = find(dates == fts.data{3});%  Integer indices of the date location
timeSubSet = fts.data{5}(dateRowNum);% Times of the desired date

% Convert serial time to actual string. This will eliminate the
% problem of round-off error (if any) of looking for times, since
% time in serial format is a float (often with repeating digits).
stringTime = datestr(timeSubSet,15);


% Check to see where the time is.
% enteredStringTime is the time input from user (string)
if t == 0 
    enteredStringTime = entry(spaceIdx+1:end);
elseif t == 1
    enteredStringTime = entry(spaceIdx+1:dblColonIdx-1);
elseif t == 2
    enteredStringTime = entry(spaceIdx(1)+1:dblColonIdx-1);
elseif t == 3
    enteredStringTime = entry(spaceIdx(2)+1:end);
end

% Check to see if time is valid, cannot be outside time ranges.
try
    enteredStringTimeNum = datenum(enteredStringTime) - datenum('00:00:00');
catch
    msg = 'Invalid date/time entry (left hand side argument).';
    pseudoDateRow = [];theDate = [];
    return
end

% Get the correct datarows by comparing the serial dates/times.
% Comparing via a tolerance of 0.001 seconds (or 1.157407407407408e-008).
tol = (0.001/60/60/24);
if ((enteredStringTimeNum < min(timeSubSet)) && (abs(enteredStringTimeNum - min(timeSubSet)) > tol)) || ...
        ((enteredStringTimeNum > max(timeSubSet)) && (abs(enteredStringTimeNum - max(timeSubSet)) > tol))
    msg = 'Some or all of the specified times do not exist for the specific dates.';
    pseudoDateRow = [];theDate = [];
    return
end

% First deblank any leading and trailing spaces if they exist, then 
% add a leading 0 to time if there is none in the entered string time.
% i.e. '4:15' --> '04:15'
enteredStringTime = deblank(enteredStringTime);
enteredStringTime = strtrim(enteredStringTime);

if length(enteredStringTime) < 5
    enteredStringTime = ['0' enteredStringTime];
elseif length(enteredStringTime) > 5
    msg = 'Invalid time syntax.';
    pseudoDateRow = [];theDate = [];
    return
end

% Check to see which time matches, thus finding the correct date
for idx = 1:length(dateRowNum)
    sameDate = strcmp(enteredStringTime,stringTime(idx,:));
    sameDateFlag = sameDate;
    if sameDateFlag == 1 % Correct time integer index and its datenum
        pseudoDateRow=dateRowNum(idx);
        theDate=timeSubSet(idx);
        return
    end
end

% Check to see if the date/time actually exists. This is the last check to
% see if there is such a date and time. We are assuming the input string is
% entered correctly as stated in the manual. 
% Also, we need this check outside the above FOR b/c if none of times 
% match, then it reaches here.
msg = 'Some or all input dates and times do not exist in object.';
pseudoDateRow = [];theDate = [];
return


% -MakeFts------------------------------------------------------------------
function [ftso,msg] = makeFts(fts,datafld,datarow,numidxflag,datacol,b,varargin)
% MAKEFTS generates a new FTS object with the information that the user
%   requests. 

% Set up some variables
msg = '';

% Make the new fts object (ftso)
ftso = fts;

% Fill in ftso with the data that inputted 
switch datafld
case 0   % Assigning all the data series only
    if isempty(datarow)
        ftso = [];
    elseif length(datarow) == fts.datacount
        % i.e. fts('::') = #; or fts(1:end) = #; 
        % Assign the input data
        try
            ftso.data{4}(:) = b;
        catch
            % Check to see if its too many or too few.
            if ftso.datacount < length(b)
                msg = 'Too many data points (right hand side) being entered.';
                ftso = [];
                return
            elseif ftso.datacount > length(b)
                msg = 'Too few data points (right hand side) being entered.';
                ftso = [];
                return
            end
        end
    else
        idxNum = length(datarow);
        idxSeries = fts.serscount;
        
        % Only allow an input matrix size equal to the matrix size that is
        % referenced in the FTS or a matrix size of 1 x 1 (constant).
        if ((size(b,1) == idxNum) & (size(b,2) == idxSeries)) | (prod(size(b)) == 1)
            if ~isnumeric(b)
                msg = 'The data being entered (right hand side) must be numeric.';
                ftso = [];
                return
            end
            % Assign the input data
            ftso.data{4}(datarow, :) = b;
        else
            msg = sprintf(['The data being entered (right hand side) has either too\n',...
                    'many columns or not enough columns compared to the data\n', ...
                    'being replaced (left hand side).']);
            ftso = [];
            return
        end
    end
case {1, 2}   % Reference the DESC & FREQ field only.
    % Assign the input data
    ftso.data{datafld} = b;
case 3   % Reference the DATES field only.
    % Allow for replacement of similar dates with one specified input date.
    if sum(diff(fts.data{3}(datarow))) == 0
        % Assign the input data
        try
            ftso.data{datafld}(datarow) = b;
        catch
            % Will enter here only if too many dates are entered.
            msg = 'Too many DATES (right hand side) being entered.';
            ftso = [];
            return
        end
    elseif length(datarow) ~= length(b)
        % Check if lengths agree; must enter 1 new date to be assigned
        % for every existing date.
        if length(datarow) > length(b)
            msg = 'Too few DATES (right hand side) being entered.';
            ftso = [];
            return
        elseif length(datarow) < length(b)
            msg = 'Too many DATES (right hand side) being entered.';
            ftso = [];
            return
        end
    end
    
    % Assign the input data
    ftso.data{datafld}(datarow) = b;
case 4   % Reference particular rows and series of data only.
    if isempty(datarow)
        ftso = [];
    else
        % Assign the input data. Since, 'case 4' is referencing a data
        % column, the input can only be a column vector.
        if size(b, 2) ~= 1
            msg = 'Right hand side input must be a column vector data series.';
            ftso = [];
            return
        else
            % Check too see if the num of rows = the num of inputs
            switch nargin
            case 6 % If accessing existing fields
                if sum(size(b)) == 2
                    % do nothing
                elseif length(datarow) < length(b)
                    msg = 'Too many data points (right hand side) being entered.';
                    ftso = [];
                    return
                elseif length(datarow) > length(b)
                    msg = 'Too few data points (right hand side) being entered.';
                    ftso = [];
                    return
                end
                ftso.data{datafld}(datarow, datacol-3) = b;
            case 7
                % 7 input args only if a non-existent field is added to the fts and 
                % one is referencing a structure only (i.e. fts.unknown_field = yyy)
                nameidx = varargin{1};
                if (sum(size(b)) == 2) | (size(b,1) == length(datarow))
                    % do nothing
                elseif (size(b,1) == 1) & (size(b,2) > 1)
                    msg = 'Right hand side input must be a column vector data series.';
                    return
                elseif length(b) > length(datarow)
                    msg = 'Too many data points (right hand side) being entered.';
                    ftso = [];
                    return
                else
                    msg = sprintf(['Please specify which dates and/or times (rows) to assign\n', ...
                            'the data (right hand side) to.']);
                    ftso = [];
                    return
                end                
                ftso.data{datafld}(:, datacol-3) = b;
            case 8
                % 8 input args only if a non-existent field is added to the fts and 
                % one is referencing a structure and matix (i.e. fts.unknown_field(xxx) = yyy)
                sidx = varargin{1};
                nameidx = varargin{2};
                if ((sum(size(b)) == 2) | (size(b,1) == length(datarow))) & sidx > 1
                    % do nothing
                elseif (size(b,1) == 1) & (size(b,2) > 1)
                    msg = 'Right hand side input must be a column vector data series.';
                    ftso = [];
                    return
                end
                
                % Only assign b if sidx is > 1
                if sidx ~= 1
                    ftso.data{datafld}(datarow, datacol-3) = b;
                end
            otherwise
                msg = 'invalid number of inputs.';
                ftso = [];
                return
            end % end of 'switch nargin'
        end % end of 'if size(b, 2) ~= 1'
        
        % Fill in other info
        ftso.datacount = length(ftso.data{3});
        ftso.serscount = size(ftso.data{4}, 2);
        fts = ftso;
    end
case 5 % Reference the TIMES field only
    % Check if TIMES is empty
    if isempty(fts.data{end})
        msg = 'There is no time data in this object.';
        ftso = [];
        return
    elseif length(datarow) ~= length(b)
        % Check if lengths agree; must enter 1 new date to be assigned
        % for every existing date.
        if length(datarow) < length(b)
            msg = 'Too many TIMES being entered.';
            ftso = [];
            return
        elseif length(datarow) > length(b)
            msg = 'Too few TIMES being entered.';
            ftso = [];
            return
        end
    end
    
    ftso.data{end}(datarow) = b;
end % End of 'switch datafld'

% [EOF]
