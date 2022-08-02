function llvts = llow(ftsa, varargin)
%@FINTS/LLOW Lowest low of a FINTS object within the past N periods.
%
%   LLVTS = LLOW(FTS) generates a vector of lowest low values the
%   past 14 periods from the financial time series object FTS.  The 
%   object FTS must include at least the series 'Low'.  LLVTS is a 
%   FINTS object with the same dates as FTS and data series named 
%   'LowestLow'.
%
%   LLVTS = LLOW(FTS, NPERIODS) generates a FINTS object of lowest  
%   low values, LLVTS, the past NPERIODS periods.
%
%   LLVTS = LLOW(FTS, NPERIODS, ParameterName, ParameterValue) does the
%   same thing as above with the exception of the parameter name-value 
%   pairs.  The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'LowName'  :  high prices series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_LLow = llow(dis);
%              plot(dis_LLow);
%
%   See also @FINTS/HHIGH.
%

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.14 $   $Date: 2002/02/05 15:51:33 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

% Check input arguments.
lownm = 'low';
switch nargin
case 1
    nperiods = 14;
case 2
    nperiods = varargin{1};
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_fints_llow:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
case 4
    nperiods = varargin{1};
    if isempty(nperiods)
        nperiods = 14;
    end
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_fints_llow:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    if lower(varargin{2}(1)) == 'l'
        lownm = lower(varargin{3});
    else
        error('Ftseries:ftseries_fints_llow:InvalidParameterName', ...
            'Invalid ParameterName.');
    end
otherwise
    error('Ftseries:ftseries_fints_llow:InvalidNumOfArguments', ...
        'Invalid number of arguments.');
end
snames = lownm;
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_llow:SeriesNameNotInObject', ...
        'One or more required series are not found.  Please check the series names.');
end
lowp = ftsa.data{4}(:, snameidx(1)-3);


% Generate the lowest low matrix by calling the generalized LLOW.
llvmtx = llow(lowp, nperiods);

% Assign output.
llvts           = fints;
llvts           = chfield(llvts,'series1','LowestLow'); % rename the series
llvts.data{1}   = ['LLow: ', ftsa.data{1}];             % desc
llvts.data{2}   = ftsa.data{2};                         % freq
llvts.data{3}   = ftsa.data{3};                         % dates
llvts.data{4}   = llvmtx(:);                            % data
llvts.data{5}   = ftsa.data{5};                         % times
llvts.datacount = length(llvmtx);
llvts.serscount = 1;

% [EOF]
