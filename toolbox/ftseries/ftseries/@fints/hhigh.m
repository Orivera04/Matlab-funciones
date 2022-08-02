function hhvts = hhigh(ftsa, varargin)
%@FINTS/HHIGH Highest high of a FINTS object within the past N periods.
%
%   HHVTS = HHIGH(FTS) generates a vector of highest high values in the
%   past 14 periods from the financial time series object FTS.  The 
%   object FTS must include at least the series 'High'.  HHVTS is a 
%   FINTS object with the same dates as FTS and data series named 
%   'HighestHigh'.
%
%   HHVTS = HHIGH(FTS, NPERIODS) generates a FINTS object of highest 
%   high values, HHVTS, the past NPERIODS periods.
%
%   HHVTS = HHIGH(FTS, NPERIODS, ParameterName, ParameterValue) does the
%   same thing as above with the exception of the parameter name-value 
%   pairs.  The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'HighName'  :  high prices series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_HHigh = hhigh(dis);
%              plot(dis_HHigh);
%
%   See also FINTS/LLOW.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.13 $   $Date: 2002/02/05 15:51:41 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

% Check input arguments.
highnm = 'high';
switch nargin
case 1
    nperiods = 14;
case 2
    nperiods = varargin{1};
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_fints_hhigh:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
case 4
    nperiods = varargin{1};
    if isempty(nperiods)
        nperiods = 14;
    end
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_fints_hhigh:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    if lower(varargin{2}(1)) == 'h'
        highnm = lower(varargin{3});
    else
        error('Ftseries:ftseries_fints_hhigh:InvalidParameterName', ...
            'Invalid ParameterName.');
    end
otherwise
    error('Ftseries:ftseries_fints_hhigh:InvalidNumOfArguments', ...
        'Invalid number of arguments.');
end
snames = highnm;
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_hhigh:SeriesNameNotInObject', ...
        'One or more required series are not found.  Please check the series names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);

% Generate the highest high matrix by calling the generalized HHIGH.
hhvmtx = hhigh(highp, nperiods);

% Assign output.
hhvts           = fints;
hhvts           = chfield(hhvts,'series1','HighestHigh');   % rename the series
hhvts.data{1}   = ['HHigh: ', ftsa.data{1}];                % desc
hhvts.data{2}   = ftsa.data{2};                             % freq
hhvts.data{3}   = ftsa.data{3};                             % dates
hhvts.data{4}   = hhvmtx(:);                                % data
hhvts.data{5}   = ftsa.data{5};                             % times
hhvts.datacount = length(hhvmtx);
hhvts.serscount = 1;

% [EOF]
