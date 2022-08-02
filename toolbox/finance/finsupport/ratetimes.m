function [Rates, EndTimes, StartTimes] = ratetimes(Compounding, RefRates, RefEndX, RefStartX, EndX, StartX, Settle, Basis, EndMonthRule)
%RATETIMES Change time intervals defining an interest rate environment.
%   Takes an interest rate environment defined by yields over one
%   collection of time intervals, and computes the yields over another
%   set of time intervals.  The zero rate is assumed to be piecewise
%   linear in time.
%
%   Usage 1: 
%     [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%        RefRates, RefEndTimes, RefStartTimes, EndTimes)
%
%     [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%        RefRates, RefEndTimes, RefStartTimes, EndTimes, StartTimes)
%     
%     Optional: RefStartTimes, StartTimes
%
%   Usage 2 : 
%     ValuationDate passed and interval points input as dates.
%     [Rates, EndTimes, StartTimes] = ratetimes(Compounding, ...
%        RefRates, RefEndDates, RefStartDates, EndDates, StartDates, ...
%        ValuationDate)
%
%   Inputs:
%     Compounding - Scalar value representing the frequency at which the
%     input zero rates were compounded when annualized.  This argument
%     determines the formula for the discount factors and interpretation
%     of times as follows:   
%     1) Compounding = 1, 2, 3, 4, 6, 12 = F
%        Disc = (1 + Z/F)^(-T), where F is the compounding frequency,
%        Z is the zero rate, and T is the time in periodic units, i.e. T=F
%        is one year.
%     2) Compounding = 365 
%        Disc = (1 + Z/F)^(-T), where F is the number of days in the
%        basis year and T is a number of days elapsed computed by basis.
%     3) Compounding = -1
%        Disc = exp( -T * Z ), where T is time in years.
%
%     RefRates - NREFPTS by NCURVES matrix of reference rates in decimal
%     form.  RefRates are the yields over investment intervals from
%     RefStartTimes, where the cash flow is valued, to RefEndTimes, where
%     the cash flow is received.  
%
%     Usage 1: When ValuationDate is not passed, the third through sixth
%     arguments are interpreted as times:
%
%     RefEndTimes - NREFPTS by 1 vector or scalar of times in periodic units
%     ending the intervals corresponding to RefRates.
%
%     RefStartTimes - NREFPTS by 1 vector or scalar of times in periodic units
%     starting the intervals corresponding to RefRates.  RefStartTimes is
%     optional and the default value is 0. 
%
%     EndTimes - NPOINTS by 1 vector or scalar of times in periodic units
%     ending the new intervals where rates are desired.
%
%     StartTimes - NPOINTS by 1 vector or scalar of times in periodic units
%     starting the new intervals where rates are desired.  StartTimes is
%     optional and the default value is 0. 
%
%     Usage 2: When ValuationDate is passed, the third through sixth
%     arguments are interpreted as dates.  The ValuationDate is used
%     as the zero point for computing the times:
%
%     RefEndDates - NREFPTS by 1 vector or scalar of serial dates 
%     ending the intervals corresponding to RefRates.
%
%     RefStartDates - NREFPTS by 1 vector or scalar of serial dates 
%     starting the intervals corresponding to RefRates.  RefStartDates is
%     optional and the default value is ValuationDate. 
%
%     EndDates - NPOINTS by 1 vector or scalar of serial dates 
%     ending the new intervals where rates are desired.
%
%     StartDates - NPOINTS by 1 vector or scalar of serial dates 
%     starting the new intervals where rates are desired.  StartDates is
%     optional and the default value is ValuationDate. 
%
%     ValuationDate - scalar value in serial date number form representing the
%     observation date of the investment horizons entered in StartDates and
%     EndDates.  ValuationDate is required in usage 2.  ValuationDate
%     must be omitted or passed as an empty matrix to invoke usage 1. 
%
%   Outputs:
%     Rates - NPOINTS by NCURVES column vector of rates implied by the
%     reference interest rate structure and sampled at new intervals.
% 
%     StartTimes - NPOINTS by 1 column vector of times starting the new
%     intervals where rates are desired, measured in periodic units.  
%
%     EndTimes - NPOINTS by 1 column vector of times ending the new
%     intervals, measured in periodic units.  
%  
%   Notes:
%     If Compounding = 365 (daily), StartTimes and EndTimes are measured in
%     days.  The arguments otherwise contain values, T, computed from SIA
%     semi-annual time factors, Tsemi, by the formula T = Tsemi/2 * F, where
%     F is the compounding frequency.  F is set to 1 for continuous compounding. 
%
%     The investment intervals can be specified either with input times
%     (Usage 1) or with input dates (Usage 2).  Entering the argument,
%     ValuationDate, invokes the date interpretation, with omitting
%     ValuationDate invokes the default time interpretations.
%
%   Examples:
%   1) The reference environment is a collection of zero rates at 6, 12, and
%      24 months.  Create a collection of 1 year forward rates beginning 
%      at 0, 6, and 12 months.
%
%      RefRates = [0.05; 0.06; 0.065];
%      RefEndTimes = [1; 2; 4];
%      StartTimes = [0; 1; 2];
%      EndTimes   = [2; 3; 4];
%      Rates = ratetimes(2, RefRates, RefEndTimes, 0, EndTimes, StartTimes)
%
%   2) Interpolate a zero yield curve to different dates.  Zero curves
%      start at the default date of ValuationDate.
%
%      RefRates = [0.04; 0.05; 0.052];
%      RefDates = [729756; 729907; 730121];
%      Dates    = [730241; 730486];
%      ValuationDate   = 729391;
%      [Rate] = ratetimes(2, RefRates, RefDates, [], Dates, [], ValuationDate)
%
%   See also RATE2DISC, DISC2RATE.

