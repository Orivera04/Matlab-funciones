function choscts = chaikosc(ftsa, varargin)
%@FINTS/CHAIKOSC Chaikin Oscillator of a FINTS object.
%
%   CHOSCTS = chaikosc(FTS) calculates the Chaikin Oscillator, CHOSCTS, 
%   from tha data contained in the financial time series object FTS.  FTS 
%   must at least contain data series with names 'High', 'Low', 'Close', 
%   and 'Volume'.  These series must represent the high, low, and closing 
%   prices, plus the volume traded.  CHOSCTS is a financial time series 
%   object with the same dates as FTS but only one series named 'ChaikOsc'.
%
%   CHOSCTS = chaikosc(FTS, ParameterName, ParameterValue, ... ) does the
%   same as above with the exception of the parameter name-value pairs.
%   The purpose for these pairs is to specify the name(s) for the
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
%   Chaikin Oscillator is calculated by subtracting the 10-period
%   exponential moving average of the Accumulation/Distribution (A/D) 
%   Line from the 3-period exponential moving average of the A/D Line.
%
%   Example:   load disney.mat
%              dis_ChaikOsc = chaikosc(dis);
%              plot(dis_ChaikOsc);
%
%   See also FINTS/ADLINE.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 91-94

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.12 $   $Date: 2002/01/21 12:25:38 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
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
            error('Ftseries:ftseries_fints_chaikosc:InvalidParameterName', ...
                'Invalid Parameter Name.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_chaikosc:InvalidNumberOfArguments', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm closenm volnm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_chaikosc:MissingSeriesName', ...
        'One or more required series are not found.  Please check the series names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);
closep  = ftsa.data{4}(:, snameidx(3)-3);
tvolume = ftsa.data{4}(:, snameidx(4)-3);

% Calculate Chaikin Oscillator by calling generalized CHAIKOSC.
chosc = chaikosc(highp, lowp, closep, tvolume);

% Assign output time series.
choscts = fints;
choscts = chfield(choscts,'series1','ChaikOsc');    % Rename the default series name
choscts.data{1} = ['ChaikOsc: ', ftsa.data{1}];     % desc
choscts.data{2} = ftsa.data{2};                     % freq
choscts.data{3} = ftsa.data{3};                     % dates
choscts.data{4} = chosc(:);                         % datea
choscts.data{5} = ftsa.data{5};                     % times
choscts.datacount = length(chosc);
choscts.serscount = 1;

% [EOF]
