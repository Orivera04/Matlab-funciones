function [cvForecast,cvSeries] = ugarchpred(u , kappa , alpha , beta , nPeriods)
%UGARCHPRED Forecast conditional variance of univariate GARCH(P,Q) processes.
%
%   [VarianceForecast , H] = ugarchpred(U , Kappa , Alpha , Beta  , NumPeriods)
%
%   Inputs:
%     U: Single column vector of random disturbances (i.e., the residuals, 
%     or innovations, of an econometric model) representing a mean-zero, 
%     discrete-time stochastic process. The innovations time series U is 
%     assumed to follow a GARCH(P,Q) process. 
%
%     Kappa: Scalar constant term of the GARCH process. 
%
%     Alpha: P by 1 column vector of coefficients, where P is the number of
%     lags of the conditional variance included in the GARCH process. Alpha 
%     can be an empty matrix, in which case P is assumed zero; when P = 0,
%     a GARCH(0,Q) process is actually an ARCH(Q) process.
%
%     Beta: Q by 1 column vector of coefficients, where Q is the number of
%     lags of the squared innovations included in the GARCH process.
%
%     NumPeriods: Positive, scalar integer representing the forecast horizon
%     of interest, expressed in periods compatible with the sampling  
%     frequency of the input innovations column vector U. 
%
%   Outputs:
%     VarianceForecast: NUMPERIODS by 1 column vector of the minimum mean 
%     square error forecast of the conditional variance of the innovations 
%     time series vector U. The first element contains the 1-period-ahead 
%     forecast, the second element contains the 2-period-ahead forecast, and
%     so on. Thus, if a forecast horizon greater than one is specified (i.e.,
%     NUMPERIODS > 1), the forecasts of all intermediate horizons are 
%     returned as well; in this case, the last element of will contain the 
%     variance forecast of the specified horizon, NUMPERIODS from the most 
%     recent observation in U.
%
%     H: Single column vector of the same length as the input innovations 
%     vector U. To model the GARCH(P,Q) process, the conditional variance 
%     time series, H(t), must be constructed (see notes below). This 
%     represents the time series inferred from the innovations U, and is a 
%     re-construction of the 'past' conditional variances, whereas the above
%     output 'VarianceForecast' represents the projection of conditional 
%     variances into the 'future'. This sequence is based on setting pre-sample
%     values of H(t) to the unconditional variance of the U(t) process.
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
%     U(t) = sqrt(H(t))*v(t), where {v(t)} is an i.i.d. sequence.
%
%   See also UGARCH, UGARCHSIM, UGARCHPLOT.

% Author(s): R.A. Baker, 05/05/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.7 $   $ Date: 1998/01/30 13:45:34 $


% References:
% -----------
% Hamilton, James D., 1994. 'Time Series Analysis',
%    Princeton University Press (ISBN 0-691-04289-6).
%
% Baillie, R.T. and Bollerslev, T., 1992. 'Prediction in Dynamic 
%    Models with Time-Dependent Conditional Variances.' 
%    Journal of Econometrics, 52:91-113.
%

%
% Error-checking on scalar/vector input parameter dimensions.
%

if size(u,2) > 1
   error(' Innovations time series U must be a single column vector.')
elseif isempty(u)
   error(' Innovations time series U is empty.')
end

if (length(nPeriods) > 1) | any(nPeriods <= 0)
   error(' Forecast horizon NUMPERIODS must be a positive scalar.')
elseif isempty(nPeriods)
   error(' Forecast horizon NUMPERIODS is empty.')
end

if size(alpha,2) > 1
   error(' Conditional variance coefficient vector ALPHA must be a single column vector.')
end

if size(beta,2) > 1
   error(' Squared innovations coefficient vector BETA must be a single column vector.')
elseif isempty(beta)
   error(' Squared innovations coefficient vector BETA is empty.')
end

%
% Perform GARCH(P,Q) constraint checking. The GARCH(P,Q) constraints are:
%
%   (1) k > 0
%   (2) a(1),a(2),...a(P) , b(1),b(2),...b(Q) >= 0
%   (3) a(1) + a(2) + ... + a(P) + b(1) + b(2) +... + b(Q) < 1
%
% where parameter vector is [k , a(1,2,...P) , b(1,2,...Q)];
%

