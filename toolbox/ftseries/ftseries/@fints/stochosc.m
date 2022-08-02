function stoscts = stochosc(ftsa, varargin)
%@FINTS/STOCHOSC Stochastic Oscillator of a FINTS object.
%
%   STOSCTS = STOCHOSC(FTS) calculates the Fast PercentK (F%K) and Fast 
%   PercentD (F%D) from the stock price data in the financial time series 
%   object FTS.  The object FTS must minimally contain the series 'High' 
%   (high prices), 'Low' (low prices), and 'Close' (closing prices).  It 
%   uses %K period default of 10 periods, %D period default of 3 periods, 
%   and %D moving average default method of exponential ('e').  STOSCTS 
%   is a FINTS object with similar dates to FTS and 2 data series named 
%   'SOK' and 'SOD'.
%
%   STOSCTS = STOCHOSC(FTS, KPERIODS, DPERIODS, DMAMETHOD) calculates the 
%   Fast PercentK (F%K) and Fast PercentD (F%D) from the stock price data 
%   in the financial time series object FTS.  The object FTS must 
%   minimally contain the series 'High' (high prices), 'Low' (low prices), 
%   and 'Close' (closing prices).  The %K period is manually set through 
%   KPERIODS.  The %D period is manually set through DPERIODS.  And, %D 
%   moving average method is specified in DMAMETHOD.
%
%   STOSCTS = STOCHOSC(FTS, KPERIODS, DPERIODS, DMAMETHOD, ParameterName, 
%   ParameterValue, ... ) does the same thing as above with the exception 
%   of the parameter name-value pairs.  The purpose for these pairs is to 
%   specify the name(s) for the required data series in case they are 
%   different than the expected default name(s).  Valid ParameterName's 
%   are:
%
%         'HighName'  :  high prices series name
%         'LowName'   :  low prices series name
%         'CloseName' :  closing prices series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above. 
%
%   Valid moving average methods for %D are Exponential ('e') and 
%   Triangular ('t').  Please refer to the help for TSMOVAVG for 
%   explanations on those methods.
%
%   Example:   load disney.mat
%              dis_StochOsc = stochosc(dis);
%              plot(dis_StochOsc);
%
%   See also FINTS/FPCTKD, FINTS/SPCTKD.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 268-271

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:20:40 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
highnm  = 'high';
lownm   = 'low';
closenm = 'close';
switch nargin
case 1   % stochosc(FTS)
    kperiods  = 10;
    dperiods  = 3;
    dmamethod = 'e';
case 2   % stochosc(FTS, KPERIODS)
    kperiods = varargin{1};
    if prod(size(kperiods)) ~= 1 | floor(kperiods) ~= kperiods
        error('Ftseries:ftseries_fints_stochosc:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    elseif isempty(kperiods)
        kperiods = 10;
    end
    dperiods  = 3;
    dmamethod = 'e';
case 3   % stochosc(FTS, KPERIODS, DPERIODS)
    kperiods = varargin{1};
    dperiods = varargin{2};
    if prod(size(kperiods)) ~= 1 | floor(kperiods) ~= kperiods
        error('Ftseries:ftseries_fints_stochosc:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    elseif isempty(kperiods)
        kperiods = 10;
    end
    if prod(size(dperiods)) ~= 1 | floor(dperiods) ~= dperiods
        error('Ftseries:ftseries_fints_stochosc:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods)
        dperiods = 3;
    end
    dmamethod = 'e';
case 4  % stochosc(FTS, KPERIODS, DPERIODS, DMAMETHOD)
    kperiods  = varargin{1};
    dperiods  = varargin{2};
    dmamethod = varargin{3};
    if prod(size(kperiods)) ~= 1 | floor(kperiods) ~= kperiods
        error('Ftseries:ftseries_fints_stochosc:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    elseif isempty(kperiods)
        kperiods = 10;
    end
    if prod(size(dperiods)) ~= 1 | floor(dperiods) ~= dperiods
        error('Ftseries:ftseries_fints_stochosc:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods)
        dperiods = 3;
    end
    if isempty(dmamethod)
        dmamethod = 'e';
    elseif ~ischar(dmamethod)
        error('Ftseries:ftseries_fints_stochosc:InvalidMethod', ...
            'Valid method must be ''e'' or ''t''.');
    end
case {6, 8, 10}
    kperiods  = varargin{1};
    dperiods  = varargin{2};
    dmamethod = varargin{3};
    if prod(size(kperiods)) ~= 1 | floor(kperiods) ~= kperiods
        error('Ftseries:ftseries_fints_stochosc:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    elseif isempty(kperiods)
        kperiods = 10;
    end
    if prod(size(dperiods)) ~= 1 | floor(dperiods) ~= dperiods
        error('Ftseries:ftseries_fints_stochosc:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods)
        dperiods = 3;
    end
    if isempty(dmamethod)
        dmamethod = 'e';
    elseif ~ischar(dmamethod)
        error('Ftseries:ftseries_fints_stochosc:InvalidMethod', ...
            'Valid method must be ''e'' or ''t''.');
    end
    for nidx = 4:2:nargin-1
        switch lower(varargin{nidx}(1))
        case 'h'  % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l'  % 'LowName'
            lownm = lower(varargin{nidx+1});
        case 'c'  % 'CloseName'
            closenm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_stchosc:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_stochosc:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_stochosc:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);
closep  = ftsa.data{4}(:, snameidx(3)-3);

% Check for data suffiency.
if (length(highp) < kperiods) | (length(highp) < dperiods)
    error('Ftseries:ftseries_fints_stochosc:KPERIODS_DPERIODSTooLarge', ...
        'KPERIODS and/or DPERIODS are greater than the number of data points.');
end

% Calculate F%K and F%D by calling generalized stochosc.
stosc = stochosc(highp, lowp, closep, kperiods, dperiods, dmamethod);

% Assign output time series.
stoscts           = fints;
stoscts.names     = {'desc' 'freq' 'dates' 'SOK' 'SOD' 'times'};
stoscts.data{1}   = ['StochOsc: ', ftsa.data{1}];       % desc
stoscts.data{2}   = ftsa.data{2};                       % freq
stoscts.data{3}   = ftsa.data{3};                       % dates
stoscts.data{4}   = stosc;                              % data
stoscts.data{5}   = ftsa.data{5};                       % times
stoscts.datacount = size(stosc, 1);                   
stoscts.serscount = 2;

% [EOF]