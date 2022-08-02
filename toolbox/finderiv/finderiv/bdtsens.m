function [Delta, Gamma, Vega, Price] = bdtsens(BDTTree, IVar, options)
%BDTSENS Instrument sensitivities and prices by a BDT interest rate model.
%   Computes dollar sensitivities and prices for instruments using an
%   interest rate tree created with BDTTREE.  
%
%   [Delta, Gamma, Vega, Price] = bdtsens(BDTTree, InstSet)
%
%   [Delta, Gamma, Vega, Price] = bdtsens(BDTTree, InstSet, Options)
%
% Inputs:
%   BDTTree - Black-Derman-Toy tree sampling an interest rate process.
%             Type "help bdttree" for information on creating the 
%             variable BDTTree.
%
%   InstSet - Variable containing a collection of NINST instruments.
%             Instruments are broken down by type and each type can have
%             different data fields.  
%
%   Options	- Structure created with derivset containing derivatives 
%             pricing options. Type "help derivset" for more information.
%
% Outputs:
%
%   Delta   - NINST x 1 vector of deltas, representing the rate of 
%             change of instruments prices with respect to changes in the 
%             interest rate. Delta is computed by finite differences in 
%             calls to BDTTREE.  Type "help bdttree" for information on 
%             the observed yield curve.
%
%   Gamma   - NINST x 1 vector of gammas, representing the rate of
%             change of instruments deltas with respect to the changes in
%             the interest rate. Gamma is computed by finite differences
%             in calls to BDTPRICE.
%
%   Vega    - NINST x 1 vector of vegas, representing the rate of
%             change of instruments prices with respect to the changes 
%             in the volatility, Sigma(t,T), of the interest rate. Vega
%             is computed by finite differences in calls to BDTTREE. Type 
%             "help bdtvolspec" for information on the volatility process.
%
%   Price  - NINST x 1 vector of prices of each instrument.  The prices
%            are computed by backward dynamic programming on the interest rate
%            tree. If an instrument cannot be priced, a NaN is returned.
%
%
% Notes:
%   BDTSENS handles the following instrument types: 'Bond', 'CashFlow',
%   'OptBond', 'Fixed', 'Float', 'Cap', 'Floor', 'Swap'. Type 
%   "help instadd" to construct defined types.
%
%   All sensitivities are returned as dollar sensitivities. To find the
%   per-dollar sensitivities, they must be divided by their respective
%   instrument price.
%
%   Delta and gamma are calculated based on yield shifts of 100 basis points.
%   Vega is calculated based on 1% shift in the volatility process.
%
%
% Example:
%   load deriv
%   instdisp(BDTInstSet)
%   [Delta, Gamma] = bdtsens(BDTTree, BDTInstSet)
%
% See also BDTPRICE, BDTTREE, BDTVOLSPEC.

%   Author(s): M. Reyes-Kattar 7/05/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.2 $  $                         $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------
if (nargin<1) | ~isafin(BDTTree,'BDTFwdTree')
  error('The first argument must be a BDT tree created by BDTTREE');
end

if (nargin<2) | ~isafin(IVar,'Instruments')
  error('The second argument must be a Financial Instrument Variable')
end

% Set default for pricing option
if(nargin < 3 | isempty(options))
    options = derivset;
end

BDTTree = checktree(BDTTree, IVar, options);

% If any warnings were to come out, they would come from inside
% checktree. Turn off warnings for the rest of the function.
options = derivset(options, 'Warnings', 'off');

% Compute initial prices
Price0 = bdtprice(BDTTree, IVar, options);

% Introduce a disturbance of 100 (up and down) basis points to the
% intially observed Rates, and recalculate the price
Disturbance = 0.01;

% Extract the initial rate curve for the tree
RateSpec = BDTTree.RateSpec;
Rates = intenvget(RateSpec, 'Rates');

% Going Up
RatesUp = Rates + Disturbance;
RateSpecUp = intenvset(RateSpec, 'Rates', RatesUp);

% Going Down
RatesDown = Rates - Disturbance;
RateSpecDown = intenvset(RateSpec, 'Rates', RatesDown);

% Introduce a disturbance of 1% to Sigma
SigmaShift = 0.01;
 
% Extract the volatility specification
VolSpec = BDTTree.VolSpec;
 
% Shift the volatiltiy up
VolSpecUp = bdtvolspec(VolSpec, SigmaShift);

% Extract the time specification
TimeSpec = BDTTree.TimeSpec;

%-----------------------------------------------------------------
% Create new trees and calculate shifted prices
%-----------------------------------------------------------------
% compute up rate tree
ShiftTree = bdttree(VolSpec, RateSpecUp, TimeSpec);
  
PriceFup = bdtprice(ShiftTree, IVar, options);
  
% compute down rate tree
ShiftTree = bdttree(VolSpec, RateSpecDown, TimeSpec);
  
PriceFdown = bdtprice(ShiftTree, IVar, options);

if nargout >= 3,
  % compute sigma shifted tree
  ShiftTree = bdttree(VolSpecUp, RateSpec, TimeSpec);
  
  PriceSigma = bdtprice(ShiftTree, IVar, options);
end

%-----------------------------------------------------------------
% Compute sensitivities by finite differences
%-----------------------------------------------------------------

if nargout >= 3
  % Vega
  Vega = ( PriceSigma - Price0 )/SigmaShift;
end

if nargout >= 2
  % Gamma
  Gamma = ( PriceFup - 2*Price0 + PriceFdown )/(Disturbance*Disturbance);
end

% Do two-sided difference for Delta
Delta = ( PriceFup - PriceFdown )/(2*Disturbance);

if nargout == 4
   Price = Price0; 
end

