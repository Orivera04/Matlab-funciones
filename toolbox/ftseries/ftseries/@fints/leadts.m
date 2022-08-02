function fts = leadts(ftsa, nperiod, padmode)
%@FINTS/LEADTS advances a FINTS object values by a specified time step.
%
%   LEADTS will shift the time series values to the left on an increasing 
%   time scale.  It is advancing the data series to happen at an earlier 
%   time point.
%
%   NEWFTS = LEADTS(OLDFTS) advances the data series in OLDFTS by 1 (one) 
%   period and returns the result in the object NEWFTS.  So, if OLDFTS is 
%   a daily time series, it will be advanced by 1 day.  The end will be 
%   padded with zeros, by default.
%
%   NEWFTS = LEADTS(OLDFTS, LEADPERIOD) advances the data series in 
%   OLDFTS by LEADPERIOD periods and returns the result in the object 
%   NEWFTS.  LEADPERIOD is the number of periods used as the frequency 
%   of the object OLDFTS.  So, if OLDFTS is a daily time series, 
%   LEADPERIOD is specified as days.  The end will be padded with zeros, 
%   by default.
%
%   NEWFTS = LEADTS(OLDFTS, LEADPERIOD, PADMODE) behaves simlarly as above
%   except the padding mode.  Here, you can specify to pad the data with
%   anything you desire as long as it is one of the followings: a value, 
%   NaN, or Inf.
%
%   See also FINTS/LAGTS.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:23:18 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['LEADTS on ', ftsa.data{1}];

switch nargin
case 1
    nperiod = 1;
    padmode = 0;
    
case 2
    if nperiod > ftsa.datacount
        error('Ftseries:leadts:NPERIODExceedsTSLength', ...
            'NPERIOD exceeds length of time series.');
    end
    padmode = 0;
case 3
    if nperiod > ftsa.datacount
        error('Ftseries:leadts:NPERIODExceedsTSLength', ...
            'NPERIOD exceeds length of time series.');
    end
    if ischar(padmode)
        error('Ftseries:leadts:PADMODEMustBeValueNaNorInf', ...
            'PADMODE must be a value, NaN, or Inf.')
    end
otherwise
    error('Ftseries:leadts:InvalidNumOfInputs.', ...
        'Invalid number of inputs.');
end

if nperiod < 0
    error('Ftseries:leadts:NPERIODMustBePositiveScalar', ...
        'NPERIOD must be a positive scalar.');
end

padding = padmode * ones(nperiod, ftsa.serscount);

fts.data{4} = [ftsa.data{4}(nperiod+1:end, :); padding];

% [EOF]