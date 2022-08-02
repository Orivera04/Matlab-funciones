function [DiscTree, TreeErrorFlag] = mkdisctree(TreeTimes, ...
     BasePriceProcess, VolatilityProcess, MaxIterations)
%MKDISCTREE Discount Tree Iterated from Specified Price-Volatility Processes
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:47:41 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of input arguments and set defaults
if (nargin < 4)
     MaxIterations = 20;
end

if ((nargin < 3) | (isempty(TreeTimes) | isempty(BasePriceProcess) |...
          isempty(VolatilityProcess) | isempty(MaxIterations))) 
     error('Too few input arguments specified!')
end


%Check the specification for the maximum number of iterations
if (length(MaxIterations) > 1)
     error('MaxIerations must be a scalar value!')
end

if (MaxIterations > 50)
     warning('Excessive number of iterations will hinder model performance!')
end



%Make sure all input vectors are conforming
NumberTimeSteps = length(TreeTimes);

if ((length(BasePriceProcess) ~= NumberTimeSteps) &...
          (length(VolatilityProcess) ~= NumberTimeSteps))
     error('Input vectors must contain the same number of elements!')
end


%Make sure all input vectors are in column vector form for processing
TreeTimes = TreeTimes(:);
BasePriceProcess = BasePriceProcess(:);
VolatlityProcess = VolatilityProcess(:);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the number of time steps in the base price process
MaxStep = length(BasePriceProcess);


%Preallocate the output trees and initialize their starting values.
ShortTree = zeros(MaxStep, MaxStep);
DiscTree = ShortTree;


%Preallocate the state-price vectors.
ShortVol = zeros(1,MaxStep);
StatePrices = zeros(MaxStep,1);
UpStatePrices = StatePrices;
DownStatePrices = UpStatePrices;


%Preallocate the vectors for temporary up and down jumps in price
UpTempPrices = zeros(MaxStep+1, 1);
DownTempPrices = UpTempPrices;


%Build a matrix of time multiples
MultVect = [0 : MaxStep - 1]';
MultMat = MultVect(:, ones(1, MaxStep));
TFact = sqrt(TreeTimes)'; % column to go across the tree
TFactMat = TFact(ones(MaxStep, 1),:);
TimeMultMatrix = 2.0*TFactMat.*MultMat;


%Take the first specified unit bond price and derive an initial guess for
%the first rate in the short rate process
SRate00 = -log(BasePriceProcess(1, :));


%Take the first specified volatlity value as the starting guess for the
%volatlity of the short rate
InitialVolatility = log(VolatilityProcess(1, :)) ./ 2 ./TFact(1);


%Write the intial values for the short rate and the bond price into the
%initial nodes of the their respective trees
ShortTree(1,1) = SRate00;
DiscTree(1,1) = BasePriceProcess(1);


%Write the initial values for the underlyer and the underlyer's volatility
%into the state prices vector
ShortVol(1) = InitialVolatility;
StatePrices(1) = BasePriceProcess(1);


%Calculate the initial short rate after a down jump using initial
%approximations and a dedicated Newton-Ralphson iterative method in one
%variable
%Calculate r20, the down short rate for the first time step, by
%Newton-Raphson in 1 variable
TimeStepNum = 2;
     
SRateN0 = exp(SRate00 .* TreeTimes(TimeStepNum) ./ ...
     TreeTimes(TimeStepNum - 1)) - 1;

SRateN0 = SRateN0 .* exp( - ShortVol(TimeStepNum - 1) .*...
     TFact(TimeStepNum - 1));

SRateN0 = rootfind1(SRateN0, ...
     InitialVolatility, ...
     TimeStepNum, ...
     StatePrices(1 : TimeStepNum), ...
     BasePriceProcess(TimeStepNum),...
     TimeMultMatrix(1 : TimeStepNum, ...
     TimeStepNum - 1),...
     MaxIterations);

%Update the short rate tree
ShortTree(1 : TimeStepNum, TimeStepNum) = SRateN0 .* ...
     exp(InitialVolatility .* TimeMultMatrix(1 : TimeStepNum, ...
     TimeStepNum - 1));

%Update the discount factor tree
DiscTree(1 : TimeStepNum, TimeStepNum) = exp( - ShortTree(1 : ...
     TimeStepNum, TimeStepNum));

