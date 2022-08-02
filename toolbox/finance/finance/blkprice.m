function [call, put] = blkprice(F, X, r, T, sigma)
%BLKPRICE Black's model for pricing futures options.
%   Compute European put and call futures option prices using Black's model. 
%
%   [Call,Put] = blkprice(Price, Strike, Rate, Time, Volatility)
%
% Inputs: 
%   Price - Current price of the underlying asset (i.e., a futures contract).
%
%   Strike - Strike (i.e., exercise) price of the futures option.
%
%   Rate - Annualized continuously compounded risk-free rate of return 
%     over the life of the option, expressed as a positive decimal number.
%
%   Time - Time to expiration of the option, expressed in years.
%
%   Volatility - Annualized futures price volatility, expressed as a 
%     positive decimal number.
%
% Outputs:
%   Call - Price (i.e., value) of a European call futures option.
%
%   Put - Price (i.e., value) of a European put futures option.
%
% Example:  
%   Consider European futures options with exercise prices of $20 that 
%   expire in 4 months. Assume the current underlying futures price is also
%   $20 and has a volatility of 25% per annum, and that the risk-free rate
%   is 9% per annum. Using this data,
%
%   [Call, Put] = blkprice(20, 20, 0.09, 4/12, 0.25)
%
%   returns equal call and put prices of $1.1166.
%
% Notes:
% (1) Any input argument may be a scalar, vector, or matrix. If a scalar, 
%     then that value is used to price all options. If more than one input 
%     is a vector or matrix, then the dimensions of those non-scalar inputs
%     must be the same.
% (2) Ensure that Rate, Time, and Volatility are expressed in consistent 
%     units of time. 
%
% See also BLKIMPV, BLSPRICE.

% References: 
%   Hull, J.C., "Options, Futures, and Other Derivatives", Prentice Hall, 
%     5th edition, 2003, pp. 287-288.
%   Black, F.,  "The Pricing of Commodity Contracts," Journal of Financial
%     Economics, March 3, 1976, pp. 167-79.
%              

% Copyright 1995-2003 The MathWorks, Inc. 
% $Revision: 1.11.2.1 $   $Date: 2004/01/08 03:06:16 $

%
% Implement Black's model for pricing European futures options
% as a pure wrapper around a Black-Scholes option pricing model.
%
% In this context, Black's model is simply a special case of a
% Black-Scholes model in which the futures/forward contract is 
% the underlying asset and the dividend yield = the risk-free rate.
%

try
  [call, put] = blsprice(F, X, r, T, sigma, r);
catch
	 errorStruct            = lasterror;
 	errorStruct.identifier = strrep(errorStruct.identifier, 'blsprice', 'blkprice');
		errorStruct.message    = strrep(errorStruct.message   , 'blsprice', 'blkprice');
		rethrow(errorStruct);
end