%   Author(s): J. Akao 12/15/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.14 $  $Date: 2002/04/14 21:38:44 $

%------------------------------------------------------------------------
% Checking input arguments
%------------------------------------------------------------------------
if (nargin < 3)
  error('Arguments Compounding, RefRates, and EndTimes are required')
end

% Defaults for market basis
if ( nargin < 9 | isempty(EndMonthRule) | isnan(EndMonthRule(1)) )
  EndMonthRule = 1;
end

if ( nargin < 8 | isempty(Basis) | isnan(Basis(1)) )
  Basis = 0;
end

% Decide if times are in date form or time form
if (nargin < 7 | isempty(Settle) | isnan(Settle(1)) )
  % Interpret RefEndX, RefStartX, EndX, StartX arguments as times
  TimeArgForm = 'times';

else
  % check if settlement is a date string
  if ischar(Settle)
    Settle = datenum(Settle);
  end
  
  % check if settlement is a scalar
  if length(Settle)~=1
    error('Settle must be a single date');
  end

  % Interpret RefEndX, RefStartX, EndX, StartX arguments as times
  TimeArgForm = 'dates';

end

% Collect date/time arguments
if (nargin < 6)
  StartX = [];
end

if (nargin < 5)
  EndX = [];
end

if (nargin < 4)
  RefStartX = [];
end

if isempty(StartX) & strcmp(TimeArgForm,'dates')
    StartX = Settle;
end

if isempty(RefStartX) & strcmp(TimeArgForm,'dates')
    RefStartX = Settle;
end

% Parse size of the rates
[NumRefPts, NumCurves] = size(RefRates);

% Default is semi-annual Compounding 
if isempty(Compounding)
  Compounding=2;
end

% Convert to times from dates if needed
if strcmp(TimeArgForm,'dates')
  StartTimes    = date2time(Settle,    StartX, Compounding,Basis,EndMonthRule);
  EndTimes      = date2time(Settle,      EndX, Compounding,Basis,EndMonthRule);
  RefStartTimes = date2time(Settle, RefStartX, Compounding,Basis,EndMonthRule);
  RefEndTimes   = date2time(Settle,   RefEndX, Compounding,Basis,EndMonthRule);
else
  StartTimes    = StartX;
  EndTimes      = EndX;
  RefStartTimes = RefStartX;
  RefEndTimes   = RefEndX;
end  

%---------------------------------------------------------------------
% Parse Time structures and apply default interpretations
% NumRefPts (scalar) 
% RefStartTimes [NumRefPts x 1]
% RefEndTimes   [NumRefPts x 1]
% 
% NumPts (scalar)
% StartTimes [NumPts x 1]
% EndTimes   [NumPts x 1]
% 
%---------------------------------------------------------------------

% Reference Curve --------------
[mE,nE] = size(RefEndTimes);
if (nE>1)
  error('RefEndTimes argument must be a single column vector');
elseif ( (mE>1) & (mE~=NumRefPts) )
  error('RefEndTimes must have as many points as the RefRate curves');
end

[mS,nS] = size(RefStartTimes);
if (nS>1)
  error('RefEndTimes argument must be a single column vector');
elseif ( (mS>1) & (mS~=NumRefPts) )
  error('RefStartTimes must have as many points as the RefRate curves');
end

% scalar expansion
if mE==1,
  RefEndTimes = RefEndTimes(ones(NumRefPts,1));
end
if mS==1,
  RefStartTimes = RefStartTimes(ones(NumRefPts,1));
end

% Empty expansion
if isempty(RefEndTimes)
  % Unit forward curve
  RefEndTimes = RefStartTimes + 1;
end
if isempty(RefStartTimes)
  % zero curve
  RefStartTimes = zeros(NumRefPts,1);
end

% Output Curve ----------------
[mE,nE] = size(EndTimes);
if (nE>1)
  error('EndTimes argument must be a single column vector');
