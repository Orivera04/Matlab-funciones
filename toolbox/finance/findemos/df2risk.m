function [RiskyDiscRates, RiskyDiscTFactors, CreditRates, CreditTFactors,...
     CreditCurveDates] = df2risk(DiscRates, DiscTFactors,...
     CreditCurve, InterpMethod, CreditCompounding, CreditBasis, ...
     CreditEndMonthRule)
%DF2RISK Risk-Adjusted Discount Factors Given Discount Curve and Spread
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.8 $   $Date: 2002/04/14 21:47:32 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 3)
     error('Too few input arguments specified!')
end

%Check to see if a credit spread has been passed in
if (isempty(CreditCurve))
     RiskyDiscRates = DiscRates;
     RiskyDiscTFactors = DiscTFactors;     
     return
end

if (nargin < 4)
     InterpMethod = 'linear';
end

if (nargin < 5)
     CreditCompounding = 2;
end

if (nargin < 6)
     CreditBasis = 0;
end

if (nargin < 7)
     CreditEndMonthRule = 1;
end

if (isempty(CreditCompounding))
     CreditCompounding = 2;
end

if (isempty(CreditBasis))
     CreditBasis = 0;
end

if (isempty(CreditEndMonthRule))
     CreditEndMonthRule = 1;
end


%Make sure specified parameters are valid
if (any(CreditCompounding ~= 1 & CreditCompounding ~= 2 &...
     CreditCompounding ~= 3 & CreditCompounding ~= 4 &...
     CreditCompounding ~=6 & CreditCompounding ~= 12 &...
     CreditCompounding ~= -1))
     error('Invalid credit spread compounding frequency specified!')
end

if (any(CreditBasis ~= 0 & CreditBasis ~= 1 & CreditBasis ~= 2 &...
          CreditBasis ~= 3))
     error('Invalid credit basis specified')
end

if (any(CreditEndMonthRule ~= 0 & CreditEndMonthRule ~= 1))
     error('Invalid credit end of month rule specified!')
end


%Parse the interpolation method specified
InterpMethod  = lower(InterpMethod);

if (~any(strcmp(InterpMethod, 'nearest') | strcmp(InterpMethod, 'linear')...
          | strcmp(InterpMethod, 'spline') | strcmp(InterpMethod, 'cubic')))
     error('Invalid interpolation method specified!')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%               ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Unpack the input credit curve and create time factors if necessary
CreditTFactorFlag = 0;
if (isa(CreditCurve, 'struct'))
     
     %Check the input zero curve
     CreditCurve = checkcreditcrv(CreditCurve);
     
     CreditRates = CreditCurve.CreditRates;
     CreditRates = CreditRates(:);
     CreditCurveDates = CreditCurve.CurveDates;
     CreditCurveDates = CreditCurveDates(:);
     CreditCompounding = CreditCurve.Compounding;
     CreditBasis = CreditCurve.Basis;
     CreditEndMonthRule = CreditCurve.EndMonthRule;
     
     %Check to see if only a scalar credit spread is specified within the
     %structure
     if (length(CreditRates) == 1)
          
          %Do scalar expansion on the credit spread and use the discount
          %curve time factors
          CreditRates = CreditRates .* ones(size(DiscRates));
          CreditTFactors = DiscTFactors;
     else
          
          %If the credit spreads are not scalar check to see if an
          %appropriately size curve dates vector has also been passed or
          %if the number of credit spreads matched the number of discount
          %factors passed in
          if (~isempty(CreditCurveDates))
               
               %Set a flag indicating that time factor must be calculated
               CreditTFactorFlag = 1;
               
               if (length(CreditRates) ~= length(CreditCurveDates))
                    
                    error('If both credit rates and credit curve dates are specified they must contain the same number of rates!')
               end
               
          else
               if (length(CreditRates) == length(DiscRates))
                    
                    CreditTFactors = DiscTFactors;
               else
                    
                    error('Curve dates cannot be empty when an an arbitrary credit curve has been specified!')
               end
          end
     end     
     
elseif (isa(CreditCurve, 'double'))
     
     CreditCurveSize = size(CreditCurve, 2);
     
     if (CreditCurveSize > 2)
          
          error('If CreditCurve is numeric it must be a N*2 matrix!')
                    
     elseif (CreditCurveSize == 2)
          
          CreditTFactorFlag = 0;
          
          CreditRates = CreditCurve(:, 1);
          CreditTFactors = CreditCurve(:, 2);
                    
     elseif (CreditCurveSize == 1)
          
          %Check to see if the credit spread is empty or zero; if it is, 
          %return the input disc rates
          if ((isempty(CreditRates)) | (CreditRates == 0))
     
            RiskyDiscRates = DiscRates;
            RiskyDiscTFactors = DiscTFactors;
            return
          end
          
          CreditRates = CreditCurve;
          CreditTFactors = DiscTFactors;
          CreditRates = CreditRates .* DiscRates;
     end
