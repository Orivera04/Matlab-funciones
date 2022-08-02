function procts = prcroc(ftsa, varargin)
%@FINTS/PRCROC Price Rate-of-Change of a FINTS object.
%
%   PROCTS = PRCROC(FTS) calculates the price rate-of-change, PROCTS, 
%   from the financial time series object FTS.  The price rate-of-change 
%   is calculated between the current closing price and the closing price 
%   12 periods ago.  FTS must have, at least, a series named 'Close'.  
%   PROCTS is a FINTS object with similar dates as FTS and data series 
%   named 'PriceROC'.
%
%   PROCTS = PRCROC(FTS, NPERIODS) calculates the price rate-of-change, 
%   PROCTS, similarly as above except, instead of the 12-period difference,
%   it is NPERIODS period difference.  The closing price rate-of-change is 
%   calculated between the current closing price and the closing price 
%   NPERIODS periods ago.  FTS must have, at least, a series named 'Close'.  
%   PROCTS is a FINTS object with similar dates as FTS and data series 
%   named 'PriceROC'.
%
%   PROCTS = PRCROC(FTS, NPERIODS, ParameterName, ParameterValue) does the
%   same thing as above with the exception of the parameter name-value 
%   pairs.  The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'CloseName'  :  closing price traded series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_PROC = prcroc(dis);
%              plot(dis_PROC);
%
%   see also FINTS/VOLROC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 243-245

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.12 $   $Date: 2002/01/21 12:21:34 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
closenm  = 'close';
switch nargin
case 1
    nperiods = 12;
case 2
    nperiods = varargin{1};
    if prod(size(nperiods)) ~= 1 | floor(nperiods) ~= nperiods
        error('Ftseries:ftseries_fints_prcrpc:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
case 4
    nperiods = varargin{1};
    if prod(size(nperiods)) ~= 1 | floor(nperiods) ~= nperiods
        error('Ftseries:ftseries_fints_prcrpc:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    if lower(varargin{2}(1)) == 'c'
        closenm = lower(varargin{3});
    else
        error('Ftseries:ftseries_fints_prcroc:InvalidParameterName', ...
            'Invalid ParameterName.');
    end
otherwise
    error('Ftseries:ftseries_fints_prcroc:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = closenm;
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_prcroc:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
closep = ftsa.data{4}(:, snameidx-3);

% Calculate the Price Rate-of-Change by calling the generalized PRCROC.
proc = prcroc(closep, nperiods);

% Assign output time series.
procts           = fints;
procts           = chfield(procts,'series1','PriceROC');    % Rename series name
procts.data{1}   = ['PrcROC: ', ftsa.data{1}];              % desc
procts.data{2}   = ftsa.data{2};                            % freq
procts.data{3}   = ftsa.data{3};                            % dates
procts.data{4}   = proc(:);                                 % data
procts.data{5}   = ftsa.data{5};                            % times
procts.datacount = length(proc);
procts.serscount = 1;

% [EOF]