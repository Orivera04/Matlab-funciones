function skdts = spctkd(ftsa, dperiods, dmamethod, varargin)
%@FINTS/SPCTKD Slow Stochastics, S%K and S%D, for a FINTS object.
%
%   SKDTS = SPCTKD(FTS) calculates the slow stochastics, S%K and S%D, 
%   using the default 3-period exponential moving average for S%D.  
%   The input FTS, a financial time series object, must contain the 
%   fast stochastics, F%K and F%D, in data series named 'PercentK' and 
%   'PercentD'.  The outputs FINTS object SKDTS has the same dates as 
%   FTS and contains 2 series named 'SlowPctK' and 'SlowPctD'which 
%   represent the respective slow stochastics.
%
%   So, to obtain the slow stochastics, you should call the Fast 
%   Stochastics function, fpctkd, first.  See example below.
%
%   SKDTS = SPCTKD(FTS, DPERIODS, DMAMETHOD) functions similarly to the
%   above except that you can specify the length and the method of the
%   moving average to be used to calculate S%D values, DPERIODS and 
%   DMAMETHOD, respectively.
%
%   SKDTS = SPCTKD(FTS, DPERIODS, DMAMETHOD, ParameterName, 
%   ParameterValue, ... ) does the same thing as above with the exception 
%   of the parameter name-value pairs.  The purpose for these pairs is to 
%   specify the name(s) for the required data series in case they are 
%   different than the expected default name(s).  Valid ParameterName's 
%   are:
%
%         'KName'  :  Fast %K series name
%         'DName'  :  Fast %D series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above. 
%
%   Valid moving average methods for %D (DMAMETHOD) are Exponential 
%   ('e'), Triangular ('t'), and Modified ('m').  Please refer to the 
%   help of TSMOVAVG for explanations on those methods.
%
%   Example:   load disney.mat
%              dis_FastStoch = fpctkd(dis);
%              dis_SlowStoch = spctkd(dis_FastStoch);
%              plot(dis_SlowStoch);
%
%   See also FINTS/FPCTKD, FINTS/STOCHOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 268-271

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/02/11 09:14:11 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
fpctknm = 'percentk';
fpctdnm = 'percentd';
switch nargin
case 1   % spctkd(FTS)
    dperiods  = 3;
    dmamethod = 'e';
case 2   % spctkd(FTS, DPERIODS)
    if prod(size(dperiods)) ~= 1 | floor(dperiods) ~= dperiods
        error('Ftseries:ftseries_fints_spctkd:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods),
        dperiods = 3;
    end
    dmamethod = 'e';
case 3   % fpctkd(FTS, DPERIODS, DMAMETHOD)
    if prod(size(dperiods)) ~= 1 | floor(dperiods) ~= dperiods
        error('Ftseries:ftseries_fints_spctkd:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods)
        dperiods = 3;
    end
    if isempty(dmamethod)
        dmamethod = 'e';
    elseif ~ischar(dmamethod)
        error('Ftseries:ftseries_fints_spctkd:InvalidMethod', ...
            'Valid method must be ''e'' or ''t''.');
    end
case {5, 7}
    if prod(size(dperiods)) ~= 1 | floor(dperiods) ~= dperiods,
        error('Ftseries:ftseries_fints_spctkd:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods)
        dperiods = 3;
    end
    if isempty(dmamethod)
        dmamethod = 'e';
    elseif ~ischar(dmamethod)
        error('Ftseries:ftseries_fints_spctkd:InvalidMethod', ...
            'Valid method must be ''e'' or ''t''.');
    end
    for nidx = 1:2:nargin-3
        switch lower(varargin{nidx}(1))
        case 'k'  % 'KName'
            fpctknm = lower(varargin{nidx+1});
        case 'd'  % 'DName'
            fpctdnm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_spctkd:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_spctkd:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {fpctknm fpctdnm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_spctkd:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
fpctk = ftsa.data{4}(:, snameidx(1)-3);
fpctd = ftsa.data{4}(:, snameidx(2)-3);

% Check for data sufficiency.
if length(fpctk) < dperiods
    error('Ftseries:ftseries_fints_spctkd:DPERIODSTooLarge', ...
        'DPERIODS is too large for the number of data points.');
end

% Calculate the Slow Stochactics by calling the generalized SPCTKD.
[spctk, spctd] = spctkd(fpctk, fpctd, dperiods, dmamethod);

% Assign output.
skdts           = fints;
skdts.names     = {'desc' 'freq' 'dates' 'SlowPctK' 'SlowPctD' 'times'};
skdts.data{1}   = ['SlowPercentKD: ', ftsa.data{1}];    % desc
skdts.data{2}   = ftsa.data{2};                         % freq
skdts.data{3}   = ftsa.data{3};                         % dates
skdts.data{4}   = [spctk(:) spctd(:)];                  % data
skdts.data{5}   = ftsa.data{5};                         % times
skdts.datacount = size(spctk, 1);
skdts.serscount = 2;

% [EOF]
