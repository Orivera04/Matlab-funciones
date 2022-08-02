function [Price, PriceTree, CFTree] = fixedbybdt(BDTTree, varargin)
%FIXEDBYBDT Price a fixed rate note from a BDT interest rate tree.
%   Dynamic programming subroutine for BDTPRICE.
%
%   [Price, PriceTree] = fixedbybdt(BDTTree, CouponRate, Settle, Maturity)
%
%   [Price, PriceTree] = fixedbybdt(BDTTree, CouponRate, Settle, Maturity, ...
%                                   Reset, Basis, Principal, Options) 
%
% Inputs:
%   BDTTree    - Interest rate tree structure created by BDTTREE.
%   CouponRate - NINSTx1 Decimal annual rate.
%   Settle     - NINSTx1 vector of dates representing the settle date of the fixed rate note.
%   Maturity   - NINSTx1 vector of dates representing the maturity date of the fixed rate note.
%   Reset      - NINSTx1 vector representing the frequency of payments per year.
%                Default is 1.
%	Basis      - NINSTx1 vector representing the basis used when annualizing the 
%                input forward rate tree. Default is 0 (actual/actual).
%   Principal  - NINSTx1 vector of the notional principal amount. Default is 100.
%   Options    - Structure created with derivset containing derivatives 
%                pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price     - NINSTx1 expected prices at time 0.
%   PriceTree - Structure containing trees of vectors of instrument prices and 
%               accrued interest, and a vector of observation times for each
%               node. 
%
%               PriceTree.PTree contains the clean prices. 
%               PriceTree.AITree contains the accrued interest.
%               PriceTree.tObs contains the observation times.
%  
%
% Notes: The Settle date for every fixed rate note is set to the ValuationDate 
%        of the BDT Tree.  The fixed rate note argument, Settle, is ignored.
%
% See also BDTTREE, CFBYBDT, CAPBYBDT, SWAPBYBDT, FLOORBYBDT, FLOATBYBDT, BONDBYBDT
%

%   Author(s): M. Reyes-Kattar 03/14/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $  $                       $

%Checking the input arguments.

if ~isafin(BDTTree,'BDTFwdTree')
  error('The first argument must be a BDT tree created by BDTTREE');
end

if (nargin < 4)
   error('You must enter BDTTree, CouponRate, Settle and Maturity');
end

% Extract pricing options
options = [];
if length(varargin) > 6
  options = varargin{7};
  varargin = varargin(1:6);
end

% Set default for pricing option
if(isempty(options))
    options = derivset;
end

% Sanity check on 'options'
if ~isa(options,'struct')
  error('Options must be an options structure created with DERIVSET.');
end


[CouponRate, Settle, Maturity, FixedReset, Basis, Principal] = ...
   instargfixed(varargin{1}, BDTTree.TimeSpec.ValuationDate, varargin{3:end});
  
% Special rules: Single Settle equal to Valuation Date
FixedSettle = finargdate(varargin{2});
FixedSettle = FixedSettle(~isnan(FixedSettle));
if ~isempty(FixedSettle) & any(FixedSettle ~= Settle(1))
   warning('Fixed rate notes are valued at BDT Tree ValuationDate rather than Settle');
end

[Price, PriceTree, CFTree] = bondbybdt(BDTTree, CouponRate, Settle, Maturity, ...
   FixedReset, Basis, [], [], [], [], [], Principal, options);

