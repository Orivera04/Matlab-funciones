function fts = toweekly(ftsa)
%@FINTS/TOWEEKLY converts a FINTS object to one of a weekly freq. 
%
%   NEWFTS = TOWEEKLY(OLDFTS) converts the object OLDFTS to the weekly 
%   time series object NEWFTS.  It will set the dates to the Friday of 
%   each week.
%
%   Note: If the OLDFTS contains times, the NEWFTS will contain the 
%   time '00:00' for specific dates that do not already exist. Existing
%   dates and times take precedence and will appear as they did in the
%   OLDFTS.
%
%   In addition, TOWEEKLY will display only the last date and last time
%   of the Friday of each week.
%
%   See also TOANNUAL, TODAILY, TOMONTHLY, TOQUARTERLY, TOSEMI.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11.2.1 $   $Date: 2003/01/16 12:51:08 $

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% If input object does not have a description, use object name instead.
if isempty(ftsa.data{1}),
    ftsa.data{1} = inputname(1);
end

% Create output object.
fts = fints;

% Convert any object into a daily object.  Then, convert it back to the original
% frequency.  This is to make sure that the dates line up correctly.
dfts = todaily(ftsa);
if ftsa.data{2} > 0 & ftsa.data{2} < 2,
    dfts = convertto(dfts, ftsa.data{2});
end

% Generate the weekly dates.
if isempty(dfts.data{3})
    error('There is no data and/or the specified dates are not valid business days');
else
    weeklydays = busdays(dfts.data{3}(1), dfts.data{3}(end), 'weekly');
end

% Generate actual end of week dates.
endofweek = weeklydays + (6-mod(weeklydays+5, 7));

% Make sure all the dates are fridays and valid business days. If not,
% find the previous business day.
busDayFlags = isbusday(endofweek);
while any(~busDayFlags)
    nonBusDays = find(busDayFlags == 0);
    prevDay = endofweek(nonBusDays) - 1;
    endofweek(nonBusDays) = prevDay;
    busDayFlags = isbusday(endofweek);
end

% Find the weekly dates within the daily dates.  The business end-of-the-week day  
% is only a place holder; it is not the end of the weekly period.  The end of 
% the weekly period is still the Saturday of the week in question.
weekdatesloc = [];
for adlidx = 1:length(weeklydays)
    % Find where the first occurance of the weekly dates exist
    if timeData
        sameDates = find(endofweek(adlidx) == dfts.data{3});
        firstOccur(adlidx) = min(sameDates);
        lastOccur(adlidx) = max(sameDates);
        
        datesloc = find(dfts.data{3} <= endofweek(adlidx));
        %weekdatesloc(adlidx) = datesloc(end);
        lastOccur(adlidx) = datesloc(end);
        weekdatesloc = [weekdatesloc; sameDates];
    else
        datesloc = find(dfts.data{3} <= endofweek(adlidx));
        weekdatesloc(adlidx) = datesloc(end);
    end
end

% Extract/average data.
% Remove all NaN's (set == 0) but average over the same number of days each time.
didx = 1;

allData = dfts.data{4}(1:weekdatesloc(didx), :);
numDataPts = size(allData,1);
theNans = isnan(allData);
allData(theNans) = 0;
sumOfNonNan = sum(allData,1);

weeklydata(didx, :) = sumOfNonNan ./ numDataPts;
if timeData
    for didx = 2:length(firstOccur)
        allData2 = dfts.data{4}(lastOccur(didx-1)+1:lastOccur(didx), :);
        numDataPts2 = size(allData2,1);
        theNans2 = isnan(allData2);
        allData2(theNans2) = 0;
        sumOfNonNan2 = sum(allData2,1);
        
        weeklydata(didx, :) = sumOfNonNan2 ./ numDataPts2;
    end
else
    for didx = 2:length(weekdatesloc)
        allData2 = dfts.data{4}(weekdatesloc(didx-1)+1:weekdatesloc(didx), :);
        numDataPts2 = size(allData2,1);
        theNans2 = isnan(allData2);
        allData2(theNans2) = 0;
        sumOfNonNan2 = sum(allData2,1);
        
        weeklydata(didx, :) = sumOfNonNan2 ./ numDataPts2;
    end
end

% Fill the new daily object.
fts.names     = ftsa.names;
fts.data{1}   = ['TOWEEKLY: ', ftsa.data{1}];   % desc
fts.data{2}   = 2;                              % freq
fts.data{3}   = weeklydays;                     % dates
fts.data{4}   = weeklydata;                     % data
if timeData 
    fts.data{5} = dfts.data{5}(lastOccur);      % times
else
    fts.data{5} = [];                           % times
end
fts.datacount = size(weeklydays,1);
fts.serscount = ftsa.serscount;

% [EOF]
