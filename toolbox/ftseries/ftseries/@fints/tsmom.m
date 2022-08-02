function momts = tsmom(ftsa, nperiods)
%@FINTS/TSMOM Momentum between N periods of a FINTS object.
%
%   MOMTS = TSMOM(FTS) calculates the momentum of data series in the
%   financial time series object FTS with time distance of 12 periods.
%   It is essentially the difference of the current data with the data 
%   12 periods ago.  Each data series in FTS is treated individually.
%   MOMTS is a FINTS object with similar dates and data series names as 
%   FTS.
%
%   MOMTS = TSMOM(FTS, NPERIODS) calculates the momentum of data series 
%   in the financial time series object FTS with time distance of 12 
%   periods.  It is essentially the difference of the current data with 
%   the data NPERIODS periods ago.  Each data series in FTS is treated 
%   individually.  MOMTS is a FINTS object with similar dates and data 
%   series names as FTS.
%
%   Momentum is defined as the difference of 2 prices (data points)
%   separated by N periods.
%
%   Example:   load disney.mat
%              dis_Moment = tsmom(dis);
%              plot(dis_Moment);
%
%   See also FINTS/TSACCEL.

%   Reference: Kaufman, P. J., The New Commodity Trading Systems 
%              and Methods, New York: John Wiley & Sons, 1987. 

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/02/11 09:14:01 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
switch nargin
case 1
    nperiods = 12;
case 2
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_fints_tsmom:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
otherwise
    error('Ftseries:ftseries_fints_tsmom:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Check for data sufficiency.
if ftsa.datacount < nperiods
    error('Ftseries:ftseries_fints_tsmom:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of data points.');
end

% Calculate the Momentum by calling the generalized TSMOM.
mom = tsmom(ftsa.data{4}, nperiods);

% Assign output.
momts           = fints;
momts.names     = ftsa.names;
momts.data{1}   = ['Momentum: ', ftsa.data{1}];     % desc
momts.data{2}   = ftsa.data{2};                     % freq
momts.data{3}   = ftsa.data{3};                     % dates
momts.data{4}   = mom;                              % data
momts.data{5}   = ftsa.data{5};                     % times
momts.datacount = size(mom, 1);
momts.serscount = size(mom, 2);

% [EOF]
