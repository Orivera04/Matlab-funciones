function [Price, PriceTree] = crrprice(BinStockTree, varargin)
%CRRPRICE Price instruments by a CRR binomial tree.
%   Computes prices for instruments using a CRR binomial tree
%   created with CRRTREE.  
%
%   Price = crrprice(CRRTree, InstSet)
%
%   [Price, PriceTree] = crrprice(CRRTree, InstSet)
%
%   [Price, PriceTree] = crrprice(CRRTree, InstSet, Options)
%
% Inputs:
%   CRRTree - Cox-Ross-Rubinstein stock tree.
%             Type "help crrtree" for information on creating the variable 
%             CRRTree.
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
%   CRRPRICE handles the following instrument types: 'OptStock', 'Barrier',
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
%   tree information.  For example, type "help barrierbycrr".
%   optstockbycrr  - Price American, European or Bermuda options by a CRR tree.
%   barrierbycrr   - Price barrier options by a CRR tree.
%   asianbycrr     - Price asian options by a CRR tree.
%   lookbackkbycrr - Price lookback options by a CRR tree.
%   compoundbycrr  - Price compound options by a CRR tree.
%
% See also CRRSENS, CRRTREE, INSTADD.

%   Author(s): M. Reyes-Kattar 19-May-2003
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:23 $

%-----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if ~isafin(BinStockTree, 'BinStockTree') | ~strcmpi(BinStockTree.Method, 'CRR')
    error('finderiv:crrprice:InvalidTree','The first argument must be a Stock tree created with CRRTREE.')
end

if (nargin<2) | ~isafin(varargin{1},'Instruments')
    error('finderiv:crrprice:InvalidInstrumentSet','The second argument must be a Financial Instrument Variable.')
end

[Price,PriceTree] = bintreeprice(BinStockTree, varargin{:});
