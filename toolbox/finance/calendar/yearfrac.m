function [YearFraction] = yearfrac(Date1, Date2, Basis)
%YEARFRAC Fraction of Year Between Dates.
%   This function determines the fraction of a year occurring between two
%   dates based on the number days between those dates using a specified
%   day count basis.
%
%   [YearFraction] = yearfrac(Date1, Date2, Basis)
%
%   Inputs:
%   Date1 - [Nx1 or 1xN] vector containing values for Date 1 in either date
%           string or serial date form
%   
%   Date2 - [Nx1 or 1xN] vector containing values for Date 2 in either date 
%           string or serial date form
%
%   Basis - [Nx1 or 1xN] vector containing value specifying the Basis for
%           each set of dates. 
%
%           Possible values include:
%           0 - actual/actual(default)
%           1 - 30/360
%           2 - actual/360
%           3 - actual/365
%
%   Outputs: 
%   YearFraction - [Nx1 or 1xN] vector of real numbers identifying the
%                  interval, in years, between Date1 and Date2.
%
%   See also: YEAR

% Author(s): C.F. Garvin, 2-23-95; C. Bassignani, 11-12-97; 
%            P.Wang & K. Lui 12/03
% Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.15.2.2 $   $Date: 2004/04/06 01:06:33 $


% Check the number of arguments being passed in and set defaults
if nargin < 3
    Basis = 0;
end

if nargin < 2
    error('Finance:yearfrac:tooFewInputs', ...
        'Enter values for Date1 and Date2.!')
end

% Parse inputs as necessary
if ischar(Date1)
    Date1 = datenum(Date1);
end

if ischar(Date2)
    Date2 = datenum(Date2);
end

% Parse Basis argument
if ischar(Basis)
    Basis = str2double(Basis);
end

if any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3)
    error('Finance:yearfrac:invalidBasis', ...
        'Invalid bond Basis.')
end

% Scale up input arguments as required
InputsSize = [size(Date1); size(Date2); size(Basis)];

if length(Date1) == 1
    Date1 = Date1*ones(max(InputsSize(:,1)), max(InputsSize(:,2)));
end

if length(Date2) == 1
    Date2 = Date2*ones(max(InputsSize(:,1)), max(InputsSize(:,2)));
end

if length(Basis) == 1
    Basis = Basis*ones(max(InputsSize(:,1)), max(InputsSize(:,2)));
end

% Make sure all input arguments are of the same size and shape
if (checksiz([size(Date1); size(Date2); size(Basis)], mfilename))
    return
end

% Get the shape of the input arguments for later reshaping of the output
[RowSize, ColumnSize] = size(Date1);

% Make sure all inputs are packed into column vectors
Date1 = Date1(:);
Date2 = Date2(:);
Basis = Basis(:);

% Preallocate the output variable
YearFraction = zeros(size(Date1));

% Get whole years
wYears = floor(abs(Date1 - Date2) / 365);

% Push current years out wYears
c = datevec(Date1);
c(:,1) = c(:,1) + wYears;
date1Num = datenum(c);

% Find cases where Basis is actual/actual and determine the year fraction
Ind = find(Basis == 0);
if (~isempty(Ind))
    pad = ones(size(Date1(Ind)));
    YearFraction(Ind) = daysact(date1Num(Ind), Date2(Ind)) ./...
        daysact(datenum(year(date1Num(Ind)), month(date1Num(Ind)), ...
        day(date1Num(Ind))), ...
        datenum(year(date1Num(Ind)) + 1, month(date1Num(Ind)), ...
        day(date1Num(Ind))));
end

% Find cases where Basis is 30/360 and determine the year fraction
Ind = find(Basis == 1);
if (~isempty(Ind))
    YearFraction(Ind) = days360(date1Num(Ind), Date2(Ind)) ./ 360;
end

% Find cases where Basis is actual/360 and determine the year fraction
Ind = find(Basis == 2);
if (~isempty(Ind))
    pad = ones(size(date1Num(Ind)));
    YearFraction(Ind) = daysact(date1Num(Ind), Date2(Ind)) ./ 360;
end

% Find cases where Basis is actual/365 and determine the year fraction
Ind = find(Basis == 3);
if (~isempty(Ind))
    YearFraction(Ind) = daysact(date1Num(Ind), Date2(Ind)) ./ 365;
end

% Add back the wYears to each year fraction
YearFraction = YearFraction + wYears;

YearFraction = reshape(YearFraction, RowSize, ColumnSize);


% [EOF]
