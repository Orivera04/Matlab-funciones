function [HJMTree] = hjmtree(VolSpec, RateSpec, TimeSpec)
%HJMTREE Build an HJM forward rate tree.
% 
%   [HJMTree] = hjmtree(VolSpec, RateSpec, TimeSpec)
%
% Inputs:
%   VolSpec  - Volatility process specification.  Sets the number of
%              factors and the rules for computing the volatility 
%              sigma(t,T) for each factor.  Type "help hjmvolspec" for 
%              information on the volatility process. 
%   RateSpec - Interest rate specification of the initial rate curve.
%              Type "help intenvset" for information on declaring an 
%              interest rate variable. 
%   TimeSpec - Tree time layout specification.  Type "help hjmtimespec"
%              for information on the tree structure.  Defines the 
%              observation dates of the HJM tree and the Compounding rule 
%              for date to time mapping and price-yield formulas.
%
% Outputs:
%   HJMTree  - Structure containing time and forward rate information on a
%              bushy tree.
%
% See also HJMVOLSPEC, HJMTIMESPEC, INTENVSET, HJMPRICE, HJMVOLPROC.
%

%   Author(s): J.Akao 7/17/98
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.18 $  $Date: 2002/04/14 16:37:49 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if nargin<3 
	error('The function hjmtree requires three input arguments: VolSpec, RateSpec and TimeSpec'); 
end

if ~isafin(VolSpec,'HJMVolSpec')
	error('The first argument must be a volatility structure created using HJMVOLSPEC');
end 

if ~isafin(RateSpec,'RateSpec')
	error('The second argument must be a term structure created using INTENVSET');
end 

if ~isafin(TimeSpec,'HJMTimeSpec')
	error('The third argument must be a time structure created using HJMTIMESPEC');
end

%----------------------------------------------------------------
% Extract tree and process parameters from the process specification
%----------------------------------------------------------------

NumFactors  = VolSpec.NumFactors;
NumBranch   = VolSpec.NumBranch;
PBranch     = VolSpec.PBranch;    
Fact2Branch = VolSpec.Fact2Branch;

%----------------------------------------------------------------
% Map time structure
%----------------------------------------------------------------
ValuationDate   = TimeSpec.ValuationDate  ;
Maturity = TimeSpec.Maturity;
Compound = TimeSpec.Compounding;
Basis    = TimeSpec.Basis   ;
EOM      = TimeSpec.EndMonthRule;

% find the depth of the tree
NumLevels = length(Maturity);

% dates and times for the tree
dSpan = [ValuationDate; Maturity];
tSpan = date2time(ValuationDate, dSpan, Compound, Basis, EOM);

% Break down into observation times, fwd rate times (StartTimes), and cash
% flow times (EndTimes).

% Observation times of the tree nodes (row)
dObs = dSpan(1:NumLevels)'; 
tObs = tSpan(1:NumLevels)'; 

% Starting and ending times of rates stored at each observation level
DFwd   = cell(1,NumLevels);
CFlowD = cell(1,NumLevels);
TFwd   = cell(1,NumLevels);
CFlowT = cell(1,NumLevels);
for iObs = 1:NumLevels,
  DFwd{iObs}   = dSpan(iObs:NumLevels);
  CFlowD{iObs} = dSpan(iObs+1:NumLevels+1);
  
  TFwd{iObs}   = tSpan(iObs:NumLevels);
  CFlowT{iObs} = tSpan(iObs+1:NumLevels+1);
end

%----------------------------------------------------------------
% Compute initial forward rates
%----------------------------------------------------------------

% for now, insure that the vector is the right size
if ~isafin(RateSpec, 'RateSpec')
  FwdRates = RateSpec;
else
  % adjust interest rate environment to initial forward curve dates
  
  % Set the Compounding of the RateSpec to match that of the TimeSpec:
  if(RateSpec.Compounding ~= Compound)
      RateSpec = intenvset(RateSpec, 'Compounding', Compound);
  end
  
  % Back up the RateSpec passed in, since it contains the information
  % specified by the user
  RateSpecOri = RateSpec;
  
  % Call intenvset so that the discounts are recalculated to values that
  % are consistent with those found in the TimeSpec
  RateSpec = intenvset(RateSpec, 'EndDates', CFlowD{1}, ...
     'StartDates', DFwd{1}, 'ValuationDate', ValuationDate);
  
  % pull appropriate forward rates from the interest rate environment
  % These forward rates are the reciprocal discount factors
  FwdRates = 1./intenvget(RateSpec, 'Disc');
end

NumFwd = length(FwdRates);

%----------------------------------------------------------------
% NumLevels : depth of tree
% NumPos : number of fwd rates contained at each observation time
% NumStates : number of states at each observation time
%
%----------------------------------------------------------------

