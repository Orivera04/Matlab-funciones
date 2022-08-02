function fts = lagts(ftsa, nperiod, padmode)
%@FINTS/LAGTS delays a FINTS object values by a specified time step.
%
%   LAGTS will shift the time series values to the right on an increasing 
%   time scale.  It is delaying the data series to happen at a later time 
%   point.
%
%   NEWFTS = LAGTS(OLDFTS) delays the data series in OLDFTS by 1 (one)
%   period and returns the result in the object NEWFTS.  So, if OLDFTS is 
%   a daily time series, it will be delayed by 1 day.  It will pad the 
%   data with zeros; this is the default.
%
%   NEWFTS = LAGTS(OLDFTS, LAGPERIOD) delays the data series in OLDFTS by 
%   LAGPERIOD periods and returns the result in the object NEWFTS.  
%   LAGPERIOD is the number of periods used as the frequency of the 
%   object OLDFTS.  So, if OLDFTS is a daily time series, LAGPERIOD is 
%   specified as days.  It will pad the data with zeros; this is the
%   default.
%
%   NEWFTS = LAGTS(OLDFTS, LAGPERIOD, PADMODE) behaves simlarly as above
%   except the padding mode.  Here, you can specify to pad the data with
%   anything you desire as long as it is one of the followings: a value, 
%   NaN, or Inf.
%
%   See also FINTS/LEADTS.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:23:23 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

fts = ftsa;

fts.data{1} = ['LAGTS on ', ftsa.data{1}];

switch nargin
case 1
    nperiod = 1;
    padmode = 0;
case 2
    if nperiod > ftsa.datacount
        error('Ftseries:lagts:NPERIODExceedsTSLength', ...
            'NPERIOD exceeds length of time series.');
    end
    padmode = 0;
case 3
    if nperiod > ftsa.datacount
        error('Ftseries:lagts:NPERIODExceedsTSLength', ...
            'NPERIOD exceeds length of time series.');
    end
    if ischar(padmode)
        error('Ftseries:lagts:PADMODEMustBeValueNaNorInf', ...
            'PADMODE must be a value, NaN, or Inf.')
    end
otherwise
    error('Ftseries:lagts:InvalidNumOfInputs.', ...
        'Invalid number of inputs.');
end

if nperiod < 0
    error('Ftseries:lagts:NPERIODMustBePositiveScalar', ...
        'NPERIOD must be a positive scalar.');
end

padding = padmode * ones(nperiod, ftsa.serscount);

fts.data{4} = [padding; ftsa.data{4}(1:end-nperiod, :)];

% [EOF]