function [FwdProbCurve, CumProbCurve] = dfltprob(DiscRates, RiskyDiscRates)
%DFLTPROB  Cumulative and Forward Default Probability Curves
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:47:35 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments in
if (nargin < 2)
     error('Too few input arguemtns specified!')
end

%Check to see of both curves are of the same length
if length(DiscRates) ~= length(RiskyDiscRates)
     error('The default-free and risky discount curves must be of the same length.')
end


DiscRates = DiscRates(:);
RiskyDiscRates = RiskyDiscRates(:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%               ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Get the number of default free discount rates
NumDiscRates = length(DiscRates);


%Calculate the cumulative default probability curve
CumProbCurve = 1 - (RiskyDiscRates./DiscRates);


%Calculate the forward default probability curve
if (NumDiscRates > 1)
     
     DenominatorFunction = DiscRates(2 : NumDiscRates) ./ ...
          DiscRates(1 : NumDiscRates - 1);
     
     NumeratorFunction = RiskyDiscRates(2 : NumDiscRates) ./ ...
          RiskyDiscRates(1 : NumDiscRates - 1);
     
     FwdProbCurve = 1 - (NumeratorFunction ./ DenominatorFunction);
else
     %Initially set the forward default probability curve to an empty matrix
     FwdProbCurve = [];
end

FwdProbCurve = [CumProbCurve(1); FwdProbCurve];