end
[mS,nS] = size(StartTimes);
if (nS>1)
  error('EndTimes argument must be a single column vector');
end
NumPts = max(mE,mS);

% scalar expansion
if mE==1,
  EndTimes = EndTimes(ones(NumPts,1));
end
if mS==1,
  StartTimes = StartTimes(ones(NumPts,1));
end

% Empty expansion
% if both are empty, output zero curve to BreakTimes
if isempty(EndTimes) & isempty(StartTimes)
  % substitute in BreakTimes later
  NumPts = 0;
elseif isempty(EndTimes)
  % Unit forward curve
  EndTimes = StartTimes + 1;
elseif isempty(StartTimes)
  % zero curve
  StartTimes = zeros(NumPts,1);
end

% Finally, return if there is nothing to do
if length(StartTimes) == length(RefStartTimes) & ...
   length(EndTimes) == length(RefEndTimes)     & ...
        all(StartTimes == RefStartTimes)       & ...
        all(EndTimes == RefEndTimes)
  Rates = RefRates;
  return
end

%---------------------------------------------------------------------
% -------------------- Computational section -------------------------
%---------------------------------------------------------------------

%---------------------------------------------------------------------
% Create the zero time structure to be interpolated
%
% Inputs:
%  Compounding   [scalar]
%  RefEndTimes   [NumRefPts x 1]
%  RefStartTimes [NumRefPts x 1]
%  RefRates      [NumRefPts x NumCurves]
%
% Outputs: zero curve structure
%  BreakTimes    [NumBrkPts x 1]
%  BreakRates    [NumRefPts x NumCurves]
%
% Variables
%  RefLogDisc    [NumRefPts x NumCurves]
%  BrkLogDisc    [NumBrkPts x NumCurves]
%
%  StartLoc      [NumRefPts x 1] index of starting times in BreakTimes
%  EndLoc        [NumRefPts x 1] index of ending times in BreakTimes
%---------------------------------------------------------------------

if all(RefStartTimes==0)
  % Input curve was already a zero curve
  BreakTimes = RefEndTimes;
  BreakRates = RefRates;
