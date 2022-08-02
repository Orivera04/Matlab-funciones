function hhv = hhigh(data, nperiods, dim)
%HHIGH Highest high within the past N periods.
%
%   HHV = HHIGH(DATA) generates a vector of highest high values 
%   the past 14 periods from the matrix/vector DATA.  
%
%   HHV = HHIGH(DATA, NPERIODS, DIM) generates a vector of highest 
%   high values the past NPERIODS periods.  DIM indicates the direction
%   which the highest high is to be searched.  If you input '[]' for
%   NPERIODS, the default is 14.
%
%   Example:   load disney.mat
%              dis_HHigh = hhigh(dis_HIGH);
%              plot(dis_HHigh);
%
%   See also LLOW.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/02/05 15:53:08 $

% Check input arguments.
switch nargin
case 1
    nperiods = 14;
    dim = 1;
case 2
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_hhigh:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    dim = 1;
case 3
    if isempty(nperiods)
        nperiods = 14;
    end
    if prod(size(nperiods)) ~= 1 | mod(nperiods,1) ~= 0
        error('Ftseries:ftseries_hhigh:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
otherwise
    error('Ftseries:ftseries_hhigh:InvalidNumOfArguments', ...
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
    error('Ftseries:ftseries_hhigh:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of observations.');
end

% Generate the highest high vector.
if (nperiods > 0) & (nperiods ~= 0)
    hhv = zeros(size(data));
    switch dim
    case 1   % Find highest high column-wise.
        for didx = 1:size(data, 1)
            if didx < nperiods
                hhv(didx, :) = max(data(1:nperiods, :), [], 1);
            else
                hhv(didx, :) = max(data(didx-nperiods+1:didx, :), [], 1);
            end
        end
    case 2
        for didx = 1:size(data, 2)
            if didx < nperiods
                hhv(:, didx) = max(data(:, 1:nperiods), [], 2);
            else
                hhv(:, didx) = max(data(:, didx-nperiods+1:didx), [], 2);
            end
        end
    otherwise
        error('Ftseries:ftseries_hhigh:InvalidDimention', ...
            'Invalid DIM value.');
    end
elseif nperiods < 0
    error('Ftseries:ftseries_hhigh:NPERIODSMustBePosScalar', ...
        'NPERIODS must be a positive scalar.');
else
    hhv = data;
end

% If the output is a vector, transpose it, if needed.
if tflag
    hhv = hhv';
end

% [EOF]
