function acc = tsaccel(varargin)
%TSACCEL Acceleration between N periods.
%
%   ACC = TSACCEL(DATA) calculates the acceleration of a data series, DATA,
%   with a time distance of 12 periods.  TSACCEL is the difference of the
%   current momentum with the momentum 12 periods ago.  DATA is a series
%   that contains the raw data and not the momentum of the raw data.
%
%   ACC = TSACCEL(DATA, NPERIODS, DATATYPE) is similar to the above.
%   However in this case, DATA can contain the raw data or the momentum
%   of the raw data.  Set DATATYPE = 0 (default) to indicate raw data, or
%   set DATATYPE = 1 to indicate that the DATA contains the momentum of the
%   raw data.
%
%   Acceleration is defined as the difference of two momentums separated 
%   by N periods.
%
%   Example:   load disney.mat
%              dis_CloseAccel = tsaccel(dis_CLOSE);
%              plot(dis_CloseAccel);
%
%   See also TSMOM.

%   Reference: Kaufman, P. J., The New Commodity Trading Systems 
%              and Methods, New York: John Wiley & Sons, 1987. 

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.9.2.3 $   $Date: 2004/04/06 01:09:49 $

% Check input arguments.
switch nargin
case 1
    data  = varargin{1};
    nperiods = 12;
    datatype = 0;
case 2
    data  = varargin{1};
    if numel(varargin{2}) ~= 1 || mod(varargin{2},1) ~= 0
        error('Ftseries:ftseries_tsaccel:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    nperiods = varargin{2};
    datatype = 0;
case 3
    data  = varargin{1};
    if numel(varargin{2}) ~= 1 || mod(varargin{2},1) ~= 0
        error('Ftseries:ftseries_tsaccel:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    if varargin{3} ~= 0 && varargin{3} ~= 1
        error('Ftseries:ftseries_tsaccel:InvalidDATATYPE', ...
            'DATATYPE can only be 0 for data or 1 for momentum.');
    end
    nperiods = varargin{2};
    datatype = varargin{3};
otherwise
    error('Ftseries:ftseries_tsaccel:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Check for data sufficiency.
if size(data,1) < nperiods
    error('Ftseries:ftseries_tsaccel:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of data points.');
end

% Calculate the Acceleration.
if datatype
    momdata = data;
else
    momdata = tsmom(data, nperiods);
end

if (nperiods > 0)
    acc = repmat(NaN,size(momdata));
    tvec1 = nperiods:size(momdata, 1);
    tvec2 = 1:size(momdata, 1)-nperiods+1;
    acc(tvec1, :) = momdata(tvec1, :) - momdata(tvec2, :);
elseif nperiods < 0
    error('Ftseries:ftseries_tsmom:NPERIODSMustBePosScalar', ...
        'NPERIODS must be a positive scalar.');
else
    acc = data;
end

% [EOF]
