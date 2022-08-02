function [h , y , yTotalRMSE, yRMSE] = garchpred(spec , y , horizon , X , XF)
%GARCHPRED Univariate GARCH process forecasting.
%   Given specifications for the conditional mean and variance of an observed 
%   univariate return series, forecast the conditional mean and standard 
%   deviation of the return series NUMPERIODS into the future. Additionally, 
%   volatility forecasts of asset returns over multi-period holding intervals, 
%   and the standard errors of conditional mean forecasts are also computed. 
%   The conditional mean may be of general ARMAX form and the conditional 
%   variance of GARCH, EGARCH, or GJR form.
%
%   [SigmaForecast, MeanForecast] = garchpred(Spec, Series)
%
%   [SigmaForecast, MeanForecast] = garchpred(Spec, Series, NumPeriods, X, XF)
%
%   [SigmaForecast, MeanForecast, ...
%     SigmaTotal   , MeanRMSE   ] = garchpred(Spec, Series)
%
%   [SigmaForecast, MeanForecast, ...
%     SigmaTotal   , MeanRMSE   ] = garchpred(Spec, Series, NumPeriods)
%
%   Optional Inputs: NumPeriods, X, XF
%
% Inputs:
%   Spec - Structure specification for the conditional mean and variance models.
%     Spec is a structure with fields generated by calling the function 
%     GARCHSET, or the output of the estimation function GARCHFIT. For details, 
%     type "help garchset" or "help garchfit".
%
%   Series - Matrix of observations of the underlying univariate return series 
%     of interest. Series is the response variable representing the return 
%     series fit to conditional mean and variance specifications. Each column 
%     of Series in an independent realization (i.e., path). The last row of 
%     Series holds the most recent observation of each realization. Series is 
%     assumed to be a stationary stochastic process, and the ARMA component of 
%     the conditional mean model (if any) is assumed to stationary and 
%     invertible.
%
% Optional Inputs:
%   NumPeriods - Positive, scalar integer representing the forecast horizon of
%     interest, expressed in periods compatible with the sampling frequency 
%     of the input Series. If empty or missing, the default is 1.
%
%   X - Time series regression matrix of observed explanatory data. Typically, 
%     X is a matrix of observed asset returns (e.g., the return series of an 
%     equity index), and represents the past history of the explanatory data. 
%     Each column of X is an individual explanatory variable in the regression 
%     component of the conditional mean. In each column of X, the first row 
%     contains the oldest observation and the last row the most recent. If X is 
%     specified, the most recent number of valid (non-NaN) observations in each 
%     column of X must equal or exceed the most recent number of valid 
%     observations in Series. When the number of valid observations in each 
%     column of X exceeds that of Series, only the most recent observations of 
%     X are used. If empty or missing, the conditional mean will have no 
%     regression component. 
%
%   XF - Time series matrix of forecasted explanatory data. XF represents the 
%     evolution of the same explanatory data found in X projected into the 
%     future. Thus, XF and X must have the same number of columns. In each 
%     column of XF, the first row contains the 1-period-ahead forecast, the 
%     second row the 2-period-ahead forecast, and so on. If XF is specified, 
%     the number of rows (forecasts) in each column (time series) of XF must 
%     equal or exceed the forecast horizon NUMPERIODS. When the number of 
%     forecasts in XF exceeds NUMPERIODS, only the first NUMPERIODS forecasts 
%     are used. If empty or missing, the conditional mean forecast will have 
%     no regression component.
%
% Outputs:
%   SigmaForecast - Matrix of conditional standard deviations of future 
%     innovations (i.e., model residuals) on a per period basis. This matrix 
%     represents the standard deviations derived from the minimum mean square 
%     error (MMSE) forecasts associated with a particular recursive volatility 
%     model. For GARCH(P,Q) and GJR(P,Q) models, SigmaForecast is the square 
%     root of the MMSE conditional variance forecasts; for EGARCH(P,Q) models, 
%     SigmaForecast is the square root of the exponential of the MMSE forecasts 
%     of the logarithm of conditional variance. SigmaForecast will have 
%     NUMPERIODS rows and the same number of columns as Series. The first row
%     contains the standard deviation in the 1st period for each realization 
%     of Series, the second row contains the standard deviation in the 2nd 
%     period, and so on. Thus, if a forecast horizon greater than one is 
%     specified (NUMPERIODS > 1), the per-period standard deviations of all 
%     intermediate horizons are returned as well; in this case, the last row 
%     contains the standard deviation at the specified forecast horizon.
%
%   MeanForecast - Matrix of minimum mean square error (MMSE) forecasts of the
%     conditional mean of Series on a per period basis. MeanForecast will be 
%     the same size as SigmaForecast. The first row contains the forecast in 
%     the 1st period for each realization of Series, the second row contains 
%     the forecast in the 2nd period, and so on.
%
%   SigmaTotal - Matrix of volatility forecasts of Series over multi-period 
%     holding intervals. The first row contains the standard deviation of returns
%     expected for assets held for 1 period for each realization of Series, the 
%     second row contains the standard deviation of returns expected for assets 
%     held for 2 periods, and so on. Thus, the last row will contain the 
%     forecast of the standard deviation of the cumulative return obtained if an 
%     asset was held for the entire NUMPERIODS forecast horizon. These forecasts
%     are correct for continuously-compounded returns, and approximate for 
%     periodically compounded returns. SigmaTotal is the same size as 
%     SigmaForecast provided the conditional mean is modeled as a stationary/
%     invertible ARMA process; for conditional mean models with regression 
%     components (i.e., X and/or XF are specified), an empty matrix, [], is 
%     returned.
%
%   MeanRMSE - Matrix of root mean square errors (RMSE) associated with 
%     MeanForecast. That is, MeanRMSE is the conditional standard deviation 
%     of the forecast errors (i.e., the standard error of the forecast) of the
%     corresponding MeanForecast matrix. MeanRMSE is the same size as 
%     MeanForecast and is organized in exactly the same manner, provided the
%     conditional mean is modeled as a stationary/invertible ARMA process; for 
%     conditional mean models with regression components (i.e., X and/or XF 
%     are specified), an empty matrix, [], is returned.
%
% Notes:
% (1) Since a complete conditional mean specification is required to correctly
%     infer the innovations process which drives the forecasts, the regression 
%     matrix of observed returns (X), is typically the same X (if any) used for 
%     simulation (via GARCHSIM) or estimation (via GARCHFIT). XF, however, is
%     just the forecast of X, and is ONLY needed for forecasting the 
%     conditional mean (MeanForecast). Thus, if only the conditional variance 
%     forecast (SigmaForecast) is needed, XF is unnecessary. Furthermore, 
%     although X may be specified without XF, the converse is NOT true. XF may 
%     be specified ONLY when X is specified.
% (2) This function calls the function GARCHINFER to access the past history 
%     of innovations and conditional standard deviations inferred from Series. 
%     If the innovations and conditional standard deviations are needed, call 
%     GARCHINFER directly.
% (3) EGARCH(P,Q) models represent the logarithm of the conditional variance as
%     the output of a linear filter. As such, the minimum mean square error 
%     forecasts derived from EGARCH(P,Q) models are optimal for the logarithm 
%     of the conditional variance, but are generally downward biased forecasts 
%     of the conditional variance process itself. Since the output arrays 
%     SigmaForecast, SigmaTotal, and MeanRMSE are based upon the conditional 
%     variance forecasts, these outputs will generally underestimate their
%     true expected values for conditional variances derived from EGARCH(P,Q) 
%     models. The important exception is the one-period-ahead forecast, which 
%     is unbiased in all cases. 
%
% See also GARCHSET, GARCHSIM, GARCHINFER, GARCHFIT.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.12.4.1 $   $Date: 2003/05/08 21:45:29 $

