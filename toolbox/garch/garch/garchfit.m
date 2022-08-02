function varargout = garchfit(spec, y, X, e0, s0, y0)
%GARCHFIT Univariate GARCH process parameter estimation.
%   Given an observed univariate return series, estimate the parameters of a
%   conditional mean specification of ARMAX form and conditional variance 
%   specification of GARCH, EGARCH, or GJR form. The estimation process infers
%   the innovations from the return series and fits the model specification 
%   to the return series by maximum likelihood.
%
%   [Coeff,Errors,LLF,Innovations,Sigmas,Summary] = garchfit(Series)
%
%   [Coeff,Errors,LLF,Innovations,Sigmas,Summary] = garchfit(Spec, Series)
%   [Coeff,Errors,LLF,Innovations,Sigmas,Summary] = garchfit(Spec, Series, X,
%     PreInnovations, PreSigmas, PreSeries)
%
%   garchfit(...)
%
%   Optional Input: Spec, X, PreInnovations, PreSigmas, PreSeries
%
%   The first calling syntax is strictly a convenience form, modeling a return 
%   series as a constant plus GARCH(1,1) conditionally Gaussian innovations. 
%   For any models beyond this default (yet common) model, a specification 
%   structure, Spec, must be provided.
%
%   The second and third calling syntaxes allow the specification of much more 
%   elaborate models for the conditional mean and variance processes.
%
%   The last calling syntax (with no output arguments) will perform identical
%   estimation procedures as the first three, but will print the iterative 
%   optimization information to the MATLAB command window along with the final
%   parameter estimates and standard errors. It will also produce a tiered plot 
%   of the original return series as well as the innovations (i.e., residuals)
%   inferred, and the corresponding conditional standard deviations.
%
% Inputs:
%   Series - Time series column vector of observations of the underlying 
%     univariate return series of interest. Series is the response variable 
%     representing the time series fit to conditional mean and variance 
%     specifications. The last row of Series holds the most recent observation.
%
% Optional Inputs:
%   Spec - Structure specification for the conditional mean and variance models,
%     and optimization parameters. Spec is a structure with fields created by 
%     calling the function GARCHSET or GARCHFIT. Type "help garchset" for details.
%
%   X - Time series regression matrix of explanatory variable(s). Typically, X 
%     is a regression matrix of asset returns (e.g., the return series of an 
%     equity index). Each column of X is an individual time series used as an 
%     explanatory variable in the regression component of the conditional mean. 
%     In each column of X, the first row contains the oldest observation and 
%     the last row the most recent. If X is specified, the most recent number 
%     of valid (non-NaN) observations in each column of X must equal or exceed 
%     the most recent number of valid observations in Series. When the number 
%     of valid observations in each column of X exceeds that of Series, only 
%     the most recent observations of X are used. If empty or missing, the 
%     conditional mean will have no regression component.
%
%   PreInnovations - Time series column vector of pre-sample innovations (i.e.,
%     residuals) upon which the recursive mean and variance models are 
%     conditioned. This vector may have any number of rows, provided sufficient 
%     observations exist to initialize the mean and variance equations. Thus, if
%     M and Q are the number of lagged innovations required by the conditional 
%     mean and variance equations, respectively, then the PreInnovations vector
%     must have at least max(M,Q) rows. If the number of rows exceeds max(M,Q), 
%     then only the last (i.e., most recent) max(M,Q) rows are used as pre-sample
%     observations. 
%
%   PreSigmas - Time series column vector of positive pre-sample conditional 
%     standard deviations upon which the recursive variance model is conditioned.
%     This vector may have any number of rows, provided sufficient observations 
%     exist to initialize the conditional variance equation. Thus, if P and Q 
%     are the number of lagged conditional standard deviations and lagged 
%     innovations required by the conditional variance equation, respectively, 
%     then the PreSigmas vector must have at least P rows for GARCH and GJR 
%     models, and at least max(P,Q) rows for EGARCH models. If the number of 
%     rows exceeds the requirement, then only the last (i.e., most recent) rows
%     are used as pre-sample observations. 
%
%   PreSeries - Time series column vector of pre-sample observations of the 
%     return series of interest upon which the recursive mean model is 
%     conditioned. This vector may have any number of rows, provided sufficient 
%     observations exist to initialize the conditional mean equation. Thus, if 
%     R is the number of lagged observations of the return series required by 
%     the conditional mean equation, then the PreSeries vector must have at 
%     least R rows. If the number of rows exceeds R, then only the last (i.e., 
%     most recent) R rows are used as pre-sample observations. 
%
% Outputs:
%   Coeff - Structure containing the estimated coefficients. Coeff is of the 
%     same form as the Spec input structure, which allows other GARCH Toolbox 
%     functions (e.g., GARCHSET, GARCHGET, GARCHSIM, GARCHPRED, GARCHINFER) to
%     accept either Spec or Coeff seamlessly.
%
%   Errors - Structure containing the estimation errors (i.e., the standard 
%     errors) of the coefficients. Errors is of the same form as the Spec and 
%     Coeff structures. In the event an error occurs calculating the standard 
%     errors, all fields associated with estimated coefficients are set to NaN.
%
%   LLF - Optimized log-likelihood objective function value associated with the
%     parameter estimates found in Coeff. Optimization is performed by the 
%     FMINCON function of the Optimization Toolbox.
%
%   Innovations - Innovations (i.e., residuals) time series column vector 
%     inferred from the input Series. The size of Innovations is the same as
%     the size of Series. In the event of an error, Innovations will be a 
%     vector of NaN's.
%
%   Sigmas - Conditional standard deviation time series column vector 
%     corresponding to Innovations. The size of Sigmas is the same as the size 
%     of Series. In the event of an error, Sigmas will be a vector of NaN's.
%
%   Summary - Structure of summary information about the optimization process,
%     including convergence information, iterations, objective function calls,
%     active constraints, and the covariance matrix of coefficient estimates.
%
% Notes:
% (1) When specified, the PreInnovations, PreSigmas, and PreSeries time series
%     column vectors contain user-specified pre-sample observations used to 
%     infer the outputs Innovations and Sigmas. When these vectors are specified 
%     and necessary, they MUST be specified together. This is an all-or-nothing
%     approach. In other words, if a user chooses to provide pre-sample data, 
%     then ALL necessary pre-sample data for ALL 3 vectors must be specified.
% (2) Although PreInnovations, PreSigmas, and PreSeries are companion inputs,
%     there are circumstances in which one or more may be empty. For example, a
%     GARCH(0,Q) (i.e., an ARCH(Q)) model does not require lagged conditional 
%     variances, and thus PreSigmas could be empty ([]). Similarly, PreSeries 
%     is only necessary when the mean equation has an auto-regressive component.
% (3) If the conditional mean and/or conditional variance equation is not 
%     recursive in any way, then certain pre-sample information is unnecessary
%     to jump-start the model(s). However, specifying redundant pre-sample 
%     information is NOT an error, and any pre-sample observations specified 
%     for models that require no such information are simply ignored.
% (4) When specified, the PreInnovations, PreSigmas, and PreSeries pre-sample 
%     vectors form the conditioning set used to initiate the inverse filtering, 
%     or inference, process. When no explicit pre-sample data is provided, the
%     necessary pre-sample observations are derived by conventional time series 
%     techniques as outlined in the GARCH Toolbox User's Guide.
%
% See also GARCHSET, GARCHSIM, GARCHPRED, GARCHINFER, FMINCON.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.11.4.4 $   $Date: 2004/04/06 01:10:06 $

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
%   Engle, R.F. (1982), "Autoregressive Conditional Heteroskedasticity 
%     with Estimates of the Variance of United Kingdom Inflation", 
%     Econometrica, vol. 50, pp. 987-1007.
%
%   Engle, R.F., Lilien, D.M., Robins, R.P. (1987), "Estimating Time Varying 
%     Risk Premia in the Term Structure: The ARCH-M Model", Econometrica, 
%     vol. 59, pp. 391-407.
%
%   Glosten, L.R., Jagannathan, R., Runkle, D.E. (1993), "On the Relation between 
%     Expected Value and the Volatility of the Nominal Excess Return on Stocks", 
%     The Journal of Finance, vol.48, pp. 1779-1801.
%
%   Hamilton, J.D., "Time Series Analysis", Princeton University Press, 1994.
%
%   Nelson, D.B., "Conditional Heteroskedasticity in Asset Returns: A New 
%     Approach", Econometrica, vol. 59, pp. 347-370.
%

%
% Check input arguments. The single input case must specify a 
% valid numeric vector of returns. For the multiple input case, 
% the first input must be a specification structure.
%

switch nargin
   case 1
     if isnumeric(spec)
        y    =  spec;
        spec =  garchset;       % Allow a convenience/default model form.
     else
        error('GARCH:garchfit:UnspecifiedSeries' , ' Observed return series ''Series'' must be specified.');
     end

   case {2 , 3 , 4 , 5 , 6}
     if ~isstruct(spec)
        error('GARCH:garchfit:NonStructureInput' , ' ''Spec'' must be a structure.');
     end
%
%    Scrub the input specification structure. This automatically upgrades 
%    any GARCH Toolbox version 1.0 specification structures, and avoids any 
%    constraint violations associated with user-specified initial guesses 
%    or non-convergent structures gotten from previous GARCHFIT calls.
%
     spec = garchset(spec);

   otherwise
     error('GARCH:garchfit:TooManyInputs' , ' Too many inputs specified.');
end

%
% Scrub the observed return series vector y(t).
%
% For backward compatibility, allow for the possibility of a row vector 
% as an input return series.
%
% Although this is technically inconsistent with the documentation, the
% presence of a row vector is deemed sufficiently unambiguous and is
% interpreted as a single realization of a univariate time series (as 
% opposed to multiple realizations of a univariate time series with
% only a single observation in each realization, which just does not
% make sense!).
%

if prod(size(y)) == length(y)   % Check for a vector (single return series).
   rowY  =  size(y,1) == 1;     % Flag a row vector for outputs.
   y     =  y(:);               % Convert to a column vector.
else
   error('GARCH:garchfit:NonVectorSeries' , ' Observed return series ''Series'' must be a column vector.');
end

%
%  The following code segment assumes that missing observations are indicated
%  by the presence of NaN's. Any initial rows with NaN's are removed, and 
%  processing proceeds with the remaining block of contiguous non-NaN rows. 
%  Put another way, NaN's are allowed, but they MUST appear as a contiguous 
%  sequence in the initial rows of the y(t) vector.
%

i1  =  find(isnan(y));
i2  =  find(isnan(diff([y ; zeros(1,size(y,2))]) .* y));

if (length(i1) ~= length(i2)) | any(i1 - i2)
   error('GARCH:garchfit:MissingData' , ' Only initial observations in ''Series'' may be missing (NaN''s).')
end

if any(sum(isnan(y)) == size(y,1))
   error('GARCH:garchfit:AllMissingData' , ' A realization of ''Series'' is completely missing (all NaN''s).')
end

firstValidRow  =  max(sum(isnan(y))) + 1;
y              =  y(firstValidRow:end , :);

%
% Scrub the regression matrix and ensure the observed return series vector y(t) 
% and the regression matrix X(t) have the same number of valid (i.e., non-NaN)
% rows (i.e., impose time index compatibility). During estimation, the innovations
% process e(t) must be inferred from the conditional mean specification, which 
% may include a regression component if desired. In contrast to simulation, 
% estimation of the innovations process e(t) is NOT independent of X. 
%

if (nargin >= 3) & ~isempty(X)

   if prod(size(X)) == length(X)   % Check for a vector.
      X  =  X(:);                  % Convert to a column vector.
   end

%
%  Retain the last contiguous block of non-NaN (i.e, non-missing valued) observations only. 
%
   if any(isnan(X(:)))
      X  =  X((max(find(isnan(sum(X,2)))) + 1):end , :);
   end

   if size(X,1) < size(y,1)
      error('GARCH:garchfit:NotEnoughData' , ' Regression matrix ''X'' has insufficient number of observations.');
   else
      X  =  X(size(X,1) - (size(y,1) - 1):end , :);    % Retain only the most recent samples.
   end

%
%  Ensure number of regression coefficients (if specified) match number of regressors.
%
   regress  =  garchget(spec , 'Regress');             % Regression coefficients.

   if ~isempty(regress)
      if size(X,2) ~= length(garchget(spec , 'Regress'))
         error('GARCH:garchfit:InputMismatch' , ' Number of ''Regress'' coefficients unequal to number of regressors in ''X''.');
      end
   end

else

   X        =  [];   % Ensure X exists.
   regress  =  [];

end

nX  =  size(X,2);    % Record the number of regressors.

%
% Extract model orders & coefficients.
%

R        =  garchget(spec , 'R');        % Conditional mean AR order.
M        =  garchget(spec , 'M');        % Conditional mean MA order.
P        =  garchget(spec , 'P');        % Conditional variance order for lagged variances.
Q        =  garchget(spec , 'Q');        % Conditional variance order for lagged residuals.

C        =  garchget(spec , 'C');        % Conditional mean constant.
AR       =  garchget(spec , 'AR');       % Conditional mean AR coefficients.
MA       =  garchget(spec , 'MA');       % Conditional mean MA coefficients.

K        =  garchget(spec , 'K');        % Conditional variance constant.
GARCH    =  garchget(spec , 'GARCH');    % Conditional variance coefficients for lagged variances.
ARCH     =  garchget(spec , 'ARCH');     % Conditional variance coefficients for lagged residuals.
Leverage =  garchget(spec , 'Leverage'); % Leverage coefficients for asymmetric EGARCH and GJR models.

%
% Set a Boolean flag to indicate whether the mean equation will include a constant.
%

if isnan(garchget(spec , 'C'))
   isConstantInMean  =  logical(0);      % Do NOT included a constant.
else
   isConstantInMean  =  logical(1);      % Included a constant.
end

