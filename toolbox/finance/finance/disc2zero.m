function [ZeroRates, CurveDates] = disc2zero(DiscRates, CurveDates, Settle,...
     Compounding, Basis)
%DISC2ZERO Zero curve given a discount curve.
%
%   [ZeroRates, CurveDates] = disc2zero(DiscRates, CurveDates, Settle,...
%        Compounding, Basis)
%
%   Summary: 
%     Given a discount curve and a set of maturity dates as inputs, this
%     function generates a zero curve for the investment horizon represented
%     by those maturity dates; zero rates are the yields to maturity on  
%     theoretical zero coupon bonds.
%
%   Inputs: 
%     DiscRates - (required) an Nx1 vector of discount factors in decimal form
%       which in aggregate represent a discount curve for a given investment 
%       horizon
%     CurveDates - (required) an Nx1 vector of maturity dates in serial
%       date number form which correspond to the discount factors
%     Settle - (required) scalar value in serial date number form
%       representing the settlement date for the discount factors
%     Compounding - (optional) scalar value representing the rate
%       at which the output zero rates are compounded when annualized;
%       possible values include:
%       Compounding = 1 - annual compounding
%       Compounding = 2 - (default) semi-annual compounding
%       Compounding = 3 - compounding three times per year
%       Compounding = 4 - quarterly compounding
%       Compounding = 6 - bi-monthly compounding
%       Compounding = 12 - monthly compounding
%       Compounding = 365 - daily compounding
%       Compounding = -1 - continuous compounding
%
%     Basis - (optional) scalar value representing the basis to be
%       used in annualizing the output zero rates; possible values include:
%       1) Basis = 0 - actual/actual(default)
%       2) Basis = 1 - 30/360
%       3) Basis = 2 - actual/360
%       4) Basis = 3 - actual/365
%
%   Outputs: 
%     ZeroRates - an Nx1 column vector of zero rates in decimal form
%     CurveDates - an Nx1 column vector of maturity dates in serial date
%       number form representing the maturity date for each zero rate
%       contained in ZeroRates
%
%   See also ZERO2DISC, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO,
%            PYLD2ZERO, ZERO2PYLD.

%Author(s): C. Bassignani, 11/21/97 
%   Copyright 1995-2004 The MathWorks, Inc.
%$Revision: 1.14.2.2 $   $Date: 1997/08/12 08:43:00


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 3)
     error('You must enter at least DiscRates, CurveDates and Settle!');
end


%Check the number of arguments passed in and set defaults
if (nargin < 5)
     Basis = 0;
end

if (nargin < 4)
     Compounding = 2;
end


%Parse output compounding argument
if (length(Compounding(:)) > 1)
     error('Output compounding must be passed in as a scalar value!')
end

if all(Compounding ~= [-1 1 2 3 4 6 12 365])
     error('Invalid output compounding specified!')
end


%Parse output basis argument
if (length(Basis(:)) > 1)
     error('Output basis must be passed in as a scalar value!')
end

if (Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3)
     error('Invalid output bond basis specified!')
end


%Set continuous output compounding flag
OutContCompFlag = 0;
if (Compounding == -1)
     OutContCompFlag = 1;
end


%Sort the rates with respect to the curve dates
[Temp, SortIndex] = sort(CurveDates);
DiscRates = DiscRates(SortIndex);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the maturity values for T in fractions of a year
OutYearMats = yearfrac(Settle, CurveDates, Basis);


%Check compounding flag and convert zero rates to discount factor
if (OutContCompFlag)
     %Continuous compounding
     ZeroRates = -log(DiscRates) ./ OutYearMats;
else
     %Discrete compounding
     ZeroRates = (DiscRates .^ (-1 ./ (OutYearMats .* Compounding)) - 1)...
          .* Compounding;
end


%end of DISC2ZERO function
