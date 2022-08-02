function [Delta, Gamma, Price] = intenvsens(RateSpec, IVar)
%INTENVSENS Instrument sensitivities and prices against a set of zero curve(s).
%   Computes dollar sensitivities and prices for instruments using an
%   zero coupon bond rate term structure.  
%
%   [Delta, Gamma, Price] = intenvsens(RateSpec, InstSet)
%
%   Inputs:
%   RateSpec - The zero annualized rate term structure for valuation. The 
%   'Rates' field of RateSpec is an NPOINTS x NUMCURVES matrix of annualized 
%   zero rates.  Type "help intenvset" for information on creating the term 
%   structure.
%
%   InstSet - Variable containing a collection of NINST instruments.
%   Instruments are broken down by type and each type can have different
%   data fields.  
%
%   Outputs:
%     Delta - NINST x NUMCURVES matrix of deltas, representing the rate of 
%     change of instruments prices with respect to shifts in the observed
%     forward yield curve. Delta is computed by finite differences.
%
%     Gamma - NINST x NUMCURVES matrix of gammas, representing the rate of
%     change of instruments deltas with respect to shifts in the observed 
%     forward yield curve.  Gamma is computed by finite differences.
%
%     Price - NINST x NUMCURVES matrix of prices of each instrument.  If an  
%     instrument cannot be priced, a NaN is returned.
%
%   Note:
%     INTENVSENS handles the following instrument types: 'Bond', 'CashFlow',
%     'Fixed', 'Float', 'Swap'.  Type "help instadd" to construct defined types.
%
%
%   Example:	
%     load deriv
%     instdisp(ZeroInstSet)
%     [Delta, Gamma]= intenvsens(ZeroRateSpec,ZeroInstSet)
%
%   See also INTENVPRICE, INTENVSET, INSTADD, HJMPRICE, HJMSENS.

%   Author(s): P. N. Secakusuma, M. Reyes-Kattar, 3-Jan-2000
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $  $Date: 2002/04/14 21:40:53 $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------
if (nargin<1) | ~isafin(RateSpec,'RateSpec')
  error('The first argument must be a term structure created using INTENVSET');
end

if (nargin<2) | ~isafin(IVar,'Instruments')
  error('The second argument must be a Financial Instrument Variable')
end

% Compute initial prices
Price0 = intenvprice(RateSpec, IVar);

% Introduce a disturbance of 100 (up and down) basis points to the
% intially observed Rates, and recalculate the price
Disturbance = 0.01;

% Extract the initial rate curve for the term structure
Rates = intenvget(RateSpec, 'Rates');

% Going Up
RatesUp = Rates + Disturbance;
RateSpecUp = intenvset(RateSpec, 'Rates', RatesUp);

% Going Down
RatesDown = Rates - Disturbance;
RateSpecDown = intenvset(RateSpec, 'Rates', RatesDown);

%-----------------------------------------------------------------
% Create new term structures and calculate shifted prices
%-----------------------------------------------------------------
% compute up term structure price
PriceFup = intenvprice(RateSpecUp, IVar);

% compute down term structure price
PriceFdown = intenvprice(RateSpecDown, IVar);

%-----------------------------------------------------------------
% Compute sensitivities by finite differences
%-----------------------------------------------------------------
if nargout >= 2
   % Gamma
   Gamma = ( PriceFup - 2*Price0 + PriceFdown )/(Disturbance*Disturbance);
end  

% Do two-sided difference for Delta
Delta = ( PriceFup - PriceFdown )/(2*Disturbance);

%-----------------------------------------------------------------
% Output Price, if requested
%-----------------------------------------------------------------
if nargout == 3
   Price = Price0; 
end


