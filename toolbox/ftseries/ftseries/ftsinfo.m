function info = ftsinfo(fts)
%FTSINFO Financial Time Series Object Information
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
%   See also FINTS, FREQNUM, FREQSTR, FTSBOUND.

%   Author: P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.4.2.1 $   $Date: 2003/01/16 12:51:19 $

% Check input.
if nargin ~= 1
    error('Ftseries:ftseries_ftsinfo:InputRequired', ...
        'A Financial Time Series object is required as an input.');
else
    if ~isa(fts, 'fints')
        error('Ftseries:ftseries_ftsinfo:InputMustBeFintsObject', ...
            'Please enter a Financial Time Series object.');
    end
end

% [EOF]
