function [InterpVolRates, OriginalVolatilityTimes] = ...
     volinterp(VolatilityRates, VolatilityTimes, InterpTimes,...
     ZeroDate, Basis, EndMonthRule, InterpMethod)
%VOLINTERP Interpolated Zero Volatility Curve from Volatility Curve
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.7 $   $Date: 2002/04/14 21:47:29 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments in and set defaults
if (nargin < 7)
     InterpMethod = 'linear';
end

if (nargin < 6)
     EndMonthRule = 1;
end

if (nargin < 5)
     Basis = 0;
end

if (nargin < 4)
     error('Too few input arguments specified!')
end


%Check to make sure that the volatility rates and curve dates vectors have
%the same number of elements
NumVolRates = length(VolatilityRates);

NumVolDates = length(VolatilityTimes);

if (NumVolRates ~= NumVolDates)
     error('VolatilityRates and VolatilityTimes must have the same number of elemtnets!')
end


%Check the zero date parameter
if (length(ZeroDate) > 1)
     error('Zero date must be a scalar argument!')
end

if (ischar(ZeroDate))
     ZeroDate = datenum(ZeroDate);
end


%Check the validity of the other input parameters
if (any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3))
     error('Invalid bond basis specified!')
end

if (any(EndMonthRule ~= 0 & EndMonthRule ~= 1))
     error('Invalid end of month rule flag specified!')
end


%Parse the interpolation method specified
InterpMethod  = lower(InterpMethod);

if (~any(strcmp(InterpMethod, 'nearest') | strcmp(InterpMethod, 'linear')...
          | strcmp(InterpMethod, 'spline') | strcmp(InterpMethod, 'cubic')))
     error('Invalid interpolation method specified!')
end



VolatilityRates = VolatilityRates(:);
VolatilityTimes = VolatilityTimes(:);
InterpTimes = InterpTimes(:);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%               ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Parse the curve dates vector
if (any(VolatilityTimes < ZeroDate))
     %Find all curve dates greater than the zero date
     VolatilityTimes = VolatilityTimes(  min(find(VolatilityTimes >= ZeroDate)) : ...
          NumVolDates  );
     
     %Change the vector of volatility rates to match any changes to the
     %vector of curve dates
     VolatilityRates = VolatilityRates(  min(find(VolatilityTimes >=...
          ZeroDate)) : NumVolDates  );
end


%Check to see if volatility times are dates; calculate the time factors 
%if necessary
if (VolatilityTimes(1, 1) > datenum('01-Jan-1800'));
     
     VolTFactors = tmfactor(ZeroDate, VolatilityTimes);

end

OriginalVolatilityTimes = VolatilityTimes;


%Check to see if the first time factor is zero; if it is not, then append
%the vector and make the corresponding change to the volatility rates
%vector
if (VolTFactors(1, 1) ~= 0)
     
     VolTFactors = [0; VolTFactors];
     
     VolatilityRates = [VolatilityRates(1, 1); VolatilityRates];
     
     NumVolRates = NumVolRates + 1;
     
     NumVolDates = NumVolDates + 1;
end


%Check to see if the last time factor is less than the last time factor
%specified for the horizon; if it is, then append the vector and make the
%corresponding change to the volatility rates vector
NumHorizonTimes = length(InterpTimes);

if (VolTFactors(NumVolRates, 1) < InterpTimes(NumHorizonTimes, 1))
     
     VolTFactors = [VolTFactors; InterpTimes(NumHorizonTimes, 1)];
     
     VolatilityRates = [VolatilityRates; VolatilityRates(NumVolRates, 1)];
end


%Check to see if the first value in the horizon time factor vector is zero;
%if it is, remove it
if (InterpTimes(1, 1) == 0)
     WorkingInterpTimes = InterpTimes(2 : NumHorizonTimes);
else
     WorkingInterpTimes = InterpTimes;
end

%Make sure that you pass on only unique zero time factors for interpolation
[UniqueVolTFactors, UniqueInd] = unique(VolTFactors);
UniqueVolatilityRates = VolatilityRates(UniqueInd);


%Interpolate to get volatility rates for each time step spanning the
%investment horizon
InterpVolRates = interp1(UniqueVolTFactors, UniqueVolatilityRates, ...
     InterpTimes, InterpMethod);

%end of VOLINTERP function
