function vrocts = volroc(ftsa, varargin)
%@FINTS/VOLROC Volume Rate-of-Change of a FINTS object.
%
%   VROCTS = volroc(FTS) calculates the volume rate-of-change, VROCTS, 
%   from the financial time series object FTS.  The volume rate-of-change 
%   is calculated between the current volume and the volume 12 periods 
%   ago.  VROCTS is a FINTS object with similar dates as FTS and data 
%   series named 'VolumeROC'.
%
%   VROCTS = volroc(FTS, NPERIODS) calculates the volume rate-of-change, 
%   VROCTS, similarly as above except, instead of the 12-period difference,
%   it is NPERIODS period difference.  The volume rate-of-change is 
%   calculated between the current volume and the volume NPERIODS periods 
%   ago.
%
%   VROCTS = volroc(FTS, NPERIODS, ParameterName, ParameterValue) does the
%   same thing as above with the exception of the parameter name-value 
%   pairs.  The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'VolumeName'  :  volume traded series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_VROC = volroc(dis);
%              plot(dis_VROC);
%
%   See also FINTS/PRCROC.
%

%
%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 310-311
%

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.12 $   $Date: 2002/02/11 09:13:58 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
volnm  = 'volume';
switch nargin
case 1
    nperiods = 12;
case 2
    nperiods = varargin{1};
    if prod(size(nperiods)) ~= 1 | floor(nperiods) ~= nperiods
        error('Ftseries:ftseries_fints_volroc:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
case 4
    nperiods = varargin{1};
    if prod(size(nperiods)) ~= 1 | floor(nperiods) ~= nperiods
        error('Ftseries:ftseries_fints_volroc:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    if lower(varargin{2}(1)) == 'v'
        volnm = lower(varargin{2+1});
    else
        error('Ftseries:ftseries_fints_volroc:InvalidParameterName', ...
            'Invalid ParameterName.');
    end
otherwise
    error('Ftseries:ftseries_fints_volroc:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = volnm;
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_volroc:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
tvolume = ftsa.data{4}(:, snameidx-3);

% Calculate the Volume Rate-of-Change by calling the generalized VOLROC.
vroc = volroc(tvolume, nperiods);

% Assign output time series.
vrocts           = fints;
vrocts           = chfield(vrocts,'series1','VolumeROC');   % rename series name
vrocts.data{1}   = ['VolROC: ', ftsa.data{1}];          % desc
vrocts.data{2}   = ftsa.data{2};                        % freq
vrocts.data{3}   = ftsa.data{3};                        % dates
vrocts.data{4}   = vroc(:);                             % data
vrocts.data{5}   = ftsa.data{5};                        % times
vrocts.datacount = length(vroc);
vrocts.serscount = 1;

% [EOF]
