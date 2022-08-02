function chvts = chaikvolat(ftsa, varargin)
%@FINTS/CHAIKVOLAT Chaikin's Volatility of a FINTS onject.
%
%   CHVTS = CHAIKVOLAT(FTS) calculates the Chaikin's Volatility from the 
%   financial time series object FTS.  The object must contain at least 
%   2 series named 'High' and 'Low' which represent the high and low 
%   prices per period.  CHVTS is a FINTS object which contains the Chaikin's
%   Volatility values which are calculated based on a 10-period exponential
%   moving average and 10-period period difference.  CHVTS has the same 
%   dates as FTS and a series called 'ChaikVol'.
%
%   CHVTS = CHAIKVOLAT(FTS, NPERDIFF, MANPER, ParameterName, ParameterValue, ... ) 
%   does the same thing as above with the exception of the parameter 
%   name-value pairs.  The purpose for these pairs is to specify the name(s) 
%   for the required data series in case they are different than the 
%   expected default name(s).  Valid ParameterName's are:
% 
%          'HighName'  :  high prices series name
%          'LowName'   :  low prices series name
% 
%    ParameterValue's are the strings that represents the valid 
%    ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_ChaikVol = chaikvolat(dis);
%              plot(dis_ChaikVol);
%
%   See also @FINTS/CHAIKOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 304-305

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11 $   $Date: 2002/01/21 12:27:11 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

% Check and extract input arguments.
highnm  = 'high';
lownm   = 'low';
switch nargin
case 1
    nperdiff = 10;
    manper   = 10;
case {2, 3, 5, 7}
    if isstr(varargin{1})
        nperdiff = 10;
        manper   = 10;
        for nidx = 2:2:nargin-1
            switch lower(varargin{nidx}(1))
            case 'h'   % 'HighName'
                highnm = lower(varargin{nidx+1});
            case 'l'   % 'LowName'
                lownm = lower(varargin{nidx+1});
            otherwise
                error('Ftseries:ftseries_fints_chaikvolat:InvalidParameterName', ...
                    'Invalid ParameterName.');
            end
        end
    elseif isstr(varargin{2})
        manper   = 10;
        if prod(size(varargin{2})) ~= 1
            error('Ftseries:ftseries_fints_chaikvolat:NPERDIFFMustBeAScaler', ...
                'NPERDIFF must be a scalar integer.');
        else
            nperdiff = varargin{1};
        end
        for nidx = 3:2:nargin-1
            switch varargin{nidx}
            case 'HighName'
                highnm = lower(varargin{nidx+1});
            case 'LowName'
                lownm = lower(varargin{nidx+1});
            otherwise
                error('Ftseries:ftseries_fints_chaikvolat:InvalidParameterName', ...
                    'Invalid ParameterName.');
            end
        end
    else
        if prod(size(varargin{1})) ~= 1 | prod(size(varargin{2})) ~= 1
            error('Ftseries:ftseries_fints_chaikvolat:NPERDIFFAndMANPERMustBeAScalar', ...
                'NPERDIFF and MANPER must be scalar integers.');
        else
            nperdiff = varargin{1};
            manper = varargin{2};
        end
        for nidx = 4:2:nargin-1
            switch varargin{nidx}
            case 'HighName'
                highnm = lower(varargin{nidx+1});
            case 'LowName'
                lownm = lower(varargin{nidx+1});
            otherwise
                error('Ftseries:ftseries_fints_chaikvolat:InvalidParameterName', ...
                    'Invalid ParameterName.');
            end
        end
    end
otherwise
    error('Ftseries:ftseries_fints_chaikvolat:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_chaikvolat:MissingSeriesNames', ...
        'One or more required series are not found.  Please check the series names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);

% Calculate Chaikin's Volatility by calling generalized CHAIKVOLAT.
chvol = chaikvolat(highp, lowp, nperdiff, manper);

% Assign output time series.
chvts = fints;
chvts = chfield(chvts,'series1','ChaikVol');    % Rename the default series name        
chvts.data{1} = ['ChaikVolat: ', ftsa.data{1}]; % desc
chvts.data{2} = ftsa.data{2};                   % freq
chvts.data{3} = ftsa.data{3};                   % dates
chvts.data{4} = chvol(:);                       % data
chvts.data{5} = ftsa.data{5};                   % times
chvts.datacount = length(chvol);
chvts.serscount = 1;

% [EOF]