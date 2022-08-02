function fts = toannual(ftsa)
%@FINTS/TOANNUAL converts a FINTS object to one of an annual freq. 
%
%   NEWFTS = TOANNUAL(OLDFTS) converts the object OLDFTS to the annual 
%   time series object NEWFTS.  It will set the dates to the end of the 
%   year i.e. 31st of December.  However, if the end of the year is not
%   a business day, TOANNUAL will set the end of the year to the
%   nearest, previous date that is a business day.
%
%   Note: If the OLDFTS contains times, the NEWFTS will contain the 
%   time '00:00' for specific dates that do not already exist. Existing
%   dates and times take precedence and will appear as they did in the
%   OLDFTS.
%
%   In addition, TOANNUAL will display only the last date and last time
%   of the end of the year.
%
%   See also TODAILY, TOWEEKLY, TOMONTHLY, TOQUARTERLY, TOSEMI. 

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:51:04 $

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
dfts = todaily(ftsa,1);
if ftsa.data{2} > 0 & ftsa.data{2} < 6
    dfts = convertto(dfts, ftsa.data{2});
end

% Generate the annual dates.
annualdays = busdays(dfts.data{3}(1), dfts.data{3}(end), 'annual');

% Generate actual end of the quarter dates.
[y, m] = datevec(annualdays);
endofannum = datenum(y, m+1, 1) - 1;

% Make sure all the dates are valid business days. If not,
% find the previous business day.
busDayFlags = isbusday(endofannum);
while any(~busDayFlags)
    nonBusDays = find(busDayFlags == 0);
    prevDay = endofannum(nonBusDays) - 1;
    endofannum(nonBusDays) = prevDay;
    busDayFlags = isbusday(endofannum);
end

% Find the annual dates within the daily dates.  The business end-of-the-annum
% day is only a place holder; it is not the end of the annual period.  The 
% end of the annual period is still the actual end of the annual period in 
% question.
anndatesloc = [];
for adlidx = 1:length(annualdays)
    % Find where the first occurance of the annual dates exist
    if timeData
        sameDates = find(endofannum(adlidx) == dfts.data{3});
        firstOccur(adlidx) = min(sameDates);
        lastOccur(adlidx) = max(sameDates);
        
        datesloc = find(dfts.data{3} <= endofannum(adlidx));
        %anndatesloc(adlidx) = datesloc(end);
        lastOccur(adlidx) = datesloc(end);
        anndatesloc = [anndatesloc; sameDates];
    else
        datesloc = find(dfts.data{3} <= endofannum(adlidx));
        anndatesloc(adlidx) = datesloc(end);
    end
end

% Extract/average data.
% Remove all NaN's (set == 0) but average over the same number of days each time.
didx = 1;

allData = dfts.data{4}(1:anndatesloc(didx), :);
numDataPts = size(allData,1);
theNans = isnan(allData);
allData(theNans) = 0;
sumOfNonNan = sum(allData,1);

annualdata(didx, :) = sumOfNonNan ./ numDataPts;
if timeData
    for didx = 2:length(firstOccur)
        allData2 = dfts.data{4}(lastOccur(didx-1)+1:lastOccur(didx), :);
        numDataPts2 = size(allData2,1);
        theNans2 = isnan(allData2);
        allData2(theNans2) = 0;
        sumOfNonNan2 = sum(allData2,1);
        
        annualdata(didx, :) = sumOfNonNan2 ./ numDataPts2;
    end
else
    for didx = 2:length(anndatesloc)
        allData2 = dfts.data{4}(anndatesloc(didx-1)+1:anndatesloc(didx), :);
        numDataPts2 = size(allData2,1);
        theNans2 = isnan(allData2);
        allData2(theNans2) = 0;
        sumOfNonNan2 = sum(allData2,1);
        
        annualdata(didx, :) = sumOfNonNan2 ./ numDataPts2;
    end
end

% Fill the new daily object.
fts.names     = ftsa.names;
fts.data{1}   = ['TOANNUAL: ', ftsa.data{1}];   % desc
fts.data{2}   = 6;                              % freq
fts.data{3}   = annualdays;                     % dates
fts.data{4}   = annualdata;                     % data
if timeData
    fts.data{5} = dfts.data{5}(lastOccur);      % times
else
    fts.data{5} = [];                           % times
end
fts.datacount = size(annualdays,1);
fts.serscount = ftsa.serscount;

% [EOF]