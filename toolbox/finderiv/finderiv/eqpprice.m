function [Price, PriceTree] = eqpprice(BinStockTree, varargin)
%EQPPRICE Price instruments by an EQP binomial tree.
%   Computes prices for instruments using an EQP binomial tree
%   created with EQPTREE.  
%
%   Price = eqpprice(EQPTree, InstSet)
%
%   [Price, PriceTree] = eqpprice(EQPTree, InstSet)
%
%   [Price, PriceTree] = crrprice(CRRTree, InstSet, Options)
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
%   Price     - NINST x 1 vector of prices of each instrument at time 0.  
%               The prices are computed by backward dynamic programming on 
%               the stock tree. If an instrument cannot be priced,  
%               a NaN is returned in that entry. 
%
%   PriceTree - Structure containing trees of vectors of instrument prices
%               and a vector of observation times for each node. 
%
%               PriceTree.PTree contains the prices. 
%               PriceTree.tObs contains the observation times.
%               PriceTree.dObs contains the observation dates.
%
% Notes:
%   EQPPRICE handles the following instrument types: 'OptStock', 'Barrier',
%   'Asian', 'Lookback', 'Compound'.  Type "help instadd" to construct 
%   defined types.
%
%   Pricing of path-dependent options is done using Hull-White.
%   Consequently, for these options there are no unique prices on the 
%   tree nodes with the exception of the root node. The 
%   corresponding nodes of the tree are populated with NaNs for 
%   these particular options.
%
%   See single-type pricing functions to retrieve state-by-state pricing
%   tree information.  For example, type "help barrierbyeqp".
%   optstockbyeqp  - Price American, European or Bermuda options by an EQP tree.
%   barrierbyeqp   - Price barrier options by an EQP tree.
%   asianbyeqp     - Price asian options by an EQP tree.
%   lookbackkbyeqp - Price lookback options by an EQP tree.
%   compoundbyeqp  - Price compound options by an EQP tree.
%
% See also EQPSENS, EQPTREE, INSTADD.

%   Author(s): M. Reyes-Kattar 19-May-2003
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:31 $

%-----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if ~isafin(BinStockTree, 'BinStockTree') | ~strcmpi(BinStockTree.Method, 'EQP')
    error('finderiv:eqpprice:InvalidTree','The first argument must be a Stock tree created with EQPTREE.')
end

if (nargin<2) | ~isafin(varargin{1},'Instruments')
    error('finderiv:eqpprice:InvalidInstrumentSet','The second argument must be a Financial Instrument Variable.')
end

[Price,PriceTree] = bintreeprice(BinStockTree, varargin{:});