%
% Ensure the variance model specification is complete.
%
% SPECIAL NOTE ON UNDOCUMENTED FEATURES: Variance-in-Mean Models
%
% The presence of an appended dash (i.e., '-') in the 'VarianceModel' field 
% is an indication that the conditional variance is included as an explanatory 
% variable in the conditional mean equation. 
%
% Please note that inference/estimation of residuals in the presence of 
% variance-in-mean conditions is allowed ONLY for conditional variance models 
% of GARCH-M form. In other words, inference of variance-in-mean models is 
% allowed ONLY if the conditional variance equation is described by a GARCH(P,Q) 
% model. Conditional variances derived from EGARCH(P,Q) and GJR(P,Q) variance 
% models are NOT allowed to enter the mean equation for inference/estimation 
% purposes. This is in contrast to simulation applications, in which variance-in-mean
% models are allowed for GARCH-M, EGARCH-M, and GJR-M models.
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
% in the conditional mean equation. For inference/estimation purposes, the 
% 'InMean' parameter field is applicable ONLY to GARCH-M models.
%
% Again, inference/estimation of GARCH-M models is an UNDOCUMENTED feature!
%

varianceModel  =  garchget(spec , 'VarianceModel');

[varianceModel , InMeanString] = strtok(varianceModel , '-');

isVarianceInMean = ~isempty(InMeanString);       % Set a Boolean flag (1 = include variance-in-mean).
InMean           =  garchget(spec , 'InMean');   % Get the variance-in-mean coupling coefficient.

if isVarianceInMean
   if ~any(strcmp(upper(varianceModel) , {'GARCH' 'CONSTANT'}))
      error('GARCH:garchfit:InvalidFunctionality' , ' EGARCH-M and GJR-M variance-in-mean models are NOT allowed.');
   end
end

%
% Determine whether valid pre-sample information is specified and necessary.
%
% Let y(t) = return series of interest (assumed stationary)
%     e(t) = innovations of the model noise process (assumed invertible)
%     h(t) = conditional variance of the innovations process e(t)
%
% Set a Boolean convenience flag to indicate the absence of user-specified
% pre-sample conditioning information:
%
% isPreSampleMissing = 1 ---> Pre-sample data missing
%                    = 0 ---> Pre-sample data provided by the user
% Notes:
% (1) By default, no pre-sample conditioning information is assumed.
%     This implies that the inference routines auto-generate their own
%     pre-sample information via standard time series techniques.
% (2) Notice that pre-sample information is really only needed to 
%     jump-start recursive conditional mean and/or variance models. 
%     If neither the conditional mean nor conditional variance equation 
%     is recursive in any way, then no pre-sample information is needed 
%     to jump-start the models. In this case, specifying pre-sample 
%     information is redundant, but NOT an error, and any pre-sample 
%     observations specified for models that require no such information 
%     are simply ignored. 
% (3) If pre-sample data is specified, we require at least R pre-sample 
%     lags of y(t), at least max(M,Q) pre-sample lags of e(t), and at 
%     least P pre-sample lags of h(t) for GARCH & GJR conditional 
%     variance models, but max(P,Q) pre-sample lags of h(t) for EGARCH 
%     conditional variance models.
%

isPreSampleMissing  =  logical(1);  % Initialize to 'Missing User-Specified Pre-Sample Data'.

if (nargin >= 4)
%
%  Determine the number of pre-sample conditional standard deviations required.
%
   if strcmp(upper(varianceModel) , 'EGARCH')
%
%    'EGARCH' volatility models require at least max(P,Q) pre-sample 
%     observations of conditional standard deviations.
%
      nSTDs  =  max([P Q]);

   else
%
%    'GARCH', 'GJR', and 'Constant' volatility models require at least P
%     pre-sample observations of conditional standard deviations ('Constant'
%     volatility models will have P = 0).
%
      nSTDs  =  P;

   end
%
%  Determine which pre-sample information is required. If any pre-sample
%  data is needed, then update the missing pre-sample data flag.
%
   preInnovationsNeeded  =  logical(0);
   preSigmasNeeded       =  logical(0);
   preSeriesNeeded       =  logical(0);

   if (max([M Q]) > 0)
      preInnovationsNeeded =  logical(1);
      isPreSampleMissing   =  logical(0);  % Pre-sample data provided.
   end

   if (nSTDs > 0)
      preSigmasNeeded    =  logical(1);
      isPreSampleMissing =  logical(0);    % Pre-sample data provided.
   end

   if (R > 0)
      preSeriesNeeded    =  logical(1);
      isPreSampleMissing =  logical(0);    % Pre-sample data provided.
   end

end

%
% If pre-sample conditioning observations are provided, then scrub the 
% pre-sample data. 
%
% In the error checking that follows, notice that the column oriented
% nature of a time series is strictly enforced. For this reason, each 
% pre-sample input {e0, s0, y0} MUST be a column vector.
%

if isPreSampleMissing

%
%  If no pre-sample data is provided, then initialize ALL the pre-sample
%  arrays to empty matrices. This is done simply so that calls to the
%  log-likelihood objective functions have the same calling syntax.
%
   preInnovations  =  [];
   preSigmas       =  [];
   preSeries       =  [];

else

%
%  Pre-allocate the pre-sample data arrays. Notice that all pre-sample 
%  conditioning arrays, if provided, MUST have max([R M P Q]) rows for 
%  time index compatibility. This is required by the log-likelihood 
%  objective functions.
%
   maxRMPQ  =  max([R M P Q]);      % # of rows in pre-sample arrays
   nPaths   =  size(y , 2);         % # of columns in pre-sample arrays (MUST be 1 for estimation!)

   preInnovations  =  zeros(maxRMPQ , nPaths);
   preSigmas       =  ones (maxRMPQ , nPaths);  % Set to 1's to prevent incorrectly trapping errors below.
   preSeries       =  zeros(maxRMPQ , nPaths);

%
%  Scrub any required pre-sample conditioning information for the innovations e(t).
%
   if preInnovationsNeeded
      [preInnovations, message]  =  presamplecheck(preInnovations, 'PreInnovations', e0, max([M Q]));
      error(message);
   end
%
%  Scrub any required pre-sample conditioning information 
%  for the conditional standard deviations.
%
   if preSigmasNeeded

      if nargin >= 5
         [preSigmas, message]  =  presamplecheck(preSigmas, 'PreSigmas', s0, nSTDs);
         error(message);
      else
         error('GARCH:garchfit:UnspecifiedPreSigmas' , ' ''PreSigmas'' array must be specified.');
      end

      if any(preSigmas(:) <= 0)
         error('GARCH:garchfit:NonPositivePreSigmas' , ' All required ''PreSigmas'' standard deviations must be positive.');
      end

   end
%
%  Scrub any required pre-sample conditioning information for the return series y(t).
%
   if preSeriesNeeded

      if nargin >= 6
         [preSeries, message]  =  presamplecheck(preSeries, 'PreSeries', y0, R);
         error(message);
      else
         error('GARCH:garchfit:UnspecifiedPreSeries' , ' ''PreSeries'' array must be specified.');
      end

   end

end

%
% Set a 'Display' flag to determine if any warnings or 
% messages should be printed to the screen to alert users.
%

DisplayFlag  =  garchget(spec , 'Display');
DisplayFlag  =  strcmp(DisplayFlag(~isspace(DisplayFlag)) , 'on');

%
% Generate initial parameter estimates if necessary. Note that the code below
% adopts an 'all or nothing' approach for model specifications.
%
% That is, if a user provides parameter values either as 
%
%  (1) Initial guesses for refinement during the optimization process, or as
%  (2) Equality constraints in which some of the parameters are held fixed 
%      and some are refined
%
% then the parameter specification MUST be complete. 
%
% The only flexibility regarding model specification is that the conditional
% mean and variance models are treated separately. For example, a user may 
% provide initial values for the conditional mean parameters, and allow the 
% code to provide initial values for conditional variance parameters.
%

%
% Initialize conditional mean parameter estimates if necessary. If an
% incomplete conditional mean specification is found (i.e., the user has
% NOT explicitly set ALL required coefficients for a given conditional mean 
% model), then compute initial estimates and over-write any pre-existing 
% parameters in the incomplete specification. This is an 'all or nothing' 
% approach for model specification.
%

isMeanComplete         =  logical(1);  % Initialize to a complete mean specification.
unconditionalVariance  =  [];          % Make sure it exists.

if isempty(X)

   if isempty(C) | (isempty(AR) & (R > 0)) | (isempty(MA) & (M > 0))
%
%     General ARMA conditional mean with no regression component.
%
      if isConstantInMean
%
%        Include an estimate of the mean equation constant 'C'.
%
         [AR , MA , C , unconditionalVariance]  =  arma0(y , R , M);

      else
%
%        Exclude the mean equation constant 'C' by first removing the 
%        mean from the observed return series.
%
         [AR , MA , dummy , unconditionalVariance]  =  arma0(y-mean(y) , R , M);

      end

      isMeanComplete  =  logical(0);   % Indicate an INCOMPLETE mean specification.

   end

else

   if M == 0        % Check for MA terms.

      if isempty(C) | (isempty(AR) & (R > 0)) | isempty(regress)
%
%        General ARX conditional mean model with no MA terms. Initial
%        estimates can be generated by a simple OLS regression.
%
         [C, AR, regress, residuals] = arx0(y, X, R, isConstantInMean);

         MA                     =  [];
         unconditionalVariance  =  var(residuals,1);

         isMeanComplete  =  logical(0);            % Indicate an INCOMPLETE mean specification.

      end

   else

      if isempty(C) | (isempty(AR) & (R > 0)) | isempty(MA) | isempty(regress)
%
%        General ARMAX conditional mean model. Proceed to 2 steps:
%
%        (1) Estimate an ARX model via OLS.
%        (2) Filter the OLS residuals as a pure MA process.
%
         [C    , AR, regress, residuals            ] =  arx0(y, X, R, isConstantInMean);
         [dummy, MA, dummy  , unconditionalVariance] = arma0(residuals , 0 , M);

         isMeanComplete  =  logical(0);            % Indicate an INCOMPLETE mean specification.

      end

   end

end

%
% In the absence of a user-specified initial estimate, account for a variance-in-mean 
% model by simply assuming the coefficient of conditional variance is zero. This
% guarantees that the first iteration through the objective function is well behaved.
%

if isVarianceInMean & (isempty(InMean) | ~isMeanComplete)
   InMean  =  0;
end

%
% In the event a complete mean specification is provided, use the conditional 
% mean parameters to estimate the unconditional variance of the inferred residuals 
% via GARCHINFER. 
%
% The following code segment creates a temporary specification structure from the 
% user-specified conditional mean parameters. However, we assume a simple constant
% unit variance (i.e., a GARCH(0,0)) model because we ONLY care about the inferred 
% the residuals via inverse filtering.
%

if isMeanComplete

   spec00  =  garchset('C', C, 'AR', AR, 'MA', MA, 'Regress', regress, 'InMean', InMean, 'K', 1);

   if isempty([preInnovations ; preSigmas ; preSeries])
      residuals  =  garchinfer(spec00, y, X);
   else
      residuals  =  garchinfer(spec00, y, X, preInnovations, preSigmas, preSeries);
   end

   unconditionalVariance  =  var(residuals,1);

end

%
% Create initial conditional variance parameter estimates if necessary.
% As for the conditional mean above, this is an 'all or nothing' approach
% for specification of the conditional variance.
%

isVarianceComplete  =  logical(1);           % Initialize flag to indicate a complete variance specification.

switch upper(varianceModel)

   case {'GARCH' 'CONSTANT'}

      if isempty(K) | (isempty(GARCH) & (P > 0)) | (isempty(ARCH) & (Q > 0))

         [K, GARCH, ARCH]  =  garch0(P, Q, unconditionalVariance);

         isVarianceComplete  =  logical(0);        % Indicate an INCOMPLETE variance specification.

      end

   case 'EGARCH'

      if isempty(K) | (isempty(GARCH) & (P > 0)) | (isempty(ARCH) & (Q > 0)) | (isempty(Leverage) & (Q > 0))

         [K, GARCH, ARCH, Leverage]  =  egarch0(P, Q, unconditionalVariance);

         isVarianceComplete  =  logical(0);        % Indicate an INCOMPLETE variance specification.

      end

   case 'GJR'

      if isempty(K) | (isempty(GARCH) & (P > 0)) | (isempty(ARCH) & (Q > 0)) | (isempty(Leverage) & (Q > 0))
%
%        Treat a GJR(P,Q) model as a GARCH(P,Q) model with zero leverage terms.
%
         [K, GARCH, ARCH]  =  garch0(P, Q, unconditionalVariance);

         Leverage  =  zeros(Q,1);

         isVarianceComplete  =  logical(0);        % Indicate an INCOMPLETE variance specification.

      end

end

%
% Get the probability distribution of the innovations process e(t) and
% initialize the degree-of-freedom (DoF) parameter. Note that DoF will 
% be empty for Gaussian residuals. For T-distributed residuals, it will
% be empty if no initial estimate is specified.
%

distribution    =  garchget(spec , 'Distribution');
distribution    =  distribution(~isspace(distribution));
isDistributionT =  strcmp(upper(distribution),'T');  % Set a flag to indicate a T distribution.

DoF  =  garchget(spec , 'DoF');                      % Degrees-of-Freedom for T-distributions.

if isDistributionT & isempty(DoF)
   DoF  =  5;      % No initial guess, so initialize to a modest value.
end

%
% Pre-allocate an equality constraint indicator vector for individual coefficients.
%

Fix  =  zeros(isConstantInMean + R + M + nX + isVarianceInMean + 1 + P + Q , 1);

if any(strcmp(upper(varianceModel) , {'EGARCH' 'GJR'}))
   Fix  =  [Fix ; zeros(Q,1)];             % Allow for Leverage terms.
end

Fix  =  [Fix ; zeros(isDistributionT,1)];  % Allow for T distributions.

%
% Set the Boolean equality constraint indicator vector. This indicator conveys 
% which individual parameters of the composite conditional mean and variance 
% models are held fixed at the corresponding value specified by the user. A one
% in an particular element indicates that the corresponding parameter is held
% fixed throughout the optimization process. For each element of Fix that is 
% a one, there will be a corresponding row in the equality constraint matrix 
% passed into the optimizer.
%

Fix  =  setEqualityConstraints(Fix, spec, nX, isMeanComplete, isVarianceComplete);

%
% Set optimization-related fields.
%

Optimization  =  optimset('fmincon');

if isinf(optimget(Optimization, 'MaxSQPIter'))
   Optimization  =  optimset(Optimization, 'MaxSQPIter', 1000 * garchcount(spec));
end