else
  % find the break points between time intervals
  [BreakTimes,I,J] = unique([RefStartTimes; RefEndTimes]);
  StartLoc = J(1:NumRefPts);
  EndLoc   = J(NumRefPts+1:end);
  NumBrkPts = length(BreakTimes);
  
  % create equations for each quoted rate
  % log( disc[start to end] ) = log( disc[0 to end] ) - log( disc[0 to start] )
  % Aeq * BrkLogDisc = RefLogDisc
  Aeq = zeros(NumRefPts, NumBrkPts);
  
  % Ending locations (i,EndLoc(i)) get a 1
  Aeq( (1:NumRefPts)' + NumRefPts*(EndLoc-1) ) = 1;
  
  % Starting locations (i,StartLoc(i)) get a -1
  Aeq( (1:NumRefPts)' + NumRefPts*(StartLoc-1) ) = -1;
  
  % Right hand side, 1 column for each curve
  RefLogDisc = log(rate2disc(Compounding,RefRates,RefEndTimes,RefStartTimes));
  beq = RefLogDisc;
  
  % Create an equation for time zero
  % 0 = log( disc[0 to 0] )
  if any(BreakTimes==0)
    Azero = zeros(1,NumBrkPts);
    Azero(BreakTimes==0) = 1;
    bzero = zeros(1,NumCurves);
    
    Aeq = [Azero; Aeq];
    beq = [bzero; beq];
  end
  
  % Handle situations where the input timeset does not uniquely define
  % the break zero curve structure.  That is, the rank of Aeq is less
  % than NumBrkPts.
  
  % For now, assume the matrix has full rank if there are enough rows.
  if ( size(Aeq,1) >= NumBrkPts )
    % Solve the linear equations to get BrkLogDisc
    % Aeq * BrkLogDisc = beq

    BrkLogDisc = Aeq \ beq;
    % This could be overdetermined, but it would be solved in the least
    % squares sense.  Type "help mldivide"
    
  else
    % If the equalities are underdetermined, add additional conditions
    % that interior points interpolate their neighbors. 

    % dTi(i) = 1/( BreakTimes(i+1) - BreakTimes(i) );
    dTi = 1./diff(BreakTimes);
    dTi(end+1,1) = NaN; % pad for convenience

    %  Ti(i) = 1/BreakTimes(i)
    Ti = BreakTimes;
    Ti(BreakTimes==0) = NaN;
    Ti = 1./Ti;
    
    % left endpoint (diagonal before cutting)
    Ai0 = -dTi.*Ti;
    
    % interpolated point (first diagonal before cutting)
    Ai1 = (dTi(1:end-1) + dTi(2:end)).*Ti(2:end);
    
    % right endpoint (second diagonal before cutting)
    Ai2 = -dTi(2:end-1).*Ti(3:end);
    
    % build equations
    C = diag(Ai0,0) + diag(Ai1,1) + diag(Ai2,2);

    % The last two equations don't have all three points
    % They use dTi(end) = NaN
    % Also kill any equation with BreakTimes = 0 points (Ti=NaN)
    C = C(all(~isnan(C),2),:);

    % Remaining interpolation equations are C*BrkLogDisc = d = 0
    d = zeros(size(C,1),1);

    % try to fit the interpolation conditions while remaining true to the
    % original rates defined by Aeq, beq.
    LSQLINopts = optimset('Display','off','LargeScale', 'off');

    BrkLogDisc = zeros(NumBrkPts, NumCurves);
    for j = 1:NumCurves
      [BrkLogDisc(:,j), ResNorm, Residual, ExitStatus] = ...
          lsqlin(C,d, [],[], Aeq, beq(:,j), [], [], [], LSQLINopts );
    end
    
  end
  
  % Cull the meaningless rate at time zero.
  BrkLogDisc = BrkLogDisc( BreakTimes~= 0, :);
  BreakTimes = BreakTimes( BreakTimes~= 0 );
  
  % Convert to zero rates to support interpolation
  BreakRates = disc2rate(Compounding, exp(BrkLogDisc), BreakTimes);
  
end

%---------------------------------------------------------------------
% Interpolate the zero rates to the starting and ending times
%  EndRates   [NumPts x NumCurves] : zero rates to ending times
%  StartRates [NumPts x NumCurves] : zero rates to the starting times
%---------------------------------------------------------------------

% If the starting and ending times were not entered, use 0 to BreakTimes
if ( isempty(StartTimes) & isempty(EndTimes) )
  EndTimes = BreakTimes;
  NumPts = length(EndTimes);
  StartTimes = zeros(NumPts, 1);
end

% Interpolate or constant extrapolate the Ending rates
MaskMin = ( EndTimes <= BreakTimes(1) );
MaskMax = ( EndTimes >= BreakTimes(end) );
MaskInt = ~( MaskMin | MaskMax );

EndRates = zeros( NumPts, NumCurves );
if any(MaskMin)
  EndRates(MaskMin, :) = BreakRates( 1 *ones(sum(MaskMin),1), :);
end
if any(MaskMax)
  EndRates(MaskMax, :) = BreakRates(end*ones(sum(MaskMax),1), :);
end
if any(MaskInt)
  EndRates(MaskInt, :) = interp1q(BreakTimes, BreakRates, EndTimes(MaskInt));
end

% Interpolate or constant extrapolate the Starting rates
MaskMin = ( StartTimes <= BreakTimes(1) );
MaskMax = ( StartTimes >= BreakTimes(end) );
MaskInt = ~( MaskMin | MaskMax );

StartRates = zeros( NumPts, NumCurves );
if any(MaskMin)
  StartRates(MaskMin, :) = BreakRates( 1 *ones(sum(MaskMin),1), :);
end
if any(MaskMax)
  StartRates(MaskMax, :) = BreakRates(end*ones(sum(MaskMax),1), :);
end
if any(MaskInt)
  StartRates(MaskInt, :) = interp1q(BreakTimes,BreakRates,StartTimes(MaskInt));
end

%---------------------------------------------------------------------
% Create the output rates
% Zero rates are already computed
% Forward rates must be divided through the discount factors
%
% StartRates [NumPts x NumCurves]
% EndRates   [NumPts x NumCurves]
%
% Rates      [NumPts x NumCurves]
%
% EndDisc    [NumFwd x NumCurves]
% StartDisc  [NumFwd x NumCurves]
% Disc       [NumFwd x NumCurves]
%---------------------------------------------------------------------
Rates = zeros( NumPts, NumCurves );

MaskZero = ( StartTimes == 0 );
MaskFwd  = ~MaskZero;

% For zeros, read in the ending zero rates
Rates( MaskZero, : ) = EndRates( MaskZero, : );

% Otherwise, compute StartDisc and EndDisc
% The discount over the forward interval is EndDisc/StartDisc
if any(MaskFwd)
  % Change starting and ending zero rates to discount form
  EndDisc   = rate2disc(Compounding,  EndRates(MaskFwd,:),  EndTimes(MaskFwd));
  StartDisc = rate2disc(Compounding,StartRates(MaskFwd,:),StartTimes(MaskFwd));
  
  % Compute the discount over the specified interval [StartTimes, EndTimes]
  Disc = EndDisc ./ StartDisc;
  
  % Quote back as rates
  Rates( MaskFwd, : ) = disc2rate(Compounding, Disc, ...
      EndTimes(MaskFwd), StartTimes(MaskFwd));
end

return

%---------------------------------------------------------------------
%---------------------------------------------------------------------
  
