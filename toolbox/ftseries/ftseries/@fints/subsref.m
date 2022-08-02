function ftsi = subsref(fts, s)
%@FINTS/SUBSREF implements the indexing for the FINTS object.
%   
%   SUBSREF allows for the indexing into FINTS objects using integer, 
%   date string, or date and time string indexing.  Serial Dates and Times 
%   CANNOT be used as indices.  Additionally, SUBSREF allows the access of
%   individual components in the object using the structure syntax.
%     
%   The syntax for integer indexing is the same as for any other MATLAB matrix.  
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
%      myFts(2:3)
% 
%      ans = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (2)'    'times:  (2)'    'Data1:  (2)'
%      '01-Jan-2001'    '12:00'          [          2]
%      '02-Jan-2001'    '11:00'          [          3]
%      
%   The syntax for date and/or string indexing is similar to that of integer 
%   indexing.  The only difference is that the date and/or time string must
%   be enclose in single quotes.
%
%   If there is one date with multiple times, indexing with only the date
%   will return all the times for that specific date.
%     
%   For example:
%
%      myFts('01-Jan-2001')
% 
%      ans = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
% 
%      'dates:  (2)'    'times:  (2)'    'Data1:  (2)'
%      '01-Jan-2001'    '11:00'          [          1]
%      '     "     '    '12:00'          [          2]
%      
%   To specify a particular date and time, please index with the date and time.
%
%   For example:
%
%      myFts('01-Jan-2001 12:00')
% 
%      ans = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (1)'    'times:  (1)'    'Data1:  (1)'
%      '01-Jan-2001'    '12:00'          [          2]
%
%   To specify a range of dates and times, please use the double colon ('::')
%   operator. 
%
%   For example:
%
%      myFts('01-Jan-2001 12:00::03-Jan-2001 11:00')
% 
%      ans = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
% 
%      'dates:  (4)'    'times:  (4)'    'Data1:  (4)'
%      '01-Jan-2001'    '12:00'          [          2]
%      '02-Jan-2001'    '11:00'          [          3]
%      '     "     '    '12:00'          [          4]
%      '03-Jan-2001'    '11:00'          [          5]
%
%   To request all the dates, times, and data:
%   
%      myFts('::')
%
%   To access the individual components of the financial time series object,
%   please use the structure syntax.
%
%   For example, if you would like to get the object's description field: 
%
%      myFts.desc
%
%      ans =
%
%      My first FINTS
%
%   To convert the data in a FINTS object into a matrix, please use the 
%   function fts2mat function.
%
%   See also DATESTR, @FINTS/fts2mat, @FINTS/SUBSASGN.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.24.2.4 $   $Date: 2004/04/06 01:09:36 $

%-Main----------------------------------------------------------------------

% Set up some variables
msg = '';
slen = length(s);

% Check and convert old fts object from old to new
% Although ftsold2new calls fintsver, I still need to call fintsver
% to get the version number 
ftsVersion = fintsver(fts);
w = warning('off');
fts = ftsold2new(fts);
warning(w);

% Loop if input calls specific dates and a specific column.
% i.e. fts.series1({date1,date2,...})
for sidx = 1:slen
    switch s(sidx).type
    case '{}'   % Reference into a cell array
        error('Ftseries:fints_subsref:CannotUseCurlyBraces', ...
            '{} cannot be used with this object.  Use () instead.');
    case '()'   % Reference into a matrix
        [ftsi,msg] = referenceMatrix(fts,s,sidx,slen);
    case '.'    % Reference into a structure field
        [ftsi,msg] = referenceStructure(fts,s,sidx,slen);
    end
    
    % Display any error 'msg'
    error(msg);
end

