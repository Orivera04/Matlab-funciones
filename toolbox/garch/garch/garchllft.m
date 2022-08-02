function [LLF, G, H, e, h, LogLikelihoods] = garchllft(Parameters, y, R, M, P, Q, X, isConstantInMean, isVarianceInMean, e0, s0, y0)
%GARCHLLFT Univariate GARCH process objective function (Student T Distribution).
%   Compute the log-likelihood objective function value suitable for maximum 
%   likelihood estimation (MLE). This is the objective function optimized by 
%   the MATLAB Optimization Toolbox function FMINCON. The innovations are 
%   inferred from a conditional mean specification of ARMAX form, and the 
%   conditional variances are then fit to a GARCH model. Student T-distributed
%   innovations are assumed.
%
%   [LLF, G, H, Innovations, Sigmas, LogLikelihoods] = garchllft(Parameters, 
%     Series, R, M, P, Q, X, IsConstantInMean, IsVarianceInMean)
%   [LLF, G, H, Innovations, Sigmas, LogLikelihoods] = garchllft(Parameters, 
%     Series, R, M, P, Q, X, IsConstantInMean, IsVarianceInMean, PreInnovations, 
%     PreSigmas, PreSeries)
%
%   Optional Inputs: PreInnovations, PreSigmas, PreSeries
%
% Inputs:
%   Parameters - Column vector of process parameters associated with fitting
%     conditional mean and variance specifications to an observed return series 
%     Series.
%
%   Series - NUMSAMPLES-by-NUMPATHS matrix of observations of the underlying 
%     univariate return series of interest. Series is the response variable 
%     representing the time series fit to conditional mean and variance 
%     specifications. Each column of Series is an independent realization
%     (i.e., path). The last row of Series holds the most recent observation 
%     of each realization.
%
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   M - Non-negative, scalar integer representing the MA-process order.
%
%   P - Non-negative, scalar integer representing the number of lags of the
%     conditional variance included in the GARCH process.
%
%   Q - Non-negative, scalar integer representing the number of lags of the 
%     squared innovations included in the GARCH process.
%
%   X - Time series regression matrix of explanatory variable(s). Typically, X 
%     is a regression matrix of asset returns (e.g., the return series of an 
%     equity index). Each column of X is an individual time series used as an 
%     explanatory variable in the regression component of the conditional mean. 
%     In each column of X, the first row contains the oldest observation and 
%     the last row the most recent. If empty or missing, the conditional mean 
%     will have no regression component.
%
%   IsConstantInMean - Logical flag indicating whether or not the conditional
%     mean equation includes an additive scalar constant. A TRUE (i.e., 
%     logical(1)) value indicates the mean equation includes a constant
%     and a FALSE (i.e., logical(0)) value indicates that a constant is NOT
%     included in the mean equation.
%
%   IsVarianceInMean - Logical flag indicating whether or not the conditional
%     variance is included as an explanatory variable in the conditional mean
%     equation. A TRUE (i.e., logical(1)) value indicates a GARCH-M model
%     and a FALSE (i.e., logical(0)) value indicates no GARCH-M model.
% 
% Optional Inputs:
%   PreInnovations - MAX([R M P Q])-by-NUMPATHS matrix of pre-sample innovations
%     (i.e., residuals) upon which the recursive mean and variance models are 
%     conditioned.  Each column provides the pre-sample information for the 
%     corresponding column of the output Innovations matrix (see below). The
%     last row holds the most recent observation of each realization.
%
%   PreSigmas - MAX([R M P Q])-by-NUMPATHS matrix of pre-sample conditional
%     standard deviations upon which the recursive mean and variance models 
%     are conditioned.  Each column provides the pre-sample information for 
%     the corresponding column of the output Sigmas matrix (see below). The 
%     last row holds the most recent observation of each realization.
%
%   PreSeries - MAX([R M P Q])-by-NUMPATHS matrix of pre-sample returns upon 
%     which the recursive mean model is conditioned.  Each column provides the
%     pre-sample information for the corresponding column of the input Series 
%     matrix (see above). The last row holds the most recent observation of 
%     each realization.
%
% Outputs:
%   LLF - Vector of log-likelihood objective function values evaluated at the 
%     coefficients in Parameters. The length of LLF is NUMPATHS, the same as 
%     the number of columns in Series. This function is meant to be optimized 
%     via the FMINCON function of the MATLAB Optimization Toolbox. FMINCON is 
%     a minimization routine, so LLF is actually the negative of what is 
%     formally presented in most econometrics references.
%
%   G - Empty matrix (placeholder for forward compatibility).
%
%   H - Empty matrix (placeholder for forward compatibility).
%
%   Innovations - NUMSAMPLES-by-NUMPATHS matrix of innovations (i.e., residuals)
%     inferred from the input Series matrix. Rows are sequential observations, 
%     columns are sample paths (realizations). The last row of Innovations holds
%     the most recent observation of each realization. 
%
%   Sigmas - NUMSAMPLES-by-NUMPATHS matrix of conditional standard deviations 
%     of the corresponding Innovations matrix. Innovations and Sigmas are the 
%     same size, and form a matching pair of matrices. Rows are sequential 
%     times observations, columns are sample paths (realizations). The last row 
%     of Innovations holds the most recent observation of each realization. 
%
%   LogLikelihoods - NUMSAMPLES-by-NUMPATHS matrix of the logarithm of the 
%     conditional likelihood of each observation in Series. Notice that 
%     LLF = sum(LogLikelihoods). This output is used to support the calculation
%     of the estimation error covariance matrix of Parameters.
%
% Notes: 
% (1) This is a performance-sensitive objective function called by an iterative
%     numerical optimizer, and is NOT meant to be called directly. For this 
%     reason, no argument checking is performed. Please access this function
%     by calling GARCHINFER. Type "help garchinfer" for details.
% (2) PreInnovations, PreSigmas, and PreSeries are user-specified pre-sample 
%     observations associated with the Innovations, Sigmas, and Series arrays, 
%     respectively. These are optional input arrays. However, when they are 
%     specified, they MUST be specified collectively, MUST be matrices of 
%     identical size, and the size MUST be either MAX([R M P Q])-by-NUMPATHS
%     or empty (i.e., []). Passing all of them as empty matrices is the same
%     as specifying no pre-sample data.
%
% See also GARCHSIM, GARCHPRED, GARCHFIT, GARCHINFER.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.1.4.1 $   $Date: 2003/05/08 21:45:26 $

