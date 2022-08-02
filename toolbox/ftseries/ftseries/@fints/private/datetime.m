function [dt,dates,timetime,idxNST,msg] = datetime(varargin)
%DATETIME converts DATES input, which may contain time information also, from
%   @FINTS/FINTS into serial date and time (if time data exists) format.
%   
%   dt      : dates and times as one variable
%   dates   : dates only
%   timetime: times only
%   idxNST  : index of the times before they are sorted in rmvsec
%   msg     : misc. messages

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.2.2.2 $   $Date: 2004/04/06 01:09:31 $

% -Main-----------------------------------------------------------------------
msg = '';

% Check number of input arguments
if nargin == 1    % If there is one input (date only or date/time combined)
    dnt = varargin{1};
    
    [dt,dates,timetime,idxNST,msg] = datePlusTime(dnt);
elseif nargin == 2
    dateIn = varargin{1};
    timeIn = varargin{2};
    
    [dt,dates,timetime,msg] = dateThenTime(dateIn,timeIn);    
else
    error('Too many input arguments.');
end

% Make sure dates and timetime are column vectors and remake dt
if size(dates,2) ~= 1
    dates = reshape(dates,length(dates),1);
end
if size(timetime,2) ~= 1
    timetime = reshape(timetime,length(timetime),1);
end
dt = [dates,timetime];


% Return error to @FINTS/FINTS if there is an error.
if nargout < 5
    error(msg);
end


% -DatePlusTime---------------------------------------------------------------
function [dt,dates,timetime,idxNST,msg] = datePlusTime(dnt)
%DATEPLUSTIME parses the date and time from one input argument. The input could
%   dates alone or date and time together as one input.

msg = '';
idxNST = []; % unless otherwise stated

% Parse inputs
if isnumeric(dnt)       % If input is a column of serial dates/timetime
    % Get rid of any second data and any duplicate times as a result of having
    % second information.
    [dnt,idxNST,msg2] = rmvsec(dnt);
    
    if rem(dnt,1) ~= 0  % varargin{1} is a float: date and time are combined
        %timetime = mod(dnt,1);          % Get time serial number
        %dates = dnt - timetime;         % Get date serial number
        
        [Y,M,D,H,MI,S] = datevec(dnt);
        allZeros = zeros(length(Y),1);
        
        roundedS = round(S);
        loc60 = find(roundedS == 60);
        S = allZeros;
        S(loc60) = 60;
        
        timetime = datenum([allZeros,allZeros,allZeros,H,MI,S]);    % Get time serial number
        dates = datenum([Y,M,D,allZeros,allZeros,allZeros]);        % Get date serial number
        
    else                % varargin{1} is an integer: date only, no time data
        dates = dnt;
        timetime = [];
    end
