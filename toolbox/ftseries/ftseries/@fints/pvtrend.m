function pvtts = pvtrend(ftsa, varargin)
%@FINTS/PVTREND Price and Volume Trend (PVT) of a FINTS object.
%
%   PVTTS = PVTREND(FTS) calculates the Price and Volume Trend (PVT) 
%   from the stock data contained in the financial time series 
%   object FTS.  The object must contain the closing price series 
%   'Close' and the traded volume series 'Volume'.  PVTTS is a FINTS
%   object with dates similar to FTS and a data series named 'PVT'.
%
%   PVTTS = PVTREND(FTS, ParameterName, ParameterValue, ... ) does 
%   the same as above with the exception of the parameter 
%   name-value pairs.  The purpose for these pairs is to specify the 
%   name(s) for the required data series in case they are different 
%   than the expected default name(s).  Valid ParameterName's are:
%
%         'CloseName'   :  close prices series name
%         'VolumeName'  :  volume traded series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_PVT = pvtrend(dis);
%              plot(dis_PVT);
%
%   See also FINTS/TSACCEL, FINTS/TSMOM.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 239-240

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:21:29 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
closenm = 'close';
volnm   = 'volume';
switch nargin
case 1
case {3, 5}
    for nidx = 1:2:nargin-1
        switch lower(varargin{nidx}(1)),
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        case 'v'   % 'VolumeName'
            volnm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_pvtrend:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_pvtrend:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {closenm volnm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_pvtrend:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
closep  = ftsa.data{4}(:, snameidx(1)-3);
tvolume = ftsa.data{4}(:, snameidx(2)-3);

% Calculate the Price and Volume Trend by calling the generalized PVTREND.
pvt = pvtrend(closep, tvolume);

% Assign output time series.
pvtts           = fints;
pvtts           = chfield(pvtts,'series1','PVT');   % Rename series
pvtts.data{1}   = ['PVTrend: ', ftsa.data{1}];      % desc
pvtts.data{2}   = ftsa.data{2};                     % freq
pvtts.data{3}   = ftsa.data{3};                     % dates
pvtts.data{4}   = pvt(:);                           % data
pvtts.data{5}   = ftsa.data{5};                     % times
pvtts.datacount = length(pvt);
pvtts.serscount = 1;

% [EOF]