function info = ftsinfo(fts)
%@FINTS/FTSINFO Financial Time Series Object Information
%
%   FTSINFO(FTS) displays the information of the financial time
%   series object FTS.
%
%   INFOFTS = FTSINFO(FTS) obtains the information of the financial 
%   time series object FTS and stores them in the structure INFOFTS. 
%   INFOFTS has the following fields:
%
%      version     - the version of the time series object
%      desc        - description of the time series object (FTS.desc),
%      freq        - frequency of the time series data (FTS.freq),
%      startdate   - earliest date in the time series data,
%      enddate     - latest date in the time series data,
%      seriesnames - names of the columns of time series data,
%      ndata       - number of data points in the time series,
%      nseries     - number of columns of time series data.
%
%   The field 'seriesnames' is a cell array containing the time series 
%   data column names.  And, 'freq' contains the numeric representation 
%   of the time series data frequency (see help of FREQSTR for list).
%
%   Example:
%
%         dis = ascii2fts('disney.dat', 1, 3, 2);
%         ftsinfo(dis)
%
%      will give you
%
%          FINTS version: 1.0/1.1
%            Description: Walt Disney Company (DIS)					
%              Frequency: Unknown
%             Start date: 29-Mar-1996
%               End date: 29-Mar-1999
%           Series names: OPEN
%                         HIGH
%                         LOW
%                         CLOSE
%                         VOLUME
%              # of data: 782
%            # of series: 5
%
%      Then, executing
%
%         infodis = ftsinfo(dis)
%
%      will result in
%
%         infodis = 
%                     ver: '1.0/1.1'
%                    desc: 'Walt Disney Company (DIS)'
%                    freq: 0
%               startdate: '29-Mar-1996'
%                 enddate: '29-Mar-1999'
%             seriesnames: {5x1 cell}
%                   ndata: 782
%                 nseries: 5
%
%   See also FINTS, FTSBOUND, FREQSTR, FREQNUM.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.3.2.1 $   $Date: 2003/01/16 12:50:54 $

%Check input.
if nargin ~= 1
    error('Ftseries:ftseries_fints_ftsinfo:InputRequired', ...
        'A Financial Time Series object is required as an input.');
else
    if ~isa(fts, 'fints')
        error('Ftseries:ftseries_fints_ftsinfo:InputMustBeFintsObject', ...
            'Please enter a Financial Time Series object.');
    end
end

% Determine version number
[ftsver,timeData]= fintsver(fts);
if ftsver == 1
    verStr = '1.0/1.1';
else
    verStr = '2.0';
end

% Determine version and get date or date/time accordingly
if ftsver == 1
    % Ver 1/1.1 and no time info
    startdate = datestr(min(fts.data{3}));%dates));
    enddate = datestr(max(fts.data{3}));%dates));
else
    if timeData == 1
        % Ver 2 w/ time info
        startdate = datestr(min(fts.data{3} + fts.data{5}),0);
        startdate = startdate(1:end-3);
        
        enddate = datestr(max(fts.data{3} + fts.data{5}),0);
        enddate = enddate(1:end-3);
    else
        % Ver 2 w/out time info
        startdate = datestr(min(fts.data{3}));%dates));
        enddate = datestr(max(fts.data{3}));%dates));
    end
end


%Process output base on number of output arguments.
switch nargout
case 0
    %desc = fts.desc;
    desc = fts.data{1};
    
    switch fts.data{2} %fts.freq
    case 0
        freq = 'Unknown';
    case 1
        freq = 'Daily';
    case 2
        freq = 'Weekly';
    case 3
        freq = 'Monthly';
    case 4
        freq = 'Quarterly';
    case 5
        freq = 'Semi-annual';
    case 6
        freq = 'Annual';
    end
    
    seriesnames = fieldnames(fts, 1);
    
    ndata       = size(fts, 1);
    nseries     = size(fts, 2);
    
    fprintf('\n');
    fprintf('  FINTS version: %s\n', verStr); 
    fprintf('    Description: %s\n', desc);
    fprintf('      Frequency: %s\n', freq);
    fprintf('     Start date: %s\n', startdate);
    fprintf('       End date: %s\n', enddate);
    
    fprintf('   Series names: %s\n', seriesnames{1});
    if length(seriesnames) > 1
        fprintf(repmat('                 %s\n', [1 nseries-1]), seriesnames{2:end});
    end
    
    fprintf('      # of data: %d\n', ndata);
    fprintf('    # of series: %d\n', nseries);
    fprintf('\n');
    
case 1
    info.ver         = verStr;
    info.desc        = fts.data{1};
    info.freq        = fts.data{2};
    info.startdate   = startdate;
    info.enddate     = enddate;
    info.seriesnames = fieldnames(fts, 1);
    info.ndata       = size(fts, 1);
    info.nseries     = size(fts, 2);
end

% [EOF]