Optimization  =  optimset(Optimization , 'MaxFunEvals' , garchget(spec , 'MaxFunEvals') , ...
                                         'MaxIter'     , garchget(spec , 'MaxIter')     , ...
                                         'TolFun'      , garchget(spec , 'TolFun')      , ...
                                         'TolCon'      , garchget(spec , 'TolCon')      , ...
                                         'TolX'        , garchget(spec , 'TolX')      ) ;

if strcmpi(garchget(spec , 'Display') , 'off')
   Optimization  =  optimset(Optimization , 'Display'     , 'off');
   Optimization  =  optimset(Optimization , 'Diagnostics' , 'off');
else
   Optimization  =  optimset(Optimization , 'Display'     , 'iter');
   Optimization  =  optimset(Optimization , 'Diagnostics' , 'on');
end

Optimization  =  optimset(Optimization , 'LargeScale'  , 'off');

%
% Initialize a GLOBAL variable for convenience and code clarity. The 
% following tolerance parameter is needed because the numerical optimizer 
% allows linear and non-linear inequality constraints of the form A*x <= b 
% and C(x) <= 0, respectively. However, the inequality constraints of the
% GARCH Toolbox are of the form A*x < b and C(x) < 0. This tolerance 
% specifies how closely the estimated parameters may get to a particular 
% constraint, and is related to the maximum constraint violation tolerance 
% parameter ('TolCon') of the Optimization Toolbox.
%
% Since the optimizer requires that objective and non-linear constraint 
% functions share the same problem-dependent input arguments, the tolerance 
% parameter is declared as a global variable to prevent passing irrelevant 
% inputs into the objective functions.
%

global GARCH_TOLERANCE
GARCH_TOLERANCE  =  2*optimget(Optimization , 'TolCon', 1e-7);

%
% The initial input parameter guess vector 'x0' to FMINCON and the estimated 
% parameter vector 'coefficient' output from FMINCON are formatted exactly as
% the coefficients would be read from the conditional mean and variance 
% equations. The formatting is as follows:
%
%   Coefficient
%   -----------
%       C               Scalar mean equation constant (present ONLY when 'isConstantInMean' = 1)
%     AR(1:R)           R auto-regressive coefficients
%     MA(1:M)           M moving average coefficients
% Regress(1:nX)         Regression coefficients
%     InMean            Variance-in-mean coefficient (GARCH models ONLY, and present ONLY when 'isVarianceInMean' = 1)
%       K               Scalar variance equation constant 
%   GARCH(1:P)          P coefficients of lagged conditional variances
%    ARCH(1:Q)          Q coefficients of lagged innovations
% Leverage(1:Q)         Q coefficients of leverage (EGARCH and GJR variance models ONLY)
%      DoF              Scalar degree-of-freedom coefficient (T distributions ONLY)
%
% As an example, let
%
%     y(t) = return series of interest (assumed stationary)
%     e(t) = innovations of the model noise process (assumed invertible)
%     h(t) = conditional variance of the innovations process e(t)
%
% Consider the following equations for the conditional mean and variance of 
% an ARMAX(R=2,M=2,nX=1)/GARCH(P=2,Q=2) composite model:
%
%   y(t) =  1.3 + 0.5y(t-1) - 0.8y(t-2) + e(t) - 0.6e(t-1) + 0.08e(t-2) + 1.2X(t)
%   h(t) =  0.5 + 0.2h(t-1) + 0.1h(t-2) + 0.3e(t-1)^2  +  0.4e(t-2)^2
%
% In this example, the coefficient vector would be formatted as
%
%   Coefficient = [ C     AR(1:R)     MA(1:M)  B(1:nX)  K   GARCH(1:P)   ARCH(1:Q)]'
%               = [1.3   0.5 -0.8   -0.6 0.08    1.2   0.5    0.2 0.1     0.3 0.4 ]'
%
% Notice that the coefficient of e(t) in the conditional mean equation is
% defined to be 1, and is NOT included in the vector because it is not estimated.
%

x0  =  [repmat(C,isConstantInMean,1)      ; AR(:) ;    MA(:) ; regress(:) ; 
        repmat(InMean,isVarianceInMean,1) ;  K    ; GARCH(:) ;    ARCH(:) ; Leverage(:) ; DoF];   % Initial guess.

%
% Identify the objective and non-linear constraint functions, and compute
% the linear constraints (including lower & upper bounds).
%
% Notice that the log-likelihood objective function is dependent upon the
% probability distribution, while the non-linear constraint function is not. 
%
% Also, notice that GARCH and GJR variance models share the same non-linear constraints.
%

switch upper(varianceModel)

   case {'GARCH' , 'CONSTANT'}    % GARCH(0,0) and Constant variance models are the same thing.

      if isDistributionT
         objectiveFunction  =  @garchllft;
      else
         objectiveFunction  =  @garchllfn;
      end

      nonLinearConstraintFunction =  @armanlc;
      [LB, UB, A, b, Aeq, beq]    =  garchlc(R, M, P, Q, nX, isConstantInMean, isDistributionT, Fix, x0, isVarianceInMean);

   case 'EGARCH'

      if isDistributionT
         objectiveFunction  =  @egarchllft;
      else
         objectiveFunction  =  @egarchllfn;
      end

      nonLinearConstraintFunction =  @egarchnlc;
      [LB, UB, A, b, Aeq, beq]    =  egarchlc(R, M, P, Q, nX, isConstantInMean, isDistributionT, Fix, x0);

   case 'GJR'

      if isDistributionT
         objectiveFunction  =  @gjrllft;
      else
         objectiveFunction  =  @gjrllfn;
      end

      nonLinearConstraintFunction =  @armanlc;
      [LB, UB, A, b, Aeq, beq]    =  gjrlc(R, M, P, Q, nX, isConstantInMean, isDistributionT, Fix, x0);

   otherwise
      error('GARCH:garchfit:UnknownModel' , ' Unknown conditional variance model.')

end

%
% Initialize the optimization-related warning message to an empty
% string, then update later on with an appropriate warning if necessary.
%

warningMessage  =  '';

%
% Perform constrained non-linear optimization. 
%
% Notice that warnings are temporarily disabled to hide any warnings 
% related to explosive or undefined log-likelihood objective function 
% calculations that result from constraint violations during the 
% optimization. Such situations are trapped inside the objective 
% function and handled gracefully.
% 

state = warning;
warning('off')

[coefficients, LLF   , ...
 exitFlag    , output, lambda] =  fmincon(objectiveFunction          , x0              , ...
                                          A                          , b               , ...
                                          Aeq                        , beq             , ...
                                          LB                         , UB              , ...
                                          nonLinearConstraintFunction, Optimization    , ...
                                          y                          , R               , ...
                                          M                          , P               , ...
                                          Q                          , X               , ...
                                          isConstantInMean           , isVarianceInMean, ...
                                          preInnovations             , preSigmas       , preSeries);

warning(state)

%
% Examine the log-likelihood objective function (LLF) value for a likely
% pre-mature convergence situation. When LLF = 1.0e+20, this indicates an 
% error-trapped condition (see the M-file referenced by 'objectiveFunction').
%

if abs(LLF - 1.0e+20) < eps
   warningMessage  =  'Possible Invalid Convergence: Estimates May Be Inaccurate';
   if DisplayFlag | (nargout == 0)
      fprintf('%s\n%s\n' , ' ' , [warningMessage '.']);
   end
end

%
% Negate objective function value (FMINCON is a minimizer!).
%

LLF  =  -LLF;

%
% Examine the optimization exit condition and print a message if needed.
%

if exitFlag == 0

   convergeMessage  =  'Maximum Function Evaluations or Iterations Reached';
   if DisplayFlag | (nargout == 0)
      fprintf('%s\n' , ' ' , [convergeMessage '.']);
   end

elseif exitFlag < 0

   convergeMessage  =  'Function Did NOT Converge';
   if DisplayFlag | (nargout == 0)
      fprintf('%s\n' , ' ' , [convergeMessage '.']);
   end

elseif exitFlag > 0
%
%  If successful convergence is indicated, then ensure that no
%  small lower/upper bound constraint violations exist. This 
%  adjustment ensures that individual parameters will always 
%  be within the bounds by setting each parameter that violates 
%  its lower or upper bound by less than TolCon to the appropriate 
%  lower/upper bound. Note that this adjustment provides a safety 
%  net, and should occur only rarely.
%
   convergeMessage  =  'Function Converged to a Solution';
   
   TolCon  =  garchget(spec , 'TolCon');

   isLowerBoundViolation = ( ((coefficients - LB) < 0) & ((LB - coefficients) <= TolCon) );
   isUpperBoundViolation = ( ((coefficients - UB) > 0) & ((coefficients - UB) <= TolCon) );

   coefficients(isLowerBoundViolation)  =  LB(isLowerBoundViolation);
   coefficients(isUpperBoundViolation)  =  UB(isUpperBoundViolation);

end

%
% Update the equality constraint 'Fix' fields related to individual parameters. 
% This is necessary because, although the user may incrementally specify values 
% for parameters and indicate that a given parameter is to be held fixed during
% the estimation, holding any parameter fixed is ONLY allowed if the mean or
% variance equation is COMPLETELY specified.
%
% Without the following code segment, the output COEFF & ERRORS structures would
% inherit the (possibly incomplete) input equality constraint information. Subsequent 
% display via GARCHDISP would then indicate that a given parameter was held fixed 
% when, in fact, it was actually estimated because the request for holding a 
% parameter fixed was ignored due to an incomplete model initial parameter 
% specification.
%
% Notice that the input SPEC structure is modified prior to formatting the output
% COEFF & ERRORS structures. Since the input SPEC structure is already guaranteed 
% to be consistent and in compliance with all parameter constraints, this prevents
% GARCHSET from flagging an error condition in the event any constraints were 
% violated during the estimation process. In other words, if the estimation 
% structure COEFF is in violation of any constraints, then calling GARCHSET with
% COEFF would error out.
%

if ~isMeanComplete
   spec  =  garchset(spec, 'FixC', [], 'FixAR', [], 'FixMA', [], 'FixRegress', [], 'FixInMean', []);
end

if ~isVarianceComplete
   spec  =  garchset(spec, 'FixK', [], 'FixGARCH', [], 'FixARCH', [], 'FixLeverage', []);
end

%
% Format the output specification structure for further processing.
%

coeff  =  packCoefficients(spec, coefficients, nX);

%
% Record any non-default-valued optimization parameters so users may
% reproduce previous estimation results. Notice that SPEC will encapsulate
% any non-default optimization information, while (at this point) COEFF
% will have only default optimization information.
%

if ~isequal(garchget(coeff,'Display') , garchget(spec,'Display'))
   coeff.Display  =  garchget(spec,'Display');
end
if ~isequal(garchget(coeff,'MaxFunEvals') , garchget(spec,'MaxFunEvals'))
   coeff.MaxFunEvals  =  garchget(spec,'MaxFunEvals');
end
if ~isequal(garchget(coeff,'MaxIter') , garchget(spec,'MaxIter'))
   coeff.MaxIter  =  garchget(spec,'MaxIter');
end
if ~isequal(garchget(coeff,'TolCon') , garchget(spec,'TolCon'))
   coeff.TolCon  =  garchget(spec,'TolCon');
end
if ~isequal(garchget(coeff,'TolFun') , garchget(spec,'TolFun'))
   coeff.TolFun  =  garchget(spec,'TolFun');
end
if ~isequal(garchget(coeff,'TolX') , garchget(spec,'TolX'))
   coeff.TolX  =  garchget(spec,'TolX');
end

%
% Call GARCHSET to guarantee that no constraint violations exist. 
%

try
%
%  Perform constraint violation error checking.
%
   comment =  garchget(coeff, 'Comment');  % Save the comment to retain the number of regressors.
   coeff   =  garchset(coeff);
   coeff.Comment = comment;                % Restore the comment (a question mark '?' would have been inserted).

catch
%
%  A constraint violation has occurred, so create warning and 
%  convergence messages and update the exit flag to formally 
%  indicate a lack of convergence.
%
   warningMessage  =  lasterr;   % Store the violation.
   iStart          =  findstr(warningMessage, 'garchset') + length('garchset');
   warningMessage  =  warningMessage(iStart:end);
   warningMessage  =  fliplr(deblank(fliplr(warningMessage)));

   if DisplayFlag | (nargout == 0)
      fprintf('%s\n%s\n' , ' ' , warningMessage);
   end

   convergeMessage =  'Function Did NOT Converge';

   if (DisplayFlag | (nargout == 0)) & (exitFlag > 0)
      fprintf('%s\n%s\n' , ' ' , [convergeMessage '.']);
   end

   exitFlag  =  -1;
   
end

%
% Compute the variance-covariance matrix of the parameter 
% estimates and extract the standard errors of the estimation.
%

if (nargout >= 2) | (nargout == 0)

   try
      covarianceMatrix = varcov(objectiveFunction, coefficients    , y, R, M, P, Q, X, Fix, ...
                                isConstantInMean , isVarianceInMean,                        ...
                                preInnovations   , preSigmas       , preSeries);
   catch
%
%     Indicate an error in computing the error covariance matrix
%     by creating a matrix of NaN's.
%
      covarianceMatrix = repmat(NaN, length(coefficients), length(coefficients));

   end

   standardErrors  =  sqrt(diag(covarianceMatrix))';
   errors          =  packCoefficients(spec, standardErrors, nX);

else

   errors  =  [];   % Make sure this exists for packing into varargout (see below).
   
end

%
% Return the innovations and conditional standard deviation vectors if
% requested.
%

if (nargout >= 4) | (nargout == 0)
%
%  If an error occurs inferring the innovations and conditional standard
%  deviations, then create output vectors of NaN's of appropriate size.
%
   try
	   
      if isempty([preInnovations ; preSigmas ; preSeries])
         [innovations, sigmas]  =  garchinfer(coeff, y, X);
      else
         [innovations, sigmas]  =  garchinfer(coeff, y, X, preInnovations, preSigmas, preSeries);
      end 
	 
   catch
	   
	  innovations  =  repmat(NaN, size(y));
	  sigmas       =  repmat(NaN, size(y));

   end
   
else
	
   innovations  =  [];   % Make sure they exist for packing into varargout (see below).
   sigmas       =  [];
   
end

