function [call,put] = blsprice(S, X, r, T, sig, q) 
%BLSPRICE Black-Scholes put and call option pricing.
%   Compute European put and call option prices using a Black-Scholes model.
%
%   [Call,Put] = blsprice(Price, Strike, Rate, Time, Volatility)
%   [Call,Put] = blsprice(Price, Strike, Rate, Time, Volatility, Yield)
%
% Optional Input: Yield
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
%   Volatility - Annualized asset price volatility (i.e., annualized standard
%     deviation of the continuously compounded asset return), expressed as 
%     a positive decimal number.
%
% Optional Input:
%   Yield - Annualized continuously compounded yield of the underlying asset
%     over the life of the option, expressed as a decimal number. For example,
%     this could represent the dividend yield or foreign risk-free interest
%     rate for options written on stock indices and currencies, respectively.
%     If empty or missing, the default is zero.
%
% Outputs:
%   Call - Price (i.e., value) of a European call option.
%
%   Put - Price (i.e., value) of a European put option.
%
% Example:  
%   Consider European stock options with an exercise price of $95 that 
%   expire in 3 months. Assume the underlying stock pays no dividends, is
%   trading at $100, and has a volatility of 50% per annum, and that the 
%   risk-free rate is 10% per annum. Using this data,  
% 
%   [Call,Put] = blsprice(100, 95, 0.1, 0.25, 0.5) 
% 
%   returns call and put prices of $13.70 and $6.35, respectively.
%
% Notes:
% (1) Any input argument may be a scalar, vector, or matrix. If a scalar, 
%     then that value is used to price all options. If more than one input 
%     is a vector or matrix, then the dimensions of those non-scalar inputs
%     must be the same.
% (2) Ensure that Rate, Time, Volatility, and Yield are expressed in 
%     consistent units of time.
%
% See also BLSIMPV, BLSDELTA, BLSGAMMA, BLSLAMBDA, BLSTHETA, BLSRHO.

% Copyright 1995-2003 The MathWorks, Inc.  
% $Revision: 1.8.2.1 $   $Date: 2004/01/08 03:06:18 $

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
   error('Finance:blsprice:InsufficientInputs', ...
				     'Specify Price, Strike, Rate, Time, and Volatility.') 
end

if (nargin < 6) || isempty(q)
   q = zeros(size(S));
end

message = blscheck('blsprice', S, X, r, T, sig, q);
error(message);
	
%
% Perform scalar expansion & guarantee conforming arrays.
%

try
   [S, X, r, T, sig, q] = finargsz('scalar', S, X, r, T, sig, q);
catch
   error('Finance:blsprice:InconsistentDimensions', ...
		 	     'Inputs must be scalars or conforming matrices.')
end

%
% Record array dimensions for output argument formatting.
%

[nRows, nCols] = size(S);

call = repmat(NaN, nRows * nCols, 1);
put  = repmat(NaN, nRows * nCols, 1);

%
% Convert to column vectors for intermediate processing.
%

[S, X, r, T, sig, q] = deal(S(:), X(:), r(:), T(:), sig(:), q(:));

%
% Enforce some boundary conditions that produce warnings (e.g.,
% logarithm of zero and divide by zero) and potential NaN's in
% the output option price arrays:
%
%  (1) At expiration (i.e., T = 0), the price of all options is
%      simply the greater of their intrinsic value and zero.
%
%  (2) When the price of the underlying asset is zero (i.e., 
%      S = 0), the value of a call option is zero and the
%      value of a put option is equal to its strike price (X).
%      This boundary condition enforces the "absorbing barrier"
%      property associated with the geometric Brownian motion
%      diffusion process governing the price path of the 
%      underlying asset (S).
%
%  (3) When the strike price is zero (i.e., X = 0), the 
%      value of a put option is zero and the value of a call
%      option is equal to the price of the underlyer (S).
%

isTimeZero         = (T == 0);         % Expired options.
call(isTimeZero)   = max(S(isTimeZero) - X(isTimeZero), 0);
put (isTimeZero)   = max(X(isTimeZero) - S(isTimeZero), 0);

isStockZero        = (S == 0);
call(isStockZero)  = 0;                % Worthless calls.
put (isStockZero)  = X(isStockZero);

isStrikeZero       = (X == 0);
call(isStrikeZero) = S(isStrikeZero);
put (isStrikeZero) = 0;                % Worthless puts.

%
% Suppress a divide by zero warning ONLY for zero volatility
% conditions. Other warnings could be valuable.
%

state = warning;  % Store the current state.

if any(sig == 0)
	  warning('off', 'MATLAB:divideByZero')
end

%
% Now apply the general Black-Scholes European option pricing 
% formulae, excluding the boundary cases handled above, and
% explicitly handling calculations that produce 0/0 = NaN's 
% for the parameters of the cumulative normal distribution 
% function (i.e., d1 & d2).
%
% NaN's occur when S = X, r = q, and Sigma = 0. This situation 
% corresponds to at-the-money options written on riskless 
% underlying assets. Such assets should earn the risk-free rate
% less the dividend yield. But when r = q, the net growth rate
% is also zero, resulting in 0/0 = NaN.
%

i  = ~(isTimeZero | isStockZero | isStrikeZero);

d1 = log(S(i)./X(i)) + (r(i) - q(i) + sig(i).^2/2) .* T(i);
d1 = d1 ./(sig(i).*sqrt(T(i))); 
d2 = d1 - (sig(i).*sqrt(T(i)));

d1(isnan(d1)) = 0;
d2(isnan(d2)) = 0;

call(i) = S(i) .* exp(-q(i).*T(i)) .* normcdf( d1) - ...
	         X(i) .* exp(-r(i).*T(i)) .* normcdf( d2);
put (i) = X(i) .* exp(-r(i).*T(i)) .* normcdf(-d2) - ...
	         S(i) .* exp(-q(i).*T(i)) .* normcdf(-d1);

warning(state)    % Restore the state.

%
% Reshape the outputs for the user.
%

call = reshape(call, nRows, nCols);
put  = reshape(put , nRows, nCols);
