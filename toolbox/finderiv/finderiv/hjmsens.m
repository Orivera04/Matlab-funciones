function [Delta, Gamma, Vega, Price] = hjmsens(HJMTree, IVar, options)
%HJMSENS Instrument sensitivities and prices by an HJM interest rate model.
%   Computes dollar sensitivities and prices for instruments using an
%   interest rate tree created with HJMTREE.  
%
%   [Delta, Gamma, Vega, Price] = hjmsens(HJMTree, InstSet)
%
%   [Delta, Gamma, Vega, Price] = hjmsens(HJMTree, InstSet, Options)
%
% Inputs:
%   HJMTree - Heath-Jarrow-Morton tree sampling a forward rate process.
%             Type "help hjmtree" for information on creating the 
%             variable HJMTree.
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
%             calls to HJMTREE.  Type "help hjmtree" for information on 
%             the observed yield curve.
%
%   Gamma   - NINST x 1 vector of gammas, representing the rate of
%             change of instruments deltas with respect to the changes in
%             the interest rate. Gamma is computed by finite differences
%             in calls to HJMTREE.
%
%   Vega    - NINST x 1 vector of vegas, representing the rate of
%             change of instruments prices with respect to the changes 
%             in the volatility, Sigma(t,T), of the interest rate. Vega
%             is computed by finite differences in calls to HJMTREE. Type 
%             "help hjmvolspec" for information on the volatility process.
%
%   Price  - NINST x 1 vector of prices of each instrument.  The prices
%            are computed by backward dynamic programming on the interest rate
%            tree. If an instrument cannot be priced, a NaN is returned.
%
%
% Notes:
%   HJMSENS handles the following instrument types: 'Bond', 'CashFlow',
%   'OptBond', 'Fixed', 'Float', 'Cap', 'Floor', 'Swap'.  Type 
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
%   instdisp(HJMInstSet)
%   [Delta, Gamma] = hjmsens(HJMTree, HJMInstSet)
%
% See also HJMPRICE, HJMTREE, HJMVOLSPEC, INSTADD, INTENVSENS.

%   Author(s): M. Reyes-Kattar, J. Akao 10/27/99
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $  $Date: 2002/04/14 16:37:46 $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------
if (nargin<1) | ~isafin(HJMTree,'HJMFwdTree')
  error('The first argument must be an HJM tree created by HJMTREE');
end

if (nargin<2) | ~isafin(IVar,'Instruments')
  error('The second argument must be a Financial Instrument Variable')
end

% Set default for pricing option
if(nargin < 3 | isempty(options))
    options = derivset;
end

HJMTree = checktree(HJMTree, IVar, options);

% If any warnings were to come out, they would come from inside
% checktree. Turn off warnings for the rest of the function.
options = derivset(options, 'Warnings', 'off');

% Compute initial prices
Price0 = hjmprice(HJMTree, IVar, options);

% Introduce a disturbance of 100 (up and down) basis points to the
% intially observed Rates, and recalculate the price
Disturbance = 0.01;

% Extract the initial rate curve for the tree
RateSpec = HJMTree.RateSpec;
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
VolSpec = HJMTree.VolSpec;

% Shift the volatiltiy up
VolSpecUp = hjmvolspec(VolSpec, SigmaShift);

% Extract the time specification
TimeSpec = HJMTree.TimeSpec;

%-----------------------------------------------------------------
% Create new trees and calculate shifted prices
%-----------------------------------------------------------------
% compute up rate tree
ShiftTree = hjmtree(VolSpec, RateSpecUp, TimeSpec);
  
PriceFup = hjmprice(ShiftTree, IVar, options);
  
% compute down rate tree
ShiftTree = hjmtree(VolSpec, RateSpecDown, TimeSpec);
  
PriceFdown = hjmprice(ShiftTree, IVar, options);

if nargout >= 3,
  % compute sigma shifted tree
  ShiftTree = hjmtree(VolSpecUp, RateSpec, TimeSpec);
  
  PriceSigma = hjmprice(ShiftTree, IVar, options);
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