elseif ischar(dnt)% If input is a column of strings ['01-jan-2001 13:00';'...]
    
    % The following lines of code are removed due to the inability to fully
    % catch all the errors that may occur with allowing string matricies as inputs
    %
    %     colind=strfind((dnt(1,:)),':');     % Where is the ':'
    %     spaceind=strfind((dnt(1,:)),' ');   % Where is the ' '
    %     if isempty(colind)  % If there is no ':' --> no time data
    %         dates=datenum(dnt);             % Get date serial number
    %         timetime=[];
    %     elseif isempty(spaceind)% If there is a ' ' --> date & time are invalid
    %         msg='Invalid DATES and TIMES format.';
    %         dates=[]; timetime=[]; dt=[];
    %         return
    %     else                % If there is a ':' --> there is time data
    %         dates=datenum(dnt(:,1:colind-3));       % Get date serial number
    %         timetime=datenum(dnt(:,colind-2:end));  % Get time serial number
    %     end
    
    % Column of strings not allowed. Too difficult to check for.
    msg = 'DATES must be a column vector or a column cell array.';
    dates = []; timetime = []; dt = [];
    return
elseif iscell(dnt)% If input is a column of cells ({'01-jan-2001 13:00';'...})
    colind = strfind((dnt{1}),':');               % Where is the ':'
    %spaceind = strfind((dnt{1}),' ');             % Where is the ' '
    if isempty(colind)  % If there is no ':' --> no time data
        % Get serial num
        [Y,M,D,H,MI,S] = datevec(dnt);
        dates = datenum([Y,M,D]);                   % Get date serial number
        
        % Get rid of any duplicate dates and return ind of new dates taken
        [dates,idxNST,msg2] = rmvsec(dates);
        timetime = [];
    else                % If there is a ':' --> there is time data
        % Get rid of any duplicate dates, seconds, and return ind of new dates taken
        [Y,M,D,H,MI,S] = datevec(dnt);
        [datesNTime,idxNST,msg2] = rmvsec([Y,M,D,H,MI,S]);
        
        timetime = mod(datesNTime,1);          % Get time serial number
        dates = datesNTime - timetime;         % Get date serial number
    end
else
    msg = 'Invalid DATES format. Please see '' HELP '' for correct syntax.';
    dates = []; timetime = []; dt = [];
end

% Check if dates and timetime are the same length, but leave alone if time = []
if isempty(timetime)
    dt = [dates,timetime]; % Display dt if one or no output argument is specified
elseif size(dates,1) ~= size(timetime,1)
    msg = 'The lengths of DATES and TIMES are not the same.';
    dates = []; timetime = []; dt = []; 
    return
elseif size(dates,1) == size(timetime,1)
    dt = [dates,timetime]; % Display dt if one or no output argument is specified
end


% -DateThenTime--------------------------------------------------------------
function [dt,dates,timetime,idxNST,msg] = dateThenTime(dateIn,timeIn)
%DATETHENTIME parses the date and time when they are entered in separetly. 

msg = '';
idxNST = []; % unless otherwise stated

% Check what type of dates exist 
if isnumeric(dateIn)    % date = xxxxx (serial date)
    if rem(dateIn,1) ~= 0 % if dateIn is a float == contains time data
        msg = 'The DATES should not contain time information or the DATES are invalid.';
        dates = []; timetime = []; dt = [];
        return
    end
    
    dates = dateIn;
elseif ischar(dateIn)  % date = '01-jan-0000'
    if ~isempty(strfind(dateIn(1,:),':'))   % If ':' exists, there is time data
        msg = 'The DATES should not contain time information or the DATES are invalid.';
        dates = []; timetime = []; dt = [];
        return
    end
    
    [Y,M,D,H,MI,S] = datevec(dateIn);
    dates = datenum([Y,M,D]);
elseif iscell(dateIn)  % date = ({'01-jan-0000'})
    if ~isempty(strfind(dateIn{1},':'));    % If ':' exists, there is time data
        msg = 'The DATES should not contain time information or the DATES are invalid.';
        dates = []; timetime = []; dt = [];
        return
    end
    
    %dates = datenum(char(dateIn));
    [Y,M,D,H,MI,S] = datevec(dateIn);
    dates = datenum([Y,M,D]);
else
    msg = 'DATES must be serial dates, strings, or a cell array in column form.';
    dates = []; timetime = []; dt = [];
    return
end

% Check what type of timetime exist 
if ischar(timeIn) | iscell(timeIn)      % time = '13:00' or {'13:00'}
    if isempty(strfind(timeIn(1,:),':'))   % If ':' does not exist, there is no time data
        msg = 'Invalid TIMES.';
        timetime = []; dt = [];
        return
    end
   
    % Get rid of duplicate dates, seconds, and return ind
    [Y,M,D,H,MI,S] = datevec(timeIn);
    [timetime,idxNST,msg2] = rmvsec([Y,M,D,H,MI,S]);
else
    msg = 'TIMES must be strings or a cell array in column form.';
    timetime = []; dt = [];
    return
end

% Check to see if dates and timetime are the same length
if isempty(idxNST)
    if size(dates,1) ~= size(timetime,1)
        msg = 'The lengths of DATES and TIMES are not the same.';
        dates = []; timetime = []; dt = [];
        return
    end
    dt = [dates,timetime]; % Display dt if one or no output argument is specified
else
    dates = dates(idxNST);
    if size(dates,1) ~= size(timetime,1)
        msg = 'The lengths of DATES and TIMES are not the same.';
        dates = []; timetime = []; dt = [];
        return
    end
    dt = [dates,timetime]; % Display dt if one or no output argument is specified
end

% [EOF]
