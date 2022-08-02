function fts = todaily(ftsa,endOf)
%@FINTS/TODAILY converts a FINTS object to one of a daily freq. 
%
%   NEWFTS = TODAILY(OLDFTS) converts the object OLDFTS to the daily 
%   time series object NEWFTS.  It will assume a 5-day business week 
%   that is from Monday to Friday; Saturday and Sunday are considered to
%   belong to the previous week. TODAILY will set the starting day to
%   Monday and the ending day to Friday. 
%
%   Note: If the OLDFTS contains times, the NEWFTS will contain the 
%   time '00:00' for specific dates that do not already exist. Existing
%   dates and times take precedence and will appear as they did in the
%   OLDFTS.
%
%   NEWFTS = TODAILY(OLDFTS, PER) does the same as above except that
%   TODAILY will append business days (and/or times) ranging from the
%   last date (and/or time) in OLDFTS to the last date (and/or time) of
%   the period (PER) selected. Valid periods (PER) are: 0 (none), 
%   1 (annual), 2 (monthly), 3 (quarterly), or 4 (semi-annual).
%
%   See also TOANNUAL, TODAILY, TOMONTHLY, TOQUARTERLY, TOSEMI, TOWEEKLY.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/02/11 09:14:06 $

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% If input object does not have a description, use object name instead.
if isempty(ftsa.data{1})
    ftsa.data{1} = inputname(1);
end

if nargin == 2
    if ~isnumeric(endOf)
        error('Ftseries:todaily:InvalidPeriod', ...
            sprintf(['Invalid ''Period''. Valid ''Period'' are: 0 (none), 1 (annual),\n', ...
                '2 (monthly), 3 (quarterly), or 4 (semi-annual).']));
    elseif (endOf < 0) | (endOf > 4)
        error('Ftseries:todaily:InvalidPeriod', ...
            sprintf(['Invalid ''Period''. Valid ''Period'' are: 0 (none), 1 (annual),\n', ...
                '2 (monthly), 3 (quarterly), or 4 (semi-annual).']));
    end
else
    endOf = 0;
end

% Different conversion procedures based on the original object's frequency.
switch ftsa.data{2}
case {0,1}     % The input is a unknown/daily frequency time series: unknown/dailty -> daily.
    fts = ftsa;   % Copy the input object.
    
    ftsadates = ftsa.data{3};
    startdate = ftsa.data{3}(1);
    
    [yrS1, monS1, dayS1] = datevec(startdate);    
    
    % Get the Monday of the week of the startdate
    shiftdist = (mod(startdate+5, 7) - 1);
    shiftdist(shiftdist == -1) = 6;
    startdate = startdate - shiftdist;   % Shift dates to Monday but stay in the same month.
    
    [yrS2, monS2, dayS2] = datevec(startdate);
    if monS1 ~= monS2
        % The only way this can happen is if the starting date was a sat (0) or sun (6)
        % and the date was 1 or 2. In this scenerio, move the date forward since shiftdist
        % moved it back. i.e. f = fints(datenum('1-dec-2001'),999)
        
        % Push the startdate forward since it was set back to a Monday
        startdate = startdate + 1;
        
        % Find the next Monday
        dayOfWeek = (6-mod(startdate+5, 7));
        while dayOfWeek ~= 5 % Monday
            startdate = startdate + 1;
            dayOfWeek = (6-mod(startdate+5, 7));
        end
    end
    
    % Get the Friday of the week
    enddate = ftsa.data{3}(end);
    switch endOf
    case 0
        dayOfWeek = (6-mod(enddate+5, 7));
        if (dayOfWeek == 0) | (dayOfWeek == 6) % 0 = sat and 6 = sun
            % Get the closest Friday but stay within the current month. The only way it could
            % backtrack into a previous month is if the day number is 1 or 2 and they fall on a
            % sat or sun.
            
            % Move backward to find the closest Friday since sat and sun belong to the previous week.
            while dayOfWeek ~= 1 % Friday
                enddate = enddate - 1;
                dayOfWeek = (6-mod(enddate+5, 7));
            end
        else
            % Get the Firday of the end of this current week but do not go into the next month
            while dayOfWeek ~= 1 % Friday
                [yr1, mon1, day1] = datevec(enddate);
                
                enddate = enddate + 1;
                
                [yr2, mon2, day2] = datevec(enddate);
                if mon1 ~= mon2
                    enddate = enddate - 1;
                    dayOfWeek = 1;
                else                  
                    dayOfWeek = (6-mod(enddate+5, 7));
                end    
            end
        end
    case {1, 2, 3, 4}
        enddate = datefinder(enddate,endOf);
    otherwise
        error('Ftseries:todaily:InvalidPeriod', ...
            sprintf(['Invalid ''Period''. Valid ''Period'' are: 0 (none), 1 (annual),\n', ...
                '2 (monthly), 3 (quarterly), or 4 (semi-annual).']));
    end
    
    % Create the dates/time and data for generating the new FTS
    [dailydata,dailydays,dailyTimes] = freqchanger(ftsa,timeData,ftsadates,startdate,enddate);
