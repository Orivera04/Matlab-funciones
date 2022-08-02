function pkdts = fpctkd(ftsa, kperiods, dperiods, dmamethod, varargin)
%@FINTS/FPCTKD Fast PercentK (F%K) and Fast Percentd (F%D) of a FINTS object.
%
%   PKTS = FPCTKD(FTS) calculates the Fast PercentK (F%K) and Fast 
%   PercentD (F%D) from the stock price data in the financial time series 
%   object FTS.  The object FTS must minimally contain the series 'High' 
%   (high prices), 'Low' (low prices), and 'Close' (closing prices).  It 
%   uses %K period default of 10 periods, %D period default of 3 periods, 
%   and %D moving average default method of exponential ('e').  PKTS is a
%   FINTS object with similar dates to FTS and 2 data series named 
%   'PercentK', and 'PercentD'.
%
%   PKTS = FPCTKD(FTS, KPERIODS, DPERIODS, DMAMETHOD) calculates the 
%   Fast PercentK (F%K) and Fast PercentD (F%D) from the stock price data 
%   in the financial time series object FTS.  The object FTS must 
%   minimally contain the series 'High' (high prices), 'Low' (low prices), 
%   and 'Close' (closing prices).  The %K period is manually set through 
%   KPERIODS.  The %D period is manually set through DPERIODS.  And, %D 
%   moving average method is specified in DMAMETHOD.
%
%   PKTS = FPCTKD(FTS, KPERIODS, DPERIODS, DMAMETHOD, ParameterName, 
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
%              dis_FastStoc = fpctkd(dis);
%              plot(dis_FastStoc);
%
%   See also FINTS/SPCTKD, FINTS/STOCHOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 268-271

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.14 $   $Date: 2002/02/11 09:14:35 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

% Check input arguments.
highnm  = 'high';
lownm   = 'low';
closenm = 'close';
switch nargin
case 1   % fpctkd(FTS)
    kperiods  = 10;
    dperiods  = 3;
    dmamethod = 'e';
case 2   % fpctkd(FTS, KPERIODS)
    if prod(size(kperiods)) ~= 1 | floor(kperiods) ~= kperiods
        error('Ftseries:ftseries_fints_fpctkd:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    end
    dperiods  = 3;
    dmamethod = 'e';
case 3   % fpctkd(FTS, KPERIODS, DPERIODS)
    if prod(size(kperiods)) ~= 1 | floor(kperiods) ~= kperiods
        error('Ftseries:ftseries_fints_fpctkd:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    end
    if prod(size(dperiods)) ~= 1 | floor(dperiods) ~= dperiods
        error('Ftseries:ftseries_fints_fpctkd:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    end
    dmamethod = 'e';
case 4   % fpctkd(FTS, KPERIODS, DPERIODS, DMAMETHOD)
    if prod(size(kperiods)) ~= 1 | floor(kperiods) ~= kperiods
        error('Ftseries:ftseries_fints_fpctkd:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    end
    if prod(size(dperiods)) ~= 1 | floor(dperiods) ~= dperiods
        error('Ftseries:ftseries_fints_fpctkd:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    end
    if ~ischar(dmamethod)
        error('Ftseries:ftseries_fints_fpctkd:ValidMethodsAreEOrT', ...
            'Valid method must be ''e'' or ''t''.');
    end
case {6, 8, 10}
    if prod(size(kperiods)) ~= 1 | floor(kperiods) ~= kperiods,
        error('Ftseries:ftseries_fints_fpctkd:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    end
    for nidx = 1:2:nargin-4
        switch lower(varargin{nidx}(1))
        case 'h'   % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l'   % 'LowName'
            lownm = lower(varargin{nidx+1});
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_fpctkd:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_fpctkd:InvalidNumOfInputs', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_fpctkd:SeriesNameMissing', ...
        'One or more required series are not found.  Please check the series names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);
closep  = ftsa.data{4}(:, snameidx(3)-3);

% Check for data suffiency.
if (length(highp) < kperiods) | (length(highp) < dperiods)
    error('Ftseries:ftseries_fints_fpctkd:InvalidNumberOfKPERIODSAndOrDPERIODS', ...
        'KPERIODS and/or DPERIODS are greater than the number of data points.');
end

% Calculate F%K and F%D by calling generalized FPCTKD.
[pctk, pctd] = fpctkd(highp, lowp, closep, kperiods, dperiods, dmamethod);

% Assign output time series.
pkdts           = fints;
pkdts.names     = {'desc' 'freq' 'dates' 'PercentK' 'PercentD' 'times'};
pkdts.data{1}   = ['FastPercentKD: ', ftsa.data{1}];% desc
pkdts.data{2}   = ftsa.data{2};                     % freq    
pkdts.data{3}   = ftsa.data{3};                     % dates
pkdts.data{4}   = [pctk(:) pctd(:)];                % data
pkdts.data{5}   = ftsa.data{5};                     % times
pkdts.datacount = size(pctk, 1);
pkdts.serscount = 2;

% [EOF]
