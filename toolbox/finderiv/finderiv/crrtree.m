function [CRRTree] = crrtree(StockSpec, RateSpec, BinTimeSpec)
%CRRTREE Build a Cox-Ross-Rubinstein stock Tree.
%
% [CRRTree] =  crrtree(StockSpec, RateSpec, TimeSpec)
%                                  
% Inputs:
%   StockSpec  - Stock specification. Type "help stockspec" for 
%                information on the stock specification. 
%   RateSpec   - Interest rate specification of the initial risk free rate curve.
%                Type "help intenvset" for information on declaring an 
%                interest rate variable. 
%   TimeSpec   - Tree time layout specification.  Type "help crrtimespec"
%                for information on the tree structure.  Defines the 
%                observation dates of the CRR binomial tree.
%
% Outputs:
%   CRRTree  - Structure specifying stock and time information for a CRR tree. 
%
%   Notes: This function allows to implement a binomial tree with varying
%          interest rates. In this case, the resulting tree will not longer
%          be a standard CRR tree. 
%
% See also STOCKSPEC, CRRTIMESPEC, INTENVSET.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:26 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if nargin<3 
	error('finderiv:crrtree:InvalidInputs','The function crrtree requires three input arguments: StockSpec, RateSpec and TimeSpec.'); 
end

if ~isafin(StockSpec,'StockSpec')
	error('finderiv:crrtree:InvalidStockSpec','The first argument must be a stock structure created using STOCKSPEC.');
end 

if ~isafin(RateSpec,'RateSpec')
	error('finderiv:crrtree:InvalidRateSpec','The second argument must be a term structure created using INTENVSET.');
end 

if ~isafin(BinTimeSpec,'BinTimeSpec')
	error('finderiv:crrtree:InvalidTimeSpec','The third argument must be a time structure created using CRRTIMESPEC.');
end


[CRRTree] = binstocktree(StockSpec, RateSpec, BinTimeSpec, 'CRR');

return