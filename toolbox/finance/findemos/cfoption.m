function [CallSPrices, PutSPrices] = cfoption(InputBond, InterpDates)
%CFOPTION Strike Price Vectors Spanning Tree for Interest Rate Options
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Author(s): C. Bassignani, 04-198 
%              J. Akao        05/14/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.7 $   $Date: 2002/04/14 21:47:23 $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%             ************* CHECK INPUTS **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of arguments in
if (nargin < 2)
     error('Too few input arguments!')
end

InterpDates = InterpDates(:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%             ************* GENERATE OUTPUTS **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Check the input bond structure
InputBond = checkbond(InputBond);


%Unpack the input bond structure as needed
CallType       = InputBond.CallType;
CallStrike     = InputBond.CallStrike;
CallStartDate  = InputBond.CallStartDate;
CallExpiryDate = InputBond.CallExpiryDate;

PutType       = InputBond.PutType;
PutStrike     = InputBond.PutStrike;
PutStartDate  = InputBond.PutStartDate;
PutExpiryDate = InputBond.PutExpiryDate;

% Default of no options
CallSPrices =  Inf*ones(size(InterpDates));
 PutSPrices = -Inf*ones(size(InterpDates));
 
% if a call option is specified, place the strikes in the vector 
if (~isempty(CallType))
     OptInd = (CallStartDate <= InterpDates) & (InterpDates <= CallExpiryDate);

     if (~any(OptInd))
          warning(['No tree nodes fall in the callability period' ...
                   ' specified']);
     end

     CallSPrices( OptInd ) = CallStrike;
end

% if a put option is specified, place the strikes in the vector 
if (~isempty(PutType))
     OptInd = (PutStartDate <= InterpDates) & (InterpDates <= PutExpiryDate);

     if (~any(OptInd))
          warning(['No tree nodes fall in the putability period' ...
                   ' specified']);
     end

     PutSPrices( OptInd ) = PutStrike;
end


%end of CFOPTION function