%
% References:
%
%   Bollerslev, T. (1986), "Generalized Autoregressive Conditional 
%     Heteroskedasticity", Journal of Econometrics, vol. 31, pp. 307-327.
%
%   Bollerslev, T. (1987), "A Conditionally Heteroskedastic Time Series Model
%     for Speculative Prices and Rates of Return", The Review Economics and
%     Statistics, vol. 69, pp 542-547.
%
%   Box, G.E.P., Jenkins, G.M., Reinsel, G.C., "Time Series Analysis: 
%     Forecasting and Control", 3rd edition, Prentice Hall, 1994.
%
%   Enders, W., "Applied Econometric Time Series", John Wiley & Sons, 1995.
%
%   Engle, R.F., Lilien, D.M., Robins, R.P. (1987), "Estimating Time Varying 
%     Risk Premia in the Term Structure: The ARCH-M Model", Econometrica, 
%     vol. 59, pp. 391-407.
%
%   Engle, Robert (1982), "Autoregressive Conditional Heteroskedasticity 
%     with Estimates of the Variance of United Kingdom Inflation", 
%     Econometrica, vol. 50, pp. 987-1007.
%
%   Hamilton, J.D., "Time Series Analysis", Princeton University Press, 1994.
%

%
% SPECIAL NOTE: Estimation of Variance-in-Mean Models
%
% In addition to the fields formally documented, the GARCH Toolbox specification 
% structure supports the following UNDOCUMENTED parameters:
%
%       InMean - Scalar coefficient for variance-in-mean models. 
%                [ scalar coefficient | {[]} ]
%    FixInMean - Equality constraint indicator for InMean coefficient.
%                [ logical scalar | {[]} ]
%
% In the code that follows, the 'InMean' parameter is a coupling coefficient
% that allows inclusion of the conditional variance as an explanatory variable
% in the conditional mean equation. 
%
% From an ESTIMATION standpoint, the 'InMean' and 'FixInMean' parameter fields
% are applicable ONLY to GARCH-M variance-in-mean models.
%
% Notice that it is the conditional VARIANCE that is included in the mean 
% equation.
%
% Please note that estimation of GARCH-M models is an UNDOCUMENTED feature!
%