%
% References:
%
%   Baillie, R.T., Bollerslev, T. (1992), "Prediction in Dynamic Models with 
%     Time-Dependent Conditional Variances", Journal of Econometrics, 
%     vol. 52, pp. 91-113.
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
%   Engle, Robert (1982), "Autoregressive Conditional Heteroskedasticity 
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
% Check & scrub the observed return series matrix y(t).
%

if (nargin < 2)

   error('GARCH:garchpred:UnspecifiedSeries' , ' Observed return series ''Series'' must be specified.');

else

   rowY  =  logical(0);     

   if prod(size(y)) == length(y)   % Check for a vector (single return series).
      rowY  =  size(y,1) == 1;     % Flag a row vector for outputs.
      y     =  y(:);               % Convert to a column vector.
   end

%
%  The following code segment assumes that missing observations are indicated
%  by the presence of NaN's. Any initial rows with NaN's are removed, and 
%  processing proceeds with the remaining block of contiguous non-NaN rows. 
%  Put another way, NaN's are allowed, but they MUST appear as a contiguous 
%  sequence in the initial rows of the y(t) matrix. Since the log-likelihood 
%  functions are designed to process y(t) as a matrix (instead of individual 
%  vectors!), any initial rows with NaN's are stripped. Thus, realizations 
%  with no missing observations will lose data if other realizations have 
%  missing values.
%
   i1  =  find(isnan(y));
   i2  =  find(isnan(diff([y ; zeros(1,size(y,2))]) .* y));

   if (length(i1) ~= length(i2)) | any(i1 - i2)
      error('GARCH:garchpred:MissingData' , ' Only initial observations in ''Series'' may be missing (NaN''s).')
   end

   if any(sum(isnan(y)) == size(y,1))
      error('GARCH:garchpred:AllMissingData' , ' A realization of ''Series'' is completely missing (all NaN''s).')
   end

   firstValidRow  =  max(sum(isnan(y))) + 1;
   y              =  y(firstValidRow:end , :);