if isa(ftsi,'fints')
    
    % Turn off backtrace
    wb = warning('off','backtrace');
    
    % Warn of object conversion
    if ftsVersion == 1
        warning('Ftseries:fints_subsref:ObjConverted', ...
            sprintf(['The FINTS object being referenced is an object\n' ...
                'from an earlier version of the Financial Time Series\n', ...
                'Toolbox, and the object being displayed has been converted\n', ...
                'to an object compatible with the Financial Time Series\n', ...
                'Toolbox Version 2.0. Please save and use this new object\n', ...
                'instead of the older object. If you would like to update\n', ...
                'any existing old objects, please use the function\n', ...
                '@FINTS/FTSOLD2NEW.\n']));
    end
    
    % Check to see if all the dates and times are monotonically increasing
    w2 = warning('off'); % This is necessary due to a duplicate warning msg in ISSORTED
    monoD = issorted(ftsi);
    warning(w2);
    
    % Turn it off again (was turned on by the previous warning call)
    wb = warning('off','backtrace');
    
    if monoD ~= 1
        ftsi = sortfts(ftsi);
        warning('Ftseries:fints_subsref:NonMonotonic', ...
            sprintf(['The dates and/or times in the referenced object\n', ...
                'were not monotonically increasing. It is recommended that\n', ...
                'all dates and/or times be in chronological order.\n']));
    end
    
    % Warn duplicate dates
    % Note: Keep this warning as the last warning displayed.
    if isempty(ftsi.data{5})
        % No time information
        if ftsuniq(ftsi.data{3}) == 0
            warning('Ftseries:fints_subsref:DuplicateDates', ...
                sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                    'exist. FINTS objects must not contain duplicate dates. The\n', ...
                    'function FTSUNIQ may be of assistance in determining which\n', ...
                    'dates are duplicates.\n']));
        end
    else
        % Contains time information
        if ftsuniq(ftsi.data{3}+ftsi.data{5}) == 0
            warning('Ftseries:fints_subsref:DuplicateDatesAndTimes', ...
                sprintf(['The dates and times in this object are not unique and\n', ...
                    'duplicate dates and times exist. FINTS objects must not\n', ...
                    'contain duplicate dates and times. The function FTSUNIQ\n', ...
                    'may be of assistance in determining which dates and times\n', ...
                    'are duplicates.\n']));
        end
    end
    
    % Restore old backtrace state 
    warning(wb)
end


% -ReferenceMatrix----------------------------------------------------------
function [ftsi,msg] = referenceMatrix(fts,s,sidx,slen);
%REFERENCEMATRIX allows for referencing into a matrix via conventional matrix
%   referencing syntax. 
%   
%   For Example, if fts is a time series object:
%      fts(1) or fts('01-jan-2001') or etc.

% Setup some variables
msg = '';
lookForType = 0;    % Used to determine the type of input
datafld = 0;        % Used to determine fields in the object structure
numidxflag = 0;     % Used to determine different cases for desc/freq
datacol=[];         % Initialize data columns to empty