case 2     % The input is a weekly time series: weekly -> daily.
    fts = fints;
    
    shiftdist = (mod(ftsa.data{3}+5, 7) - 1);
    shiftdist(shiftdist == -1) = 6;
    ftsadates = ftsa.data{3} - shiftdist;   % Shift dates to Mondays.
    startdate = ftsadates(1);               % Start on a Monday.
    enddate   = ftsadates(end) + 4;         % End on a Friday.
    
    % Create the dates/time and data for generating the new FTS
    [dailydata,dailydays,dailyTimes] = freqchanger(ftsa,timeData,ftsadates,startdate,enddate);
case 3     % The input is a monthly time series: monthly -> daily.
    fts = fints;
    
    [yr, mon, day] = datevec(ftsa.data{3});
    if any(~diff(mon)) & ~timeData
        error('Ftseries:todaily:MonthlyDatesNotUniq', ...
            'Your monthly dates are not unique.');
    end
    ftsadates = ftsa.data{3} - (day - 1);     % Shift dates to the first of the month.
    startdate = ftsadates(1);                 % Start on the first of the month.
    enddate   = eomdate(yr(end), mon(end));   % End on the end of the month.
    
    % Create the dates/time and data for generating the new FTS
    [dailydata,dailydays,dailyTimes] = freqchanger(ftsa,timeData,ftsadates,startdate,enddate);
case 4     % The input is a quarterly time series: quarterly -> daily.
    fts = fints;
    
    qmons(1, :) = [ 1  3];   % Begin and end months of quarter 1.
    qmons(2, :) = [ 4  6];   % Begin and end months of quarter 2.
    qmons(3, :) = [ 7  9];   % Begin and end months of quarter 3.
    qmons(4, :) = [10 12];   % Begin and end months of quarter 4.
    [yr, mon, day] = datevec(ftsa.data{3});
    quarter(find(mon>=qmons(1, 1) & mon<=qmons(1, 2))) = 1;
    quarter(find(mon>=qmons(2, 1) & mon<=qmons(2, 2))) = 2;
    quarter(find(mon>=qmons(3, 1) & mon<=qmons(3, 2))) = 3;
    quarter(find(mon>=qmons(4, 1) & mon<=qmons(4, 2))) = 4;
    if any(~diff(quarter)) & ~timeData
        error('Ftseries:todaily:QuarterlyDatesNotUniq', ...
            'Your quarterly dates are not unique.');
    end
    
    ftsadates = datenum(yr, qmons(quarter, 1), 1);          % Shift dates to the first of the quarter.
    startdate = ftsadates(1);                               % Start on the first of the quarter.
    enddate   = eomdate(yr(end), qmons(quarter(end), 2));   % End on the end of the quarter.
    
    % Create the dates/time and data for generating the new FTS
    [dailydata,dailydays,dailyTimes] = freqchanger(ftsa,timeData,ftsadates,startdate,enddate);