% Allocate a variable for the Forward Rate Tree
FwdTree = mkbush(NumLevels, NumBranch, NumFwd, 1);

% Get the size information
[NumLevels, NumChild, NumPos, NumStates] = bushshape(FwdTree);

% Set the first vector to the initial forward rates
FwdTree{1}(:) = FwdRates(:);

%----------------------------------------------------------------
% Run the interest rate process forward in time
% HJMVOLPROC customizes volatility models.
% HJMDRIFTPROC adds factors to the evolution.
%----------------------------------------------------------------
for iObs = 1:NumLevels-1,
  % Compute the raw volatility processes
  % Sigma [NumRates x NumFactors]
  [Sigma, PropFlag, PropMax] = hjmvolproc(VolSpec,tObs(iObs),TFwd{iObs+1});
  
  % Scale the volatility process by the observation time step
  % Sigma * sqrt(dT)
  dT = tObs(iObs+1) - tObs(iObs);
  Sigma = Sigma*sqrt(dT);
  
  % Scale the discretized rate volatilities by the rate term
  % Term [NumRates x 1]
  % The evolution is for rates at the next step
  % Apply to every factor
  Term = CFlowT{iObs+1} - TFwd{iObs+1};
  Sigma = Sigma .* Term(:, ones(1,NumFactors));
  
  % Pull out the current spot rates [1 x NumStates]
  % Compounding = -1 : log( FwdTree{iObs}(1,:) )/dt;
  % Compounding =  1 : (FwdTree{iObs}(1,:) - 1)/dt;
  Spot = disc2rate(Compound, 1./FwdTree{iObs}(1,:), ... 
                   CFlowT{iObs}(1), TFwd{iObs}(1) );
  
  % create multipliers for proportional volatilties
  % volatility contribution is Sigma * Spot
  PropMult = ones(NumFactors, NumStates(iObs));
  for lF=1:NumFactors
    if PropFlag(lF)
      PropMult(lF,:) = min(Spot, PropMax(lF));
    end
  end
  
  % Compute the children along each branch, allowing arbitrage
  for kB = 1:NumBranch
    % Collapse the volatility factors for this branch
    % Sum the effects of each factor
    SigmaSum = zeros(NumPos(iObs+1), NumStates(iObs));
    for lF=1:NumFactors
      SigmaSum = SigmaSum + Fact2Branch(lF,kB)*Sigma(:,lF)*PropMult(lF,:);
    end
    
    % The arbitrage-free process looks like this, but we don't know DriftProc
    % FwdTree{iObs+1}(:,:,kB) = FwdTree{iObs}(2:end,:) .* DriftProc .* ...
    %   exp( SigmaSum );
    
    % Compute the children allowing arbitrage
    % The current spot rate does not propagate
    FwdTree{iObs+1}(:,:,kB) = FwdTree{iObs}(2:end,:) .* exp( SigmaSum );
  end
  
  % Compute the unit bond prices at valued at iObs+1 for arbitrage 
  % PObs - current observed prices
  % PExp - expected prices over the children
  PObs = 1./cumprod(FwdTree{iObs}(2:end,:) ,1);
  PExp = zeros(NumPos(iObs+1), NumStates(iObs));
  for kB = 1:NumBranch
    PExp = PExp + PBranch(kB) * 1./cumprod(FwdTree{iObs+1}(1:end,:,kB) ,1);
  end
  
  % Compute the drift process which makes the evolution arbitrage-free
  % DriftProc [NumRates x NumStates]
  % PObs = 1./cumprod(DriftProc) .* PExp
  % cumprod(DriftProc) = PExp ./ PObs
  DriftProc = zeros(NumPos(iObs+1), NumStates(iObs));
  CProd = PExp./PObs;
  DriftProc(1,:) = CProd(1,:);
  DriftProc(2:end,:) = CProd(2:end,:)./CProd(1:end-1,:);
  
  % Go back and apply the drift process to each child
  for kB = 1:NumBranch
    FwdTree{iObs+1}(:,:,kB) = FwdTree{iObs+1}(:,:,kB) .* DriftProc;
  end

end
    
%----------------------------------------------------------------
% create a structure to hold the tree
%----------------------------------------------------------------
HJMTree = classfin('HJMFwdTree');
HJMTree.VolSpec  = VolSpec;
HJMTree.TimeSpec = TimeSpec;
HJMTree.RateSpec = RateSpecOri;  % Save the original RateSpec
HJMTree.tObs     = tObs;
HJMTree.TFwd     = TFwd;
HJMTree.CFlowT   = CFlowT;
HJMTree.FwdTree  = FwdTree;

return

