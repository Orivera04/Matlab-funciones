function BinTimeSpec = bintimespec(varargin)
%BINTIMESPEC Specify time structure for a binomial tree.
%
%   This is a private function that is not meant to be called directly
%   by the user.
%
%  TimeSpec = bintimespec(ValuationDate, Maturity, NumPeriods)
%  TimeSpec = bintimespec(ValuationDate, Maturity, NumPeriods, Basis)
%
% Inputs:
%   ValuationDate - Scalar date marking the pricing date and first observation
%                   in the tree. Specify ValuationDate as a serial date number 
%                   or date string.
%   Maturity      - Scalar date marking the depth of the tree. 
%   NumPeriods    - Scalar. Determines how many time steps are in the tree.
%
% Optional Inputs: 
%   Basis         - Scalar. Determines how many days are in the tree.
%                   Default is 0.
%
% Output:
%   TimeSpec - Structure specifying the time layout for a binomial tree.  
%
%
% See also CRRTREE, EQPTREE, STOCKSPEC.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:09 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if nargin < 3
    error('finderiv:bintimespec:InvalidInputs','ValuationDate, Maturity, and NumPeriods are required input arguments.') 
elseif nargin > 5
    error('finderiv:bintimespec:InvalidInputs','Too many input arguments.')
else
    EndArgs = cell(1, 5-nargin);
end

% parse arguments to standard form: handle dates and empties
ClassList = {'date'; 'date'; 'dble'; 'dble'; 'dble'};
[ValuationDate, Maturity, NumPeriods, Basis, EOM] = ... 
       finargparse(ClassList, varargin{:}, EndArgs{:});

% handle defaults
EOM( isnan(EOM) ) = 1;
Basis( isnan(Basis) ) = 0;



if(any(cellfun('prodofsize', {ValuationDate, Maturity, NumPeriods, Basis, EOM})>1))
    error('finderiv:bintimespec:InvalidInputSize','All input arguments are expected to be scalars.')
end

if(ValuationDate > Maturity(1))
    error('finderiv:bintimespec:InvalidValuationDate','ValuationDate cannot be later than first Maturity date.')
end

if round(NumPeriods) ~= NumPeriods
    error('finderiv:bintimespec:InvalidNumPeriods','NumPeriods must be an integer.')
end

% Find observation dates and times
TMaturity = date2time(ValuationDate, Maturity, -1, Basis, EOM);
tObs = linspace(0, TMaturity, NumPeriods+1)';
dObs = time2date( ValuationDate, tObs, -1, Basis, EOM);

BinTimeSpec                 = classfin('BinTimeSpec');
BinTimeSpec.ValuationDate   = ValuationDate;
BinTimeSpec.Maturity        = Maturity;
BinTimeSpec.NumPeriods      = NumPeriods;
BinTimeSpec.Basis           = Basis;
BinTimeSpec.EndMonthRule    = EOM;
BinTimeSpec.tObs            = tObs';
BinTimeSpec.dObs            = dObs';
