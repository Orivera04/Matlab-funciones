function BDTTree = bdttree(BDTVolSpec, RateSpec, BDTTimeSpec)
%BDTTREE Build a BDT interest rate tree.
% 
%   [BDTTree] = bdttree(VolSpec, RateSpec, TimeSpec)
%
% Inputs:
%   VolSpec  - Volatility process specification.  Type "help bdtvolspec" for 
%              information on the volatility process. 
%   RateSpec - Interest rate specification of the initial rate curve.
%              Type "help intenvset" for information on declaring an 
%              interest rate variable. 
%   TimeSpec - Tree time layout specification.  Type "help bdttimespec"
%              for information on the tree structure.  Defines the 
%              observation dates of the BDT tree and the Compounding rule 
%              for date to time mapping and price-yield formulas.
%
% Outputs:
%   BDTTree  - Structure containing time and interest rate information of a
%              recombining tree.
%
% See also BDTVOLSPEC, BDTTIMESPEC, INTENVSET, BDTPRICE.
%

%   Author(s): M.Reyes-Kattar 12/17/2000
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $  $Date: 2002/04/14 16:38:40 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if nargin<3 
	error('The function bdttree requires three input arguments: VolSpec, RateSpec and TimeSpec'); 
end

if ~isafin(BDTVolSpec,'BDTVolSpec')
	error('The first argument must be a volatility structure created using BDTVOLSPEC');
end 

if ~isafin(RateSpec,'RateSpec')
	error('The second argument must be a term structure created using INTENVSET');
end 

if ~isafin(BDTTimeSpec,'BDTTimeSpec')
	error('The third argument must be a time structure created using BDTTIMESPEC');
end

%----------------------------------------------------------------
% Map time structure
%----------------------------------------------------------------
ValuationDate   = BDTTimeSpec.ValuationDate  ;
Maturity 		= BDTTimeSpec.Maturity;
Compound 		= BDTTimeSpec.Compounding;
Basis    		= BDTTimeSpec.Basis;
EOM      		= BDTTimeSpec.EndMonthRule;

% Make sure valuation dates between rates and volatility match:
if(datenum(ValuationDate) ~= datenum(BDTVolSpec.ValuationDate) )
	error('RateSpec and BDTVolSpec must have the same valuation date')
end

% find the depth of the tree
NumLevels = length(Maturity);

% dates and times for the tree
dSpan = [ValuationDate; Maturity];
tSpan = date2time(ValuationDate, dSpan, Compound, Basis, EOM);


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
% Calculate Fwd rates
%----------------------------------------------------------------

% adjust interest rate environment to initial forward curve dates
  
% Set the Compounding of the RateSpec to match that of the TimeSpec:
if(RateSpec.Compounding ~= Compound)
	RateSpec = intenvset(RateSpec, 'Compounding', Compound, Basis, EOM);
end
  
% Back up the RateSpec passed in, since it contains the information
% specified by the user
RateSpecOri = RateSpec;
  
% Call intenvset so that the discounts are recalculated to values that
% are consistent with those found in the TimeSpec
RateSpec = intenvset(RateSpec, 'EndDates', Maturity, ...
     'StartDates', ValuationDate, 'ValuationDate', ValuationDate);
 
% Do the same with the volatility curve
VolSpec = interpvolspec(BDTVolSpec, Maturity, Compound, BDTVolSpec.VolInterpMethod,...
                        Basis, EOM);
 
% Define the basic BDT interpolation Parameters
ZeroRates = intenvget(RateSpec, 'rates');
ZeroVols = VolSpec.VolCurve;

% We're building a fwd tree. We know the value for the first node
% because it's given
ZeroDisc = intenvget(RateSpec, 'Disc');
FwdTree{1} = 1/ZeroDisc(1);

LsqOptions = optimset('Display','off','tolfun',eps);

NumInterpTimes = length(tSpan)-1;
for iLevel = 2:NumInterpTimes
	[R,RESNORM,RESIDUAL,EXITFLAG] = lsqnonlin('addbdtlevel', [ZeroRates(iLevel); 1.1], ...
		[0;0], [], LsqOptions, [ZeroRates(iLevel); ZeroVols(iLevel)], Compound, tSpan', FwdTree);
	
	if(EXITFLAG < 0)
		FwdTree = NaN;
		warning('Unable to find BDT rates tree with given parameters')
		break;
	end
	
	[Dummy, FwdTree] = addbdtlevel(R, [0;0], Compound, tSpan', FwdTree);
end

% Flip all levels so that rates decrease as the tree moves upward
% (HJM convention)
for(iLevel=2:NumLevels)
	FwdTree{iLevel} = fliplr(FwdTree{iLevel});
end

%---------------------------------------------------------------------
%Build all output constructs
%---------------------------------------------------------------------
BDTTree = classfin('BDTFwdTree');
BDTTree.VolSpec  	= BDTVolSpec;
BDTTree.TimeSpec 	= BDTTimeSpec;
BDTTree.RateSpec 	= RateSpecOri;  % The original RateSpec
BDTTree.tObs     	= tObs;
BDTTree.TFwd     	= TFwd;
BDTTree.CFlowT   	= CFlowT;
BDTTree.FwdTree 	= FwdTree;

return


function VolSpec = interpvolspec(BDTVolSpec, Maturity, Compound, InterpMethod, Basis, EOM)

% Make sure there's something to be done
if (all(ismember(Maturity, BDTVolSpec.VolDates)))
	VolSpec = BDTVolSpec;
	return;
end

% Map dates to times:
VolMaturityT = date2time(BDTVolSpec.ValuationDate, BDTVolSpec.VolDates, Compound, Basis, EOM);
MaturityT = date2time(BDTVolSpec.ValuationDate, Maturity, Compound, Basis, EOM);

% Maturities are now zero-based, since they share the ValuationDate
% Do straight interpolation based on options passed in
options = optimset('display', 'off');

InterpVol = interp1(VolMaturityT, BDTVolSpec.VolCurve, MaturityT, BDTVolSpec.VolInterpMethod, 'extrap');

% Build the new VolSpec based on the interpolated values
VolSpec = bdtvolspec(BDTVolSpec.ValuationDate, Maturity, InterpVol);









