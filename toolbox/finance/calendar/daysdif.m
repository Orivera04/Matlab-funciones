function d = daysdif(d1,d2,basis)
%DAYSDIF Days between dates for any day count basis.
%   DAYSDIF returns the number of days between D1 and D2 using the given 
%   day count basis. Enter dates as serial date numbers or date strings.
%   
%   D = daysdif(D1, D2)
%   D = daysdif(D1, D2, Basis)
%
%   Optional Inputs: Compounding, Basis
%
%   Inputs:
%   D1 - [Scalar or Vector] of dates.
%   D2 - [Scalar or Vector] of dates.
%
%   Optional Inputs:
%   Basis - [Scalar or Vector] of day-count basis.
%
%      Valid Basis are:
%            0 = actual/actual (default)
%            1 = 30/360 
%            2 = actual/360
%            3 = actual/365
%      (NEW) 4 - 30/360 (PSA compliant)
%      (NEW) 5 - 30/360 (ISDA compliant)
%      (NEW) 6 - 30/360 (European)
%      (NEW) 7 - act/365 (Japanese)

% Author(s): C.F. Garvin, 4-07-95, Bob Winata 02/02/02
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.8.2.3 $   $Date: 2004/04/06 01:06:28 $

% Error check
if nargin < 2
    error('Finance:daysdif:invalidNumberOfInputs', ...
        'Please enter D1 and D2.')
end
if ischar(d1) || ischar(d2)
    d1 = datenum(d1);
    d2 = datenum(d2);
end
if nargin < 3
    basis = zeros(size(d1));
end
if ~(all(all(basis == 0 | basis == 1 | basis == 2 | basis == 3 | ...
        basis == 4 | basis == 5 | basis == 6 | basis == 7)))
    error('Finance:daysdif:invalidBasis', ...
        'Invalid day count basis specified.')
end

sz = [size(d1); size(d2); size(basis)];
if length(d1) == 1
    d1 = d1*ones(max(sz(:,1)), max(sz(:,2)));
end
if length(d2) == 1
    d2 = d2*ones(max(sz(:,1)), max(sz(:,2)));
end
if length(basis) == 1
    basis = basis*ones(max(sz(:,1)), max(sz(:,2)));
end
if checksiz([size(d1); size(d2); size(basis)], mfilename)
    return
end

% Determine diff in days based on basis
d = zeros(size(d1));
i = find(basis == 0 | basis == 2 | basis == 3);
if ~isempty(i)
    d(i) = daysact(d1(i),d2(i));
end

i = find(basis == 1);
if ~isempty(i)
    d(i) = days360(d1(i),d2(i));
end

i = find(basis == 4);
if ~isempty(i)
    d(i) = days360isda(d1(i),d2(i));
end

i = find(basis == 5);
if ~isempty(i)
    d(i) = days360psa(d1(i),d2(i));
end

i = find(basis == 6);
if ~isempty(i)
    d(i) = days360e(d1(i),d2(i));
end

i = find(basis == 7);
if ~isempty(i)
    d(i) = days365(d1(i),d2(i));
end


% [EOF]
