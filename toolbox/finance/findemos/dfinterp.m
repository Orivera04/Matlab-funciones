function [DiscRates, DiscTFactors, ZeroRates, ZeroTFactors, CurveDates] = ...
     dfinterp(ZeroCurve, HorizonTimes, TimeZeroDate, InterpMethod, ...
     InputCompounding, InputBasis, InputEndMonthRule)
%DFINTERP Interpolated Discount Factors Given Time Horizon and Yield Curve
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:47:26 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments passed in and set defaults
if (nargin < 2)
     error('Too few input arguments specified!')
end

if ((nargin < 4) | isempty(InterpMethod))
     InterpMethod = 'linear';
end

if (nargin < 5)
     InputCompounding = 2;
end

if (nargin < 6)
     InputBasis = 0;
end

if (nargin < 7)
     InputEndMonthRule = 1;
end

if ((nargin >= 3) & ~isempty(TimeZeroDate))
     TimeZeroFlag = 1;
else
     TimeZeroFlag = 0;
end

if (TimeZeroFlag == 0)     
     TimeZeroDate = [];
end

%Check the zero date parameter
if (TimeZeroFlag)
     
     %Convert date to serial date number if necessary
     if (ischar(TimeZeroDate))
          TimeZeroDate = datenum(TimeZeroDate);
     end
     
     if (length(TimeZeroDate) > 1)
          error('Zero date must be a scalar argument!')
     end
end


%Parse the interpolation method specified
InterpMethod  = lower(InterpMethod);

if (~any(strcmp(InterpMethod, 'nearest') | strcmp(InterpMethod, 'linear')...
          | strcmp(InterpMethod, 'spline') | strcmp(InterpMethod, 'cubic')))
     error('Invalid interpolation method specified!')
end