else
     error('CreditCurve must be a structure or numeric matrix!')     
end


%Calculate the time factors for the credit curve if necessary
if (CreditTFactorFlag)
     
     CreditTFactors = tmfactor(CreditCurveDates(1,1), CreditCurveDates);
end


%Make sure the number of elements in the credit spread vector now matches
%the number of elements in the credit spread time factor vector; regardless
%of whether the credit curve is arbitrary, the number of elements in each
%vector must now be the same
NumCreditSpreads = length(CreditRates);
NumCreditTFactors = length(CreditTFactors);
if (~isempty(CreditTFactors))

     if (NumCreditSpreads ~= NumCreditTFactors)
     
          error('With arbitrary credit spread curve, dates corresonding to each credit spread must be specified!')
          
     end
end


%Make sure that the credit spread curve spans the time horizon
FirstCreditTF = CreditTFactors(1, 1);
FirstDiscTF = DiscTFactors(1, 1);

if (FirstCreditTF ~= 0)
     
     CreditTFactors = [0; CreditTFactors];
     CreditRates = [CreditRates(1, 1); CreditRates];
end


%Check if the last credit time factor is less than the last discount time
%factor; if it is, then add the last discount time factor to the credit
%time factor vector
LastCreditTF = CreditTFactors(end, 1);
LastDiscTF = DiscTFactors(end, 1);

if (LastCreditTF < LastDiscTF)
     
     CreditTFactors = [CreditTFactors; LastDiscTF];   
     CreditRates = [CreditRates; CreditRates(end, 1)];
end


%Convert the discount factors to annualized zero rates compounded with
%the credit compounding as the frequency

%Check to see if a "0" time factor has been specified; if one has
%remove it to avoid a divide by zero error
InitDiscTFFlag = 0;
if (DiscTFactors(1, 1) == 0)
     
     WorkingDiscRates = DiscRates(2 : end, 1);
     WorkingDiscTFactors = DiscTFactors(2 : end, 1);
     WorkingCreditRates = CreditRates;
     WorkingCreditTFactors = CreditTFactors;
else
     
     WorkingDiscRates = DiscRates;
     WorkingDiscTFactors = DiscTFactors;
     WorkingCreditTFactors = CreditTFactors;
end


%Convert discount factors to zero rates for interpolation  
if (CreditCompounding == -1)
     %Continuous compounding
     ZeroRates = -log(WorkingDiscRates) ./ (WorkingDiscTFactors ...
          ./ CreditCompounding);
else
     %Discrete compounding
     ZeroRates = (WorkingDiscRates .^ (-1 ./ ...
          (WorkingDiscTFactors)) - 1) .* CreditCompounding;
end

OriginalWorkingDiscRates = WorkingDiscRates;

%Interpolate credit rates
[UWorkingCreditTFactors, UniqueInd] = unique(WorkingCreditTFactors);
UWorkingCreditSpread = WorkingCreditRates(UniqueInd);

%Interpolate to find the missing credit spreads
InterpCreditSpreads = interp1(UWorkingCreditTFactors,...
     UWorkingCreditSpread, WorkingDiscTFactors, InterpMethod);

UpZeroRates = ZeroRates + (InterpCreditSpreads ./ 10000);


%Convert the risk adjusted zero rates back to discount factors
if (CreditCompounding == -1)
     %Continuous compounding
     WorkingDiscRates = exp(-UpZeroRates .* (WorkingDiscTFactors ./...
          CreditCompounding));
else
     %Discrete compounding
     WorkingDiscRates = (1 + UpZeroRates ./ CreditCompounding) .^ ...
          (-WorkingDiscTFactors);
end


%Fix the initial discount factor and time factor if necessary
if (WorkingDiscRates(1, 1) ~= 1)
     WorkingDiscRates = [1; WorkingDiscRates];
     WorkingDiscTFactors = [0; WorkingDiscTFactors];
end


RiskyDiscRates = WorkingDiscRates;
RiskyDiscTFactors = WorkingDiscTFactors;

%end of DF2RISK function

