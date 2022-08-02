function [Delta, Gamma, Vega, Price] = eqpsens(BinStockTree, varargin)
%EQPSENS Instrument sensitivities and prices by an EQP binomial tree.
%   Computes dollar sensitivities and prices for instruments using an EQP 
%   tree created with EQPTREE.  
%
%   [Delta, Gamma, Vega] = eqpsens(EQPTree, InstSet)
%
%   [Delta, Gamma, Vega, Price] = eqpsens(EQPTree, InstSet)
%
%   [Delta, Gamma, Vega, Price] = eqpsens(EQPTree, InstSet, Options)
%
% Inputs:
%   EQPTree - Equal Probability stock tree.
%             Type "help eqptree" for information on creating the variable 
%             EQPTree.
%
%   InstSet - Variable containing a collection of NINST instruments.
%             Instruments are broken down by type and each type can have
%             different data fields.  
%
% Optional Inputs:
%
%   Options	- Structure created with derivset containing derivatives 
%             pricing options. Type "help derivset" for more information.
%
% Outputs:
%
%   Delta   - NINST x 1 vector of deltas, representing the rate of 
%             change of instruments prices with respect to changes in the 
%             stock price. Type "help eqptree" for information on 
%             the stock tree.
%
%   Gamma   - NINST x 1 vector of gammas, representing the rate of
%             change of instruments deltas with respect to the changes in
%             the stock price. 
%
%   Vega    - NINST x 1 vector of vegas, representing the rate of
%             change of instruments prices with respect to the changes 
%             in the volatility, of the stock. Vega is computed by finite
%             differences in calls to RQPTREE. 
%
%   Price  - NINST x 1 vector of prices of each instrument.  The prices
%            are computed by backward dynamic programming on the stock
%            tree. If an instrument cannot be priced, a NaN is returned.
%
%
% Notes:
%   EQPSENS handles the following instrument types: 'OptStock', 'Barrier',
%   'Asian', 'Lookback', 'Compound'.  Type "help instadd" to construct 
%   defined types.
%
%   For path-dependent options (Lookbacks and Asians), Delta and Gamma are 
%   computed by finite differences in calls to CEQPPRICE.  Type "help eqptree" 
%   for information on the stock tree. For the rest of the options
%   ('OptStock', 'Barrier', and 'Compound'), Delta and Gamma are computed
%   from the EQP Tree and the corresponding option price tree. See Chriss,
%   Neil. "Black-Scholes and Beyond" pp 308-312.
%
%   All sensitivities are returned as dollar sensitivities. To find the
%   per-dollar sensitivities, they must be divided by their respective
%   instrument price.
%
%
% See also EQPPRICE, EQPTREE.

%   Author(s): M. Reyes-Kattar 5/05/2003
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:32 $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------
if ~isafin(BinStockTree, 'BinStockTree') | ~strcmpi(BinStockTree.Method, 'EQP')
    error('finderiv:eqpsens:InvalidTree','The first argument must be a Stock tree created with EQPTREE.')
end


if (nargin<2) | ~isafin(varargin{1},'Instruments')
    error('finderiv:eqpsens:InvalidInstrumentSet','The second argument must be a Financial Instrument Variable.')
end

[Delta, Gamma, Vega, Price] = bintreesens(BinStockTree, varargin{:});
