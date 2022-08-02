function [Delta, Gamma, Vega, Price] = bintreesens(BinStockTree, varargin)
%BINTREESENS Engine function for crrsens and eqpsens.
%
%   [Delta, Gamma, Vega, Price] = bintreesens(BinStockTree, IVar)
%   [Delta, Gamma, Vega, Price] = bintreesens(BinStockTree, IVar, Options)
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01-May-2003
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2003/09/22 19:13:59 $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------

IVar = varargin{1};

%Find number of instruments
NumInst = length(instget(IVar,'FieldName', {'Index'}));

% locate and extract path-dependent options (Lookbacks and Asians)
TypeList = insttypes(IVar);
IndAsian = strmatch('Asian', TypeList,'exact');
IndLookback= strmatch('Lookback', TypeList,'exact');

Index_PD = [];
if ~isempty(IndAsian)
    Index_PD = instget(IVar, 'Type', {'Asian'}, 'FieldName', {'Index'});
end
if ~isempty(IndLookback)
    Index_PD = [Index_PD instget(IVar, 'Type', {'Lookback'}, 'FieldName', {'Index'})];
end
Index_PD = sort(Index_PD);
NumPD = length(Index_PD);
IVar_PD = instselect(IVar, 'Index', Index_PD);

% Extract the rest:
IVar_NPD = instdelete(IVar, 'Index', Index_PD);

% Keep track of the type of instruments in the portfolio
bPD = false; bNPD = false;
if(NumPD > 0)
    bPD = true;
end

if NumPD < NumInst
    bNPD = true;
end

% Prepare output and mask
Delta = NaN*ones(NumInst,1);
Mask_PD = false(NumInst,1); Mask_PD(Index_PD)=true;

% Get prices
[Price, PriceTree] = bintreeprice(BinStockTree, varargin{:});

% Find sensitivities and combine results

if nargout == 1
    if(bPD)
        Delta(Mask_PD) = bintreedeltagamma_PD(BinStockTree, Price, IVar_PD);
    end
    if(bNPD)
        Delta(~Mask_PD) = bintreedeltagamma_NPD(BinStockTree, PriceTree);
    end
elseif nargout >= 2
    % Initialize Gamma to NaNs
    Gamma = Delta;
    if(bPD)
        % package input args depending on how they were passed in
        if nargin > 2
            InVars_PD = {IVar_PD, varargin{2}};
        else
            InVars_PD = {IVar_PD};
        end
        [Delta(Mask_PD), Gamma(Mask_PD)] = bintreedeltagamma_PD(BinStockTree, Price(Mask_PD), InVars_PD);
    end
    
    if(bNPD)
        [Delta(~Mask_PD), Gamma(~Mask_PD)] = bintreedeltagamma_NPD(BinStockTree, PriceTree, ~Mask_PD);
    end
end
    
if nargout > 2
    Vega = bintreevega(BinStockTree, Price, varargin);
end

return



% ===============================================================
% ===============================================================
function [Delta, Gamma] = bintreedeltagamma_PD(BinStockTree, Price0, InVars)

% Extract the initial stock price used for building
% the stock tree
StockSpec = BinStockTree.StockSpec;
So = StockSpec.AssetPrice;
Disturbance = (eps ^ (1/4)) *So; %Jackel, P. - Monte Carlo methods in Finance, pp. 142

% Up
SoUp = So+Disturbance;
StockSpecUp = StockSpec;
StockSpecUp.AssetPrice = SoUp;

% Down
SoDn = So-Disturbance;
StockSpecDn = StockSpec;
StockSpecDn.AssetPrice = SoDn;

% Extract the time specification
BinTimeSpec = BinStockTree.TimeSpec;

% Extract the interest rate environment
RateSpec = BinStockTree.RateSpec;

% Extract the method
method = BinStockTree.Method;

%-----------------------------------------------------------------
% Create new trees and calculate shifted prices
%-----------------------------------------------------------------
% compute up rate tree

ShiftTree = binstocktree(StockSpecUp, RateSpec, BinTimeSpec, method);  
PriceFup = bintreeprice(ShiftTree, InVars{:});

% compute down rate tree
ShiftTree = binstocktree(StockSpecDn, RateSpec, BinTimeSpec, method);    
PriceFdown = bintreeprice(ShiftTree, InVars{:});

%-----------------------------------------------------------------
% Compute sensitivities by finite differences
%-----------------------------------------------------------------
if nargout >= 2
  % Gamma
  Gamma = ( PriceFup - 2*Price0 + PriceFdown )/(Disturbance .* Disturbance);
end

% Do two-sided difference for Delta
Delta = ( PriceFup - PriceFdown )/(2*Disturbance);

return




% ===============================================================
% ===============================================================
function [Delta, Gamma] =  bintreedeltagamma_NPD(BinStockTree, PriceTree0, Mask_NPD)

SU =  BinStockTree.STree{2}(1);
SD =  BinStockTree.STree{2}(2);

if nargout > 1
  % Gamma
  PUU = PriceTree0.PTree{3}(Mask_NPD,1);
  PUD = PriceTree0.PTree{3}(Mask_NPD,2);
  PDD = PriceTree0.PTree{3}(Mask_NPD,3);
  SUU = BinStockTree.STree{3}(1);
  SUD = BinStockTree.STree{3}(2);
  SDD = BinStockTree.STree{3}(3);  
  Gamma = ((PUU-PUD)/(SUU-SUD) - (PUD-PDD)/(SUD-SDD))/(SU-SD);
end

% Do two-sided difference for Delta
Delta = (PriceTree0.PTree{2}(Mask_NPD,1) - PriceTree0.PTree{2}(Mask_NPD,2) )/(SU-SD);
return




% =================================================================
% =================================================================
function Vega = bintreevega(BinStockTree, Price0, InVars)

% Introduce a disturbance of 1% to Sigma
SigmaShift = 0.01;

% Modify the volatility specification
StockSpecSigmaUp = BinStockTree.StockSpec;
StockSpecSigmaUp.Sigma = StockSpecSigmaUp.Sigma + SigmaShift;

% Extract the time specification
BinTimeSpec = BinStockTree.TimeSpec;

% Extract the interest rate environment
RateSpec = BinStockTree.RateSpec;

% Extract the method
method = BinStockTree.Method;

% compute sigma shifted tree and calculate Vega
ShiftTree = binstocktree(StockSpecSigmaUp, RateSpec, BinTimeSpec, method);
PriceSigma = bintreeprice(ShiftTree, InVars{:});
Vega = ( PriceSigma - Price0 )/SigmaShift;

return