end

%
% Check input parameters and set defaults.
%

if (nargin >= 3) & ~isempty(horizon)
   if prod(size(horizon)) > 1
      error('GARCH:garchpred:NonScalarHorizon' , ' Forecast horizon ''NumPeriods'' must be a scalar.');
   end
   if (round(horizon) ~= horizon) | (horizon <= 0)
      error('GARCH:garchpred:NonIntegerHorizon' , ' Forecast horizon ''NumPeriods'' must be a positive integer.');
   end
else
   horizon  =  1;   % Set default.
end

%
% Scrub the regression matrix, and ensure the observed return series matrix y(t) 
% and the regression matrix X(t) have the same number of valid (i.e., non-NaN)
% rows (i.e., impose time index compatibility).
%

if (nargin >= 4) & ~isempty(X)

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
      error('GARCH:garchpred:NotEnoughData' , ' Regression matrix ''X'' has insufficient number of observations.');
   else
      X  =  X(size(X,1) - (size(y,1) - 1):end , :);    % Retain only the most recent samples.
   end
%
%  Ensure number of regression coefficients match number of regressors.
%
   regress =  garchget(spec , 'Regress'); % Conditional mean regression coefficients.

   if size(X,2) ~= length(regress)
      error('GARCH:garchpred:InputMismatch' , ' Number of ''Regress'' coefficients unequal to number of regressors in ''X''.');
   end

else

   X        =  [];   % Ensure X exists.
   regress  =  [];

end