%Pack all input arguments into column vectors for processing
HorizonTimes = HorizonTimes(:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%               ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Unpack the input zero curve and create time factors if necessary
if (isa(ZeroCurve, 'struct'))
     
     %Check the input zero curve
     ZeroCurve = checkzerocrv(ZeroCurve);
          
     ZeroTFactorFlag = 1;
     
     ZeroRates = ZeroCurve.ZeroRates;
     ZeroRates = ZeroRates(:);
     CurveDates = ZeroCurve.CurveDates;
     CurveDates = CurveDates(:);
     InputCompounding = ZeroCurve.Compounding;
     InputBasis = ZeroCurve.Basis;
     InputEndMonthRule = ZeroCurve.EndMonthRule;
elseif (isa(ZeroCurve, 'double'))
     ZeroCurveSize = size(ZeroCurve, 2);
     if (ZeroCurveSize ~= 2 & ZeroCurveSize ~=3)
          error('If ZeroCurve is numeric it must be a N*2 matrix!')
     elseif (ZeroCurveSize == 3)
          ZeroTFactorFlag = 0;
          ZeroRates = ZeroCurve(:, 1);
          CurveDates = ZeroCurve(:, 2);
          ZeroTFactors = ZeroCurve(:, 3);
     elseif(ZeroCurveSize == 2)
          ZeroTFactorFlag = 1;
          ZeroRates = ZeroCurve(:, 1);
          CurveDates = ZeroCurve(:, 2);
     end
else
     error('ZeroCurve must be a structure or numeric matrix!')     
end



%Store the original zero curve
OriginalZeroRates = ZeroRates;
OriginalCurveDates = CurveDates;


%Find time factors if necessary
if (ZeroTFactorFlag)

     %Covert the zero curve dates into time factors
     ZeroTFactors = tmfactor(TimeZeroDate, CurveDates);
end

%Store the original TFactors
OriginalZeroTFactors = ZeroTFactors;


%Get the number of curve dates passed in
NumCurveDates = length(CurveDates);

%Get the number of zero rates passed in
NumZeroRates = length(ZeroRates);

%Make sure the number of zero rates and the number of curve dates is the
%same
if (NumCurveDates ~= NumZeroRates)
     error('The number of zero rates must match the number of curve dates!')
end


%Check to see if a time zero date has been passed in; if not, set the
%time zero date equal to the first date in curve dates
if (TimeZeroFlag == 0)
     TimeZeroDate = CurveDates(1, 1);
end

%Check to see if any dates in curve dates preceed the time zero date; if so,
%truncate the curve at the time zero date
if (CurveDates(1, 1) < TimeZeroDate)
     
     %Find the first date that is greater than or equal to the time zero 
     %date
     Ind = min(find(CurveDates >= TimeZeroDate));
     CurveDates = CurveDates(Ind : NumZeroRates, :);
     ZeroRates = ZeroRates(Ind : NumZeroRates, :);
end


%Get the number of times specified over the horizon
NumHrznTimes = length(HorizonTimes);

%Get the last time factor
MatTimeFactor = HorizonTimes(NumHrznTimes);


%Check to see if the last zero time factor is greater than or equal to the
%maturity time factor
if (ZeroTFactors(NumZeroRates) < MatTimeFactor)
     
     %Linearly interpolate and add a zero rate and date to the end of the
     %zero curve to make it the correct length
     
     %Preallocate temporary storage vectors, making them one element larger
     TempZeroTF = zeros(NumZeroRates + 1, 1);
     TempZeroRates = TempZeroTF;
     
     TempZeroTF(1 : NumZeroRates, :) = ZeroTFactors(1: NumZeroRates, :);
     
     TempZeroRates(1 : NumZeroRates, :) = ZeroRates(1 : NumZeroRates, :);
     
     TempZeroTF(NumZeroRates + 1, 1) = MatTimeFactor;
     
     %Linearly interpolate the last zero rate
     TempZeroRates(NumZeroRates + 1, 1) = TempZeroRates(NumZeroRates, 1);
     
     %Write the new zero curve back to the original variables
     ZeroRates = TempZeroRates;
     
     ZeroTFactors = TempZeroTF;
     
     %Get the new number of zero rates
     NumZeroRates = length(ZeroRates);
end


%Preallocate the working and output variables
WorkingRates = zeros(NumZeroRates, 1);
DiscRates = WorkingRates;
DiscDates = DiscRates;


%Covert the zero rates to discount factors based on the compounding
%frequency specified
if (InputCompounding == -1)
     
     %Continuous compounding
     WorkingRates = exp(-ZeroTFactors .* ZeroRates);
     
else
     %Discrete compounding
     WorkingRates = (1 + ZeroRates/InputCompounding).^...
          (-ZeroTFactors);
end


%Check to see if the first discount factor is 1 (at time zero); if it is
%not then append both vectors as necessary
if (ZeroTFactors(1, 1) ~= 0 | WorkingRates(1, 1) ~= 1)
     
     WorkingRates = [1; WorkingRates];
     
     ZeroTFactors = [0; ZeroTFactors];
end


%Use the interpolation method specified to find the discount factors which
%correspond to the time factors specified across the horizon

%Convert back to simple periodic rates for interpolation purposes
WorkingRates = -log(WorkingRates);


%Make sure that you pass on only unique zero time factors for interpolation
[UniqueZeroTFactors, UniqueInd] = unique(ZeroTFactors);
UniqueWorkingRates = WorkingRates(UniqueInd);


%Interpolate to find the the rates
InterpWorkingRates = interp1(UniqueZeroTFactors, UniqueWorkingRates, ...
     HorizonTimes, InterpMethod);


%Convert back to discount factors and assign to output variable
DiscRates = exp(-InterpWorkingRates);

DiscTFactors = HorizonTimes;

ZeroRates = OriginalZeroRates;
CurveDates = OriginalCurveDates;
ZeroTFactors = OriginalZeroTFactors;

%end of DFINTERP function



