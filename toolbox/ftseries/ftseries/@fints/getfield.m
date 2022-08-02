function fts = getfield(ftsa, varargin)
%@FINTS/GETFIELD gets structure field contents of a FINTS object.
%
%   F = GETFIELD(S,'field') returns the contents of the specified
%   field.
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
%      F = getfield(myFts,'times')
%      F =
%          0.4583
%          0.5000
%          0.4583
%          0.5000
%          0.4583
%          0.5000
%
%      stringTime = datestr(F,15)
%      stringTime =
%      11:00
%      12:00
%      11:00
%      12:00
%      11:00
%      12:00
%      
%   F = GETFIELD(S,'field', {'dates'}) returns the contents of the
%   specified field for the specified dates.  'dates' can be 
%   individual cells of date strings or a cell of a date string 
%   range using the :: operator such as '01-Jan-2001::03-Jan-2001'.
%
%   For example:
%
%      F2 = getfield(myFts,'Data1',{'01-Jan-2001','03-Jan-2001'})
%      F2 =
%           1
%           2
%           NaN
%           6
%
%   F = GETFIELD(S,'field', {'dates/times'}) is similar to the
%   above except for the ability to specify times. 'dates/times'
%   can be individual cells of date strings or a cell of a date 
%   string  range using the :: operator such as 
%   '01-Jan-2001 12:00::02-Jan-2001 12:00'.
%
%   For example:
%
%      F3 = getfield(myFts,'Data1','01-Jan-2001 12:00::02-Jan-2001 12:00')
%      F3 =
%           2
%           3
%           4
%
%   See also SETFIELD, ISFIELD, FIELDNAMES, CHFIELD, RMFIELD.

%   Author: P. Wang, P. N. Secakusuma
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.12.2.1 $  $Date: 2003/01/16 12:50:56 $

% Check input arguments
error(nargchk(2,3,nargin));

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

noSFlag = 0;
dataFlag = 0;
fname = varargin{1};

switch fname
case 'desc'
    if nargin ~= 2
        error('Ftseries:fints_getfield:TwoInputsReq', ...
            'Two input arguments required: the object, the string ''desc''');
    end
    
    s(1).type = '.';
    s(1).subs = 'desc';
case 'freq'
    if nargin ~= 2
        error('Ftseries:fints_getfield:TwoInputsReq', ...
            'Two input arguments required: the object, the string ''freq''');
    end
    
    s(1).type = '.';
    s(1).subs = 'freq';
case 'dates'
    s(1).type = '.';
    s(1).subs = 'dates';
    
    if nargin == 3
        s(2).type = '()';
        if isnumeric(varargin{2})
            s(2).subs = {datestr(varargin{2})};
        else
            s(2).subs = varargin(2);
        end
    end
case 'times'
    s(1).type = '.';
    s(1).subs = 'times';
    
    if nargin == 3
        s(2).type = '()';
        if isnumeric(varargin{2})
            s(2).subs = {datestr(varargin{2})};
        else
            s(2).subs = varargin(2);
        end
    end
otherwise % accessing data
    dataFlag = 1;
    
    s(1).type = '.';
    s(1).subs = varargin{1};
    
    if nargin == 3
        s(2).type = '()';
        if isnumeric(varargin{2})
            s(2).subs = {datestr(varargin{2})};
        else
            s(2).subs = varargin(2);
        end
    end
end % end of 'switch fname'

% Call @fints/subsasgn to do the assigning. Catch any errors 
%and display the call to subsasgn.
try
    fts = feval(@subsref, ftsa, s);
catch
    errMsg = lasterror;
    try
        s(2).subs;
    catch
        noSFlag = 1;
        
        % Check to see if the type is specified and error accordingly.
        subsrefCall = sprintf([inputname(1),'.',char(s(1).subs)]);
        error('Ftseries:fints_getfield:SubsrefError', ...
            sprintf([subsrefCall, ' is the function call that was made to\n', ...
                '@FINTS/SUBSREF via @FINTS/GETFIELD.\n\n', ...
                'The resulting error is:\n\n', errMsg.message]));
        
    end
    
    if ~noSFlag
        subsrefCall = sprintf([inputname(1),'.',char(s(1).subs),'(''dates/times'')']);
        
        error('Ftseries:fints_getfield:SubsrefError', ...
            sprintf([subsrefCall, ' is the function call\n', ...
                'that was made to @FINTS/SUBSREF via @FINTS/GETFIELD.\n\n', ...
                'The resulting error is:\n\n', errMsg.message]));
    end
end

% Due to backward compatibility, I (PW) am forced to use this due to the
% incorrect help that was originally written. Even though the original
% help said that ,"F = GETFIELD(S,'field') returns the contents of the
% specified field.  This is equivalent to the syntax F = S.field.
% S must be a 1-by-1 structure," the result of F = GETFIELD(S,'field')
% and F = S.field were not the same. The first produced a matrix F of the
% data stored in 'field' and the latter produces an object F. Thus, I kept
% original functionality and did not change it.
if dataFlag
    fts = fts2mat(fts);
end

% [EOF]
