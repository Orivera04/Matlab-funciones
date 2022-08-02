function pvits = posvolidx(ftsa, initpvi, varargin)
%@FINTS/POSVOLIDX Positive Volume Index of a FINTS object.
%
%   PVITS = POSVOLIDX(FTS) calculates the positive volume index from the 
%   financial time series object FTS.  The object must contain, at least, 
%   the series 'Close' and 'Volume'.  PVITS is a FINTS object with dates 
%   similar to FTS and a data series named 'PVI'.  The initial value for 
%   the positive volume index is arbitrarily set to 100.
%
%   PVITS = POSVOLIDX(FTS, INITPVI) calculates the positive volume index 
%   from the financial time series object FTS.  The object must contain, 
%   at least, the series 'Close' and 'Volume'.  PVITS is a FINTS object 
%   with dates similar to FTS and a data series named 'PVI'.  The initial 
%   value for the positive volume index is manually set to INITPVI.
%
%   PVITS = POSVOLIDX(FTS, INITPVI, ParameterName, ParameterValue, ... ) 
%   does the same thing as above with the exception of the parameter 
%   name-value pairs.  The purpose for these pairs is to specify the 
%   name(s) for the required data series in case they are different than 
%   the expected default name(s).  Valid ParameterName's are:
%
%         'CloseName'   :  close prices series name
%         'VolumeName'  :  volume traded series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_PVI = posvolidx(dis);
%              plot(dis_PVI);
%
%   See also FINTS/NEGVOLIDX, FINTS/ONBALVOL.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 236-238

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:21:44 $

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
    initpvi = 100;
case 2
    if prod(size(initpvi)) ~= 1 | floor(initpvi) ~= initpvi
        error('Ftseries:ftseries_fints_posvolidx:INITNVIMustBeScalar', ...
            'INITNVI must be a scalar integer.');
    end
case {4, 6}
    if prod(size(initpvi)) ~= 1 | floor(initpvi) ~= initpvi
        error('Ftseries:ftseries_fints_posvolidx:INITNVIMustBeScalar', ...
            'INITNVI must be a scalar integer.');
    end
    for nidx = 1:2:nargin-2
        switch lower(varargin{nidx}(1))
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        case 'v'   % 'VolumeName'
            volnm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_posvolidx:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_posvolidx:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {closenm volnm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_posvolidx:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
closep  = ftsa.data{4}(:, snameidx(1)-3);
tvolume = ftsa.data{4}(:, snameidx(2)-3);

% Calculate the Positive Volume Index by calling the generalized POSVOLIDX.
pvi = posvolidx(closep, tvolume, initpvi);

% Assign output time series.
pvits           = fints;
pvits           = chfield(pvits,'series1','PVI');   % Rename series name
pvits.data{1}   = ['NegVolIdx: ', ftsa.data{1}];    % desc
pvits.data{2}   = ftsa.data{2};                     % freq
pvits.data{3}   = ftsa.data{3};                     % dates
pvits.data{4}   = pvi(:);                           % data
pvits.data{5}   = ftsa.data{5};                     % times
pvits.datacount = length(pvi);  
pvits.serscount = 1;

% [EOF]