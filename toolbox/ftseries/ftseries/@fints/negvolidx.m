function nvits = negvolidx(ftsa, initnvi, varargin)
%@FINTS/NEGVOLIDX Negative Volume Index of a FINTS object.
%
%   NVITS = NEGVOLIDX(FTS) calculates the negative volume index from the 
%   financial time series object FTS.  The object must contain, at least, the
%   series 'Close' and 'Volume'.  NVITS is a FINTS object with dates similar 
%   to FTS and a data series named 'NVI'.  The initial value for the negative 
%   volume index is arbitrarily set to 100.
%
%   NVITS = NEGVOLIDX(FTS, INITNVI) calculates the negative volume index from 
%   the financial time series object FTS.  The object must contain, at least, 
%   the series 'Close' and 'Volume'.  NVITS is a FINTS object with dates 
%   similar to FTS and a data series named 'NVI'.  The initial value for the 
%   negative volume index is manually set to INITNVI.
%
%   NVITS = NEGVOLIDX(FTS, INITNVI, ParameterName, ParameterValue, ... ) does the
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
%              dis_NVI = negvolidx(dis);
%              plot(dis_NVI);
%
%   See also FINTS/ONBALVOL, FINTS/POSVOLIDX.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 193-194

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:22:11 $

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
    initnvi = 100;
case 2
    if (prod(size(initnvi)) ~= 1) | (floor(initnvi) ~= initnvi)
        error('Ftseries:ftseries_fints_negvolidx:INITNVIMustBeScalar', ...
            'INITNVI must be a scalar integer.');
    end
case {4, 6}
    if (prod(size(initnvi)) ~= 1) | (floor(initnvi) ~= initnvi)
        error('Ftseries:ftseries_fints_negvolidx:INITNVIMustBeScalar', ...
            'INITNVI must be a scalar integer.');
    end
    for nidx = 1:2:nargin-2
        switch lower(varargin{nidx}(1))
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        case 'v'   % 'VolumeName'
            volnm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_negvolidx:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_negvolidx:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {closenm volnm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_negvolidx:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
closep  = ftsa.data{4}(:, snameidx(1)-3);
tvolume = ftsa.data{4}(:, snameidx(2)-3);

% Calculate the Negative Volume Index by calling the generalized NEGVOLIDX.
nvi = negvolidx(closep, tvolume, initnvi);

% Assign output time series.
nvits           = fints;
nvits           = chfield(nvits,'series1','NVI');   % Rename the series
nvits.data{1}   = ['NegVolIdx: ', ftsa.data{1}];    % desc
nvits.data{2}   = ftsa.data{2};                     % freq
nvits.data{3}   = ftsa.data{3};                     % dates
nvits.data{4}   = nvi(:);                           % data
nvits.data{5}   = ftsa.data{5};                     % times
nvits.datacount = length(nvi);
nvits.serscount = 1;

% [EOF]