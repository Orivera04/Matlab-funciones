function [kappa , alpha , beta] = ugarch(u , p , q , options)
%UGARCH Univariate GARCH(P,Q) parameter estimation with Gaussian innovations.
%
%   [Kappa , Alpha , Beta] = ugarch(U , P , Q)
%
%   Inputs:
%     U: Single column vector of random disturbances (i.e., the residuals, 
%        or innovations, of an econometric model) representing a mean-zero, 
%        discrete-time stochastic process. The innovations time series U is 
%        assumed to follow a GARCH(P,Q) process. 
%
%     P: Non-negative, scalar integer representing a model order of the GARCH 
%        process: P is the number of lags of the conditional variance included 
%        in the GARCH process. Note that P can be zero; when P = 0, a GARCH(0,Q)
%        process is actually an ARCH(Q) process.
%
%     Q: Positive, scalar integer representing a model order of the GARCH 
%        process: Q is the number of lags of the squared innovations included 
%        in the GARCH process. 
%
%   Outputs:
%     Kappa: Estimated scalar constant term of the GARCH process. 
%
%     Alpha: P by 1 column vector of estimated coefficients, where P is the
%            number of lags of the conditional variance included in the 
%            GARCH process. 
%
%     Beta: Q by 1 column vector of estimated coefficients, where Q is the 
%           number of lags of the squared innovations included in the 
%           GARCH process.
%
%   Notes:
%     GARCH(P,Q) coefficients {Kappa, Alpha, Beta} are subject to constraints:
%     (1) Kappa > 0
%     (2) Alpha(i) >= 0 for i = 1,2,...P
%     (3) Beta(i)  >= 0 for i = 1,2,...Q
%     (4) sum(Alpha(i) + Beta(j)) < 1 for i = 1,2,...P and j = 1,2,...Q
%
%     The time-conditional variance, H(t), of a GARCH(P,Q) process is modeled 
%     as follows:
%
%     H(t) = Kappa + Alpha(1)*H(t-1) + Alpha(2)*H(t-2) +...+ Alpha(P)*H(t-P)
%                  + Beta(1)*U^2(t-1)+ Beta(2)*U^2(t-2)+...+ Beta(Q)*U^2(t-Q)
%
%     Note that U is a vector of innovations, or regression residuals of an
%     econometric model, representing a mean-zero, discrete-time stochastic 
%     process. That is, it is assumed that a regression model has already been
%     run, and that U(t) = y(t) - F(X(t),B) is the time series of innovations 
%     derived from the model. 
%
%     Although H is generated via the equation above, U and H are related:
%
%     U(t) = sqrt(H(t))*v(t), where {v(t)} is an i.i.d. sequence ~ N(0,1).
%
%   See also UGARCHPRED, UGARCHSIM, UGARCHPLOT.

% Author(s): R.A. Baker, 08/24/1999
% Copyright 1995-2003 The MathWorks, Inc.
% $Revision: 1.13.2.2 $   $ Date: 1998/01/30 13:45:34 $

%
% Error-checking on P and Q. Note that I allow P to be zero, with 
% the understanding that a GARCH(0,Q) process is an ARCH(Q) process.
%

if (length(p) > 1) | any(p <  0)
   error(' P must be a non-negative scalar.')
elseif isempty(p)
   error(' P is an empty matrix.')
end

if (length(q) > 1) | any(q <= 0)
   error(' Q must be a positive scalar.')
elseif isempty(q)
   error(' Q is an empty matrix.')
end

%
% Ensure we have a single, univariate time series COLUMN vector.
%

if size(u,2) > 1
   error(' Innovations time series U must be a single column vector.')
elseif isempty(u)
   error(' Innovations time series U is empty.')
end

%
% GARCH(P,Q) processing requires pre-sample values for conditioning. That is, we 
% require P pre-sample values of h(t), the conditional variance of the residuals,
% or innovations, u(t), and Q pre-sample values of u(t) itself to 'jump-start' the
% process. To be safe, allocate M = max(P,Q) pre-sample lags for both h(t) and u(t).
%

m  =  max(p,q);   % # of pre-sample lags needed to 'jump-start' the process.

