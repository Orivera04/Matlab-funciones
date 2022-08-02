function [Price, PriceTree, CFTree] = fixedbyhjm(HJMTree, varargin)
%FIXEDBYHJM Price a fixed rate note from an HJM interest rate tree.
%   Dynamic programming subroutine for HJMPRICE.
%
%   [Price, PriceTree] = fixedbyhjm(HJMTree, CouponRate, Settle, Maturity)
%
%   [Price, PriceTree] = fixedbyhjm(HJMTree, CouponRate, Settle, Maturity, ...
%                                   Reset, Basis, Principal, Options) 
%
% Inputs:
%   HJMTree    - Forward rate tree structure created by HJMTREE.
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
%               PriceTree.PBush contains the clean prices. 
%               PriceTree.AIBush contains the accrued interest.
%               PriceTree.tObs contains the observation times.
%
%
% Notes: The Settle date for every fixed rate note is set to the ValuationDate 
%        of the HJM Tree.  The fixed rate note argument, Settle, is ignored.
%
% See also HJMTREE, CFBYHJM, CAPBYHJM, SWAPBYHJM, FLOORBYHJM, FLOATBYHJM, BONDBYHJM
%

%   Author(s): M. Reyes-Kattar 04/28/99
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.13 $  $Date: 2002/04/14 16:39:37 $

%Checking the input arguments.

if ~isafin(HJMTree,'HJMFwdTree')
  error('The first argument must be an HJM tree created by HJMTREE');
end

if (nargin < 4)
   error('You must enter HJMTree, CouponRate, Settle and Maturity');
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
   instargfixed(varargin{1}, HJMTree.TimeSpec.ValuationDate, varargin{3:end});
  
% Special rules: Single Settle equal to Valuation Date
FixedSettle = finargdate(varargin{2});
FixedSettle = FixedSettle(~isnan(FixedSettle));
if ~isempty(FixedSettle) & any(FixedSettle ~= Settle(1))
   warning('Fixed rate notes are valued at HJM Tree ValuationDate rather than Settle');
end

[Price, PriceTree, CFTree] = bondbyhjm(HJMTree, CouponRate, Settle, Maturity, ...
   FixedReset, Basis, [], [], [], [], [], Principal, options);