case 5     % The input is a semiannual time series: semiannual -> daily.
    fts = fints;
    
    samons(1, :) = [1  6];   % Begin and end months of semiannual period 1.
    samons(2, :) = [7 12];   % Begin and end months of semiannual period 2.
    [yr, mon, day] = datevec(ftsa.data{3});
    semiann(find(mon>=samons(1, 1) & mon<=samons(1, 2))) = 1;
    semiann(find(mon>=samons(2, 1) & mon<=samons(2, 2))) = 2;
    if any(~diff(semiann)) & ~timeData
        error('Ftseries:todaily:SemiannualDatesNotUniq', ...
            'Your semiannual dates are not unique.');
    end
    
    ftsadates = datenum(yr, samons(semiann, 1), 1);          % Shift dates to the first of the quarter.
    startdate = ftsadates(1);                                % Start on the first of the quarter.
    enddate   = eomdate(yr(end), samons(semiann(end), 2));   % End on the end of the quarter.
    
    % Create the dates/time and data for generating the new FTS
    [dailydata,dailydays,dailyTimes] = freqchanger(ftsa,timeData,ftsadates,startdate,enddate);
case 6     % The input is a annual time series: annual -> daily.
    fts = fints;
    
    [yr, mon, day] = datevec(ftsa.data{3});
    if any(~diff(yr)) & ~timeData
        error('Ftseries:todaily:AnnualDatesNotUniq', ...
            'Your annual dates are not unique.');
    end
    ftsadates = eomdate(yr-1, 12) + 1;   % Shift dates to the first of the year.
    startdate = ftsadates(1);            % Start on the first of the year.
    enddate   = eomdate(yr(end), 12);    % End on the end of the year.
    
    % Create the dates/time and data for generating the new FTS
    [dailydata,dailydays,dailyTimes] = freqchanger(ftsa,timeData,ftsadates,startdate,enddate);
otherwise
    error('Ftseries:todaily:InvalidFreq', ...
        'Either the frequency is invalid or the frequency is not set.');
end

% Fill the new daily object.
fts.names     = ftsa.names;
fts.data{1}   = ['TODAILY: ', ftsa.data{1}];    % desc
fts.data{2}   = 1;                              % freq
fts.data{3}   = dailydays;                      % dates
fts.data{4}   = dailydata;                      % data
if timeData
    fts.data{5} = dailyTimes;                   % times
else
    fts.data{5} = ftsa.data{5};                 % times
end
fts.datacount = length(dailydays);
fts.serscount = ftsa.serscount;

% -freqchanger-----------------------------------------------------------------------
function [dailydata,dailydays,dailyTimes] = freqchanger(ftsa,timeData,ftsadates,startdate,enddate)
%FREQCHANGER gets the dates, times, and data for the conversion from any freq to freq of 1

if timeData == 0    % No time data
    % Make sure that the available dates fall on business days.
    if sum(~isbusday(ftsadates)) ~= 0
        ftsadates(~isbusday(ftsadates)) = busdate(ftsadates(~isbusday(ftsadates)));
    end
    
    % Create a vector of business days and locate where the available dates
    % are in that business days vector.
    dailydays = busdays(startdate, enddate, 'daily');
    datesloc = datefind(ftsadates, dailydays);
    
    % Get the original date and data location
    origDateLoc = datefind(ftsa.data{3},dailydays);
    origDataLoc = datefind(dailydays(origDateLoc),ftsa.data{3});
    
    % Create a daily dataset with missing values set to NaN's.
    % Then, replace NaN's with the last non-NaN value.
    dailydata = NaN*ones(length(dailydays), ftsa.serscount);
    dailydata(origDateLoc, :) = ftsa.data{4}(origDataLoc,:);
    for idx = 1:length(dailydays)
        if isnan(dailydata(idx, :)) & (idx ~= 1) % if NaNs populate the first one, leave them alone
            dailydata(idx, :) = dailydata(idx-1, :);
        end
    end
    
    % Dummy variable when timeData == 0
    dailyTimes = [];