if (length(kappa) > 1) | any(kappa <= 0)
   error(' GARCH constant KAPPA must be a positive scalar.')
elseif isempty(kappa)
   error(' GARCH constant KAPPA is empty.')
end

if any([alpha ; beta] < 0)
   error(' All GARCH(P,Q) process coefficients must be non-negative.');
end

if sum([alpha ; beta]) >= 1
   error(' Sum of GARCH(P,Q) coefficients ''a(1,2,...P) + b(1,2,...Q)'' must be less than 1.')
end

%
% Determine the GARCH(P,Q) lag orders. 
%

p  =  size(alpha , 1);
q  =  size(beta  , 1);

%
% Construct the parameter column vector of length (1 + P + Q).
%

parameters  =  [kappa ; alpha ; beta];             % GARCH(P,Q) parameter vector.

%
% GARCH(P,Q) processing requires P pre-sample values of h(t), the conditional variance of
% the innovations u(t), and Q pre-sample values of u(t) itself to 'jump-start' the process. 
% To be safe, create M = max(P,Q) pre-sample lags of both h(t) and u(t). The M = max(P,Q)
% samples are prepended to u(t), thus increasing the size of u(t) by M samples. Hamilton 
% (top of page 667), suggests assigning the unconditional variance of u(t) to the first 
% M samples of h(t) and u^2(t). This implies that the square root of the variance, the
% unconditional standard deviation, is assigned to the first M samples of u(t). 
%

m     =  max(p,q);                                 % # of pre-sample lags needed to 'jump-start' the process.
sigma =  sqrt(kappa./(1 - sum([alpha ; beta])));   % Unconditional STD of u(t).
u     =  [sigma(ones(m,1)) ; u];                   % Prepend M samples of the standard deviation to u(t).
L     =  size(u,1);                                % The total (original + M padded samples) length of u(t).
h     =  u(1).^2;                                  % Prepend M samples of the variance of u(t) to h(t).
h     =  [h(ones(m,1)) ; zeros(L - m,1)];          % Pre-allocate the h(t) vector.

%
% Form the time-conditional variance h(t) time series.
%

for t = (m + 1):L
    h(t) = parameters' * [1 ; h(t-(1:p)) ; u(t-(1:q)).^2];
end

%
% Strip h(t) of the first M pre-pended samples, and pass it back to the caller.
%

cvSeries  =  h((m + 1):end);

%
% Re-format the h(t) conditional variance and the u(t) innovations processes for
% the purpose of forecasting/prediction. For forecasting, we only really need the 
% last (i.e., most recent) P samples of h(t) and Q samples of u(t). Thus, I first 
% truncate h(t) and u(t), retaining only the most recent M samples, then re-size 
% them by appending 'nPeriod' zeros to accommodate the user-specified forecast 
% horizon. Also, forecasting requires the squared innovations u(t)^2, so I work 
% with them directly instead of the input u(t) process (this is done simply for 
% performance purposes, and avoids having to iteratively exponentiate and square 
% root inside the FOR loop below).
%

h  =  h((end - m + 1):end);              % Keep only the most recent max(P,Q) samples of h(t).
u  =  u((end - m + 1):end);              % Keep only the most recent max(P,Q) samples of u(t).
h  =  [h    ; zeros(nPeriods - m , 1)];  % Now re-size them to the user-specified length.
u2 =  [u.^2 ; zeros(nPeriods - m , 1)];  % Work with the squared innovations directly.

%
% Apply iterative expectations one forecast step at a time. Note that the second 
% line inside the FOR loop applies the identity that the conditional expectation
% of the squared innovation at time 't' is also the conditional expectation
% of the variance forecast at time 't' for any period in the future.
%
% Note that the forecasts constructed below make no assumptions about the 
% distribution of the innovations process u(t) other than that the conditional 
% distribution is symmetric with zero-mean (see Baillie & Bollerslev, 1992).
%

T  =  nPeriods  +  m;

for t = (m + 1):T
    h (t) = parameters' * [1 ; h(t-(1:p)) ; u2(t-(1:q))];
    u2(t) = h(t);
end

%
% Now strip off the first M pre-sample values of the conditional variance h(t). After
% the first M samples have been excluded, h(N) = conditional variance forecast N periods
% from now. 
%

cvForecast =  h((m + 1):end);