%
% Notes:
%
% Let y(t) = return series of interest (assumed stationary)
%     e(t) = innovations of the model noise process (assumed invertible)
%     h(t) = conditional variance of the innovations process e(t)
%
% The input coefficient vector 'Parameters' is formatted exactly as the 
% coefficients would be read from the recursive difference equations when 
% solving for the current values of the y(t) and h(t) time series. 
%
% Consider the following general Variance-in-Mean + ARMAX(R,M,nX)/GARCH(P,Q) form:
%
%   y(t) =  C + AR(1)y(t-1) + ... + AR(R)y(t-R) + e(t) 
%             + MA(1)e(t-1) + ... + MA(M)e(t-M) + B(1)X(t,1) + ... + B(nX)X(t,nX)
%             + Ih(t)
%
%   h(t) =  K + GARCH(1)h(t-1)   + ... + GARCH(P)h(t-P) 
%             +  ARCH(1)e(t-1)^2 + ... +  ARCH(Q)e(t-Q)^2
%
% The input flags 'IsConstantInMean' and 'IsVarianceInMean' do NOT affect 
% the general functional forms of the equations, but rather indicate the 
% presence or absence of the scalar parameters 'C' and 'I' in the mean
% equation, respectively.
%
% When 'IsConstantInMean' is TRUE, the first element of 'Paramaters' will 
% house the constant 'C'. When 'IsConstantInMean' is FALSE, the constant 'C' 
% is NOT included in the input vector 'Paramaters'.
%
% Similarly, when 'IsVarianceInMean' is TRUE, this indicates that the 'Paramaters'
% vector will contain an element reserved for the variance-in-mean coefficient 'I'
% in the above mean equation. When 'IsVarianceInMean' is FALSE, this indicates 
% that the 'Paramaters' vector will NOT allocate an element for the variance-in-mean 
% coefficient.
%
% For example, consider the following equations for the conditional mean 
% and variance of an ARMAX(R=2,M=2,nX=1)/GARCH(P=2,Q=2) composite model:
%
%   y(t) =  1.3 + 0.5y(t-1) - 0.8y(t-2) + e(t) - 0.6e(t-1) + 0.08e(t-2) + 1.2X(t)
%   h(t) =  0.5 + 0.2h(t-1) + 0.1h(t-2) + 0.3e(t-1)^2 + 0.2e(t-2)^2
%
% For this example, we would have
%
%   IsConstantInMean = logical(1) (i.e., TRUE)
%   IsVarianceInMean = logical(0) (i.e., FALSE)
%
% and the coefficient vector 'Parameters' would be
%
%   Parameters = [ C     AR(1:R)     MA(1:M)  B(1:nX)  K   GARCH(1:P)   ARCH(1:Q)]'
%              = [1.3   0.5 -0.8   -0.6 0.08    1.2   0.5    0.2 0.1     0.3 0.2 ]'
%
% Notice that the coefficient of e(t) in the conditional mean equation is
% defined to be 1, and is NOT included in 'Parameters' vector because it
% is not estimated.
%
% Now consider a Variance-In-Mean + ARMAX(R=2,M=2,nX=1)/GARCH(P=2,Q=2) composite model:
%
%   y(t) =  0.5y(t-1) - 0.8y(t-2) + e(t) - 0.6e(t-1) + 0.08e(t-2) + 1.2X(t) + 0.2h(t)
%   h(t) =  0.5 + 0.2h(t-1) + 0.1h(t-2) + 0.3e(t-1)^2 + 0.2e(t-2)^2
%
% Now we would have
%
%   IsConstantInMean = logical(0) (i.e., FALSE)
%   IsVarianceInMean = logical(1) (i.e., TRUE)
%
% and the coefficient vector 'Parameters' would be
%
%   Parameters = [ AR(1:R)     MA(1:M)  B(1:nX)  I    K   GARCH(1:P)   ARCH(1:Q)]'
%              = [0.5 -0.8   -0.6 0.08    1.2   0.2  0.5    0.2 0.1     0.3 0.2 ]'
%
% To actually infer the residuals {e(t)} and conditional variances {h(t)}, 
% the mean coefficients are modified to accommodate the inference. To do 
% this, the general conditional mean equation given above for y(t) is now 
% solved for e(t) as the dependent variable. The residuals are now inferred 
% from the following general conditional mean equation:
%
%   e(t) = -C + y(t) - AR(1)y(t-1) - ... - AR(R)y(t-R)   
%                    - MA(1)e(t-1) - ... - MA(M)e(t-M) 
%                    -  B(1)X(t,1) - ... - B(nX)X(t,nX) - Ih(t)
%
% Note that the input return series y(t) may have several columns in which
% each column represents a unique stochastic realization (i.e, each column
% is an independent path, or trial, of the process y(t)). In contrast, the 
% regression matrix X is NOT path-dependent in any way, and is simply a 
% known regression matrix applied to each realization of y(t).
%