%
% The following initial guesses are based on empirical observation of GARCH
% model parameters. This approach is rather ad hoc, but is often typical of
% GARCH models in financial time series. 
%
% The following approach assumes the sum of the conditional variance model 
% coefficients is close to 1 (i.e., the integrated boundary). Specifically,
% we assume that
%
%    Alpha(1) + ... + Alpha(P) + Beta(1) + ... + Beta(Q) = 0.9
%
% If P > 0 (i.e., the variance model includes lagged conditional variances), 
% then allocate 0.85 out of the available 0.9 to these ALPHA coefficients, and
% the remaining 0.05 to the BETA coefficients. When P = 0, we have an ARCH(Q)
% model in which all 0.9 is allocated to the Q BETA terms.
%
% For example, the most common GARCH(P,Q) model is the simple GARCH(1,1) 
% model, and would be modeled as follows:
%
%            H(t) = Kappa + 0.85H(t-1) + 0.05U^2(t-1)
%
% In a GARCH(1,1) model, the unconditional variance of the innovations 
% process, V, is
%
%            V = Kappa / (1 - (0.85 + 0.05))
% or,
%            Kappa = V * (1 - (0.85 + 0.05))
%
% For higher-order GARCH(P,Q) models, this approach assumes the sum of the
% lagged conditional variance coefficients = 0.85, and the sum of the coefficients
% of lagged squared innovations = 0.05.
%

alpha =  0.85;
alpha =  alpha(ones(p,1)) / max(p,1);
alpha =  alpha(:);

beta  =  0.90 - sum(alpha);
beta  =  beta(ones(q,1)) / max(q,1);
beta  =  beta(:);

kappa =  mean(u.^2) * (1 - sum([alpha ; beta]));

%
% Perform constrained optimization.
%

lowerBounds          =  zeros(1 + p + q , 1);       % Linear inequalities captured
upperBounds          =  [];                         % as lower bounds constraints.

gradientFunction     =  [];

summationConstraintA =  [0  ones(1,p)  ones(1,q)];  % Linear inequality related to 
summationConstraintB =  1;                          % covariance-stationary constraint.

%
%  Allow a user-specified OPTIONS structure if one exists, but set default 
%  to 'iterative display' with 'diagnostics' printed to the screen.
%

if (nargin <= 3) | isempty(options)
   options  =  optimset('fmincon');
   options  =  optimset(options , 'Display'     , 'iter');
   options  =  optimset(options , 'Diagnostics' , 'on');
   options  =  optimset(options , 'LargeScale'  , 'off');
end

%
% Set linear inequality of the covariance-stationarity constraint of 
% the conditional variance, Ax <= b. Since the conditional variance 
% (ALPHA(i) for i = 1,2,...P, BETA(j) for j = 1,2,...Q) parameters 
% are constrained to be non-negative, the covariance-stationarity 
% constraint is just a summation constraint. Also, adjust the 
% summation constraint to reflect a tolerance offset from a fully 
% integrated conditional variance condition.
%

summationConstraintB = summationConstraintB - 2*optimget(options, 'TolCon', 1e-6);

%
% Estimate the parameters.
%

[garchParameters , LLF    , ...
 EXITFLAG        , OUTPUT , ...
 LAMBDA  , GRAD  , HESSIAN] =  fmincon('ugarchllf'            , [kappa ; alpha ; beta] , ...
                                        summationConstraintA  , summationConstraintB   , ... 
                                        [] , [] , lowerBounds , upperBounds            , ...
                                        [] , options          , u , p , q);
%
% Over-write all GARCH constraint-violating parameters that are less than 
% zero. This will, occasionally, occur because FMINCON may violate constraints 
% ever so slightly. When a constraint violation does occur, it is EXTREMELY 
% small (e.g. -3.51422153312504e-013 is very nearly 0).
%

garchParameters(find(garchParameters    <  0)) = 0;          % All coefficients
garchParameters(find(garchParameters(1) <= 0)) = realmin;    % Constant term Kappa.

%
% Assign (decode) the estimated GARCH(P,Q) coefficients to the output parameters.
%

kappa  =  garchParameters(      1);
alpha  =  garchParameters(  2:p+1);
beta   =  garchParameters(p+2:end);
