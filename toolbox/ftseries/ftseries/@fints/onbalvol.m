function obvts = obvol(ftsa, varargin)
%@FINTS/ONBALVOL On-Balance Volume of a FINTS object.
%
%   OBVTS = ONBALVOL(FTS) calculates the On-Balance Volume from the 
%   stock data in the financial time series object FTS.  The object
%   must minimally contain series names 'Close' and 'Volume'.  OBVTS 
%   is a FINTS object with the same dates as FTS and a series named
%   'OnBalVol'.
%
%   OBVTS = ONBALVOL(FTS, ParameterName, ParameterValue, ... ) does the
%   same thing as above with the exception of the parameter name-value 
%   pairs.  The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'CloseName'   :  close prices series name
%         'VolumeName'  :  volume traded series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_OBV = onbalvol(dis);
%              plot(dis_OBV);
%
%   See also FINTS/NEGVOLIDX, FINTS/POSVOLIDX.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 207-209

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:22:06 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

% Check input arguments.
closenm = 'close';
volnm   = 'volume';
switch nargin
case 1
case {3, 5}
    for nidx = 1:2:nargin-1
        switch lower(varargin{nidx}(1))
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        case 'v'   % 'VolumeName'
            volnm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_onbalvol:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_onbalvol:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {closenm volnm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx),
    error('Ftseries:ftseries_fints_onbalvol:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
closep  = ftsa.data{4}(:, snameidx(1)-3);
tvolume = ftsa.data{4}(:, snameidx(2)-3);

% Calculate the On-Balance Volume by calling the generalized ONBALVOL.
obv = onbalvol(closep, tvolume);

% Assign output time series.
obvts           = fints;
obvts           = chfield(obvts,'series1','OnBalVol');  % Rename series name
obvts.data{1}   = ['OnBalVol: ', ftsa.data{1}];         % desc
obvts.data{2}   = ftsa.data{2};                         % freq
obvts.data{3}   = ftsa.data{3};                         % dates
obvts.data{4}   = obv(:);                               % data
obvts.data{5}   = ftsa.data{5};                         % times
obvts.datacount = length(obv);
obvts.serscount = 1;

% [EOF]