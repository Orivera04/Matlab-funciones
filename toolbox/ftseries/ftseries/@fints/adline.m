function adlnts = adline(ftsa, varargin)
%@FINTS/ADLINE Accumulation/Distribution Line of a FINTS object.
%
%   ADLNTS = adline(FTS) calculates the Accumulation/Distribution
%   Line, ADLNTS, from tha data contained in the financial time series 
%   object FTS.  FTS must at least contain data series with names 'High', 
%   'Low', 'Close', and 'Volume'.  These series must represent the high,
%   low, and closing prices, plus the volume traded.  ADLNTS is a financial
%   time series object with the same dates as FTS but only one series named
%   'ADLine'.
%
%   ADLNTS = adline(FTS, ParameterName, ParameterValue, ... ) does the
%   same thing as above with the exception of the parameter name-value 
%   pairs.  The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'HighName'  :  high prices series name
%         'LowName'   :  low prices series name
%         'CloseName' :  closing prices series name
%         'VolumeName':  volume traded series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_ADLine = adline(dis);
%              plot(dis_ADLine);
%
%   See also FINTS/ADOSC, FINTS/WILLAD, FINTS/WILLPCTR.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 56-58

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.15 $   $Date: 2002/01/21 12:25:53 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
highnm  = 'high';
lownm   = 'low';
closenm = 'close';
volnm   = 'volume';
switch nargin
case 1
case {3, 5, 7, 9}
    for nidx = 1:2:nargin-1
        switch lower(varargin{nidx}(1))
        case 'h'   % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l'   % 'LowName'
            lownm = lower(varargin{nidx+1});
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        case 'v'   % 'VolumeName'
            volnm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_adline:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_adline:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm closenm volnm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_adline:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);
closep  = ftsa.data{4}(:, snameidx(3)-3);
tvolume = ftsa.data{4}(:, snameidx(4)-3);

% Calculate A/D Line by calling generalized ADLINE.
adln = adline(highp, lowp, closep, tvolume);

% Assign output time series.
adlnts              = fints;
adlnts              = chfield(adlnts,'series1','ADLine');   % Rename the default series name
adlnts.data{1}      = ['ADLine: ', ftsa.data{1}];           % desc
adlnts.data{2}      = ftsa.data{2};                         % freq
adlnts.data{3}      = ftsa.data{3};                         % dates
adlnts.data{4}      = adln(:);                              % data
adlnts.data{5}      = ftsa.data{5};                         % time
adlnts.datacount    = length(adln);
adlnts.serscount    = 1;

% [EOF]