%
% Determine the dimension of various arrays. 
%
%   Special Note:
% 
%     Throughout this M-file, and the associated C Mex file, the variable 'maxRMPQ' 
%     (i.e,. max([R M P Q]) is frequently found. This parameter, although not required, 
%     ensures that all time-tagged data arrays have common dimensions and, therefore, 
%     are indexed in an identical manner. 
% 
%     For example, when the optional inputs 'preInnovations', 'PreSigmas', and
%     'preSeries' are specified, they all have max([R M P Q]) rows. Similarly, the 
%     first max([R M P Q]) rows of the processes {y(t)}, {e(t)}, and {h(t)} are reserved 
%     for pre-sample observations. Please note that NOT all of these max([R M P Q]) rows 
%     will necessarily be used. 
% 
%     For example, the input return series {y(t)} requires, strictly speaking, only
%     R pre-sample observations, but will nonetheless be padded by max([R M P Q])
%     observations for convenience. Whenever the required number of pre-sample 
%     observations is less than max([R M P Q]), for any of the {y(t)}, {e(t)}, and 
%     {h(t)} processes, the required pre-sample observations will occupy the 
%     last (i.e., most recent in time) elements of the full pre-sample sub-array. 
% 
%     For example, assume max([R M P Q]) = 4, and that R = 2. This means that the 
%     conditional mean equation of the return series {y(t)} has a 2nd-order
%     auto-regressive component. In this case, the first 4 rows of each column of 
%     {y(t)} will be [x x y(t-2) y(t-1)], where "x" is any real-valued placeholder 
%     that never gets used.
% 
%     The same situation applies to the initial max([R M P Q]) rows of the output 
%     residuals {e(t)} and variances {h(t)} arrays. For the input regression 
%     matrix X(t), the initial max([R M P Q]) rows are all zero simply because no 
%     pre-sample observations are needed for explanatory data.
% 
%     Granted, this method of pre-sample storage and manipulation uses more memory 
%     than absolutely necessary, but increases code clarity and is, therefore, 
%     easier to understand and maintain. Basically, it's just very convenient!
% 
%     Upon return, the max([R M P Q]) initial rows of {e(t)} and {h(t)} must be stripped.
%

T       =  size(y,1);       % # of observations in each realization of y(t).
maxRMPQ =  max([R M P Q]);  % # of pre-sample observations used to infer {e(t)} and {h(t)}.

%
% Extract the ARMA coefficients of the conditional mean equation.
%
% Regardless of whether or not the constant 'C' is included in the input
% parameter vector, the length of the ARMA coefficient vector passed into
% the C-Mex inference routine will be (2 + R + M), and will be formatted
% as follows:
%
%   e(t) = -C + y(t) - AR(1)y(t-1) - ... - AR(R)y(t-R)   
%                    - MA(1)e(t-1) - ... - MA(M)e(t-M) 
%
% The only distinction is whether 'C' is extracted from the input parameter
% vector or hard-coded as an explicit zero.
%

if isConstantInMean
%
%  The constant 'C' is included, so negate it and place it in the first element.
%
   armaCoefficients  =  [-Parameters(1) ; 1 ; -Parameters(2:(1 + R + M))];
else
%
%  The constant 'C' is NOT included, so place a zero in the first element.
%
   armaCoefficients  =  [0 ; 1 ; -Parameters(1:(R + M))];
end

%
% Extract the regression coefficients of the conditional mean equation.
%

if isempty(X) | isnan(X)
%
%  The conditional mean has no regression component. Indicate the absence
%  of a regression component by the NaN sentinal value.
%
   nX                   =  0;    % # of explanatory variables in X.
   regressCoefficients  =  NaN;  % Interpret this as NOT APPLICABLE.
   X                    =  NaN;

else                   
%
%  General ARMAX(R,M,nX) form for conditional mean.
%
%  Extract the coefficients of the regression component of the conditional 
%  mean. When extracting the regression component, coefficients are ordered
%  as inferred from the following regression component of the conditional mean:
%
%  e(t) = -B(1)X(t,1) - ... - B(nX)X(t,nX)
%
%  Notice that the first max([R M P Q]) rows of X are padded with zeros as
%  discussed above.
%
   nX                   =  size(X,2);
   regressCoefficients  = -Parameters((isConstantInMean + R + M + 1):(isConstantInMean + R + M + nX)); 
   X                    =  [zeros(maxRMPQ,nX) ; X];

end

%
% Extract the variance-in-mean coefficient of the conditional mean 
% equation for GARCH-M models.
%

if isVarianceInMean
%
%  Negate the variance-in-mean coefficient to accommodate inference of residuals.
%
   varianceInMeanCoefficient  = -Parameters(isConstantInMean + R + M + nX + 1);
else
%
%  The conditional mean has no variance-in-mean component. Indicate the 
%  absence of a GARCH-M model by the NaN sentinal value.
%
   varianceInMeanCoefficient  =  NaN;  % Interpret this as NOT APPLICABLE.
end

%
% Extract the conditional variance coefficients. 
%

varianceCoefficients  =  Parameters((isConstantInMean + R + M + nX + isVarianceInMean + 1):end-1);

%
% Extract the degree-of-freedom (DoF) parameter of the T distribution.
%

DoF  =  Parameters(end);

%
% Determine if pre-sample observations of {y(t)}, {e(t)}, and {h(t)} have
% been specified. 
%

if (nargin < 10) | isempty([e0 ; s0 ; y0])

%
%  Pre-sample information has NOT been specified. In this case, pad the first 
%  max([R M P Q]) rows of {y(t)} with the sample mean of the corresponding column.
%
   [e , h]  =  garchllf(R , M , P , Q , [repmat(mean(y),maxRMPQ,1) ; y] , armaCoefficients    , ...
                                        varianceInMeanCoefficient       , regressCoefficients , ...
                                        varianceCoefficients            , X);
else

%
%  Use the specified pre-sample observations of {y(t)}, {e(t)}, and {h(t)}. 
%
   [e , h]  =  garchllf(R , M , P , Q , [y0 ; y]                  , armaCoefficients    , ...
                                        varianceInMeanCoefficient , regressCoefficients , ...
                                        varianceCoefficients      , X                   , ...
                                        e0                        , s0.^2);
end

%
% Strip off the initial max([R M P Q]) pre-sample values of e(t) and h(t), thus 
% restoring the row dimension of both e(t) and h(t) to the original T observations 
% per path.
%

e  =  e((maxRMPQ + 1):end , :);
h  =  h((maxRMPQ + 1):end , :);

%
% Evaluate the log-likelihood objective function. Note that LLF estimation thus
% ignores the initial max([R M P Q]) pre-sample values of h(t) and e(t)^2 used 
% for conditioning.
%
% Note: Although there is no theoretical upper limit to the degree-of-freedom
%       parameter 'DoF', the GAMMA function rapidly approaches infinity as
%       'DoF' increases. To prevent a NaN (i.e., infinity/infinity) condition, 
%       the upper limit of the T distribution DoF parameter is arbitrarily set 
%       to 200, well beyond the point at which T and Gaussian distributions 
%       are essentially identical.
%

if DoF <= 200
% 
%  T-distributed innovations.
%
   LogLikelihoods  =  0.5 * (log(h)  +  (DoF + 1) * log(1 + (e.^2)./(h * (DoF - 2))));
   LogLikelihoods  =  LogLikelihoods - log(gamma((DoF + 1)/2) / (gamma(DoF/2) * sqrt(pi * (DoF - 2))));
   LLF             =  sum(LogLikelihoods);

else
% 
%  Gaussian innovations.
%
   LogLikelihoods  =  0.5 * (log(2*pi*h) + (e.^2)./h);
   LLF             =  sum(LogLikelihoods);

end

%
% Convert the conditional variances to standard deviations for output purposes.
%

h  =  sqrt(h);

%
% Catch conditions that produce anomalous log-likelihood function values.
% Typically, what happens is that input parameter values will result in
% an unstable inverse filter, which produces LLF = inf. This, in turn, will
% not allow FMINCON to update the iteration. By setting the LLF to a large, 
% but finite, value, we can safeguard against anomalies and allows the 
% iteration to continue.
%

LLF(~isfinite(LLF))  =  1.0e+20;
LLF(~(~imag(LLF)))   =  1.0e+20;


G = [];  % Placeholder for forward compatibility.
H = [];  % Placeholder for forward compatibility.
