function volatility = blkimpv(F, X, r, T, value, varargin)
%BLKIMPV Implied volatility from Black's model for futures options.
%   Compute the implied volatility of a futures price from the market
%   value of European futures options using Black's model.
%
%   Volatility = blkimpv(Price, Strike, Rate, Time, Value)
%   Volatility = blkimpv(Price, Strike, Rate, Time, Value, Limit, ...
%     Tolerance, Class)
%
% Optional Inputs: Limit, Tolerance, Class.
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
%   Value - Price (i.e., value) of a European futures option from which 
%     the implied volatility is derived.
%
% Optional Inputs:
%   Limit - Positive scalar representing the upper bound of the implied 
%     volatility search interval. If empty or missing, the default is 10,
%     or 1000% per annum.
%
%   Tolerance - Positive scalar implied volatility termination tolerance.
%     If empty or missing, the default is 1e-6.
%
%   Class - Option class (i.e., whether a call or put) indicating the 
%     option type from which the implied volatility is derived. This may
%     be either a logical indicator or a cell array of characters. To 
%     specify call options, set Class = true or Class = {'call'}; to specify
%     put options, set Class = false or Class = {'put'}. If empty or missing,
%     the default is a call option.
%
% Output:
%   Volatility - Implied volatility derived from European futures option 
%     prices, expressed as a decimal number. If no solution is found, a
%     NaN (i.e., Not-a-Number) is returned.
%
% Example:  
%   Consider a European call futures option trading at $1.1166, with an 
%   exercise prices of $20 that expires in 4 months. Assume the current 
%   underlying futures price is also $20 and that the risk-free rate is 9% 
%   per annum. Furthermore, assume we are interested in implied volatilities 
%   no greater than 0.5 (i.e., 50% per annum). Under these conditions, any
%   of the following commands
%
%   Volatility = blkimpv(20, 20, 0.09, 4/12, 1.1166, 0.5)
%   Volatility = blkimpv(20, 20, 0.09, 4/12, 1.1166, 0.5, [], {'Call'})
%   Volatility = blkimpv(20, 20, 0.09, 4/12, 1.1166, 0.5, [], true)
%
%   return an implied volatility of 0.25, or 25%, per annum.
%
% Notes:
% (1) The input arguments Price, Strike, Rate, Time, Value, and Class may be
%     scalars, vectors, or matrices. If scalars, then that value is used to 
%     compute the implied volatility from all options. If more than one of 
%     these inputs is a vector or matrix, then the dimensions of all 
%     non-scalar inputs must be the same.
% (2) Ensure that Rate and Time are expressed in consistent units of time.
%
% See also BLKPRICE, BLSPRICE, BLSIMPV.

% Copyright 1995-2003 The MathWorks, Inc.
% $Revision: 1.4.2.2 $   $Date: 2004/01/08 03:06:15 $

% References: 
%   Hull, J.C., "Options, Futures, and Other Derivatives", Prentice Hall, 
%     5th edition, 2003, pp. 287-288.
%   Black, F.,  "The Pricing of Commodity Contracts," Journal of Financial
%     Economics, March 3, 1976, pp. 167-79.
%              

%
% Implement Black's model for European futures options as a wrapper
% around a general Black-Scholes option model.
%
% In this context, Black's model is simply a special case of a
% Black-Scholes model in which the futures/forward contract is 
% the underlying asset and the dividend yield = the risk-free rate.
%

if nargin < 5
	  error('Finance:blkimpv:TooFewInputs', ...
				     'Specify Price, Strike, Rate, Time, and Value.') 
end

switch nargin
	 case 5
		  [limit, tol, optionClass] = deal([]);
	 case 6
			 [limit, tol, optionClass] = deal(varargin{1}, [], []);
	 case 7
			 [limit, tol, optionClass] = deal(varargin{1}, varargin{2}, []);
	 case 8
				[limit, tol, optionClass] = deal(varargin{1:3});
	otherwise
    error('Finance:blkimpv:TooManyInputs', 'Too many inputs.')
end

try
		volatility = blsimpv(F, X, r, T, value, limit, r, tol, optionClass);
catch
	 errorStruct            = lasterror;
 	errorStruct.identifier = strrep(errorStruct.identifier, 'blsimpv', 'blkimpv');
		errorStruct.message    = strrep(errorStruct.message   , 'blsimpv', 'blkimpv');
		rethrow(errorStruct);
end