%Calculate the resulting jumps in price from the previous state prices
UpTempPrices(2 : TimeStepNum) = 0.5 .* StatePrices(1 : TimeStepNum - 1)...
     .* DiscTree(2 : TimeStepNum, TimeStepNum);

DownTempPrices(1 : TimeStepNum - 1) = 0.5 .* StatePrices(1 : ...
     TimeStepNum - 1) .* ...
     DiscTree(1 : TimeStepNum - 1, TimeStepNum);
     
%Update the state price at the current time step     
StatePrices(1 : TimeStepNum) = UpTempPrices(1 : TimeStepNum)...
     + DownTempPrices(1 : TimeStepNum);

%Update the sup and down state prices from the discount factor tree
UpStatePrices(1) = DiscTree(2, 2);

DownStatePrices(1) = DiscTree(1, 2);
     
     
%Loop through the rest of the time steps and build the short rate and 
%discount factor and evolve the price process using a Bivariate Newton-
%Ralphson approach in two variables to iteratively solve for the down-
%jump in the short rate (up jump in the price of the underlyer) and the
%volatility of the short rate
for (TimeStepNum = 3 : MaxStep)
     
     SRateN0 = exp(ShortTree(1, TimeStepNum - 1) .* TreeTimes(TimeStepNum)...
          ./ TreeTimes(TimeStepNum-1)) - 1;
     
     SRateN0 = SRateN0 .* exp( - ShortVol(TimeStepNum - 1) .* ...
          TFact(TimeStepNum-1));

	ShortVolN0 = ShortVol(TimeStepNum - 2);

	ResOptima = [SRateN0; ShortVolN0];
     
     ResOptima = rootfind2(ResOptima, TimeStepNum, TFact(1), ...
          StatePrices(1 : TimeStepNum - 1), ...
          UpStatePrices(1 : TimeStepNum - 2),...
          DownStatePrices(1 : TimeStepNum - 2), ...
          BasePriceProcess(TimeStepNum),...
          VolatilityProcess(TimeStepNum - 1),...
          TimeMultMatrix(1 : TimeStepNum, TimeStepNum - 1),...
          MaxIterations);
										
	SRateN0 = ResOptima(1);
     
     ShortVolN0 = ResOptima(2);

	ShortVol(TimeStepNum-1) = ShortVolN0;

     ShortTree(1 : TimeStepNum, TimeStepNum) = SRateN0 .* ...
          exp(ShortVolN0 .* TimeMultMatrix(1 : TimeStepNum,...
          TimeStepNum - 1));
     
     DiscTree(1 : TimeStepNum, TimeStepNum) = ...
          exp( - ShortTree(1 : TimeStepNum, TimeStepNum));
   

     %Update the state-prices
     UpTempPrices(2 : TimeStepNum) = 0.5 .* ...
          StatePrices(1 : TimeStepNum - 1) .* ...
          DiscTree(2 : TimeStepNum, TimeStepNum);
     
     DownTempPrices(1 : TimeStepNum - 1) = 0.5 .* ...
          StatePrices(1 : TimeStepNum - 1) .* ...
          DiscTree(1 : TimeStepNum - 1, TimeStepNum);

     StatePrices(1 : TimeStepNum) =...
          UpTempPrices(1 : TimeStepNum) + DownTempPrices(1 : TimeStepNum);

	UpTempPrices(1 : TimeStepNum) = 0 .*UpTempPrices(1:TimeStepNum);
     DownTempPrices(1 : TimeStepNum) = 0 .*DownTempPrices(1:TimeStepNum);

     UpTempPrices(2 : TimeStepNum-1) = 0.5 .* ...
          UpStatePrices(1 : TimeStepNum - 2) .* ...
          DiscTree(3 : TimeStepNum, TimeStepNum);
     
     DownTempPrices(1 : TimeStepNum - 2) = 0.5 .*...
          UpStatePrices(1 : TimeStepNum - 2) .* ...
          DiscTree(2 : TimeStepNum - 1, TimeStepNum);

     UpStatePrices(1 : TimeStepNum - 1) = ...
          UpTempPrices(1 : TimeStepNum - 1) + ...
          DownTempPrices(1 : TimeStepNum - 1);

     UpTempPrices(2 : TimeStepNum - 1) = 0.5 .* ...
          DownStatePrices(1 : TimeStepNum - 2) .* ...
          DiscTree(2 : TimeStepNum - 1, TimeStepNum);
     
     DownTempPrices(1 : TimeStepNum - 2) = 0.5 .* ...
          DownStatePrices(1 : TimeStepNum - 2) .* ...
          DiscTree(1 : TimeStepNum - 2, TimeStepNum);

     DownStatePrices(1 : TimeStepNum - 1) = ...
          UpTempPrices(1 : TimeStepNum - 1) +...
          DownTempPrices(1 : TimeStepNum - 1);
     
