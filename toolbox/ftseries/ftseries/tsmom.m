function mom = tsmom(varargin)
%TSMOM  Momentum between N periods.
%
%   MOM = TSMOM(DATA) calculates the momentum of a data series 
%   DATA with time distance of 12 periods.  It is essentially 
%   the difference of the current data with the data 12 periods 
%   ago. DATA must be a column-oriented vector or matrix.
%
%   MOM = TSMOM(DATA, NPERIODS) calculates the momentum of a data 
%   series DATA with time distance of NPERIODS periods.  It is 
%   essentially the difference of the current data with the data 
%   NPERIODS periods ago.
%
%   Momentum is defined as the difference of 2 prices (data points)
%   separated by N periods.
%
%   Example:   load disney.mat
%              dis_CloseMom = tsmom(dis_CLOSE);
%              plot(dis_CloseMom);
%
%   See also TSACCEL.

%   Reference: Kaufman, P. J., The New Commodity Trading Systems 
%              and Methods, New York: John Wiley & Sons, 1987. 


%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8.2.1 $   $Date: 2003/01/16 12:51:25 $

% Check input arguments.
switch nargin
case 1
    data = varargin{1};
    nperiods = 12;
case 2
    data = varargin{1};
    if numel(varargin{2}) ~= 1 || mod(varargin{2},1) ~= 0
        error('Ftseries:ftseries_tsmom:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    nperiods = varargin{2};
otherwise
    error('Ftseries:ftseries_tsmom:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Check for data sufficiency.
if size(data,1) < nperiods
    error('Ftseries:ftseries_tsmom:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of data points.');
end

% Calculate the Momentum.
if (nperiods > 0)
    mom = repmat(NaN,size(data));
    tvec1 = nperiods:size(data, 1);
    tvec2 = 1:size(data, 1)-nperiods+1;
    mom(tvec1, :) = data(tvec1, :) - data(tvec2, :);
elseif nperiods < 0 
    error('Ftseries:ftseries_tsmom:NPERIODSMustBePosScalar', ...
        'NPERIODS must be a positive scalar.');
else
    mom = data;
end

% [EOF]
