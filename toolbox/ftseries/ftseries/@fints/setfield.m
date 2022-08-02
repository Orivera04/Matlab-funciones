function fts = setfield(ftsa, varargin)
%@FINTS/SETFIELD sets structure field contents of a FINTS object.
%
%   F = SETFIELD(S, 'field', V) sets the contents of the specified
%   field to the value V.  This is equivalent to the syntax 
%   S.field = V. S must be a 1-by-1 structure.  The changed structure 
%   is returned.
%
%   For example:
%
%      %% Create the FINTS object %%
%      dates = ['01-Jan-2001';'01-Jan-2001'; '02-Jan-2001'; ...
%              '02-Jan-2001'; '03-Jan-2001';'03-Jan-2001'];
%      times = ['11:00';'12:00';'11:00';'12:00';'11:00';'12:00'];
%      dates_times = cellstr([dates, repmat(' ',size(dates,1),1), times]);
%      myFts = fints(dates_times,[(1:4)'; nan; 6],{'Data1'},1,'My first FINTS')
%      %% Create the FINTS object %%
%
%      S = setfield(myFts,'Data1',(6:11)')
% 
%      S = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%      '01-Jan-2001'    '11:00'          [          6]
%      '     "     '    '12:00'          [          7]
%      '02-Jan-2001'    '11:00'          [          8]
%      '     "     '    '12:00'          [          9]
%      '03-Jan-2001'    '11:00'          [         10]
%      '     "     '    '12:00'          [         11]
%
%   F = SETFIELD(S, 'field', {'dates'}, V) sets the contents of the
%   specified field for the specified dates.  'dates' can be 
%   individual cells of date strings or a cell of a date string 
%   range using the :: operator such as '01-Jan-2001::02-Jan-2001'.
%
%   For example:
%
%      S = setfield(myFts,'Data1',{'01-Jan-2001';'03-Jan-2001'}, ...
%          [111;222;555;666])
%
%      S = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%      '01-Jan-2001'    '11:00'          [        111]
%      '     "     '    '12:00'          [        222]
%      '02-Jan-2001'    '11:00'          [          3]
%      '     "     '    '12:00'          [          4]
%      '03-Jan-2001'    '11:00'          [        555]
%      '     "     '    '12:00'          [        666]
%
%   F = SETFIELD(S, 'field', {'dates/times'}, V) is similar to the
%   above except for the ability to specify times. 'dates/times'
%   can be individual cells of date strings or a cell of a date 
%   string  range using the :: operator such as 
%   '01-Jan-2001 12:00::02-Jan-2001 12:00'.
%
%   For example:
%
%      S = setfield(myFts,'Data1',{'01-Jan-2001 12:00::03-Jan-2001 11:00'},(102:105)')
% 
%      S = 
% 
%      desc:  My first FINTS
%      freq:  Daily (1)
%
%      'dates:  (6)'    'times:  (6)'    'Data1:  (6)'
%      '01-Jan-2001'    '11:00'          [          1]
%      '     "     '    '12:00'          [        102]
%      '02-Jan-2001'    '11:00'          [        103]
%      '     "     '    '12:00'          [        104]
%      '03-Jan-2001'    '11:00'          [        105]
%      '     "     '    '12:00'          [          6]
%
%   See also CHFIELD, FIELDNAMES, GETFIELD, ISFIELD, RMFIELD.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.17 $  $Date: 2002/02/05 15:51:19 $

% Check input arguments
error(nargchk(3,4,nargin));

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

noSFlag = 0;
fname = varargin{1};

switch fname
case 'desc'
    if nargin ~= 3
        error('Ftseries:fints_setfield:ThreeInputsReq', ...
            sprintf(['Three input arguments required: the object, the string ''desc'',\n', ...
                'and the description field contents.']));
    elseif ~isempty(varargin{2}) & ~ischar(varargin{2})
        error('Ftseries:fints_setfield:DescMustBeStr', ...
            'Description content must be a string.');
    end
    
    s(1).type = '.';
    s(1).subs = 'desc';
    
    b = varargin{2};
case 'freq'
    if nargin ~= 3
        error('Ftseries:fints_setfield:ThreeInputsReq', ...
            sprintf(['Three input arguments required: the object, the string ''freq'',\n', ...
                'and the frequency indicator.']));
    end
    
    if ischar(varargin{2})
        varargin{2} = freqnum(varargin{2});
    elseif varargin{2} < 0 | varargin{2} > 6
        error('Ftseries:fints_setfield:InvalidFreq', ...
            'Invalid frequency indicator.');
    end
    
    s(1).type = '.';
    s(1).subs = 'freq';
    
    b = varargin{2};
case 'dates'
    if nargin == 3
        if isnumeric(varargin{2})
            new_dates = varargin{2};
        elseif iscell(varargin{2})
            try
                new_dates = datenum(varargin{2}(:));
            catch
                error('Ftseries:fints_setfield:InvalidDates', ...
                    'Invalid dates.');
            end
        elseif ischar(varargin{2})
            try
                new_dates = datenum(varargin{2});
            catch
                error('Ftseries:fints_setfield:InvalidDates', ...
                    'Invalid dates.');
            end
        end
    elseif nargin == 4
        if isnumeric(varargin{3})
            new_dates = varargin{3};
        elseif iscell(varargin{3})
            try
                new_dates = datenum(varargin{3}(:));
            catch
                error('Ftseries:fints_setfield:InvalidDates', ...
                    'Invalid dates.');
            end
        elseif ischar(varargin{3})
            try
                new_dates = datenum(varargin{3});
            catch
                error('Ftseries:fints_setfield:InvalidDates', ...
                    'Invalid dates.');
            end
        end
    end
    
    if length(unique(new_dates)) ~= length(new_dates)
        error('Ftseries:fints_setfield:DuplicateDates', ...
            sprintf(['Multiple occurences of same dates detected. Please\n', ...
                'remove any duplicate dates.']));
    end
    
    s(1).type = '.';
    s(1).subs = 'dates';
    
    if nargin == 3
        b = varargin{2};
    elseif nargin == 4
        s(2).type = '()';
        if isnumeric(varargin{2})
            s(2).subs = {datestr(varargin{2})};
        else
            s(2).subs = varargin(2);
        end
        
        b = varargin{3};
    end
case 'times'
    if nargin == 3
        if isnumeric(varargin{2})
            new_times = varargin{2};
        elseif iscell(varargin{2})
            try
                new_times = datenum(varargin{2}(:));
            catch
                error('Ftseries:fints_setfield:InvalidDates', ...
                    'Invalid times.');
            end
        elseif ischar(varargin{2})
            try
                new_times = datenum(varargin{2});
            catch
                error('Ftseries:fints_setfield:InvalidDates', ...
                    'Invalid times.');
            end
        end
    elseif nargin == 4
        if isnumeric(varargin{3})
            new_times = varargin{3};
        elseif iscell(varargin{3})
            try
                new_times = datenum(varargin{3}(:));
            catch
                error('Ftseries:fints_setfield:InvalidDates', ...
                    'Invalid times.');
            end
        elseif ischar(varargin{3})
            try
                new_times = datenum(varargin{3});
            catch
                error('Ftseries:fints_setfield:InvalidDates', ...
                    'Invalid times.');
            end
        end
    end
    
    s(1).type = '.';
    s(1).subs = 'times';
    
    if nargin == 3
        b = varargin{2};
    elseif nargin == 4
        s(2).type = '()';
        if isnumeric(varargin{2})
            s(2).subs = {datestr(varargin{2})};
        else
            s(2).subs = varargin(2);
        end
        
        b = varargin{3};
    end
otherwise % accessing data
    s(1).type = '.';
    s(1).subs = varargin{1};
    
    if nargin == 3
        b = varargin{2};
    elseif nargin == 4
        s(2).type = '()';
        if isnumeric(varargin{2})
            s(2).subs = {datestr(varargin{2})};
        else
            s(2).subs = varargin(2);
        end
        
        if isnumeric(varargin{3})
            b = varargin{3};
        else
            error('Ftseries:fints_setfield:NumericExpected', ...
                'Data must be entered as numeric values.');
        end
    end
end % end of 'switch fname'

% Call @fints/subsasgn to do the assigning. Catch any errors 
%and display the call to subsasgn.
try
    fts = feval(@subsasgn, ftsa, s, b);
catch
    errMsg = lasterror;
    
    % Check to see if the type is specified and error accordingly. 
    try
        s(2).subs;
    catch
        noSFlag = 1;
        subsasgnCall = sprintf([inputname(1),'.',char(s(1).subs),' = V']);
        error('Ftseries:fints_setfield:SubsasgnError', ...
            sprintf([subsasgnCall, ' is the function call that was made to\n', ...
                '@FINTS/SUBSASGN via @FINTS/SETFIELD.\n\n', ...
                'The resulting error is:\n\n', errMsg.message]));
    end
    
    if ~noSFlag
        subsasgnCall = sprintf([inputname(1),'.',char(s(1).subs),'(''dates/times'') = V']);
        
        error('Ftseries:fints_setfield:SubsasgnError', ...
            sprintf([subsasgnCall, ' is the function call\n', ...
                'that was made to @FINTS/SUBSASGN via @FINTS/SETFIELD.\n\n', ...
                'The resulting error is:\n\n', errMsg.message]));
    end
end

% [EOF]