end %end for loop


%Build annualized volatilities for the short rate
NumShortVol = length(ShortVol) - 1;

AnnualizedShortVol = ShortVol(1 : NumShortVol) ./ ...
     TFact(2 : NumShortVol + 1);

%Check to make sure that neither the short rate tree nor the
%annualized volatlity vector contain negative rates; if they do return
%an error flag
if (any(find(AnnualizedShortVol < 0)))
     
     TreeErrorFlag = 1;
     
elseif (any(any(find(ShortTree < 0))))
     
     TreeErrorFlag = 1;
          
elseif (size(DiscTree, 2) > 100)
     TreeErrorFlag = 2;
else
     
     TreeErrorFlag = 0;
end


%end of MKPRVTREE function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%             ************* SPECIALIZED SUBROUTINES **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function SRateN0 = rootfind1(SRateN0, InitialVolatlity, TimeStepNum, ...
     StatePrices, BasePrice, TimeFactVect, MaxIterations)
%ROOTFIND1 Dedicated Newton-Raphson Method for Univariate Tree Calibration
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set error tolerance
ErrorTol = 1.0e-5;

%Set the initial rate to the approximation passed in
InitialRate = SRateN0;

%Get the initial value and the first derivative of the objective function
[fx, dfx] = objfeval1(InitialRate, InitialVolatlity, TimeStepNum, ...
     StatePrices, BasePrice, TimeFactVect);

%Set the counter to zero
Count = 0;


%Iterate until root is found or number of max iterations is reached
while ((abs(fx) > ErrorTol) & (Count < MaxIterations))
     
     %Revise the rate
     RevisedRate = InitialRate - fx/dfx;

     [fx, dfx] = objfeval1(RevisedRate, InitialVolatlity, TimeStepNum, ...
          StatePrices, BasePrice, TimeFactVect);
	
     InitialRate = RevisedRate;
     
     %Increment counter
	Count = Count + 1;
end

SRateN0 = InitialRate;

%end of ROOTFIND1 Subroutine




function [fx, dfx] = objfeval1(SRateN0, InitialVolatlity, TimeStepNum, ...
     StatePrices, BasePrice, TimeFactVect)
%OBJEVAL1 Objective Function Evaluation for ROOTFIND1
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VolatlityMult = exp(InitialVolatlity .* TimeFactVect);

ForwardShort = SRateN0 .* VolatlityMult;

DiscFactor = exp( - ForwardShort);


%Compute changes in discount factors
DeltaDisc = - VolatlityMult .* exp( - SRateN0 .* VolatlityMult);

fx = BasePrice - ( 0.5 .* sum( StatePrices .* ...
     (DiscFactor(1 : TimeStepNum - 1) + DiscFactor(2 : TimeStepNum))) );

dfx = - 0.5 .* ( sum(StatePrices .* (DeltaDisc(1 : TimeStepNum - 1) + ...
     DeltaDisc(2 : TimeStepNum))) );

%end of OBJFEVAL1 Subroutine




function ResOptima = rootfind2(ResOptima, TimeStep, TFact, StatePrices, ...
     UpStatePrices, DownStatePrices, TruePrice, TrueVolatility, ...
     TimeMultMatrix, MaxIterations)
%ROOTFIND2 Dedicated Newton-Raphson Method for Bivariate Tree Calibration
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set tolerance for price and volatility
PriceTol = 1.0e-5;
VolatilityTol = 1.0e-5;

InitialRate = ResOptima;

[fx, dfx] = objfeval2(InitialRate, TimeMultMatrix, TimeStep, TFact, ...
StatePrices, UpStatePrices, DownStatePrices, TruePrice, TrueVolatility);

Count=0;

while ( (abs(fx(1)) > PriceTol) | ...
          ((abs(fx(2)) > VolatilityTol) & (Count < MaxIterations)) )
     
	RevisedRate = InitialRate - mldivide(dfx, fx);

	[fx, dfx] = objfeval2(RevisedRate, TimeMultMatrix, TimeStep, TFact, ...
          StatePrices, UpStatePrices, DownStatePrices, TruePrice, ...
          TrueVolatility);
     
     %Revise the initial rate
     InitialRate = RevisedRate;
     
     %Increment counter
     Count = Count+1;
