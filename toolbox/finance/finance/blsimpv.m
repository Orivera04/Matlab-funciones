function volatility = blsimpv(S, X, r, T, value, varargin)
%BLSIMPV Black-Scholes implied volatility.
%   Compute the implied volatility of an underlying asset from the market 
%   value of European call and put options using a Black-Scholes model.
%
%   Volatility = blsimpv(Price, Strike, Rate, Time, Value)
%   Volatility = blsimpv(Price, Strike, Rate, Time, Value, Limit, ...
%     Yield, Tolerance, Class)
%
% Optional Inputs: Limit, Yield, Tolerance, Class.
%
% Inputs: 
%   Price - Current price of the underlying asset.
%
%   Strike - Strike (i.e., exercise) price of the option.
%
%   Rate - Annualized continuously compounded risk-free rate of return over
%     the life of the option, expressed as a positive decimal number.
%
%   Time - Time to expiration of the option, expressed in years.
%
%   Value - Price (i.e., value) of a European option from which the implied
%     volatility of the underlying asset is derived.
%
% Optional Inputs:
%   Limit - Positive scalar representing the upper bound of the implied 
%     volatility search interval. If empty or missing, the default is 10,
%     or 1000% per annum.
%
%   Yield - Annualized continuously compounded yield of the underlying asset
%     over the life of the option, expressed as a decimal number. For example,
%     this could represent the dividend yield and foreign risk-free interest
%     rate for options written on stock indices and currencies, respectively.
%     If empty or missing, the default is zero.
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
%   Volatility - Implied volatility of the underlying asset derived from 
%     European option prices, expressed as a decimal number. If no solution
%     can be found, a NaN (i.e., Not-a-Number) is returned.
%
% Example:
%   Consider a European call option trading at $10 with an exercise price 
%   of $95 and 3 months until expiration. Assume the underlying stock pays
%   no dividends, is trading at $100, and the risk-free rate is 7.5% per 
%   annum. Furthermore, assume we are interested in implied volatilities 
%   no greater than 0.5 (i.e., 50% per annum). Under these conditions, any
%   of the following commands
%
%   Volatility = blsimpv(100, 95, 0.075, 0.25, 10, 0.5)
%   Volatility = blsimpv(100, 95, 0.075, 0.25, 10, 0.5, 0, [], {'Call'})
%   Volatility = blsimpv(100, 95, 0.075, 0.25, 10, 0.5, 0, [], true)
%
%   return an implied volatility of 0.3130, or 31.30%, per annum.
%
% Notes:
% (1) The input arguments Price, Strike, Rate, Time, Value, Yield, and 
%     Class may be scalars, vectors, or matrices. If scalars, then that
%     value is used to compute the implied volatility from all options. If 
%     more than one of these inputs is a vector or matrix, then the 
%     dimensions of all non-scalar inputs must be the same.
% (2) Ensure that Rate, Time, and Yield are expressed in consistent units 
%     of time.
%
% See also BLSPRICE, BLSDELTA, BLSGAMMA, BLSLAMBDA, BLSTHETA, BLSRHO.

% Copyright 1995-2003 The MathWorks, Inc.
% $Revision: 1.13.2.2 $   $Date: 2004/01/08 03:06:17 $

%
% References: 
%   Hull, J.C., "Options, Futures, and Other Derivatives", Prentice Hall, 
%     5th edition, 2003.
%   Luenberger, D.G., "Investment Science", Oxford Press, 1998.
%

%
% Input argument checking & default assignment.
%

if nargin < 5
	  error('Finance:blsimpv:TooFewInputs', ...
				     'Specify Price, Strike, Rate, Time, and Value.') 
end

if nargin > 9
	  error('Finance:blsimpv:TooManyInputs', ...
				     'Too many input arguments.') 
end


if any(value(:) < 0)
   error('Finance:blsimpv:NegativeValue', ...
				     'Option values cannot be negative.')
end

if (nargin < 6) || isempty(varargin{1})
   limit = 10;
else
	  if varargin{1}(1) <= 0
      error('Finance:blsimpv:NonPositiveValue', 'Volatility search interval upper bound must be positive.')
			end
			limit = varargin{1}(1);
