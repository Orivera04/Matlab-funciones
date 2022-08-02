function accts = tsaccel(ftsa, nperiods, datatype)
%@FINTS/TSACCEL Acceleration between N periods of a FINTS object.
%
%   ACCTS = TSACCEL(FTS) calculates the acceleration of the Financial Time
%   Series object, FTS, with a time distance of 12 periods.  TSACCEL is 
%   the difference of the current momentum with the momentum 12 periods
%   ago.  FTS is an object that contains the raw data and not the momentum
%   of the raw data.
%
%   ACCTS = TSACCEL(FTS, NPERIODS, DATATYPE) is similar to the above.
%   However in this case, FTS can contain the raw data or the momentum
%   of the raw data.  Set DATATYPE = 0 (default) to indicate raw data, or
%   set DATATYPE = 1 to indicate that the FTS contains the momentum of the
%   raw data.
%
%   Acceleration is defined as the difference of two momentums separated 
%   by N periods.
%
%   Example:   load disney.mat
%              dis_Accel = tsaccel(dis);
%              plot(dis_Accel);
%
%   See also FINTS/TSACCEL.

%   Reference: Kaufman, P. J., The New Commodity Trading Systems 
%              and Methods, New York: John Wiley & Sons, 1987. 

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.9.2.3 $   $Date: 2004/04/06 01:09:37 $

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
        datatype = 0;
    case 2
        if prod(size(nperiods)) ~= 1 || mod(nperiods,1) ~= 0
            error('Ftseries:ftseries_fints_tsaccel:NPERIODSMustBeScalar', ...
                'NPERIODS must be a scalar integer.');
        end
        datatype = 0;
    case 3
        if prod(size(nperiods)) ~= 1 || mod(nperiods,1) ~= 0
            error('Ftseries:ftseries_fints_tsaccel:NPERIODSMustBeScalar', ...
                'NPERIODS must be a scalar integer.');
        end
        if datatype ~= 0 & datatype ~= 1
            error('Ftseries:ftseries_fints_tsaccel:InvalidDATATYPE', ...
                'DATATYPE can only be 0 for data or 1 for momentum.');
        end
    otherwise
        error('Ftseries:ftseries_fints_tsaccel:InvalidNumberOfInputArguments', ...
            'Invalid number of input arguments.');
end

% Check for data sufficiency.
if ftsa.datacount < nperiods
    error('Ftseries:ftseries_fints_tsaccel:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of data points.');
end

% Calculate the Acceleration by calling the generalized TSACCEL.
if datatype
    momdata = ftsa.data{4};
else
    momdata = tsmom(ftsa.data{4}, nperiods);
end
acc = tsaccel(momdata, nperiods);

% Assign output.
accts           = fints;
accts.names     = ftsa.names;
accts.data{1}   = ['Acceleration: ', ftsa.data{1}];     % desc
accts.data{2}   = ftsa.data{2};                         % freq
accts.data{3}   = ftsa.data{3};                         % dates
accts.data{4}   = acc;                                  % data
accts.data{5}   = ftsa.data{5};                         % times
accts.datacount = size(acc, 1);
accts.serscount = size(acc, 2);

% [EOF]