end

ResOptima = InitialRate;

%end of ROOTFIND2 Subroutine



function [fx, Jacobian] = objfeval2(ResOptima, TimeMultMatrix, ...
     NumShortVol, TFact, StatePrices, UpStatePrices, DownStatePrices,...
     TruePrice, TrueVolatility)
%OBJEVAL2 Objective Function Evaluation for ROOTFIND2
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate the errors in matching the zero and zero-volatility curves
fx = zeros(2, 1);

SRateN0 = ResOptima(1);

VolatilityN0 = ResOptima(2);

VolatlityMult = exp(VolatilityN0*TimeMultMatrix);

ForwardShort = SRateN0 .* VolatlityMult;

DiscFactor = exp(-ForwardShort);

fx(1) = TruePrice - 0.5 .* sum( StatePrices .* ...
     (DiscFactor(1 : NumShortVol - 1) + ...
     DiscFactor(2 : NumShortVol)) );

UpPrice = 0.5 .* sum( UpStatePrices .* ...
     (DiscFactor(2 : NumShortVol - 1) + ...
     DiscFactor(3 : NumShortVol)));

DownPrice = 0.5 .* sum( DownStatePrices .* ...
     (DiscFactor(1 : NumShortVol - 2) + ...
     DiscFactor(2 : NumShortVol - 1)));

LogUp = log(UpPrice);

LogDown = log(DownPrice);

fx(2) = TrueVolatility - LogUp ./ LogDown;

%Calculate the jacobian of the errors as a function of short rate and 
%the volatility
Jacobian = zeros(2, 2);

DiffValue1 = - VolatlityMult .* exp( - ForwardShort);

Jacobian(1, 1) = - 0.5 .* sum( StatePrices .*...
     (DiffValue1(1 : NumShortVol - 1) +...
     DiffValue1(2 : NumShortVol)) );

DiffValue2 = exp(VolatilityN0 .* TimeMultMatrix);

ShortVol = - SRateN0 .* TimeMultMatrix;

Jacobian(1, 2) = - 0.5 .* sum( StatePrices .* ...
     (ShortVol(1 : NumShortVol - 1) .*...
     (DiffValue2(1 : NumShortVol - 1)) .*...
     exp( - SRateN0 .* DiffValue2(1 : NumShortVol - 1) ) + ...
     ShortVol(2 : NumShortVol) .* ...
     (DiffValue2(2 : NumShortVol)) .* ...
     exp( - SRateN0 .* DiffValue2(2 : NumShortVol))) );
				     
DLUP = 0.5 .* sum( UpStatePrices .* (DiffValue1(2 : NumShortVol - 1) + ...
     DiffValue1(3 : NumShortVol)) ) ./ UpPrice;

DLDP = 0.5 .* sum( DownStatePrices .* (DiffValue1(1 : NumShortVol - 2) + ...
     DiffValue1(2 : NumShortVol - 1))) ./ DownPrice;

Jacobian(2, 1) = -(LogDown .* DLUP - LogUp .* DLDP) ./ LogDown .^ 2;

DLUP = 0.5 .* sum( UpStatePrices .* ...
     (ShortVol(2 : NumShortVol - 1) .*...
     (DiffValue2(2 : NumShortVol-1)) .*...
     exp( - SRateN0*DiffValue2(2 : NumShortVol - 1)) + ...
     ShortVol(3 : NumShortVol) .* ...
     (DiffValue2(3 : NumShortVol)) .* ...
     exp( - SRateN0 .* DiffValue2(3 : NumShortVol))) ) ./ UpPrice;

DLDP = 0.5 .* sum( DownStatePrices .*...
     (ShortVol(1 : NumShortVol - 2) .* ...
     (DiffValue2(1 : NumShortVol - 2)) .*...
     exp( - SRateN0 .* DiffValue2(1 : NumShortVol - 2)) + ...
     ShortVol(2 : NumShortVol - 1) .*...
     (DiffValue2(2 : NumShortVol - 1)) .* ...
     exp( - SRateN0 .* DiffValue2(2 : NumShortVol-1))) ) ./ DownPrice;

Jacobian(2, 2) = - (LogDown .* DLUP - LogUp .* DLDP) ./ LogDown .^ 2;

%end OBJFEVAL2 Subroutine