else    % There is time data
    % Make sure that the available dates fall on business days.
    if sum(~isbusday(ftsadates)) ~= 0
        ftsadates(~isbusday(ftsadates)) = busdate(ftsadates(~isbusday(ftsadates)));
    end
    
    % Create a vector of business days.
    dailydays = busdays(startdate, enddate, 'daily');
    
    % Create a matrix of NaN's
    [missingDailyDates,setDiffIdx] = setdiff(dailydays,ftsa.data{3});
    totNumOfDates = length(missingDailyDates) + length(ftsa.data{3});
    alldata = ones(totNumOfDates, ftsa.serscount) * nan;
    alldata(1:ftsa.datacount,:) = ftsa.data{4};
    
    % Create a vector of all the dates
    unsortedDailyDays = [ftsa.data{3}; missingDailyDates];
    
    % Create a vector of all the times
    unsortedDailyTimes = zeros(totNumOfDates,1);
    unsortedDailyTimes(1:ftsa.datacount) = ftsa.data{5};
    
    % Remove the non-business days
    sortedWantedDataRows = [];
    for daysIdx = 1:length(dailydays)
        existingDatesIdx = datefind(dailydays(daysIdx),unsortedDailyDays);
        sortedWantedDataRows = [sortedWantedDataRows; existingDatesIdx];
    end
    
    % Create a daily dataset with missing values set to NaN's.
    % Then, replace NaN's with the last non-NaN value.
    dailydays = unsortedDailyDays(sortedWantedDataRows);
    dailydata = alldata(sortedWantedDataRows,:);
    for idx = 1:length(dailydays)
        if isnan(dailydata(idx, :)) & (idx ~= 1) % if NaNs populate the first one, leave them alone
            dailydata(idx, :) = dailydata(idx-1, :);
        end
    end
    
    dailyTimes = unsortedDailyTimes(sortedWantedDataRows);
end

% -datefinder-----------------------------------------------------------------------
function enddate = datefinder(aDate,endOf)
%DATEFINDER finds the last day of the period specified

[yr, mon, day] = datevec(aDate);
switch endOf
case 1  % Annual
    enddate   = eomdate(yr(end), 12);    % End on the end of the year.
case 2  % Monthly
    enddate   = eomdate(yr(end), mon(end));   % End on the end of the month.
case 3  % Quarterly 
    qmons(1, :) = [ 1  3];   % Begin and end months of quarter 1.
    qmons(2, :) = [ 4  6];   % Begin and end months of quarter 2.
    qmons(3, :) = [ 7  9];   % Begin and end months of quarter 3.
    qmons(4, :) = [10 12];   % Begin and end months of quarter 4.
    quarter(find(mon>=qmons(1, 1) & mon<=qmons(1, 2))) = 1;
    quarter(find(mon>=qmons(2, 1) & mon<=qmons(2, 2))) = 2;
    quarter(find(mon>=qmons(3, 1) & mon<=qmons(3, 2))) = 3;
    quarter(find(mon>=qmons(4, 1) & mon<=qmons(4, 2))) = 4;
    
    enddate   = eomdate(yr(end), qmons(quarter(end), 2));   % End on the end of the quarter.
case 4  % Semi Annual
    samons(1, :) = [1  6];   % Begin and end months of semiannual period 1.
    samons(2, :) = [7 12];   % Begin and end months of semiannual period 2.
    semiann(find(mon>=samons(1, 1) & mon<=samons(1, 2))) = 1;
    semiann(find(mon>=samons(2, 1) & mon<=samons(2, 2))) = 2;
    
    enddate   = eomdate(yr(end), samons(semiann(end), 2));   % End on the end of the quarter.
end

% [EOF]
