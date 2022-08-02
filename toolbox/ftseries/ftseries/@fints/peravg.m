function avgts = peravg(ftsa, periodspec)
%@FINTS/PERAVG calculates the periodic average of a FINTS object.
%
%   PERAVG calculates periodic averages of a FINTS object.  Periodic 
%   averages are calculated from the values per period defined.  If 
%   the period supplied is a string, it is assumed as a range of date 
%   string.  If, however, the period is entered as numeric, the number 
%   represents the number of data points (FINTS periods) to be included 
%   in a period for the calculation.
%
%   For example, if you enter '01-Jan-2001::03-Jan-2001' as the period
%   input argument, PERAVG will return the average of the time series
%   between those date, inclusive.  However, if you enter the number 5 as 
%   the period input, PERAVG will return a series of averages from the
%   time series data taken 5 date points (FINTS periods) at a time.
%
%   AVGFTS = PERAVG(FTS, NUMPERIOD) returns a structure AVGFTS that 
%   contains the periodic (per NUMPERIOD periods) average of the FINTS
%   object FTS.  The structure will have fieldnames identical to data
%   series names of FTS.  Default, NUMPERIOD = 5.
%
%   For example:
%
%      %% Create the FINTS object %%
%      dates = ['01-Jan-2001';'01-Jan-2001'; '02-Jan-2001'; ...
%              '02-Jan-2001'; '03-Jan-2001';'03-Jan-2001'];
%      times = ['11:00';'12:00';'11:00';'12:00';'11:00';'12:00'];
%      dates_times = cellstr([dates, repmat(' ',size(dates,1),1), times]);
%      myFts = fints(dates_times,(1:6)',{'Data1'},1,'My first FINTS')
%      %% Create the FINTS object %%
%
%      p = peravg(myFts,3)
%      p = 
%          Data1: [2 5]
%
%   AVGFTS = PERAVG(FTS, DATERANGE) returns a structure AVGFTS that 
%   contains the period (as specified by DATERANGE) average of the FINTS
%   object FTS.  The structure will have fieldnames identical to data
%   series names of FTS.
%
%   For example:
%
%      p = peravg(myFts,'01-Jan-2001 12:00::03-Jan-2001 11:00')
%      p =
%          Data1: 3.5000
%
%   See also MEAN, TSMOVAVG.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11.2.1 $   $Date: 2003/01/16 12:50:59 $

% Get version and if there is time data
[ftsVersion,timeData] = fintsver(ftsa);
if ftsVersion
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

if ~exist('periodspec', 'var') | isempty(periodspec)
    periodspec = 5;
end

if ftsa.data{3}(1) > ftsa.data{3}(2)
    ftsdata = flipud(ftsa.data{4});
else
    ftsdata = ftsa.data{4};
end

if isnumeric(periodspec)
    leftover = rem(ftsa.datacount, periodspec);
    
    partdata = ftsdata(1:end-leftover, :);
    numperiods = size(partdata, 1)/periodspec;
    reshpdata = reshape(partdata, periodspec, numperiods*ftsa.serscount);
    
    meandata1 = reshape(mean(reshpdata, 1), numperiods, ftsa.serscount);
    if leftover
        meandata2 = mean(ftsdata(end-leftover+1:end, :), 1);
    else
        meandata2 = [];
    end
    meandata  = [meandata1; meandata2];
elseif ischar(periodspec)
    % Convert periodspec to cell array if it is not already. Subsref requires this.
    if ~iscell(periodspec)
        periodspec = cellstr(periodspec);
    end
    
    % Call Subsref to get the data;
    s(1).type = '()';
    s(1).subs = periodspec;
    
    try
        fts = feval(@subsref, ftsa, s);
    catch
        errMsg = lasterror;
        try
            s(2).subs;
        catch
            subsrefCall = sprintf([inputname(1),'(''DATERANGE'')']);
            
            error('Ftseries:peravg:SubsrefError', ...
                sprintf([subsrefCall, ' is the function call\n', ...
                    'that was made to @FINTS/SUBSREF via @FINTS/PERAVG.\n\n', ...
                    'The resulting error is:\n\n', errMsg.message]));
        end
    end
    
    % Create a matrix of the data and find its mean
    dataMtx = fts2mat(fts);
    meandata = mean(dataMtx);
end

for idx = 4:length(ftsa.names)-1
    avgts.(char(ftsa.names(idx))) = meandata(:,idx-3)';
end

% [EOF]