%
%  Flag any boundary constraints enforced EXCEPT LINEAR EQUALITY CONSTRAINTS
%  specifically requested by the user. Whenever any constraints (excluding
%  linear equalities) are imposed, the log-likelihood function will probably NOT
%  be approximately quadratic at the solution. In this case, the standard errors
%  of the parameter estimates are unlikely to be accurate. However, if the ONLY
%  constraints are the linear equalities imposed by the user, then the resulting
%  log-likelihood value LLF may still be useful for post-fit assessment and
%  inference tests, such as likelihood ratio tests (LRT's).
%

TolCon = optimget(Optimization , 'TolCon', 1e-7);

if (norm([lambda.lower(:) ; lambda.upper(:) ; lambda.ineqlin(:) ; lambda.ineqnonlin(:)] , 1) > TolCon)
   constraintMessage  =  'Boundary Constraints Active: Standard Errors May Be Inaccurate';
   if (DisplayFlag & (nargout >= 2)) | (nargout == 0)
      fprintf('%s\n' , ' ' , [constraintMessage '.']);
   end
else
   constraintMessage  =  'No Boundary Constraints';
end

%
% Return summary information if requested.
%

if nargout >= 6

   if isempty(warningMessage)
      warningMessage  =  'No Warnings';
   end

   summary.exitFlag       =  exitFlag;
   summary.warning        =  warningMessage;
   summary.converge       =  convergeMessage;
   summary.constraints    =  constraintMessage;
   summary.covMatrix      =  covarianceMatrix;
   summary.iterations     =  output.iterations;
   summary.functionCalls  =  output.funcCount;
   summary.lambda         =  lambda;              % Lagrange multipliers at the solution.

else
   summary  =  [];
end

%
% Re-format outputs for compatibility with the SERIES input. When 
% SERIES is input as a single row vector, then pass the outputs 
% as a row vectors. 
%

if rowY & (nargout >= 4)
   innovations  =  innovations(:).';
   sigmas       =  sigmas(:).';
end

%
% Perform the default no-output action: 
%
%  (1) Print the parameter estimates to the screen, and 
%  (2) Display the estimated residuals, conditional standard
%      deviations, and input raw return series.
%

if nargout == 0

   garchdisp(coeff, errors);
   garchplot(innovations, sigmas, y);

   disp(' ')
   fprintf('  Log Likelihood Value: %g\n\n' , LLF)

else
	
   varargout  =  {coeff, errors, LLF, innovations, sigmas, summary};
   
end

%
% Clean up GLOBAL workspace.
%

clear global GARCH_TOLERANCE

%
%   * * * * *  Helper function for variance-covariance matrix.  * * * * *
%

function covarianceMatrix = varcov(objectiveFunction, p0, y, R, M, P, Q, X, Fix, ...
                                   isConstantInMean , isVarianceInMean, e0,  s0, y0);
%VARCOV Covariance matrix of maximum likelihood parameter estimates.
%   This function uses the outer-product method to compute the error 
%   covariance matrix of parameters estimated by maximum likelihood. It 
%   is valid for maximum likelihood estimation only, and assumes that 
%   the peak of the log-likelihood objective function has been found 
%   within the interior of the allowable parameter space (i.e., no 
%   boundary constraints have been actively enforced).
%
%   V = varcov(ObjectiveFunction, Parameters, Series, R, M, P, Q, X, Fix,
%     IsConstantInMean, IsVarianceInMean, PreInnovations, PreSigmas, PreSeries)
%
% Inputs:
%   ObjectiveFunction - Function handle to the appropriate log-likelihood 
%     objective to be evaluated.
%
%   Parameters - Column vector of optimized maximum likelihood parameter 
%     estimates associated with fitting conditional mean and variance 
%     specifications to an observed return series Series. 
%
%   Series - Column vector of observations of the underlying univariate return
%     series of interest. Series is the response variable representing the time
%     series fit to conditional mean and variance specifications. The last row 
%     of Series holds the most recent observation of each realization.
%
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   M - Non-negative, scalar integer representing the MA-process order.
%
%   P - Non-negative, scalar integer representing the number of lagged
%     conditional variance included in the variance process.
%
%   Q - Non-negative, scalar integer representing the number of lagged 
%     innovations included in the variance process.
%
%   X - Time series regression matrix of explanatory variable(s). Typically, X 
%     is a regression matrix of asset returns (e.g., the return series of an 
%     equity index). Each column of X is an individual time series used as an 
%     explanatory variable in the regression component of the conditional mean. 
%     In each column of X, the first row contains the oldest observation and 
%     the last row the most recent. If empty or missing, the conditional mean 
%     will have no regression component
%
%   Fix - Boolean (0,1) vector the same length as Parameters. 0's indicate 
%     that the corresponding Parameter element has been estimated; 1's indicate 
%     that the corresponding Parameter element has been held fixed.
%
%   IsConstantInMean - Logical flag indicating whether or not the conditional
%     mean equation includes an additive scalar constant. A TRUE (i.e., 
%     logical(1)) value indicates the mean equation includes a constant
%     and a FALSE (i.e., logical(0)) value indicates that a constant is NOT
%     included in the mean equation.
%
%   IsVarianceInMean - Logical flag indicating whether or not the conditional
%     variance is included as an explanatory variable in the conditional mean
%     equation. A TRUE (i.e., logical(1)) value indicates a variance-in-mean
%     model and a FALSE (logical(0)) value indicates no variance-in-mean.
%
%   PreInnovations - Time series column vector of pre-sample innovations (i.e.,
%     residuals) upon which the recursive mean and variance models are 
%     conditioned. This vector must have MAX([R M P Q]) rows, in which the
%     last row holds the most recent observation.
%
%   PreSigmas - Time series column vector of positive pre-sample conditional 
%     standard deviations upon which the recursive variance model is conditioned.
%     This vector must have MAX([R M P Q]) rows, in which the last row holds 
%     the most recent observation.
%
%   PreSeries - Time series column vector of pre-sample observations of the 
%     return series of interest upon which the recursive mean model is 
%     conditioned. This vector must have MAX([R M P Q]) rows, in which the
%     last row holds the most recent observation.
%
% Outputs:
%   V - Variance-covariance matrix of the estimation errors associated with
%     parameter estimates obtained by maximum likelihood estimation (MLE). The
%     standard errors of the estimates are the square root of the diagonal 
%     elements. V is computed by the 'outer-product' method.
%
% Notes: 
%   (1) This is an internal helper function for GARCHFIT. No error checking 
%       is performed.
%   (2) When pre-sample information is provided, the inputs PreInnovations, 
%       PreSigmas, and PreSeries MUST ALL be of length MAX([R M P Q]). 
%       However, when no pre-sample information is provided, these input
%       will ALL be empty matrices (i.e., []).
%

% References:
%   Hamilton, J.D., "Time Series Analysis", Princeton University 
%     Press, 1994, pages 142-144, 660-661.
%

delta  =  1e-10;  % Offset for numerical differentiation.

%
% Evaluate the log-likelihood objective function at the final MLE 
% parameter estimates. In contrast to the optimization which is 
% interested in the scalar-valued objective function 'LLF', here 
% we are interested in the individual log-likelihood components 
% for each observation of y(t). The relationship between them
% 
%     LLF = -sum(LogLikelihoods)
%

[LLF, G, H,         ...
 residuals, sigmas, ...
 LogLikelihoods]    =  feval(objectiveFunction, p0, y, R, M, P, Q, X, ...
                             isConstantInMean , isVarianceInMean, e0, s0, y0);

g0  =  -LogLikelihoods;

%
% Initialize the perturbed parameter vector and the scores matrix. 
% For 'T' observations in y(t) and 'nP' parameters estimated via
% maximum likelihood, the scores array is a T-by-nP matrix.
%

pDelta  =  p0;
scores  =  zeros(length(y) , length(p0));

for j=1:length(p0)

   if ~Fix(j)

      pDelta(j)   =  p0(j) * (1+delta);
      dp          =  delta * p0(j);
%
%     Trap the case of a zero parameter value (i.e., p0(j) = 0).
%
      if dp == 0
         dp        =  delta;
         pDelta(j) =  dp;
      end

      [LLF, G, H,         ...
       residuals, sigmas, ...
       LogLikelihoods]    =  feval(objectiveFunction, pDelta, y, R, M, P, Q, X, ...
                                   isConstantInMean , isVarianceInMean, e0, s0, y0);

      gDelta      = -LogLikelihoods;

      scores(:,j) =  (g0 - gDelta) / dp;
      pDelta(j)   =  p0(j);

   end

end

%
% Invert the outer product of the scores matrix to get the 
% approximate variance-covariance matrix of the MLE parameters.
%
% Notes:
%  (1) The output covariance matrix will be a square, symmetric 
%      matrix with the same number of rows and columns as the
%      number of parameters known to the optimizer. This includes
%      parameters estimated as well as parameters held fixed as
%      equality constraints.
%  (2) Although parameters held fixed as equality constraints are
%      allocated space in the covariance matrix, they are NOT 
%      truly estimated. Thus, the rows and columns associated
%      with any parameters held fixed throughout the optimization 
%      are simply filled with zeros for dimensional consistency.
%      Zero-filling the rows and columns of equality constrained 
%      parameters is consistent in that the variance and covariance
%      of such parameters is zero.
%

try

%
%  Pre-allocate the output covariance matrix to the full size, but
%  then compute and record the variances and covariances associated 
%  with the rows and columns of ONLY the estimated parameters.
%
   covarianceMatrix      =  zeros(length(p0));
   j                     = ~logical(Fix);
   covarianceMatrix(j,j) =  pinv(scores(:,j)'*scores(:,j));

catch

%
%  If an error occurs in the calculation of the parameter estimation
%  variance-covariance matrix, than simply assign a matrix of all NaN's 
%  to indicate the presence of such an error condition.
%
   covarianceMatrix  =  repmat(NaN, length(p0),length(p0));

end

%
%   * * * * *  Helper function to extract parameters and  * * * * *
%              pack the output COEFF and ERROR structures.
%

function coeff = packCoefficients(spec, coefficients, nX)
%PACKCOEFFICIENTS Format GARCH Toolbox output estimation structures.
%   Given an existing GARCH Toolbox specification structure as a template, 
%   extract parameter and standard error estimates from an input vector and
%   format an output specification structure with the estimated data.
%
%   Coeff = packCoefficients(Spec, Parameters, NX)
%
% Inputs:
%   Spec - Structure specification for the conditional mean and variance 
%     models.
%
%   Parameters - Column vector of process parameters associated with fitting
%     conditional mean and variance specifications to an observed return 
%     series. This may be the estimated coefficients, or the associated 
%     standard errors.
%
%   NX - The number of explanatory variables in the regression matrix.
%
% Output:
%   Coeff - A GARCH Toolbox specification structure of the same form as the 
%     input structure Spec (see above) into which the estimated parameters
%     or standard errors have been placed.
%

%
% Extract the parameter estimates & equality constraints.
%
% Now pack the data into the output structure. Note that the output 
% structure is of the same form as the input structure. This allows 
% GARCHSET, GARCHGET, GARCHSIM, and GARCHPRED to accept either structure 
% seamlessly. 
%
% Strictly speaking, GARCHSET should be used to make the following
% assignments. However, GARCHSET performs error checking that may 
% produce unwanted errors if certain constraints are violated, so 
% simple assignment is used to avoid this possibility.
%

coefficients  =  coefficients(:)';   % Guarantee a row vector.

R  =  garchget(spec , 'R');          % Conditional mean AR order.
M  =  garchget(spec , 'M');          % Conditional mean MA order.
P  =  garchget(spec , 'P');          % Conditional variance order for lagged variances.
Q  =  garchget(spec , 'Q');          % Conditional variance order for lagged residuals.

%
% Set some logical flags.
%

if isnan(garchget(spec , 'C'))
   isConstantInMean  =  logical(0);  % Mean equation does NOT include a constant.
else
   isConstantInMean  =  logical(1);  % Mean equation includes a constant.
end

varianceModel  =  garchget(spec , 'VarianceModel');
[varianceModel , InMeanString] = strtok(varianceModel , '-');
isVarianceInMean = ~isempty(InMeanString);

distribution    =  garchget(spec , 'Distribution');
distribution    =  distribution(~isspace(distribution));
isDistributionT =  strcmp(upper(distribution),'T');  % Set a flag to indicate a T distribution.

%
% Initialize the output structure from the input template.
%

coeff  =  garchset('R', garchget(spec,'R'), 'M', garchget(spec,'M'),  'Distribution', distribution , ...
                   'P', garchget(spec,'P'), 'Q', garchget(spec,'Q'), 'VarianceModel', garchget(spec,'VarianceModel'));
%
% Now extract the input parameters from the vector and format the output structure.
%

if isConstantInMean
   coeff  =  garchset(coeff, 'C', coefficients(1), 'FixC', garchget(spec,'FixC'));
else
   coeff  =  garchset(coeff, 'C', NaN);
end

i1  =  isConstantInMean + 1;
i2  =  isConstantInMean + R;

if R > 0
   coeff.AR  =  coefficients(i1:i2);
   FixAR     =  garchget(spec,'FixAR');
   if ~isempty(FixAR)
      coeff.FixAR  =  FixAR;
   end
end

i1  =  i2 + 1;
i2  =  i2 + M;

if M > 0
   coeff.MA  =  coefficients(i1:i2);
   FixMA     =  garchget(spec,'FixMA');
   if ~isempty(FixMA)
      coeff.FixMA  =  FixMA;
   end
end

i1  =  i2 + 1;
i2  =  i2 + nX;

if nX > 0
   coeff.Regress  =  coefficients(i1:i2);
   FixRegress     =  garchget(spec,'FixRegress');
   if ~isempty(FixRegress)
      coeff.FixRegress  =  FixRegress;
   end
end

i2  =  i2 + isVarianceInMean;

if isVarianceInMean
   coeff.InMean  =  coefficients(i2);
   FixInMean     =  garchget(spec,'FixInMean');
   if ~isempty(FixInMean)
      coeff.FixInMean  =  FixInMean;
   end
end

i2  =  i2 + 1;

coeff.K  =  coefficients(i2);
FixK     =  garchget(spec,'FixK');
if ~isempty(FixK)
   coeff.FixK  =  FixK;
end

i1  =  i2 + 1;
i2  =  i2 + P;

if P > 0
   coeff.GARCH  =  coefficients(i1:i2);
   FixGARCH     =  garchget(spec,'FixGARCH');
   if ~isempty(FixGARCH)
      coeff.FixGARCH  =  FixGARCH;
   end
end

i1  =  i2 + 1;
i2  =  i2 + Q;

if Q > 0
   if any(strcmp(upper(varianceModel) , {'EGARCH' 'GJR'}))
      coeff.Leverage  =  coefficients(i1+Q:i2+Q);
      FixLeverage     =  garchget(spec,'FixLeverage');
      if ~isempty(FixLeverage)
         coeff.FixLeverage  =  FixLeverage;
      end
   end
   coeff.ARCH  =  coefficients(i1:i2);
   FixARCH     =  garchget(spec,'FixARCH');
   if ~isempty(FixARCH)
      coeff.FixARCH  =  FixARCH
   end
end

if isDistributionT
   coeff.DoF  =  coefficients(end);
   FixDoF     =  garchget(spec,'FixDoF');
   if ~isempty(FixDoF)
      coeff.FixDoF  =  FixDoF;
   end
end

%
% Update the 'Comment' field to reflect a regression component (but ONLY
% if the comment is auto-generated, indicated by the presence of a 
% trailing NULL).
%

comment =  garchget(coeff , 'Comment');

if any(comment == char(0))
   pOpen  =  findstr(comment, '(');
   pClose =  findstr(comment, ')');
   if ~isempty(pOpen) & ~isempty(pClose) 
      commas  =  findstr(comment(pOpen(1):pClose(1)) , ',');
      if length(commas) == 1
         coeff.Comment =  [comment(1:pClose(1)-1) ',' num2str(nX) comment(pClose(1):end)];
      elseif length(commas) == 2
         coeff.Comment =  [comment(1:(pOpen(1) + commas(2)-1)) num2str(nX) comment(pClose(1):end)];
      end
   end
end


%
%   * * * * *  Helper function for initial ARMA(R,M) model guesses.  * * * * *
%

function [AR, MA, constant, variance] = arma0(y, R, M)
%ARMA0 Initial parameter estimates of univariate ARMA processes.
%   Compute initial estimates of the auto-regressive (AR) and moving average 
%   (MA) coefficients of a stationary/invertible univariate ARMA time series. 
%   Estimates of the model constant and the variance of the innovations noise 
%   process are also provided. The purpose of this function is to provide 
%   initial coefficient estimates suitable for further refinement via maximum 
%   likelihood estimation.
%
%   [AR, MA, Constant, Variance] = arma0(Series, R, M)
%
%   Optional Inputs: R, M
%
% Inputs:
%   Series - Return series vector of interest. Series is a dependent stochastic 
%     process assumed to follow a model specification of general ARMA(R,M) form. 
%     The first element contains the oldest observation and the last element 
%     the most recent. 
%
%   R - Auto-regressive order of an ARMA(R,M) model. R is a non-negative integer
%     scalar. If empty or missing, R = 0.
%
%   M - Moving average order of an ARMA(R,M) model. M is a non-negative integer 
%     scalar. If empty or missing, M = 0.
%
% Outputs:
%   AR - R by 1 vector of initial estimates of the auto-regressive parameters 
%     of an ARMA(R,M) model. The first element of AR is an estimate of the 
%     coefficient of the first lag of Series, the second element is an estimate
%     of the coefficient of the second lag of Series, and so forth.
%      
%   MA - M by 1 vector of initial estimates of the moving average parameters of 
%     an ARMA(R,M) model. The first element of MA is an estimate of the 
%     coefficient of the first lag of the innovations noise process, the second
%     element is an estimate of the coefficient of the second lag of the 
%     innovations noise process, and so forth.
%
%   Constant - Estimate of the constant included in a general ARMA model. 
%
%   Variance - Estimate of the unconditional variance of the innovations noise
%     process. Equivalently, it may also be viewed as the variance estimate of
%     the white noise innovations under the assumption of homoskedasticity.
%
% See also GARCHSET, GARCHGET, GARCHSIM, GARCHFIT.

%
% References:
%   Box, G.E.P., Jenkins, G.M., Reinsel, G.C., "Time Series Analysis: 
%     Forecasting and Control", 3rd edition, Prentice Hall, 1994.
%
%   Hamilton, J.D., "Time Series Analysis", Princeton University Press, 1994.
%

%
% Check for the simple case of no ARMA model. In this 
% case just compute the sample mean and variance and exit.
%

if (R + M) == 0
   AR        =  [];
   MA        =  [];
   constant  =  mean(y);
   variance  =  var(y,1);
   return
end

%
% Estimate the AR coefficients of a general ARMA(R,M) model.
%

if R > 0

%
%  Compute the auto-covariance sequence of the y(t) process. Note that the
%  variance (i.e, zeroth-lag auto-covariance) is found in the first element.
%
   correlation =  autocorr(y , R + M);         % auto-correlation sequence.
   variance    =  var(y,1);
   covariance  =  correlation * variance;      % auto-covariance sequence.

%
%  In each case below, the matrix 'C' of covariances is 
%  that outlined in equation A6.2.1 (page 220) of BJR.
%
   if M > 0
%
%     For ARMA processes, the matrix C of covariances derived from the 
%     estimated auto-covariance sequence is Toeplitz, but non-symmetric.
%     The AR coefficients are then found by solving the modified Yule-Walker
%     equations.
%
      i          =  [M+1:-1:M-R+2]; 
      i(i <= 0)  =  i(i <= 0) + 2;       % covariance(k) = covariance(-k)

      C  =  toeplitz(covariance(M+1:M+R) , covariance(i));

      if R == 1
         AR  =  covariance(M+2:M+R+1) / C;
      else
         AR  =  C \ covariance(M+2:M+R+1);
      end

   else

      if R == 1
         AR  =  correlation(2);
      else
%
%        For AR processes, the matrix C of covariances derived from the 
%        estimated auto-covariance sequence is Toeplitz and symmetric.
%        The AR coefficients are found by solving the Yule-Walker equations.
%
         C   =  toeplitz(covariance(1:R));
         AR  =  C \ covariance(2:R+1);

      end

   end

%
%  Ensure the AR process is stationary. If it's not stationary, then set all
%  ARMA coefficients to 0. This ensures the subsequent optimization will
%  begin with a stationary/invertible ARMA model for the conditional mean.
%

   eigenValues =  roots([1 ; -AR(:)]);

   if any(abs(eigenValues) >= 1)

      AR        =  zeros(R,1);
      MA        =  zeros(M,1);
      constant  =  mean(y);
      variance  =  var(y,1); 
      return

   end

else

   AR  =  [];

end

%
% Filter the ARMA(R,M) input series y(t) with the estimated AR coefficients 
% to obtain a pure MA process. If the input moving-average model order M is
% zero (M = 0), then the filtered output is really just a pure innovations 
% process (i.e., an MA(0) process); in this case the innovations variance 
% estimate is just the sample variance of the filtered output. If M > 0, then
% compute the auto-covariance sequence of the MA process and continue.
%

x        =  filter([1 -AR'] , 1 , y);
constant =  mean(x);

if M == 0
   variance =  var(x,1);
   MA       =  [];
   return
end

c  =  autocorr(x , M) * var(x,1);    % Covariance of an MA(M) process.

%
% Estimate the variance of the white noise innovations process e(t)
% and the MA coefficients of a general ARMA(R,M) model. The method of
% computation is that outlined in equation A6.2.4 (page 221) of BJR.
%

MA      =  zeros(M , 1);  % Initialize MA coefficients.
MA1     =  ones (M , 1);  % Saved MA coefficients from previous iteration.
counter =  1;             % Iteration counter.
tol     =  0.05;          % Convergence tolerance.

while ((norm(MA - MA1) > tol) & (counter < 100))

    MA1  =  MA;
%
%   Estimate the variance of the innovations process e(t).
%
    variance  =  c(1) /([1 ; MA]'* [1 ; MA]);

    if abs(variance) < tol 
       break
    end

    for j = M:-1:1
%
%       Now estimate the moving-average coefficients. Note that 
%       the MA coefficients are the negative of those appearing 
%       in equation A6.2.4 (page 221) of BJR. This is due to the
%       convention of entering coefficient values, via GARCHSET,
%       exactly as the equation would be written.
%
        MA(j)  =  [c(j+1) ; -MA(1:M-j)]' * [1/variance ; MA(j+1:M)];

    end

    counter  =  counter  +  1;

end

%
% Test for invertibility of the noise model.
%

eigenValues  =  roots([1 ; MA]);

if any(abs(eigenValues) >= 1) | any(isinf(eigenValues)) | any(isnan(eigenValues))

   MA        =  zeros(M,1);
   variance  =  var(x,1);

end


%
%   * * * * *  Helper function for initial ARX guesses.  * * * * *
%

function [C, AR, regress, residuals] = arx0(y, X, R, isConstantInMean)
%ARX0 Initial parameter estimates of univariate ARX processes.
%   Estimate the parameters associated with fitting an ARX model to a
%   univariate returns series of interest via ordinary least squares (OLS).
%
%   [Constant, AR, Regress, Residuals] = garchnlc(Series, X, R, IsConstantInMean)
%
% Inputs:
%   Series - Return series vector of interest. Series is a dependent stochastic 
%     process assumed to follow a model specification of general ARX form. 
%     The first element contains the oldest observation and the last element 
%     the most recent. 
%
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   X - Time series regression matrix of explanatory variable(s). Typically, X 
%     is a regression matrix of asset returns (e.g., the return series of an 
%     equity index). Each column of X is an individual time series used as an 
%     explanatory variable in the regression component of the conditional mean. 
%     In each column of X, the first row contains the oldest observation and 
%     the last row the most recent. If empty or missing, the conditional mean 
%     will have no regression component
%
%   IsConstantInMean - Logical flag indicating whether or not the conditional
%     mean equation includes an additive scalar constant. A TRUE (i.e., 
%     logical(1)) value indicates the mean equation includes a constant
%     and a FALSE (i.e., logical(0)) value indicates that a constant is NOT
%     included in the mean equation.
%
% Outputs:
%   Constant - Estimate of the constant included in a general ARX model. 
%
%   AR - R by 1 vector of initial estimates of the auto-regressive parameters 
%     of an ARX model. The first element of AR is an estimate of the 
%     coefficient of the first lag of Series, the second element is an estimate
%     of the coefficient of the second lag of Series, and so forth.
%      
%   Regress - A vector of estimated regression coefficients of the ARX model.
%     The length this vector is the same as the number of columns in the
%     explanatory regression matrix X (see above).
%
%   Residuals - Vector of residuals from fitting an ARX model to Series.
%

yLag               =  lagmatrix(y , [1:R]);
yLag(isnan(yLag))  =  mean(y);

regressionMatrix   =  [ones(size(X,1),isConstantInMean)  yLag  X];

[QQ , RR]  =  qr(regressionMatrix , 0);
b          =  RR \ (QQ'*y);
residuals  =  y - regressionMatrix * b;

if isConstantInMean

   C       =  b(1);
   AR      =  b(2:R+1);
   regress =  b(R+2:end);

else

   C       =  0;
   AR      =  b(1:R);
   regress =  b(R+1:end);

end

%
% Ensure stationarity of AR process.
%

if any(abs(roots([1 ; -AR(:)])) >= 1)
   AR(:)  =  0;
end


%
%   * * * * Helper function for initial GARCH(P,Q) & GJR(P,Q) model guesses.  * * * *
%

function [K , GARCH , ARCH] = garch0(P , Q , unconditionalVariance)
%GARCH0 Initial GARCH(P,Q) process parameter estimates.
%   Given the orders of a GARCH(P,Q) model and an estimate of the unconditional 
%   variance of the innovations process, compute initial estimates for the 
%   (1 + P + Q) parameters of a GARCH(P,Q) conditional variance model. These
%   estimates serve as initial guesses for further refinement via maximum 
%   likelihood.
%
%   [K, GARCH, ARCH] = garch0(P, Q, Variance)
%
% Inputs:
%   P - Non-negative, scalar integer representing the number of lags of the
%     conditional variance included in the GARCH process.
%
%   Q - Non-negative, scalar integer representing the number of lags of the 
%     squared innovations included in the GARCH process.
%
%   Variance - Estimate of the unconditional variance of the innovations noise
%     process. Equivalently, it may also be viewed as the variance estimate of
%     the white noise innovations under the assumption of homoskedasticity.
%
% Outputs:
%   K - Conditional variance constant (scalar).
%
%   GARCH - P-element column vector of coefficients of lagged conditional 
%     variances.
%
%   ARCH - Q-element column vector of coefficients of lagged squared 
%     innovations.
%
% Note: 
%   This is an internal helper function for GARCHFIT. No error checking is 
%   performed.
%

%
% The following initial guesses are based on empirical observation of GARCH
% model parameters. This approach is rather ad hoc, but is often typical of
% GARCH models in financial time series. 
%
% The following approach assumes the sum of the conditional variance model 
% coefficients is close to 1 (i.e., the integrated boundary). Specifically,
% we assume that
%
%    GARCH(1) + ... + GARCH(P) + ARCH(1) + ... + ARCH(Q) = 0.9
%
% If P > 0 (i.e., the variance model includes lagged conditional variances), 
% then allocate 0.85 out of the available 0.9 to these GARCH coefficients, and
% the remaining 0.05 to the ARCH coefficients. When P = 0, we have an ARCH(Q)
% model in which all 0.9 is allocated to the Q ARCH terms.
%
% For example, the most common GARCH(P,Q) model is the simple GARCH(1,1) 
% model, and would be modeled as follows:
%
%            h(t) = K + 0.85h(t-1) + 0.05e^2(t-1)
%
% In a GARCH(1,1) model, the unconditional variance of the innovations 
% process, V, is
%
%            V = K / (1 - (0.85 + 0.05))
% or,
%            K = V * (1 - (0.85 + 0.05))
%
% For higher-order GARCH(P,Q) models, this approach assumes the sum of the
% lagged conditional variance coefficients = 0.85, and the sum of the coefficients
% of lagged squared innovations = 0.05.
%

GARCH =  0.85;
GARCH =  GARCH(ones(P,1)) / max(P,1);
GARCH =  GARCH(:);

ARCH  =  0.90 - sum(GARCH);
ARCH  =  ARCH(ones(Q,1)) / max(Q,1);
ARCH  =  ARCH(:);


if isempty(unconditionalVariance) |  (unconditionalVariance <= 0)
   K  =  1e-3;   % A decent assumption for daily returns.
else
   K  =  unconditionalVariance * (1 - sum([GARCH ; ARCH]));
end


%
%   * * * * *  Helper function for initial EGARCH(P,Q) model guesses.  * * * * *
%

function [K, GARCH, ARCH, Leverage] = egarch0(P, Q, unconditionalVariance)
%EGARCH0 Initial EGARCH(P,Q) process parameter estimates.
%   Given the orders of an EGARCH(P,Q) model and an estimate of the 
%   unconditional variance of the innovations process, compute initial 
%   estimates for the (1 + P + 2Q) parameters of an EGARCH(P,Q) conditional 
%   variance model. These estimates serve as initial guesses for further 
%   refinement via maximum likelihood.
%
%   [K, GARCH, ARCH, Leverage] = egarch0(P , Q , Variance)
%
% Inputs:
%   P - Non-negative, scalar integer representing the number of lags of the
%     conditional variance included in the EGARCH(P,Q) process.
%
%   Q - Non-negative, scalar integer representing the number of lags of the 
%     innovations included in the EGARCH(P,Q) process.
%
%   Variance - Estimate of the unconditional variance of the innovations noise
%     process. Equivalently, it may also be viewed as the variance estimate of
%     the white noise innovations under the assumption of homoskedasticity.
%
% Outputs:
%   K - Conditional variance constant (scalar).
%
%   GARCH - P-element column vector of coefficients of lagged conditional 
%     variances.
%
%   ARCH - Q-element column vector of coefficients of lagged innovations.
%
%   Leverage - Q-element column vector of coefficients of lagged standardized
%     innovations.
%
% Note: 
%   This is an internal helper function for GARCHFIT. No error checking is 
%   performed.
%

%
% The general EGARCH(P,Q) model form is as follows:
%
%   log[h(t)] =  K + G(1)log[h(t-1)]               + ... +  G(P)log[h(t-P)]
%                  + A(1)[|z(t-1)| - E(|z(t-1)|)]  + ... +  A(Q)[|z(t-Q)| - E(|z(t-Q)|)] 
%                  + L(1)z(t-1)                    + ... +  L(Q)z(t-Q)
%
% where the terms |z(t-i)| are absolute magnitude of the i-th lagged standardized 
% residual and E(|z(t-i)|) is the unconditional (i.e., log-run, or time-independent)
% expected value, which is dependent upon the probability distribution.
%
% The following initial guesses are based on empirical observations of EGARCH
% model parameters. This approach is rather ad hoc, and based on the simple 
% EGARCH(1,1) model in which the coefficient of the lagged conditional variance
% (i.e., the 'GARCH' coefficient) is about 0.9, and the coefficient associated 
% with the magnitude of the lagged standardized innovation (i.e., the 'ARCH' 
% coefficient) is about 0.2. Thus, a reasonable EGARCH(1,1) assumption is:
%
%     log[h(t)] = K + 0.9log[h(t-1)] + 0.2[|z(t-1)| - E(|z(t-1)|)]
%
% Note that the 'Leverage' terms associated with lagged standardized innovations
% are assumed to be zero. Thus, in the above model, G(1) = 0.9, A(1) = 0.2, L(1) = 0.
%
% In an EGARCH(1,1) model, the approximate relationship between the unconditional 
% variance of the innovations process, V, and the GARCH parameters is assumed to be
%
%            K = (1 - G(1))*log(V) = (1 - 0.9)*log(V) = 0.1*log(V)
%
% For higher-order EGARCH(P,Q) models, this approach assumes the sum of the
% GARCH coefficient = 0.9, and the sum of the ARCH coefficients = 0.2.
%
% Note:
%   In contrast to GARCH(P,Q) and GJR(P,Q) variance models in which it may make 
%   sense to expect users to specify P = 0, the following code does NOT make
%   this assumption. For example, a GARCH(0,Q) is just an ARCH(Q) model in which 
%   no lagged conditional variances are included. However, an EGARCH(P,Q) model 
%   is a fundamentally different time series model, and the code below is most 
%   effective when P > 0.
%

GARCH =  0.9;
GARCH =  GARCH(ones(P,1)) / max(P,1);
GARCH =  GARCH(:);

ARCH  =  0.2;
ARCH  =  ARCH(ones(Q,1)) / max(Q,1);
ARCH  =  ARCH(:);

if isempty(unconditionalVariance) |  (unconditionalVariance <= 0)
   K  =  -0.01;   % A decent assumption for daily returns.
else
   K  =  (1 - sum(GARCH)) * log(unconditionalVariance);
end

Leverage  =  zeros(Q,1);


%
%   * * * * *  Helper function for setting equality constraints of individual parameters.  * * * * *
%

function  Fix = setEqualityConstraints(Fix, spec, nX, isMeanComplete, isVarianceComplete)
%SETEQUALITYCONSTRAINTS Set equality constraint indicator vector.
%   Extract user-specified equality constraint indicators for individual 
%   parameters. These indicators convey which parameters of the composite
%   conditional mean and variance model are held fixed at the corresponding
%   value specified by the user.
%
%   Fix = setEqualityConstraints(Fix, Spec, NX, IsMeanComplete, 
%     IsVarianceComplete)
%
% Inputs:
%   Fix - A column vector of zeros. The length of Fix is the number of 
%     parameters estimated by the optimizer.
%
%   Spec - Structure specification for the conditional mean and variance models,
%     and optimization parameters. Spec is a structure with fields created by 
%     calling the function GARCHSET or GARCHFIT.
%
%   NX - The number of explanatory variables (if any) in the regression matrix.
%
%   IsMeanComplete - A logical flag indicating if the user has specified all 
%     the parameters of a complete conditional mean model.
%
%   IsVarianceComplete - A logical flag indicating if the user has specified
%     all the parameters of a complete conditional variance model.
%
% Outputs:
%   Fix - An updated column vector of zeros and ones. Fix is now an updated 
%     version of the input. A one in a particular element indicates that the
%     corresponding parameter is held fixed throughout the optimization 
%     process. For each element of Fix that is a one, there will be a 
%     corresponding row in the equality constraint matrix passed into the
%     optimizer.
%

%
% Extract model orders.
%

R   =  garchget(spec , 'R');           % Conditional mean AR order.
M   =  garchget(spec , 'M');           % Conditional mean MA order.
P   =  garchget(spec , 'P');           % Conditional variance order for lagged variances.
Q   =  garchget(spec , 'Q');           % Conditional variance order for lagged residuals.

%
% Set some Boolean flags.
%

if isnan(garchget(spec , 'C'))
   isConstantInMean  =  logical(0);    % The mean equation does NOT include a constant.
else
   isConstantInMean  =  logical(1);    % The mean equation includes a constant.
end

varianceModel  =  garchget(spec , 'VarianceModel');
[varianceModel , InMeanString] = strtok(varianceModel , '-');
isVarianceInMean = ~isempty(InMeanString);

distribution    =  garchget(spec , 'Distribution');
distribution    =  distribution(~isspace(distribution));
isDistributionT =  strcmp(upper(distribution),'T');

%
% Initialize the first and last index associated with the mean equation.
%

i1  =  1;
i2  =  isConstantInMean + R + M + nX + isVarianceInMean;

%
% Now extract equality constraint information for individual coefficients.
%

if isMeanComplete
%
%  A complete conditional mean specification was provided.
%
   if isConstantInMean
%
%     If the mean model includes a constant, then we must be 
%     allocate space in the 'Fix' vector for it.
%
      FixC  =  garchget(spec , 'FixC');
      if isempty(FixC)
         FixC  =  0;
      end
   else
      FixC  =  [];     % A constant is NOT in the mean, so allocate no space for it.
   end

   if isVarianceInMean
%
%     If the mean model includes a variance-in-mean component, then
%     we must be allocate space in the 'Fix' vector for it.
%
      FixInMean  =  garchget(spec , 'FixInMean');
      if isempty(FixInMean)
         FixInMean  =  0;
      end
   else
      FixInMean  =  [];     % A variance term is NOT in the mean, so allocate no space for it.
   end

   FixAR      =  garchget(spec , 'FixAR');
   FixMA      =  garchget(spec , 'FixMA');
   FixRegress =  garchget(spec , 'FixRegress');

   if isempty(FixAR)      , FixAR      = zeros(R ,1); end
   if isempty(FixMA)      , FixMA      = zeros(M ,1); end
   if isempty(FixRegress) , FixRegress = zeros(nX,1); end

   Fix(i1:i2) = [FixC ; FixAR(:) ; FixMA(:) ; FixRegress(:) ; FixInMean];

end

if isVarianceComplete
%
%  A complete conditional variance specification was provided.
%
   FixK      =  garchget(spec , 'FixK');
   FixGARCH  =  garchget(spec , 'FixGARCH');
   FixARCH   =  garchget(spec , 'FixARCH');

   if isempty(FixK)       , FixK      = 0;          end
   if isempty(FixGARCH)   , FixGARCH  = zeros(P,1); end
   if isempty(FixARCH)    , FixARCH   = zeros(Q,1); end

   i1  =  i2 + 1;         % First index of the variance equation (excluding 'Leverage' terms).
   i2  =  i1 + P + Q;     % Last  index of the variance equation (excluding 'Leverage' terms).

   Fix(i1:i2) = [FixK ; FixGARCH(:) ; FixARCH(:)];

   if any(strcmp(upper(varianceModel) , {'EGARCH' 'GJR'}))

      FixLeverage  =  garchget(spec , 'FixLeverage');
      if isempty(FixLeverage) , FixLeverage = zeros(Q,1); end

      i1  =  i2 + 1;      % First index of variance equation 'Leverage' terms.
      i2  =  i1 + Q - 1;  % Last  index of variance equation 'Leverage' terms.

      Fix(i1:i2)  =  FixLeverage;             % Allow for Leverage terms.

   end

end

if isDistributionT
%
%  If the residuals are T-distributed, then allocate space in the 'Fix' vector for it.
%
   FixDoF  =  garchget(spec , 'FixDoF');

   if isempty(FixDoF)
      FixDoF  =  0;
   end

   Fix(end)  =  FixDoF;     % Allow for T distributions.

end


%
%   * * * * Helper function for lower/upper bound constraints of ARMAX(R,M,nX) models.  * * * *
%

function [LB, UB] = armaxlbub(R, M, nX, isConstantInMean, isVarianceInMean)
%ARMAXLBUB Set lower and upper bounds for ARMAX model parameters.
%   This helper function supports the GARCH Toolbox optimization function
%   GARCHFIT. Given information about a conditional mean model of general 
%   ARMAX(R,M,NX) form, this function returns lower and upper bound vectors
%   appropriate for numerical optimization.
%
%   [LB, UB] = armaxlbub(R, M, NX, IsConstantInMean, IsVarianceInMean)
%
% Inputs:
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   M - Non-negative, scalar integer representing the MA-process order.
%
%   NX - The number of explanatory variables in the regression matrix.
%
%   IsConstantInMean - Logical flag indicating whether or not the conditional
%     mean equation includes an additive scalar constant. A TRUE (i.e., 
%     logical(1)) value indicates the mean equation includes a constant
%     and a FALSE (i.e., logical(0)) value indicates that a constant is NOT
%     included in the mean equation.
%
%   IsVarianceInMean - Logical flag indicating whether or not the conditional
%     variance is included as an explanatory variable in the conditional mean
%     equation. A TRUE (i.e., logical(1)) value indicates a variance-in-mean 
%     model and a FALSE (i.e., logical(0)) value indicates no variance-in-mean
%     model. This is currently available for GARCH-M models ONLY.
%
% Outputs:
%   LB -  Column vector of parameter lower bounds such that LB <= x.
%
%   UB -  Column vector of parameter upper bounds such that x <= UB.
%


%
% Set lower and upper bounds constraints. 
%
% The stationarity and invertibility of the AR and MA polynomials, respectively, 
% are ultimately invoked by a non-linear constraint function which ensures that 
% the magnitude of all eigenvalues of the polynomials are inside the unit circle. 
% However, during optimization it is helpful to apply appropriate lower and upper 
% bounds on the individual AR and MA coefficients. These bounds are set to +/- the 
% model order, which is theoretically correct for AR and MA orders up to 2, and 
% very reasonable even beyond that.
%
% In summary, the following lower and upper bounds are applied for ARMAX mean models:
%
%   Coefficient  Lower Bound  Upper Bound
%   -----------  -----------  -----------
%       C           -10           10    present ONLY when 'isConstantInMean' = 1
%     AR(1:R)        -R            R
%     MA(1:M)        -M            M
%  Regress(1:nX)    -10           10
%     InMean        -10           10    present ONLY when 'isVarianceInMean' = 1 ('GARCH' models ONLY)
%

nParameters  =  isConstantInMean + R + M + nX + isVarianceInMean;
LB           =  zeros(nParameters,1);

if isConstantInMean
   LB(1)  = -10;
end

LB((isConstantInMean + 1):nParameters)  =  [repmat(-R,R,1) ; repmat(-M,M,1) ; repmat(-10,nX,1) ; repmat(-10,isVarianceInMean,1)];

UB  =  -LB;    % Lower & upper bounds are symmetric.


%
%   * * * * *  Helper function for linear constraints of GARCH(P,Q) models.  * * * * *
%

function [LB, UB, A, b, Aeq, beq] = garchlc(R, M, P, Q, nX, isConstantInMean, isDistributionT, Fix, x0, isVarianceInMean)
%GARCHLC Set linear parameter constraints for GARCH variance models.
%   This helper function supports the GARCH Toolbox optimization function
%   GARCHFIT. Given information about a conditional mean model of general 
%   ARMAX(R,M,NX) form and conditional variance model of GARCH(P,Q) form,
%   this function returns lower and upper bound vectors, linear equality 
%   and inequality matrices, and the corresponding linear equality and 
%   inequality vectors.
%
%   [LB, UB, A, b, Aeq, beq] = garchlc(R, M, P, Q, NX, IsConstantInMean, 
%     IsDistributionT, Fix, x0, IsVarianceInMean)
%
% Inputs:
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   M - Non-negative, scalar integer representing the MA-process order.
%
%   P - Non-negative, scalar integer representing the number of lagged
%     conditional variances included in the GARCH(P,Q) process.
%
%   Q - Non-negative, scalar integer representing the number of lagged
%     squared innovations included in the GARCH(P,Q) process.
%
%   NX - The number of explanatory variables in the regression matrix.
%
%   IsConstantInMean - Logical flag indicating whether or not the conditional
%     mean equation includes an additive scalar constant. A TRUE (i.e., 
%     logical(1)) value indicates the mean equation includes a constant
%     and a FALSE (i.e., logical(0)) value indicates that a constant is NOT
%     included in the mean equation.
%
%   IsDistributionT - Logical flag indicating whether or not the innovations
%     noise process is a conditional T distribution. A TRUE (i.e., 
%     logical(1)) value indicates the innovations are T-distributed and a
%     FALSE (i.e., logical(0)) value indicates the innovations are NOT 
%     T-distributed.
%
%   Fix - Logical column vector of flags that indicate which parameters 
%     are held fixed at the corresponding value in x (see below) throughout
%     the optimization process. A TRUE (i.e., logical(1)) in the i-th 
%     element indicates that the i-th parameter is held fixed at x(i). 
%     This vector is used to construct the output equality constraint 
%     arrays Aeq and beq (see below).
%
%   x0 - Column vector of initial parameter values included in the 
%     optimization. This vector is used to construct the output equality 
%     constraint arrays Aeq and beq (see below).
%
%   IsVarianceInMean - Logical flag indicating whether or not the conditional
%     variance is included as an explanatory variable in the conditional mean
%     equation. A TRUE (i.e., logical(1)) value indicates a GARCH-M model
%     and a FALSE (i.e., logical(0)) value indicates no GARCH-M model.
%
% Outputs:
%   LB -  Column vector of parameter lower bounds such that LB <= x.
%
%   UB -  Column vector of parameter upper bounds such that x <= UB.
%
%   A - The linear inequality constraint matrix of the form A*x <= b. Each 
%     row corresponds to a linear inequality constraint, and each column
%     corresponds to an estimated parameter.
%
%   b - The linear inequality constraint column vector of the form A*x <= b. 
%     Each element corresponds to a linear inequality constraint.
%
%   Aeq - The linear equality constraint matrix of the form Aeq*x = beq. 
%     Each row corresponds to a linear equality constraint, and each column
%     corresponds to an estimated parameter.
%
%   beq - The linear equality constraint column vector of the form Aeq*x = beq.
%     Each element corresponds to a linear inequality constraint.
%

%
% The following tolerance parameter specifies how closely select estimated 
% parameters may get to a corresponding constraint, and is related to 
% the maximum constraint violation tolerance parameter (TolCon) of the 
% Optimization Toolbox.
%
% The parameter is declared as a global variable to maintain consistency 
% across objective, non-linear constraint, and linear constraint functions. 
% It also prevents passing irrelevant inputs into the objective functions that
% are only required by the non-linear inequality constraint functions.
%

global GARCH_TOLERANCE

%
% Pre-allocate the lower & upper bound constraint vectors.
%

nParameters  =  isConstantInMean + R + M + nX + isVarianceInMean + 1 + P + Q + isDistributionT;
LB           =  zeros(nParameters,1);
UB           =  zeros(nParameters,1);

%
% Set lower & upper bounds for ARMAX mean models (common to ALL variance models).
%

i1  =  1;                                                 % First index of the mean equation.
i2  =  isConstantInMean + R + M + nX + isVarianceInMean;  % Last  index of the mean equation.

[LB(i1:i2) , UB(i1:i2)]  =  armaxlbub(R, M, nX, isConstantInMean, isVarianceInMean);

%
% Set lower and upper bounds for GARCH(P,Q) variance models. 
%
% A GARCH(P,Q) conditional variance equation has the following bound 
% constraints:
%
%     0 <  K                                (positivity constraint)
%     0 <= GARCH(i) < 1  for i = 1,2,...,P  (positivity constraint)
%     0 <=  ARCH(i) < 1  for i = 1,2,...,Q  (positivity constraint)
%
% In summary, the following lower and upper bounds are applied:
%
%   Coefficient  Lower Bound  Upper Bound
%   -----------  -----------  -----------
%       K            0            5
%   GARCH(1:P)       0            1
%    ARCH(1:Q)       0            1
%

i1  =  i2 + 1;                    % First index of the variance equation (i.e., K).
i2  =  i1 + P + Q;                % Last  index of the variance equation (i.e., ARCH(Q)).

LB(i1:i2)  =  [GARCH_TOLERANCE ; zeros(P+Q,1)];
UB(i1:i2)  =  [5         ;  ones(P+Q,1)];

%
% Also, if a T distribution is selected, then there is an additional constraint:
%
%   DoF > 2  (finite unconditional variance constraint)
%
% so bound 2 < DoF <= 200.
%

if isDistributionT
   LB(end)  =  2 + GARCH_TOLERANCE;
   UB(end)  =  200;
end

% 
% In the unlikely event that an element of the initial estimate vector 'x0' 
% falls outside the corresponding lower/upper bound, then re-set the bound
% to the initial estimate. This should virtually never happen with real-world
% financial return series data!
%

LB  =  min(LB , x0);
UB  =  max(UB , x0);

%
% Set linear inequality constraints of the form A*x <= b.
%
% The GARCH(P,Q) conditional variance equation has the following 
% inequality constraint:
%
%  GARCH(1:P) + ARCH(1:Q) <  1  (covariance-stationarity constraint)
%

if (P + Q) > 0
   A  =  [zeros(1,isConstantInMean + R + M + nX + isVarianceInMean + 1)  ones(1,P+Q)  zeros(isDistributionT,1)];
   b  =  1  -  GARCH_TOLERANCE;
else
   A  =  [];
   b  =  [];
end

%
% Set any user-specified linear equality constraints of the form Aeq*x <= beq.
%

if any(Fix)

   i    =  find(Fix); 
   Aeq  =  zeros(length(i),nParameters);

   for j = 1:length(i)
       Aeq(j,i(j))  =  1;
   end

   beq  =  x0(logical(Fix));

else

   Aeq  =  [];
   beq  =  [];

end


%
%   * * * * *  Helper function for linear constraints of EGARCH(P,Q) models.  * * * * *
%

function [LB, UB, A, b, Aeq, beq] = egarchlc(R, M, P, Q, nX, isConstantInMean, isDistributionT, Fix, x0)
%EGARCHLC Set linear parameter constraints for EGARCH variance models.
%   This helper function supports the GARCH Toolbox optimization function
%   GARCHFIT. Given information about a conditional mean model of general 
%   ARMAX(R,M,NX) form and conditional variance model of EGARCH(P,Q) form,
%   this function returns lower and upper bound vectors, linear equality 
%   and inequality matrices, and the corresponding linear equality and 
%   inequality vectors.
%
%   [LB, UB, A, b, Aeq, beq] = egarchlc(R, M, P, Q, NX, IsConstantInMean, 
%     IsDistributionT, Fix, x0)
%
% Inputs:
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   M - Non-negative, scalar integer representing the MA-process order.
%
%   P - Non-negative, scalar integer representing the number of lagged
%     conditional variances included in the EGARCH(P,Q) process.
%
%   Q - Non-negative, scalar integer representing the number of lagged  
%     standardized innovations included in the EGARCH(P,Q) process.
%
%   NX - The number of explanatory variables in the regression matrix.
%
%   IsConstantInMean - Logical flag indicating whether or not the conditional
%     mean equation includes an additive scalar constant. A TRUE (i.e., 
%     logical(1)) value indicates the mean equation includes a constant
%     and a FALSE (i.e., logical(0)) value indicates that a constant is NOT
%     included in the mean equation.
%
%   IsDistributionT - Logical flag indicating whether or not the innovations
%     noise process is a conditional T distribution. A TRUE (i.e., 
%     logical(1)) value indicates the innovations are T-distributed and a
%     FALSE (i.e., logical(0)) value indicates the innovations are NOT 
%     T-distributed.
%
%   Fix - Logical column vector of flags that indicate which parameters 
%     are held fixed at the corresponding value in x (see below) throughout
%     the optimization process. A TRUE (i.e., logical(1)) in the i-th 
%     element indicates that the i-th parameter is held fixed at x(i). 
%     This vector is used to construct the output equality constraint 
%     arrays Aeq and beq (see below).
%
%   x0 - Column vector of initial parameter values included in the 
%     optimization. This vector is used to construct the output equality 
%     constraint arrays Aeq and beq (see below).
%
% Outputs:
%   LB -  Column vector of parameter lower bounds such that LB <= x.
%
%   UB -  Column vector of parameter upper bounds such that x <= UB.
%
%   A - The linear inequality constraint matrix of the form A*x <= b. Each 
%     row corresponds to a linear inequality constraint, and each column
%     corresponds to an estimated parameter.
%
%   b - The linear inequality constraint column vector of the form A*x <= b. 
%     Each element corresponds to a linear inequality constraint.
%
%   Aeq - The linear equality constraint matrix of the form Aeq*x = beq. 
%     Each row corresponds to a linear equality constraint, and each column
%     corresponds to an estimated parameter.
%
%   beq - The linear equality constraint column vector of the form Aeq*x = beq.
%     Each element corresponds to a linear inequality constraint.
%

%
% The following tolerance parameter specifies how closely select estimated 
% parameters may get to a corresponding constraint, and is related to 
% the maximum constraint violation tolerance parameter (TolCon) of the 
% Optimization Toolbox.
%
% The parameter is declared as a global variable to maintain consistency 
% across objective, non-linear constraint, and linear constraint functions. 
% It also prevents passing irrelevant inputs into the objective functions that
% are only required by the non-linear inequality constraint functions.
%

global GARCH_TOLERANCE

%
% Pre-allocate the lower & upper bound constraint vectors.
%

nParameters  =  isConstantInMean + R + M + nX + 1 + P + 2*Q + isDistributionT;
LB           =  zeros(nParameters,1);
UB           =  zeros(nParameters,1);

%
% Set lower & upper bounds for ARMAX mean models (common to ALL variance models).
%

i1  =  1;                              % First index of the mean equation.
i2  =  isConstantInMean + R + M + nX;  % Last  index of the mean equation.

[LB(i1:i2) , UB(i1:i2)]  =  armaxlbub(R, M, nX, isConstantInMean, logical(0));

%
% Set lower & upper bounds for EGARCH(P,Q) variance models. 
%
% The GARCH coefficients of EGARCH(P,Q) models require that polynomial 
% eigenvalues lie inside the unit circle. This requirement is invoked in
% a non-linear inequality constraint function. These bounds are set 
% to +/- the model order P.
%
% In summary, the following lower and upper bounds are applied:
%
%   Coefficient  Lower Bound  Upper Bound
%   -----------  -----------  -----------
%       K           -5            5
%   GARCH(1:P)      -P            P
%    ARCH(1:Q)     -2Q           2Q
% Leverage(1:Q)    -2Q           2Q
%

i1  =  i2 + 1;              % First index of the variance equation (i.e., K).
i2  =  i1 + P + 2*Q;        % Last  index of the variance equation (i.e., Leverage(Q)).

LB(i1:i2)  =  [-5 ; repmat(-P,P,1) ; repmat(-2*Q,2*Q,1)];
UB(i1:i2)  =  -LB(i1:i2);

%
% Also, if a T distribution is selected, then there is an additional constraint:
%
%   DoF > 2  (finite unconditional variance constraint)
%
% so bound 2 < DoF <= 200.
%

if isDistributionT
   LB(end)  =  2 + GARCH_TOLERANCE;
   UB(end)  =  200;
end

% 
% In the unlikely event that an element of the initial estimate vector 'x0' 
% falls outside the corresponding lower/upper bound, then re-set the bound
% to the initial estimate. This should virtually never happen with real-world
% financial return series data!
%

LB  =  min(LB , x0);
UB  =  max(UB , x0);

%
% Set linear inequality constraints. Notice that EGARCH(P,Q) models
% have no linear inequality constraints on the individual parameters.
%

A  =  [];
b  =  [];

%
% Set any user-specified linear equality constraints of the form Aeq*x <= beq.
%

if any(Fix)

   i    =  find(Fix); 
   Aeq  =  zeros(length(i),nParameters);

   for j = 1:length(i)
       Aeq(j,i(j))  =  1;
   end

   beq  =  x0(logical(Fix));

else

   Aeq  =  [];
   beq  =  [];

end


%
%   * * * * *  Helper function for linear constraints of GJR(P,Q) models.  * * * * *
%

function [LB, UB, A, b, Aeq, beq] = gjrlc(R, M, P, Q, nX, isConstantInMean, isDistributionT, Fix, x0)
%GJRLC Set linear parameter constraints for GJR variance models.
%   This helper function supports the GARCH Toolbox optimization function
%   GARCHFIT. Given information about a conditional mean model of general 
%   ARMAX(R,M,NX) form and a conditional variance model of GJR(P,Q) form,
%   this function returns lower and upper bound vectors, linear equality 
%   and inequality matrices, and the corresponding linear equality and 
%   inequality vectors.
%
%   [LB, UB, A, b, Aeq, beq] = gjrlc(R, M, P, Q, NX, IsConstantInMean, 
%     IsDistributionT, Fix, x0)
%
% Inputs:
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   M - Non-negative, scalar integer representing the MA-process order.
%
%   P - Non-negative, scalar integer representing the number of lagged
%     conditional variances included in the GJR(P,Q) process.
%
%   Q - Non-negative, scalar integer representing the number of lagged
%     squared innovations included in the GJR(P,Q) process.
%
%   NX - The number of explanatory variables in the regression matrix.
%
%   IsConstantInMean - Logical flag indicating whether or not the conditional
%     mean equation includes an additive scalar constant. A TRUE (i.e., 
%     logical(1)) value indicates the mean equation includes a constant
%     and a FALSE (i.e., logical(0)) value indicates that a constant is NOT
%     included in the mean equation.
%
%   IsDistributionT - Logical flag indicating whether or not the innovations
%     noise process is a conditional T distribution. A TRUE (i.e., 
%     logical(1)) value indicates the innovations are T-distributed and a
%     FALSE (i.e., logical(0)) value indicates the innovations are NOT 
%     T-distributed.
%
%   Fix - Logical column vector of flags that indicate which parameters 
%     are held fixed at the corresponding value in x (see below) throughout
%     the optimization process. A TRUE (i.e., logical(1)) in the i-th 
%     element indicates that the i-th parameter is held fixed at x(i). 
%     This vector is used to construct the output equality constraint 
%     arrays Aeq and beq (see below).
%
%   x0 - Column vector of initial parameter values included in the 
%     optimization. This vector is used to construct the output equality 
%     constraint arrays Aeq and beq (see below).
%
% Outputs:
%   LB -  Column vector of parameter lower bounds such that LB <= x.
%
%   UB -  Column vector of parameter upper bounds such that x <= UB.
%
%   A - The linear inequality constraint matrix of the form A*x <= b. Each 
%     row corresponds to a linear inequality constraint, and each column
%     corresponds to an estimated parameter.
%
%   b - The linear inequality constraint column vector of the form A*x <= b. 
%     Each element corresponds to a linear inequality constraint.
%
%   Aeq - The linear equality constraint matrix of the form Aeq*x = beq. 
%     Each row corresponds to a linear equality constraint, and each column
%     corresponds to an estimated parameter.
%
%   beq - The linear equality constraint column vector of the form Aeq*x = beq.
%     Each element corresponds to a linear inequality constraint.
%


%
% The following tolerance parameter specifies how closely select estimated 
% parameters may get to a corresponding constraint, and is related to 
% the maximum constraint violation tolerance parameter (TolCon) of the 
% Optimization Toolbox.
%
% The parameter is declared as a global variable to maintain consistency 
% across objective, non-linear constraint, and linear constraint functions. 
% It also prevents passing irrelevant inputs into the objective functions that
% are only required by the non-linear inequality constraint functions.
%

global GARCH_TOLERANCE

%
% Pre-allocate the lower & upper bound constraint vectors.
%

nParameters  =  isConstantInMean + R + M + nX + 1 + P + 2*Q + isDistributionT;
LB           =  zeros(nParameters,1);
UB           =  zeros(nParameters,1);

%
% Set lower & upper bounds for ARMAX mean models (common to ALL variance models).
%

i1  =  1;                              % First index of the mean equation.
i2  =  isConstantInMean + R + M + nX;  % Last  index of the mean equation.

[LB(i1:i2) , UB(i1:i2)]  =  armaxlbub(R, M, nX, isConstantInMean, logical(0));

%
% Set lower and upper bounds constraints. 
%
% A GJR(P,Q) conditional variance equation has the following bound 
% constraints:
%
%     0 <  K                                (positivity constraint)
%     0 <= GARCH(i) < 1  for i = 1,2,...,P  (positivity constraint)
%     0 <=  ARCH(i)      for i = 1,2,...,Q  (positivity constraint)
%
% In summary, the following lower and upper bounds are applied:
%
%   Coefficient  Lower Bound  Upper Bound
%   -----------  -----------  -----------
%       K            0            5
%   GARCH(1:P)       0            1
%    ARCH(1:Q)       0           2Q
% Leverage(1:Q)    -2Q            1
%

i1  =  i2 + 1;                       % First index of the variance equation (i.e., K).
i2  =  i1 + P + 2*Q;                 % Last  index of the variance equation (i.e., Leverage(Q)).

LB(i1:i2)  =  [GARCH_TOLERANCE ; zeros(P+Q,1) ; repmat(-2*Q,Q,1)];
UB(i1:i2)  =  [5               ;    ones(P,1) ; repmat( 2*Q,Q,1) ; ones(Q,1)];

%
% Also, if a T distribution is selected, then there is an additional constraint:
%
%   DoF > 2  (finite unconditional variance constraint)
%
% so bound 2 < DoF <= 200.
%

if isDistributionT
   LB(end)  =  2 + GARCH_TOLERANCE;
   UB(end)  =  200;
end

% 
% In the unlikely event that an element of the initial estimate vector 'x0' 
% falls outside the corresponding lower/upper bound, then re-set the bound
% to the initial estimate. This should virtually never happen with real-world
% financial return series data!
%

LB  =  min(LB , x0);
UB  =  max(UB , x0);

%
% Set linear inequality constraints of the form A*x <= b.
%
% The GJR(P,Q) conditional variance equation has the following linear 
% inequality constraints:
%
%                ARCH(i) + Leverage(i) >= 0 for i = 1,2,...,Q  (positivity constraint)
% GARCH(1:P) + ARCH(1:Q) + 0.5*Leverage(1:Q) < 1               (covariance-stationarity constraint)
%

if (P + Q) > 0
   A  =  [zeros(Q,isConstantInMean + R + M + nX + 1 + P)      repmat(-eye(Q),1,2)       zeros(isDistributionT*Q,1) ;
          zeros(1,isConstantInMean + R + M + nX + 1)      ones(1,P+Q)  repmat(0.5,1,Q)  zeros(isDistributionT,1)  ];
   b  =  [zeros(Q,1) ; (1  -  GARCH_TOLERANCE)]; 
else
   A  =  [];
   b  =  [];
end

%
% Set any user-specified linear equality constraints of the form Aeq*x = beq.
%

if any(Fix)

   i    =  find(Fix); 
   Aeq  =  zeros(length(i),nParameters);

   for j = 1:length(i)
       Aeq(j,i(j))  =  1;
   end

   beq  =  x0(logical(Fix));

else

   Aeq  =  [];
   beq  =  [];

end


%
%   * * * * Helper function for non-linear constraints of ARMA(R,M) models.  * * * *
%

function [c, ceq, gc, gceq] = armanlc(Parameters, y, R, M, P, Q, X, isConstantInMean, varargin)
%ARMANLC Non-linear parameter constraints for ARMA models.
%   Enforce any non-linear constraints needed for maximum likelihood
%   parameter estimation of conditional mean models with ARMA components. 
%   This function serves as the non-linear constraint function required by the 
%   Optimization Toolbox function FMINCON. The non-linear constraints enforced 
%   are the stationarity and invertibility requirement of the auto-regressive
%   and moving average polynomials, respectively. 
%
%   [C, CEQ, GC, GCEQ] = armanlc(Parameters, Series, R, M, P, Q, X,
%     isConstantInMean)
%
% Inputs:
%   Parameters - Column vector of process parameters associated with fitting
%     conditional mean and variance specifications to an observed return series 
%     Series. 
%
%   Series - Column vector of observations of the underlying univariate return 
%     series of interest. Series is the response variable representing the time 
%     series fit to conditional mean and variance specifications. The last row 
%     of Series holds the most recent observation of each realization.
%
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   M - Non-negative, scalar integer representing the MA-process order.
%
%   P - Non-negative, scalar integer representing the number of lagged
%     conditional variances included in the variance process.
%
%   Q - Non-negative, scalar integer representing the number of lagged
%     innovations included in the variance process.
%
%   X - Time series regression matrix of explanatory variable(s). Typically, X 
%     is a regression matrix of asset returns (e.g., the return series of an 
%     equity index). Each column of X is an individual time series used as an 
%     explanatory variable in the regression component of the conditional mean. 
%     In each column of X, the first row contains the oldest observation and 
%     the last row the most recent. If empty or missing, the conditional mean 
%     will have no regression component
%
% Outputs:
%   C - Column vector of length (R + M) of non-linear inequality constraints 
%     associated with R roots of the auto-regressive (AR) polynomial and M
%     roots of the moving average (MA) polynomial. These constraints ensure 
%     that all eigenvalues lie inside the unit circle.
%
%   CEQ - Empty matrix placeholder for future compatibility.
%
%   GC - Empty matrix placeholder for future compatibility.
%
%   GCEQ - Empty matrix placeholder for future compatibility.
%
% Note:
%   This function is needed ONLY for optimization, and is NOT meant to be 
%   called directly. No error checking is performed.
%


%
% The following tolerance parameter specifies how close the estimated 
% parameters may get to the non-linear constraints, and are related to 
% the maximum constraint violation tolerance parameter (TolCon) of the 
% Optimization Toolbox.
%
% The optimizer requires that objective and non-linear inequality constraint 
% functions share the same problem-dependent input arguments. The parameter 
% is declared as a global variable to prevent passing irrelevant inputs into 
% the objective functions that are only required by the non-linear inequality 
% constraint functions needed to support optimization.
%

global GARCH_TOLERANCE

%
% The non-linear inequality constraints are those associated with 
% the R roots of the auto-regressive (AR) polynomial and the M roots of 
% the moving average (MA) polynomial. The polynomials are formed such 
% that the roots computed are the eigenvalues. For an ARMA(R,M) model
% to be stationary and invertible, all eigenvalues must lie inside the 
% unit circle of the complex plane. 
%

AReigenValues =  roots([1 ; -Parameters((isConstantInMean + 1):(isConstantInMean + R))]);
MAeigenValues =  roots([1 ;  Parameters((isConstantInMean + R + 1):(isConstantInMean + R + M))]);
c             =  (abs([AReigenValues ; MAeigenValues]).^2) - (1 - GARCH_TOLERANCE);

%
% Return empty matrices as placeholder for future compatibility.
%

ceq  = [];
gc   = [];
gceq = [];


%
%   * * * * *  Helper function for non-linear constraints of EGARCH(P,Q) models.  * * * * *
%

function [c, ceq, gc, gceq] = egarchnlc(Parameters, y, R, M, P, Q, X, isConstantInMean, varargin)
%EGARCHNLC Non-linear parameter constraints for EGARCH(P,Q) variance models.
%   Enforce any non-linear constraints needed for maximum likelihood
%   parameter estimation of EGARCH(P,Q) conditional variance models. This
%   function serves as the non-linear constraint function required by the 
%   Optimization Toolbox function FMINCON. The non-linear constraints enforced 
%   are the stationarity and invertibility requirement of the auto-regressive
%   and moving average polynomials of the mean equation, respectively, and the
%   stationarity requirement of the coefficients associated with the past 
%   observations of the logarithm of the conditional variance (i.e., 
%   the 'GARCH' coefficients).
%
%   [C, CEQ, GC, GCEQ] = egarchnlc(Parameters, Series, R, M, P, Q, X,
%     isConstantInMean)
%
% Inputs:
%   Parameters - Column vector of process parameters associated with fitting
%     conditional mean and variance specifications to an observed return series 
%     Series. 
%
%   Series - Matrix of observations of the underlying univariate return series 
%     of interest. Series is the response variable representing the time series 
%     fit to conditional mean and variance specifications. Each column of Series
%     in an independent realization (i.e., path). The last row of Series holds 
%     the most recent observation of each realization.
%
%   R - Non-negative, scalar integer representing the AR-process order.
%
%   M - Non-negative, scalar integer representing the MA-process order.
%
%   P - Non-negative, scalar integer representing the number of lagged
%     conditional variances included in the variance process.
%
%   Q - Non-negative, scalar integer representing the number of lagged
%     innovations included in the variance process.
%
%   X - Time series regression matrix of explanatory variable(s). Typically, X 
%     is a regression matrix of asset returns (e.g., the return series of an 
%     equity index). Each column of X is an individual time series used as an 
%     explanatory variable in the regression component of the conditional mean. 
%     In each column of X, the first row contains the oldest observation and 
%     the last row the most recent. If empty or missing, the conditional mean 
%     will have no regression component
%
% Outputs:
%   C - Column vector of length (R + M + P) of non-linear inequality constraints 
%     associated with R roots of the auto-regressive (AR) polynomial, M
%     roots of the moving average (MA) polynomial, and P roots of the GARCH
%     polynomial. These constraints ensure that all eigenvalues lie inside 
%     the unit circle.
%
%   CEQ - Empty matrix placeholder for future compatibility.
%
%   GC - Empty matrix placeholder for future compatibility.
%
%   GCEQ - Empty matrix placeholder for future compatibility.
%
% Notes:
% (1) This function is needed ONLY for optimization, and is NOT meant to be 
%     called directly. No error checking is performed.
% (2) EGARCH models are unique in that an EGARCH(P,Q) conditional variance 
%     model is an ARMA(P,Q) model for the logarithm of the conditional 
%     variance. Whereas GARCH(P,Q) and GJR(P,Q) conditional variance models
%     only have ARMA(R,M) non-linear constraints, EGARCH(P,Q) conditional 
%     variance models augment the ARMA(R,M) non-linear constraints to ensure
%     stationarity of the variance process.
%


%
% The following tolerance parameter specifies how close the estimated 
% parameters may get to the non-linear constraints, and are related to 
% the maximum constraint violation tolerance parameter (TolCon) of the 
% Optimization Toolbox.
%
% The optimizer requires that objective and non-linear inequality constraint 
% functions share the same problem-dependent input arguments. The parameter 
% is declared as a global variable to prevent passing irrelevant inputs into 
% the objective functions that are only required by the non-linear inequality 
% constraint functions needed to support optimization.
%

global GARCH_TOLERANCE

%
% The non-linear inequality constraints are those associated with 
% the R roots of the auto-regressive (AR) polynomial, the M roots of 
% the moving average (MA) polynomial, and the P roots of the GARCH
% polynomial. The polynomials are formed such that the roots computed 
% are the eigenvalues. For an ARMA(R,M) model to be stationary and 
% invertible, all eigenvalues must lie inside the unit circle of the 
% complex plane. Similarly, for an EGARCH(P,Q) model to stationary, all 
% eigenvalues must lie inside the unit circle of the complex plane.
%

%
% Compute the non-linear constraints associated with the (R + M) roots 
% of the ARMA(R,M) model in the conditional mean equation.
%

cARMA  =  armanlc(Parameters, y, R, M, P, Q, X, isConstantInMean);

%
% Compute the non-linear constraints associated with the P roots of
% the EGARCH(P,Q) conditional variance equation.
%

nX          =  size(X,2);  % # of regressors.
eigenValues =  roots([1 ; -Parameters((isConstantInMean + R + M + nX + 2):(isConstantInMean + R + M + nX + 1 + P))]);
c           =  (abs(eigenValues).^2) - (1 - GARCH_TOLERANCE);

%
% Augment the ARMA non-linear constraints with the variance model.
%

c  =  [cARMA ; c];

%
% Return empty matrices as placeholder for future compatibility.
%

ceq  = [];
gc   = [];
gceq = [];
