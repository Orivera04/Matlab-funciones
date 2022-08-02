function rsits = rsindex(ftsa, varargin)
%@FINTS/RSINDEX Relative Strength Index (RSI) of a FINTS object.
%
%   RSITS = RSINDEX(FTS) calculates the Relative Strength Index (RSI)
%   from the closing price series in the financial time series object 
%   FTS.  The object FTS must, at least, contain the series 'Close' 
%   which represents the closing prices.  The RSI will be calculated 
%   based on the default 14-period period.  RSITS is a FINTS object 
%   whose dates are the same as FTS and data series name is 'RSI'.
%
%   RSITS = RSINDEX(FTS, NPERIODS) calculates the Relative Strength 
%   Index (RSI) from the closing price series in the financial time 
%   series object FTS.  The object FTS must, at least, contain the 
%   series 'Close' which represents the closing prices.  The RSI will 
%   be calculated based on the NPERIODS-period period.  RSITS is a 
%   FINTS object whose dates are the same as FTS and data series 
%   name is 'RSI'.
%
%   RSITS = RSINDEX(FTS, NPERIODS, ParameterName, ParameterValue) does 
%   the same as above with the exception of the parameter 
%   name-value pairs.  The purpose for these pairs is to specify the 
%   name(s) for the required data series in case they are different 
%   than the expected default name(s).  Valid ParameterName's are:
%
%         'CloseName' :  closing prices series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_RSI = rsindex(dis);
%              plot(dis_RSI);
%
%   See also FINTS/NEGVOLIDX, FINTS/POSVOLIDX.

%   Reference: Murphy, John J., Technical Analysis of the Futures Market,
%              New York Institute of Finance, 1986, pp. 295-302

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.11.2.2 $   $Date: 2004/04/06 01:09:34 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
closenm = 'close';
switch nargin
case 1
    nperiods = 14;
case 2
    nperiods = varargin{1};
    if numel(nperiods) ~= 1 || mod(nperiods,1) ~= 0
        error('Ftseries:fints:rsindex:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
case 4
    nperiods = varargin{1};
    if numel(nperiods) ~= 1 || mod(nperiods,1) ~= 0
        error('Ftseries:fints:rsindex:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    if lower(varargin{2}(1)) == 'c',
        closenm = lower(varargin{3});
    else
        error('Ftseries:fints:rsindex:InvalidParameterName', ...
            'Invalid ParameterName.');
    end
otherwise
    error('Ftseries:fints:rsindex:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = closenm;
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:fints:rsindex:MissingClosingPrice', ...
        'Closing Price series is not found. Please check names.');
end
closep   = ftsa.data{4}(:, snameidx(1)-3);

% Check for data sufficiency.
if length(closep) < nperiods
    error('Ftseries:fints:rsindex:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of data points.');
end

% Calculate the Relative Strength Index by calling the generalized RSINDEX.
rsi = rsindex(closep, nperiods);

% Assign output.
rsits           = fints;
rsits           = chfield(rsits,'series1','RSI');   % Rename series name
rsits.data{1}   = ['RSIndex: ', ftsa.data{1}];      % desc
rsits.data{2}   = ftsa.data{2};                     % freq
rsits.data{3}   = ftsa.data{3};                     % dates
rsits.data{4}   = rsi(:);                           % data
rsits.data{5}   = ftsa.data{5};                     % times
rsits.datacount = length(rsi);
rsits.serscount = 1;

% [EOF]
