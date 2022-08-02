function llv = llow(data, nperiods, dim)
%LLOW Lowest low within the past N periods.
%
%   LLV = LLOW(DATA) generates a vector of lowest low values 
%   the past 14 periods from the matrix/vector DATA.
%
%   LLV = LLOW(DATA, NPERIODS, DIM) generates a vector of lowest 
%   low values the past NPERIODS periods.  DIM indicates the direction
%   which the lowest low is to be searched.  If you input '[]' for
%   NPERIODS, the default is 14.
%
%   Example:   load disney.mat
%              dis_LLow = llow(dis_LOW);
%              plot(dis_LLow);
%
%   See also HHIGH.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11 $   $Date: 2002/02/05 15:53:11 $

% Check input arguments.
switch nargin
case 1
    nperiods = 14;
    dim = 1;
case 2
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_llow:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    dim = 1;
case 3
    if isempty(nperiods)
        nperiods = 14;
    end
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_llow:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
otherwise
    error('Ftseries:ftseries_llow:InvalidNumOfArguments', ...
        'Invalid number of arguments.');
end

% If the input is a vector, make sure it's a column vector.
tflag = 0;
if size(data, 1) == 1
    data = data(:);
    tflag = 1;
end

% Make sure that number of period does not exceed nuber of observations.
if nperiods > size(data, dim)
    error('Ftseries:ftseries_llow:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of observations.');
end

% Generate the lowest low vector.
if (nperiods > 0) & (nperiods ~= 0)
    llv = zeros(size(data));
    switch dim
    case 1   % Find lowest low column-wise.
        for didx = 1:size(data, 1)
            if didx < nperiods
                llv(didx, :) = min(data(1:nperiods, :), [], 1);
            else
                llv(didx, :) = min(data(didx-nperiods+1:didx, :), [], 1);
            end
        end
    case 2
        for didx = 1:size(data, 2)
            if didx < nperiods
                llv(:, didx) = min(data(:, 1:nperiods), [], 2);
            else
                llv(:, didx) = min(data(:, didx-nperiods+1:didx), [], 2);
            end
        end
    otherwise
        error('Ftseries:ftseries_llow:InvalidDimention', ...
            'Invalid DIM value.');
    end
elseif nperiods < 0
    error('Ftseries:ftseries_llow:NPERIODSMustBePosScalar', ...
        'NPERIODS must be a positive scalar.');
else
    llv = data;
end

% If the output is a vector, transpose it, if needed.
if tflag
    llv = llv';
end

% [EOF]