%
% Scrub the regression forecast matrix XF(t) and ensure sufficient forecasts exist 
% to (at least) cover the forecast horizon. As opposed to X(t), which may contain 
% some missing data (i.e., NaN's), XF(t) is created by the user and should contain
% no missing data (i.e., XF(t) should be NaN-free). Also, XF(t) and X(t) MUST have 
% the number of columns (i.e., explanatory variables).
%

if (nargin >= 5) & ~isempty(XF)

%
%  Check XF(t) versus X(t).
%
   if isempty(X) & ~isempty(XF)
      error('GARCH:garchpred:XFwithoutX' , ' Forecast matrix ''XF'' cannot be specified without ''X''.');
   end

   if size(X,2) ~= size(XF,2)
      error('GARCH:garchpred:ColumnMismatch' , ' Matrices ''XF'' and ''X'' must have the same number of columns.');
   end
%
%  Ensure no missing values (i.e., NaN's) exist in XF(t).
%
   if any(isnan(XF(:)))
      error('GARCH:garchpred:MissingForecastData' , ' Regression forecast matrix ''XF'' has missing data (i.e., NaN''s).');
   end

   if size(XF,1) < horizon
      error('GARCH:garchpred:InsufficientForecastData' , ' Regression matrix ''XF'' has insufficient number of forecasts.');
   else
      XF  =  XF(1:horizon , :);      % Retain only the initial forecasts.
   end

else

   XF  =  [];   % Ensure XF exists.

end

%
% Given specifications for the conditional mean & variance models, infer the 
% innovations, e(t), and conditional variances, h(t), time series from the
% observed return series y(t). The code segment below represents a re-construction 
% of the past e(t) and h(t) processes, which are required for forecasting into 
% the future. 
%
% Note that GARCHINFER actually returns the conditional standard deviation, 
% rather than the conditional variance. The output h(t) is converted later 
% on instead of immediately for performance purposes only.
%
% Also notice the TRY/CATCH block wrapped around the inference routine. This is
% done simply to avoid the MATLAB calling stack trace associated with nested error 
% reporting. That is, GARCHPRED calls GARCHINFER which, in turn, calls GARCHSET. 
% GARCHINFER ensures that all required coefficients are specified and GARCHSET 
% ensures that all coefficient constraints are enforced. To avoid duplication, the 
% error checking is performed at lower levels. The TRY/CATCH block simply allows 
% the actual error to be reported, but avoids the trace.
%

try
   [e , h] =  garchinfer(spec , y , X);  % At this point, h(t) = standard deviation.
catch
   rethrow(lasterror)
end

%
% Extract model orders and conditional variance parameters.
%

R        =  garchget(spec , 'R');        % Conditional mean AR order.
M        =  garchget(spec , 'M');        % Conditional mean MA order.
P        =  garchget(spec , 'P');        % Conditional variance order for lagged variances.
Q        =  garchget(spec , 'Q');        % Conditional variance order for lagged residuals.

K        =  garchget(spec , 'K');        % Conditional variance constant.
GARCH    =  garchget(spec , 'GARCH');    % Conditional variance coefficients for lagged variances.
ARCH     =  garchget(spec , 'ARCH');     % Conditional variance coefficients for lagged residuals.
Leverage =  garchget(spec , 'Leverage'); % Leverage coefficients for asymmetric EGARCH & GJR models.

%
% Ensure the variance model specification is complete.
%
% SPECIAL NOTE ON UNDOCUMENTED FEATURE: Forecasting of Variance-in-Mean Models
%
% Please note that inference/forecasting of residuals in the presence of 
% variance-in-mean conditions is allowed ONLY for conditional variance models 
% of GARCH-M form. In other words, inference of variance-in-mean models is 
% allowed ONLY if the conditional variance equation is described by a GARCH(P,Q) 
% model. Conditional variances derived from EGARCH(P,Q) and GJR(P,Q) variance 
% models are NOT allowed to enter the mean equation for inference/forecasting 
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
% Notes: 
%  (1) The presence of an appended dash (i.e., '-') in the 'VarianceModel'
%      field is an indication that the conditional variance is included in 
%      the conditional mean equation.
%
%  (2) The 'InMean' parameter is a coupling coefficient that allows inclusion 
%      of the conditional variance as an explanatory variable in the conditional 
%      mean equation. For inference/forecasting purposes, the 'InMean' parameter 
%      field is applicable ONLY to GARCH-M models.
%
% Again, inference/forecasting of GARCH-M models is an UNDOCUMENTED feature!
%

varianceModel                 =  garchget(spec , 'VarianceModel');
[varianceModel, InMeanString] =  strtok(varianceModel , '-');
isVarianceInMean              = ~isempty(InMeanString);

%
% Let y(t) = return series of interest (assumed stationary)
%     e(t) = innovations, or residuals, of the model noise process (assumed invertible)
%     h(t) = conditional variance of the innovations process e(t)
%
% Forecasting requires pre-sample values for conditioning. 
%
% We require R pre-sample lags of y(t), max(M,Q) pre-sample lags of e(t), and 
% P pre-sample lags of h(t) for GARCH & GJR conditional variance models, but 
% max(P,Q) lags of h(t) for EGARCH conditional variance models. To be safe, 
% work with max([R M P Q]) pre-sample lags for all processes.
%

maxRMPQ  =  max([R M P Q]);   % # of pre-sample lags for 'jump-starting' the process.

%
% Set the storage size of y(t), h(t), and e(t) required for forecasting.
%

T  =  horizon  +  maxRMPQ;

%
% Re-format the y(t), h(t), and e(t) processes for the purpose of forecasting. 
%
% Thus, truncate y(t), h(t), and e(t), retaining only the most recent 'maxRMPQ' 
% values, then append 'horizon' zeros to accommodate the user-specified forecast
% horizon. 
%
% Note that, upon input, y(t) is a univariate return series observed from the
% past. Upon output, y(t) represents the minimum MSE forecast of the conditional 
% mean of the return series projected into the future.
%

y      =  y((end - maxRMPQ + 1):end , :);
e      =  e((end - maxRMPQ + 1):end , :);
h      =  h((end - maxRMPQ + 1):end , :).^2;  % Convert STDs to variances.

y(T,:) =  0;  % Allocate sufficient storage for forecasting.
e(T,:) =  0;  % Required for MMSE mean forecasting (i.e., E{e(t)} = 0 for all future times).
h(T,:) =  0;

%
% Construct the conditional variance parameter vector. Notice that the Leverage
% coefficient vector of GARCH and Constant variance models is empty.
%

varianceCoefficients  =  [K ; GARCH(:) ; ARCH(:) ; Leverage(:)]';

%
% Apply iterative expectations one forecast step at a time. 
%
% Note that the forecasts constructed below require only that the innovations 
% process {e(t)} is a serially uncorrelated, zero-mean process with symmetric
% conditional probability distribution (see Baillie & Bollerslev, 1992, pages 94-95).
%

nPaths  =  size(y,2);    % # of realizations (i.e., sample paths).

switch upper(varianceModel)

   case {'GARCH' , 'CONSTANT'}           % GARCH(0,0) and Constant variance models are the same thing.
%
%     Since GARCH(P,Q) forecasting requires squared innovations, work 
%     with them directly instead of the e(t) process.
%
      e2      =  e(1:maxRMPQ , :).^2;    % Innovations squared.
      e2(T,:) =  0;
%     
%     For each iteration in the future, GARCH(P,Q) forecasting applies 
%     the identity that the conditional expectation of any future squared 
%     innovation is also the conditional expectation of it's corresponding
%     variance forecast.
%
      for t = (maxRMPQ + 1):T
          varianceData =  [ones(1,nPaths) ; h(t-(1:P),:) ; e2(t-(1:Q),:)];
          h (t,:)      =  varianceCoefficients * varianceData;
          e2(t,:)      =  h(t,:);
      end

   case 'EGARCH'
%
%     Get the probability distribution of the innovations process.
%
      distribution  =  garchget(spec , 'Distribution');
      distribution  =  distribution(~isspace(distribution));
%
%     Determine the expected value of the absolute value (i.e., the mean 
%     absolute deviation, or MAD) of the appropriate standardized i.i.d. 
%     random sequence.
%
%     Although there is no theoretical upper limit to the degree-of-freedom
%     parameter DoF, the GAMMA function rapidly approaches infinity as DoF 
%     increases. To prevent a NaN (i.e., infinity/infinity) condition, bypass 
%     the calculation and simply replace the standardized T-distributed mean 
%     absolute deviation by the asymptotic Gaussian limit. The allowable upper 
%     limit is arbitrarily set at 200, well beyond the point at which T and 
%     Gaussian distributions are essentially identical.
%
      if strcmpi(distribution , 'T')                  % T-distributed innovations.

         DoF  =  garchget(spec , 'DoF'); 

         if isempty(DoF) 
            error('GARCH:garchpred:UnspecifiedDoF' , ' Degrees-of-freedom ''DoF'' of T-Distributed innovations must be specified.')
         end

         if DoF <= 200
            MAD  =  sqrt((DoF - 2) / pi) * gamma(0.5 * (DoF - 1)) / gamma(0.5 * DoF);
         else
            MAD  =  sqrt(2 / pi);                     % Asymptotic Gaussian limit.
         end

      else
         MAD  =  sqrt(2 / pi);                        % Gaussian innovations.
      end

%
%     Initialize arrays related to the standardized residuals. 
%
%     z(t) = standardized residuals
%     Z(t) = absolute value of the standardized residuals z(t)
%
%     Note that the first maxRMPQ rows are based upon actual past inferred data, 
%     while the forecasted future rows are the unconditional expected values.
%
      z  =  [(e(1:maxRMPQ,:) ./ sqrt(h(1:maxRMPQ,:)))  ;  zeros(horizon,nPaths)];
      Z  =  [abs(z(1:maxRMPQ,:))  ;  repmat(MAD,horizon,nPaths)];
%
%     Now implement the EGARCH(P,Q) recursive equation. Since an EGARCH(P,Q) 
%     model is a recursive equation for the logarithm of the conditional 
%     variance, we must exponentiate the result before storing it as the 
%     conditional variance in h(t).
%
%     Also, as opposed to GARCH(P,Q) & GJR(P,Q) models which must be re-arranged
%     to obtain the fundamental ARMA(max(P,Q),P) representation, EGARCH(P,Q) 
%     models are in fact ARMA(P,Q) models for the logarithm of the conditional 
%     variance. In this representation, the composite "moving average" terms, 
%     which include the ARCH and Leverage terms, are effectively set to zero.
%
      for t = (maxRMPQ + 1):T
          varianceData =  [ones(1,nPaths) ; log(h(t-(1:P),:)) ; (Z(t-(1:Q),:) - MAD) ; z(t-(1:Q),:)];
          h(t,:)       =  exp(varianceCoefficients * varianceData);
      end

   case 'GJR'
%
%     GJR volatility models significantly complicate the iterative forecasting 
%     process. This is because the transition from the past (the data observation 
%     interval) to the future (the forecast interval) is awkward as known 
%     residuals with known signs are mixed, probabilistically, with future 
%     residuals of unknown sign. This is in sharp contrast to simulation and 
%     estimation of GJR models in which the actual data are always known.
%
%     To avoid unnecessary complication and errors, bypass the iterative 
%     forecasting loop if Q = 0 and simply assign the conditional variance 
%     equation constant "K". Note that when Q = 0, P = 0 as well, and a 
%     GJR(0,0) model is simply a constant variance model.
%
      if Q > 0
%
%        The matrix "I" below is a Q-by-Horizon index array. Each column
%        of "I" contains the row numbers of the residuals matrix e(t) for 
%        which the known residuals are needed so that their signs may be 
%        tested and leverage effects applied. Note that any ones in the "I" 
%        matrix, other than the first column, are merely placeholders to 
%        guarantee a valid index.
%
%        The "mask" matrix is a Q-by-Horizon logical array corresponding 
%        to "I". Each column of "mask" indicates whether or not to use the 
%        sign of the known residual, or to apply the probability of a 
%        negatively signed residual (i.e., 0.5). Each element of "mask" 
%        that is true (i.e., logical one) indicates that we are forecasting 
%        the sign of a future residual. The "mask" array is cast to a 
%        LOGICAL so it may be used for indexing.
%
         I    =  toeplitz([(maxRMPQ + 1) - (1:Q)] , [maxRMPQ  ones(1,T-maxRMPQ-1)]);
         mask =  logical(toeplitz(zeros(Q,1) , [0 ones(1,T-maxRMPQ-1)]));
%
%        Since GJR(P,Q) forecasting requires squared innovations, work 
%        with them directly instead of the e(t) process.
%
         e2      =  e(1:maxRMPQ , :).^2;    % Innovations squared.
         e2(T,:) =  0;
%     
%        For each iteration in the future, GJR(P,Q) forecasting applies 
%        the identity that the conditional expectation of any future squared 
%        innovation is also the conditional expectation of it's corresponding
%        variance forecast.
%
         for t = (maxRMPQ + 1):T
%
%            For each iteration, the next 3 lines of code perform the following:
%
%            (1) Assign the known residuals from the observation interval (if any)
%            (2) Determine the sign of any known past residual (if any), indicating
%                negative and positive residuals by ones and zeros, respectively, 
%                to allow for leverage effects. Notice that the resulting logical 
%                array is explicitly cast to a floating point DOUBLE data type so
%                as to mix what are essentially logical-valued zeros and ones with
%                real-valued probabilities.
%            (3) Overwrite any required, yet unknown, future residuals with the
%                probability of a negative sign using the "mask" array.
%
%            The result is a Q-by-nPaths array whose elements indicate the probability 
%            of a negative residual. This array is filled with the values 0, 1, and 
%            0.5, indicating a known past positive residual, a known past negative 
%            residual, and a future residual of unknown sign, respectively.
%
             e1                      =  e(I(:,t-maxRMPQ),:);
             e1                      =  double(e1 < 0);
             e1(mask(:,t-maxRMPQ),:) =  0.5;
%
%            Now use the resulting probability array to weight the corresponding 
%            squared residual.
%
             varianceData =  [ones(1,nPaths) ; h(t-(1:P),:) ; e2(t-(1:Q),:) ; (e1 .* e2(t-(1:Q),:))];
             h (t,:)      =  varianceCoefficients * varianceData;
             e2(t,:)      =  h(t,:);

         end

      else

         h((maxRMPQ + 1):T,:)  =  K;

      end

end

%
% Forecast the conditional mean of y(t) only if requested.
%

if nargout >= 2

%
%  Get ARMA coefficients needed to forecast the conditional mean.
%
   C   =  garchget(spec , 'C');       % Conditional mean constant.
   AR  =  garchget(spec , 'AR');      % Conditional mean AR coefficients.
   MA  =  garchget(spec , 'MA');      % Conditional mean MA coefficients.

%
%  If the conditional mean equation constant is NaN (i.e., Not-Applicable), then
%  set it to zero to get the desired effect without any additional special-purpose
%  code.
%
   if isnan(C)
      C  =  0;
   end

%
%  Construct ARMA portion of the conditional mean 
%  parameter vector of length (1 + R + (1 + M)).
%

   armaCoefficients  =  [C ; AR(:) ; [1 ; MA(:)]]';

   if isempty(XF)
%
%     No regression component in the conditional mean equation.
%
      if isVarianceInMean

         InMean  =  garchget(spec , 'InMean');  % Coefficient for variance-in-mean models. 
%
%        ARMA(R,M) + Variance-in-Mean model.
%
         for t = (maxRMPQ + 1):T
             armaData =  [ones(1,nPaths) ; y(t-(1:R),:) ; e(t-(0:M),:)];
             y(t,:)   =  (armaCoefficients * armaData)  +  (InMean * h(t,:));
         end

      else
%
%        ARMA(R,M) model only.
%
         for t = (maxRMPQ + 1):T
             armaData =  [ones(1,nPaths) ; y(t-(1:R),:) ; e(t-(0:M),:)];
             y(t,:)   =  armaCoefficients * armaData;
         end

      end

   else    

%
%     The conditional mean equation includes a regression component.
%
%     Regression models included in the conditional mean are ultimately based 
%     upon the presence of the explanatory data matrices X and XF. Since the 
%     current version of the GARCH Toolbox allows for uni-variate models only, 
%     each column of the outputs represents a different realization of the 
%     corresponding uni-variate stochastic process. 
%
%     However, in contrast to the outputs, the input explanatory regression
%     matrices X and XF are each interpreted as a single realization of a 
%     possibly multi-variate regression matrix in which each column is a 
%     completely different time series.
%
%     This means that, when the conditional mean has a regression component, 
%     the entire explanatory matrix XF (i.e., all columns of XF) are applied
%     to each and every column (i.e., realization) of the output forecasts.
%

%
%     Pre-pend 'maxRMPQ' rows to XF for initialization.
%
      XF  =  [zeros(maxRMPQ,size(XF,2)) ; XF];

      if isVarianceInMean

         InMean  =  garchget(spec , 'InMean');  % Coefficient for variance-in-mean models. 
%
%        ARMAX(R,M,Nx) + Variance-in-Mean model.
%
         for t = (maxRMPQ + 1):T
             armaData =  [ones(1,nPaths) ; y(t-(1:R),:) ; e(t-(0:M),:)];
             y(t,:)   =  (armaCoefficients * armaData)  +  (InMean * h(t,:))  +  (regress * XF(t,:)');
         end

      else
%
%        ARMAX(R,M,Nx) model.
%
         for t = (maxRMPQ + 1):T
             armaData =  [ones(1,nPaths) ; y(t-(1:R),:) ; e(t-(0:M),:)];
             y(t,:)   =  (armaCoefficients * armaData)  +  (regress * XF(t,:)');
         end

      end

   end

   y  =  y((maxRMPQ + 1):end , :);

end

%
% Now strip off the first 'maxRMPQ' values of the conditional variance h(t). 
% After the first 'maxRMPQ' values have been excluded, h(j) = j-period-ahead 
% forecast of the conditional variance.
%

h  =  h((maxRMPQ + 1):end , :);

%
% Compute the following for stationary/invertible ARMA conditional 
% mean models ONLY (i.e., no regression or variance-in-mean components):
%
%   (1) The forecast of the standard deviation of the returns that
%       would be obtained if an asset were held for multiple periods.
%       In other words, for each period 1, 2, ... horizon, this is 
%       the volatility forecast of the effective, or cumulative,
%       return that would be expected if the asset was held for 1
%       period then sold, for 2 periods then sold, and so on. For
%       conditional mean models without an ARMAX component such that
% 
%           y(t) = C + e(t)
%
%       the result is the conditional analog of the 'square-root-of-time-rule'
%       for scaling standard deviations over multi-period holding intervals.
%
%       These volatility forecasts are correct for continuously-compounded
%       returns, but only approximations for periodically-compounded returns.
%
%   (2) The root mean square error (RMSE) of the forecast of the 
%       conditional mean (i.e., the standard error of the forecast
%       of future values of y(t)) in each period. This is the square
%       root of equation (19) of Baillie & Bollerslev for each 
%       period 1, 2, ... horizon.
%

yRMSE      =  [];
yTotalRMSE =  [];

if (nargout >= 3) & isempty(X) & ~isVarianceInMean

   InfiniteMA  =  1;
%
%  Compute the coefficients of the (truncated) infinite-order MA 
%  representation associated with the finite-order ARMA(R,M) model.
%
   if horizon > 1
      InfiniteMA  =  [InfiniteMA ; garchma(AR(:) , MA(:) , horizon - 1)];
   end

%
%  Compute the forecast of the standard deviation of the returns that
%  would be obtained if an asset were held for multiple periods. These 
%  are the volatility forecasts of returns over a multi-period holding
%  interval.
%

   yTotalRMSE  =  sqrt(toeplitz(cumsum(InfiniteMA(:)).^2 , [1  zeros(1 , horizon - 1)]) * h);

%
%  Compute the root mean square error (RMSE) of the forecast of the 
%  conditional mean in each period (i.e., on a per-period basis). This
%  is the square root of equation (19) of Baillie & Bollerslev for each 
%  period 1, 2, ... horizon.
%

   if nargout >= 4
      yRMSE  =  sqrt(toeplitz(InfiniteMA(:).^2 , [1  zeros(1 , horizon - 1)]) * h);
   end

end

%
% Since h(t) is the conditional variance, convert it to a standard deviation.
%

h  =  sqrt(h);

%
% Re-format outputs for compatibility with the return series input. 
% When return series input is specified as a single row vector, then 
% pass the outputs as row vectors. 
%

if rowY
   h          =  h(:).'; 
   y          =  y(:).';
   yRMSE      =  yRMSE(:).';
   yTotalRMSE =  yTotalRMSE(:).';
end