% Check input dimensioning
if length(s(sidx).subs) ~= 1
    msg = 'Please use 1-dimensional indexing.';
    ftsi = [];
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
                ftsi = [];
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
                % ftsi = [];
                % return
            end
            
            % Combine the separate pseudodatarows into one real datarow
            datarow = [datarow;pseudodatarow];
            
            % Error out if there is a 'msg'
            if ~isempty(msg)
                ftsi = [];
                return
            end
        end % end 'for idxS = 1:numDT'
    else % If there is a single date/time string or range
        
        % Remove any leading & trailing spaces, as well as multiple spaces.
        passName = s(sidx).subs{:};
        [s(sidx).subs{:},msg] = rmvspaces(passName);
        if ~isempty(msg)
            ftsi = [];
            return
        end
        
        [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
        if ~isempty(msg)    % Error out if there is a 'msg' 
            ftsi = [];
            return
        end
    end % end 'if size(s(sidx).subs{:},1) ~= 1'
elseif iscell(s(sidx).subs{:})
    % Check to see if input is not a row or column vector cell array.
    if (size(s(sidx).subs{:}, 1) ~= 1) & (size(s(sidx).subs{:}, 2) ~= 1)
        msg = 'Input must be a column vector or cell array.';
        ftsi = [];
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
            ftsi = [];
            return
        end
        
        [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
        if ~isempty(msg)    % Error out if there is a 'msg' 
            ftsi = [];
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
                ftsi = [];
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
                % ftsi = [];
                % return
            end
            
            % Combine the separate pseudodatarows into one real datarow
            datarow = [datarow;pseudodatarow];
            
            % Error out if there is a 'msg'
            if ~isempty(msg)
                ftsi = [];
                return
            end
        end
    end % end 'if (size(s(sidx).subs{:}, 1) == 1) & (size(s(sidx).subs{:}, 2) == 1)'
elseif islogical(s(sidx).subs{:})% Index is logical vector of 0's and/or 1's.
    lookForType = 1;
    [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
    if ~isempty(msg)    % Error out if there is a 'msg' 
        ftsi = [];
        return
    end
elseif isnumeric(s(sidx).subs{:})% Index is integer value(s).
    lookForType = 2;
    [datarow,numidxflag,msg] = praseDateNTime(fts,s,lookForType,sidx);
    if ~isempty(msg)    % Error out if there is a 'msg' 
        ftsi = [];
        return
    end
else
    msg = 'Invalid date and/or time.';
    ftsi = [];
    return
end

% Check to see if user entered in fts(1:2).series1 and etc.
% This is now not allowed. It does not make sense because it
% could also mean that you could do fts(1:2).series1(3:4) which
% defiantely is incorrect.
if (sidx ==1) & (isnumeric(s(sidx).subs{:})) & (slen > 1)
    msg = sprintf(['Invalid referencing syntax. Please refer to the section\n', ...
            'in the Financial Time Series manual called ''Indexing a\n', ...
            'Financial Time Series Object.''']);
    ftsi = [];
    return
end

% Check to see if reference into matrix and structure is both called. If so,
% get the data column in question. Note, data series names do not apply
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
        ftsi = [];
        return
    case {1, 2}             % Description or Frequency
        msg = ['The ','''', s(1).subs, ...
                ''' object component cannot be referenced this way.'];
        ftsi = [];
        return
    case 3                  % Dates
        datafld = 3;
    case length(fts.names)  % Times
        datafld = 5;
    end
end % end of 'if slen > 1'

% Pass to function to make fts object
[ftsi,msg] = makeFts(fts,datafld,datarow,numidxflag,datacol);
if ~isempty(msg)    % Error out if there is a 'msg' 
    ftsi = [];
    return
end


% -ReferenceStructure-------------------------------------------------------
function [ftsi,msg] = referenceStructure(fts,s,sidx,slen)
%REFERENCESTRUCTURE allows for referencing into a matrix via conventional
%   structure referencing syntax. 
%   
%   For Example, if fts is a time series object:
%      fts.dates

% Set up some variables
msg = '';
numidxflag = 0;
nameidx = getnameidx(fts.names, s(sidx).subs);
if nameidx == 0
    msg = sprintf(['The specified field, ''',s(sidx).subs, ...
            ''', does not exist in the object.']);
    ftsi = [];
    return
end
datarow = 1:fts.datacount;
datacol = [];

% Number of header names
numNames = length(fts.names);

% Check to see which field is being accessed
if isempty(nameidx) | ~nameidx
    msg = (['''', s(sidx).subs, ''' is a non-existent object component.']);
    ftsi = [];
    return
elseif (nameidx >= 4) & (nameidx < numNames)  % The data series.
    datafld = 4;
    datacol = nameidx;
elseif (nameidx < 4)           % The DESC, FREQ, and DATES fields.
    switch s(sidx).subs
    case 'desc'
        datafld = 1;
    case 'freq'
        datafld = 2;
    case 'dates'
        datafld = 3;
        if (sidx == 1) & (slen == 2)
            ftsi = [];
            return
        end
    end
elseif (nameidx == numNames)    % The TIMES field
    datafld = 5;
    if (sidx == 1) & (slen == 2)
        ftsi = [];
        return
    end
end

% Pass to function to make fts object
[ftsi,msg] = makeFts(fts,datafld,datarow,numidxflag,datacol);
if ~isempty(msg)    % Error out if there is a 'msg' 
    ftsi = [];
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
            msg = sprintf(['Improper usage of :: operator. Please see', ...
                    '''help fints/subsref'' for correct syntax.']);
            datarow = []; numidxflag = [];
            return
        elseif (length(dblColonIdx) == 1) & (numSpace == 1) & (numColon < 3)
            % i.e. '01-Jan-2001 13::05' or '01-Jan-2001 ::' etc.
            msg = sprintf(['Improper syntax or usage of :: operator. Please see\n', ...
                    '''help fints/subsref'' for correct syntax.']);
            datarow = []; numidxflag = [];
            return
        end
        
        % If there is only ONE date and/or date/time
        if isempty(dblColonIdx)
            
            % Check delimiters for input validity
            if numColon >= 2
                % Incorrect if more than 2 ':' for THIS case
                % i.e. '01-Jan-2001:13:05' etc.
                msg = sprintf(['Either the dates/times search entry is invalid (possibly\n', ...
                        'wrong usage of : operator), or the search entry is not\n', ...
                        'in a row vector or cell array.']);
                datarow = []; numidxflag = [];
                return    
            elseif (numColon == 1) & isempty(spaceIdx)
                % Incorrect if there is 1 ':' and no spaces for THIS case
                % i.e. '01-Jan-200113:05' or '10:00' etc.
                msg = sprintf(['Either there is an improper usage of the : operator\n', ...
                        '(please see ''help fints/subsref'' for correct syntax),\n', ...
                        'or dates/times must be entered with accompanying dates.']);
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
                    msg = sprintf(['Invalid dates being referenced. One possiblity could be\n', ...
                            'that the input is not a column vector or cell array.']);
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
                msg = 'Invalid date/time search entry.';
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
            %
            % Try Catch is used to catch non-informative errors from
            % datenum/datevec and display informative ones.
            
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
                        msg = sprintf(['Invalid DATE and TIME entry. Please see ''help fints/subsref''\n', ...
                                'for correct syntax.']);
                        datarow=[];
                        return
                    end
                    
                    startDate = fts.data{3}(1);
                    
                    % Catch errors from datenum
                    try
                        endDate = datenum(entry(dblColonIdx+2:end));
                    catch
                        msg = 'Invalid date being referenced.';
                        datarow = [];
                        return
                    end
                elseif strfind(entry,'::') == length(entry)-1
                    % Input (4)
                    
                    % Invalid to have a colon in THIS case
                    if numColon > 2
                        msg = sprintf(['Invalid DATE and TIME entry. Please see ''help fints/subsref''\n', ...
                                'for correct syntax.']);
                        datarow=[];
                        return
                    end
                    
                    % Catch errors from datenum
                    try
                        startDate = datenum(entry(1:(dblColonIdx-1)));
                    catch
                        msg = 'Invalid date being referenced.';
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
                        msg = 'Invalid date being referenced.';
                        datarow = [];
                        return
                    end
                else
                    msg = 'Invalid date/time entry.';
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
                        msg = sprintf(['Invalid DATE and TIME entry. Please see ''help fints/subsref''\n', ...
                                'for correct syntax.']);
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
                        msg = 'Invalid date/time being referenced.';
                        datarow = [];
                        return
                    end
                    
                elseif (spaceIdx > dblColonIdx) & (strfind(entry,'::') ~= 1)
                    % Input (8)
                    % Invalid to have a colon in THIS case
                    % i.e. f(':01-Jan-2001::02-Jan-2001 13:05') etc.
                    if numColon == 4
                        msg = sprintf(['Invalid DATE and TIME entry. Please see ''help fints/subsref''\n', ...
                                'for correct syntax.']);
                        datarow=[];
                        return
                    end
                    
                    % Catch errors from datenum
                    try
                        startDate = min(find(datenum(entry(1:(dblColonIdx-1))) == fts.data{3}));
                    catch
                        msg = 'Invalid date/time being referenced.';
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
                    msg = 'Invalid date/time entry.';
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
    else % probably will not ever reach here.
        msg = 'Invalid Input.';
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
    if any(datarow <= 0),
        msg = 'Index into matrix is negative or zero.';
        datarow = []; numidxflag = [];
        return
    elseif any(datarow > fts.datacount),
        msg = 'Index exceeds object dimension.';
        datarow = []; numidxflag = [];
        return
    end
otherwise
    msg = sprintf(['Invalid indexing procedure. Please see ''help fints/subsref''\n', ...
            'for correct syntax.']);
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

% Find the date in the date/time string input
if d == 0
    enteredStringDate = entry(1:spaceIdx-1);
elseif d == 1
    enteredStringDate = entry(dblColonIdx+2:spaceIdx-1);
elseif d == 2
    enteredStringDate = entry(1:spaceIdx(1)-1);
elseif d == 3
    enteredStringDate = entry(dblColonIdx+2:spaceIdx(2)-1);
end % end of 'if d == 0'

% Check to see if date is valid, cannot be outside date ranges
try
    dates = datenum(enteredStringDate);
catch
    msg = 'Invalid date/time input.';
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
% enteredStringTime is the time part from the date/time string input
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
    msg = 'Invalid date/time input.';
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
% match, then it will reach here.
msg = 'Some or all input dates and times do not exist in object.';
pseudoDateRow = [];theDate = [];
return



% -MakeFts------------------------------------------------------------------
function [ftsi,msg] = makeFts(fts,datafld,datarow,numidxflag,datacol)
% MAKEFTS generates a new FTS object with the information that the user
%   requests. 

% Set up some variables
msg = '';

% Make the new fts object (ftsi)
switch datafld
case 0   % Reference all the data series only
    if isempty(datarow)
        ftsi = [];
    else
        % Create a new empty object
        ftsi = fints;
        
        % Fill new object
        ftsi.names      = fts.names;    
        ftsi.data{1}    = fts.data{1};              % Description
        ftsi.data{2}    = fts.data{2};              % Frequency
        ftsi.data{3}    = fts.data{3}(datarow);     % Dates  
        ftsi.data{4}    = fts.data{4}(datarow, :);  % Data
        
        % Check to see if there is time
        if isempty(fts.data{5})
            ftsi.data{5}= fts.data{5};              % Time
        else
            ftsi.data{5}= fts.data{5}(datarow);     % Time
        end
        
        ftsi.datacount  = length(ftsi.data{3});
        ftsi.serscount  = fts.serscount;
    end
case {1, 2}   % Reference the DESC & FREQ field only.
    if numidxflag
        if max(datarow) <= length(fts.data{datafld})
            ftsi = fts.data{datafld}(datarow);
        else
            msg = 'Index exceeds matrix dimensions.';
            ftsi = [];
            return
        end
    else
        ftsi = fts.data{datafld};
    end
case 3   % Reference the DATES field only.
    ftsi = fts.data{datafld}(datarow);
case 4   % Reference particular rows and series of data only.
    if isempty(datarow)
        ftsi = [];
    else
        % Create a new empty object
        ftsi = fints;
        
        % Fill new object
        ftsi.names          = [{'desc', 'freq', 'dates'}, fts.names(datacol),{'times'}];
        ftsi.data{1}        = fts.data{1};                          % Description
        ftsi.data{2}        = fts.data{2};                          % Frequency
        ftsi.data{3}        = fts.data{3}(datarow);                 % Dates
        ftsi.data{datafld}  = fts.data{datafld}(datarow, datacol-3);% Data
        
        % Check to see if there is time
        if isempty(fts.data{5})
            % Copy over empty time
            ftsi.data{5}    = fts.data{5};                          % Time
        else
            ftsi.data{5}    = fts.data{5}(datarow);                 % Time
        end
        
        ftsi.datacount      = length(ftsi.data{3});
        ftsi.serscount      = 1;
    end
case 5 % Reference the TIMES field only
    % Check if TIMES is empty
    if ~isempty(fts.data{end})
        ftsi = fts.data{end}(datarow);
    else
        msg = 'There is no time data in this object.';
        ftsi = [];
        return
    end
end % End of 'switch datafld'

% [EOF]
