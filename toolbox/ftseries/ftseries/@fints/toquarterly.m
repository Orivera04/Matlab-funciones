function fts = toquarterly(ftsa)
%@FINTS/TOQUARTERLY converts a FINTS object to one of a quarterly freq. 
%
%   NEWFTS = TOQUARTERLY(OLDFTS) converts the object OLDFTS to the 
%   quarterly time series object NEWFTS.  It will set the dates to the 
%   end of each quarter i.e. 31st of March, 30th of June, 30th of 
%   September, and 31st of December.  However, if the end of each quarter 
%   is not a business day, TOQUARTERLY will set the end of each quarter
%   to the nearest, previous date that is a business day.
%
%   Note: If the OLDFTS contains times, the NEWFTS will contain the 
%   time '00:00' for specific dates that do not already exist. Existing
%   dates and times take precedence and will appear as they did in the
%   OLDFTS.
%
%   In addition, TOQUARTERLY will display only the last date and last time
%   of the end of each quarter.
%
%   See also TODAILY, TOWEEKLY, TOMONTHLY, TOSEMI, TOANNUAL.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:51:06 $

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
dfts = todaily(ftsa,3);
if ftsa.data{2} > 0 & ftsa.data{2} < 4
    dfts = convertto(dfts, ftsa.data{2});
end

% Generate the quarterly dates.
quarterlydays = busdays(dfts.data{3}(1), dfts.data{3}(end), 'quarterly');

% Generate actual end of the quarter dates.
[y, m] = datevec(quarterlydays);
endofquarter = datenum(y, m+1, 1) - 1;

% Make sure all the dates are valid business days. If not,
% find the previous business day.
busDayFlags = isbusday(endofquarter);
while any(~busDayFlags)
    nonBusDays = find(busDayFlags == 0);
    prevDay = endofquarter(nonBusDays) - 1;
    endofquarter(nonBusDays) = prevDay;
    busDayFlags = isbusday(endofquarter);
end

% Find the quarterly dates within the daily dates.  The business end-of-the-quarter 
% day is only a place holder; it is not the end of the quarterly period.  The end 
% of the quarter period is still the actual end of quarter in question.
quartdatesloc = [];
for adlidx = 1:length(quarterlydays)
    % Find where the first occurance of the quarterly dates exist
    if timeData
        sameDates = find(endofquarter(adlidx) == dfts.data{3});
        firstOccur(adlidx) = min(sameDates);
        lastOccur(adlidx) = max(sameDates);
        
        datesloc = find(dfts.data{3} <= endofquarter(adlidx));
        %quartdatesloc(adlidx) = datesloc(end);
        lastOccur(adlidx) = datesloc(end);
        quartdatesloc = [quartdatesloc; sameDates];
    else
        datesloc = find(dfts.data{3} <= endofquarter(adlidx));
        quartdatesloc(adlidx) = datesloc(end);
    end
end

% Extract/average data.
% Remove all NaN's (set == 0) but average over the same number of days each time.
didx = 1;

allData = dfts.data{4}(1:quartdatesloc(didx), :);
numDataPts = size(allData,1);
theNans = isnan(allData);
allData(theNans) = 0;
sumOfNonNan = sum(allData,1);

quarterlydata(didx, :) = sumOfNonNan ./ numDataPts;
if timeData
    for didx = 2:length(firstOccur)
        allData2 = dfts.data{4}(lastOccur(didx-1)+1:lastOccur(didx), :);
        numDataPts2 = size(allData2,1);
        theNans2 = isnan(allData2);
        allData2(theNans2) = 0;
        sumOfNonNan2 = sum(allData2,1);
        
        quarterlydata(didx, :) = sumOfNonNan2 ./ numDataPts2;
    end
else
    for didx = 2:length(quartdatesloc)
        allData2 = dfts.data{4}(quartdatesloc(didx-1)+1:quartdatesloc(didx), :);
        numDataPts2 = size(allData2,1);
        theNans2 = isnan(allData2);
        allData2(theNans2) = 0;
        sumOfNonNan2 = sum(allData2,1);
        
        quarterlydata(didx, :) = sumOfNonNan2 ./ numDataPts2;
    end
end

% Fill the new daily object.
fts.names     = ftsa.names;
fts.data{1}   = ['TOQUARTERLY: ', ftsa.data{1}];    % desc
fts.data{2}   = 4;                                  % freq
fts.data{3}   = quarterlydays;                      % dates
fts.data{4}   = quarterlydata;                      % data
if timeData
    fts.data{5} = dfts.data{5}(lastOccur);          % times
else
    fts.data{5} = [];                               % times
end
fts.datacount = size(quarterlydays,1);
fts.serscount = ftsa.serscount;

% [EOF]