end 

if (nargin < 7) || isempty(varargin{2})
   q = zeros(size(S));
else
	  q = varargin{2};
end 

message = blscheck('blsimpv', S, X, r, T, [], q);
error(message);

if (nargin < 8) || isempty(varargin{3})
   tol = 1e-6;
else
	  if varargin{3}(1) <= 0
      error('Finance:blsimpv:NonPositiveValue', 'Termination tolerance must be a positive scalar.')
			end
			tol = varargin{3}(1);
end

if (nargin < 9) || isempty(varargin{4})
   optionClass = true(size(S));  % Denote TRUE = 1 ==> Call Options
else
%
%  Allow some flexibility for the option class input specification (i.e.,
%  whether the implied volatility is derived from the Black-Scholes 
%  pricing formula of call options or put options). For backward 
%  compatibility, the default still derives the implied volatility of
%  the underlyer from the prices of CALL options.
%
%  However, the following code allows users to indicate the option class
%  by any of the following:
%
%     (1) Logical values: 0 = Put, 1 = Call.
%     (2) Cell arrays of character strings, in which a case-insensitive
%         comparison is made of the first character of each element of the
%         cell array with 'P' and 'C' for puts and calls, respectively.
%     (3) Numeric values: 0 = Put, anything else = Call.
%
%  The preferred methods are (1) and (2).
%
   switch class(varargin{4})
 				case {'double' , 'logical' , 'single'}
	 			  optionClass = logical(varargin{4});
				case 'cell'
					  optionClass = ~strncmpi(varargin{4}, 'P', 1);
			 	otherwise
       error('Finance:blsimpv:InvalidOptionClass', 'Option class must indicate Calls or Puts.')
			end
end

%
% Perform scalar expansion & guarantee conforming arrays.
%

try
   [S, X, r, T, value, q, optionClass] = finargsz('scalar', S, X, r, T, value, q, optionClass);
catch
   error('Finance:blsimpv:InconsistentDimensions', ...
		 	     'Inputs must be scalars or conforming matrices.')
end

%
% Record array dimensions for output argument formatting.
%

[nRows, nCols] = size(S);

volatility = repmat(NaN, nRows * nCols, 1);

%
% Convert to column vectors for intermediate processing.
%

[S, X, r, T, value, q, optionClass] = deal(S(:),     X(:), r(:), ...
	                                          T(:), value(:), q(:), optionClass(:));

%
% Now estimate the implied volatility for each option.
%

options = optimset('fzero');
options = optimset(options, 'TolX', tol(1), 'Display', 'off');

for i = 1:length(volatility)
%
% Compute the implied volatility from option prices ONLY if the 
% price of the underlying asset AND the option strike price AND 
% the time to expiry of the option are greater than zero. 
%
% Otherwise, return the implied volatility as a NaN, indicating 
% that there is insufficient information to determine a unique
% solution. Note that these boundary conditions do NOT mean that
% the true volatility of the underlying asset is non-existent, 
% only that we cannot determine a unique solution solely from 
% option prices.
%
	 if (S(i) > 0) && (X(i) > 0) && (T(i) > 0)

    try
      [volatility(i), fval, exitFlag] = fzero(@objfcn, [0 limit], options, ...
			  		         S(i), X(i), r(i), T(i), value(i), q(i), optionClass(i));

  				if exitFlag < 0
         volatility(i) = NaN;
						end
				catch
      volatility(i) = NaN;
				end

		end

end

%
% Reshape the outputs for the user.
%

volatility = reshape(volatility, nRows, nCols);

% 
% * * * * * * * Implied Volatility Objective Function * * * * * * *
%

function delta = objfcn(volatility, S, X, r, T, value, q, optionClass)
%OBJFCN Implied volatility objective function.
% The objective function is simply the difference between the specified 
% market value, or price, of the option and the theoretical value derived
% from the Black-Scholes model.
%

[callValue, putValue] = blsprice(S, X, r, T, volatility, q);

if optionClass
   delta = value - callValue;
else
   delta = value - putValue;
end
