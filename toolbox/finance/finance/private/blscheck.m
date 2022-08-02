function messageStructure = blscheck(Function,Price,Strike,Rate,Time,Volatility,DividendYield) 
%BLSCHECK Black-Scholes input argument checking.
%   Check user-specified input arguments common to the Black-Scholes
%   option modeling suite of functions in the Financial Toolbox. If 
%   errors are found, format and return an error message structure. If
%   no errors are found, return an empty error message structure. For 
%   simplicity, all input arguments are required, and an empty 
%   matrix indicates that a particular Black-Scholes parameter is
%   irrelevant and is not checked for errors. This is a private function
%   and is not intended for public use.
%
%   MessageStructure = blscheck(Function, Price, Strike, Rate, Time, ...
%     Volatility, DividendYield)
%
% Inputs:
%   Function - A character string containing the name of the function that
%     called BLSCHECK and whose inputs are checked for errors. This string
%     is placed into the output error message for additional information 
%     in the event an error occurred.
%
%   Price - Prices of the underlying assets.
%
%   Strike - Strike prices of the options.
%
%   Rate - Risk free rates over the investment horizon.
%
%   Time - Times to expiration of the options.
%
%   Volatility - Volatilities of the underlying assets.
%
%   DividendYield - Dividend yields of the underlying assets.
%
% Output:
%   MessageStructure - A MATLAB message identifier structure with fields
%     'identifier' and 'message'. If errors are found, this structure
%     will identify and summarize the error; if no errors are found, this 
%     will be an empty identifier structure.
%
% See also BLSPRICE, BLSIMPV, BLSDELTA, BLSGAMMA, BLSLAMBDA, 
%   BLSTHETA, BLSRHO.

% Copyright 1999-2003 The MathWorks, Inc.   
% $Revision: 1.1.6.1 $   $Date: 2004/01/08 03:06:19 $

%
% Initialize the message structure.
%

messageStructure.message    = '';  
messageStructure.identifier = '';

if ~isempty(Price) && any(Price(:) < 0)
   messageStructure.identifier = ['Finance:' Function ':NegativeValue'];
			messageStructure.message    =  'Underlying asset prices cannot be negative.';
   return
end
if ~isempty(Strike) && any(Strike(:) < 0)
   messageStructure.identifier = ['Finance:' Function ':NegativeValue'];
			messageStructure.message    =  'Strike prices cannot be negative.';
   return
end
if ~isempty(Rate) && any(Rate(:) < 0)
   messageStructure.identifier = ['Finance:' Function ':NegativeValue'];
			messageStructure.message    =  'Risk free rates cannot be negative.';
   return
end
if ~isempty(Time) && any(Time(:) < 0)
   messageStructure.identifier = ['Finance:' Function ':NegativeValue'];
   messageStructure.message    =  'Times to expiry cannot be negative.';
   return
end
if ~isempty(Volatility) && any(Volatility(:) < 0)
   messageStructure.identifier = ['Finance:' Function ':NegativeValue'];
   messageStructure.message    =  'Volatilities cannot be negative.';
   return
end
if ~isempty(DividendYield) && any(DividendYield(:) < 0)
   messageStructure.identifier = ['Finance:' Function ':NegativeValue'];
			messageStructure.message    =  'Dividend yields cannot be negative.';
   return
end 

%
% Return an empty message structure to indicate no error occurred.
%

messageStructure  =  messageStructure(zeros(0,1));
