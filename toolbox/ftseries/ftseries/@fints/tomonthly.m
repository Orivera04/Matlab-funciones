function fts = tomonthly(ftsa)
%@FINTS/TOMONTHLY converts a FINTS object to one of a monthly freq. 
%
%   NEWFTS = TOMONTHLY(OLDFTS) converts the object OLDFTS to the 
%   monthly time series object NEWFTS.  It will set the date to the 
%   end of each month.  However, if the last day of the month is not
%   a business day, TOMONTHLY will set the last day of the month to
%   the nearest, previous date that is a business day.
%
%   Note: If the OLDFTS contains times, the NEWFTS will contain the 
%   time '00:00' for specific dates that do not already exist. Existing
%   dates and times take precedence and will appear as they did in the
%   OLDFTS.
%
%   In addition, TOMONTHLY will display only the last date and last time
%   of the end of each month.
%
%   See also TODAILY, TOWEEKLY, TOQUARTERLY, TOSEMI, TOANNUAL.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:51:05 $

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

% Create output object.
fts = fints;

% Convert any object into a daily object.  Then, convert it back to the original
% frequency.  This is to make sure that the dates line up correctly.
dfts = todaily(ftsa,2);
if ftsa.data{2} > 0 & ftsa.data{2} < 3
    dfts = convertto(dfts, ftsa.data{2});
end

% Generate the monthly dates.
monthlydays = busdays(dfts.data{3}(1), dfts.data{3}(end), 'monthly');

% Generate actual end of the month dates.
[y, m] = datevec(monthlydays);
endofmonth = datenum(y, m+1, 1) - 1;

% Make sure all the dates are valid business days. If not,
% find the previous business day.
busDayFlags = isbusday(endofmonth);
while any(~busDayFlags)
    nonBusDays = find(busDayFlags == 0);
    prevDay = endofmonth(nonBusDays) - 1;
    endofmonth(nonBusDays) = prevDay;
    busDayFlags = isbusday(endofmonth);
end

% Find the monthly dates within the daily dates.  The business end-of-the-month 
% day is only a place holder; it is not the end of the monthly period.  The end 
% of the monthly period is still the actual end of month in question.
mondatesloc = [];
for adlidx = 1:length(monthlydays)
    % Find where the first occurance of the monthly dates exist
    if timeData
        sameDates = find(endofmonth(adlidx) == dfts.data{3});
        firstOccur(adlidx) = min(sameDates);
        lastOccur(adlidx) = max(sameDates);
        
        datesloc = find(dfts.data{3} <= endofmonth(adlidx));
        %mondatesloc(adlidx) = datesloc(end);
        lastOccur(adlidx) = datesloc(end);
        mondatesloc = [mondatesloc; sameDates];
    else
        datesloc = find(dfts.data{3} <= endofmonth(adlidx));
        mondatesloc(adlidx) = datesloc(end);
    end
end

% Extract/average data.
% Remove all NaN's (set == 0) but average over the same number of days each time.
didx = 1;

allData = dfts.data{4}(1:mondatesloc(didx), :);
numDataPts = size(allData,1);
theNans = isnan(allData);
allData(theNans) = 0;
sumOfNonNan = sum(allData,1);

monthlydata(didx, :) = sumOfNonNan ./ numDataPts;
if timeData
    for didx = 2:length(firstOccur)
        allData2 = dfts.data{4}(lastOccur(didx-1)+1:lastOccur(didx), :);
        numDataPts2 = size(allData2,1);
        theNans2 = isnan(allData2);
        allData2(theNans2) = 0;
        sumOfNonNan2 = sum(allData2,1);
        
        monthlydata(didx, :) = sumOfNonNan2 ./ numDataPts2;
    end
else
    for didx = 2:length(mondatesloc)
        allData2 = dfts.data{4}(mondatesloc(didx-1)+1:mondatesloc(didx), :);
        numDataPts2 = size(allData2,1);
        theNans2 = isnan(allData2);
        allData2(theNans2) = 0;
        sumOfNonNan2 = sum(allData2,1);
        
        monthlydata(didx, :) = sumOfNonNan2 ./ numDataPts2;
    end
end

% Fill the new daily object.
fts.names     = ftsa.names;
fts.data{1}   = ['TOMONTHLY: ', ftsa.data{1}];  % desc      
fts.data{2}   = 3;                              % freq
fts.data{3}   = monthlydays;                    % dates
fts.data{4}   = monthlydata;                    % data
if timeData
    fts.data{5} = dfts.data{5}(lastOccur);      % times
else
    fts.data{5} = [];                           % times
end
fts.datacount = size(monthlydays,1);
fts.serscount = ftsa.serscount;

% [EOF]