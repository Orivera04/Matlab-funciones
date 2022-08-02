function [H, pValue, testStatistic, criticalValue] = archtest(residuals , Lags , alpha)
%ARCHTEST Hypothesis test for the presence of ARCH/GARCH effects.
%   Test the null hypothesis that a time series of sample residuals is i.i.d. 
%   Gaussian disturbances (i.e., no ARCH effects exist). Given sample residuals 
%   obtained from a curve fit (e.g., a regression model), the presence of Mth 
%   order ARCH effects is tested by regressing the squared residuals on a 
%   constant and M lags. The asymptotic test statistic, T*R^2, where T is the 
%   number of squared residuals included in the regression and R^2 is the sample 
%   multiple correlation coefficient, is asymptotically Chi-Square distributed 
%   with M degrees of freedom under the null hypothesis. When testing for ARCH
%   effects, a GARCH(P,Q) process is locally equivalent to an ARCH(P+Q) process.
%
%   [H, pValue, ARCHstat, CriticalValue] = archtest(Residuals)
%   [H, pValue, ARCHstat, CriticalValue] = archtest(Residuals, Lags, Alpha)
%
%   Optional Inputs: Lags, Alpha
%
% Inputs:
%   Residuals - Time series vector of sample residuals (obtained from a curve
%     fit, such as a regression model), examined for the presence of ARCH 
%     effects. The last element contains the most recent observation.
%
% Optional Inputs:
%   Lags - Vector of positive integers indicating the lags of the squared 
%     sample residuals included in the ARCH test statistic. If specified, 
%     each lag should be significantly less than the length of Residuals. 
%     If empty or missing, the default is 1 lag (i.e., first order ARCH).
%
%   Alpha - Significance level(s) of the hypothesis test. Alpha may be a scalar 
%     applied to all lags in Lags, or a vector of significance levels the same
%     length as Lags. If empty or missing, the default is 0.05. All elements 
%     of Alpha must be greater then zero and less than one.
%
% Outputs:
%   H - Boolean decision vector. Elements of H = 0 indicate acceptance of the 
%     null hypothesis that no ARCH effects exist (i.e., homoskedasticity at
%     the corresponding element of Lags); elements of H = 1 indicate rejection
%     of the null hypothesis. H is a vector the same size as Lags.
%
%   pValue - Vector of P-values (significance levels) at which the null 
%     hypothesis of no ARCH effects at each lag in Lags is rejected.
%
%   ARCHstat - Vector of ARCH test statistics for each lag in Lags.
%
%   CriticalValue - Vector of critical values of the Chi-square distribution 
%     for comparison with the corresponding element of ARCHstat.
%
% Example:
%   Create a vector of 100 (synthetic) residuals, then test for 1st, 2nd, 
%   and 4th order ARCH effects at the 10 percent significance level:
%
%     randn('state',0)                % Start from a known state.
%     residuals     = randn(100,1);   % 100 Gaussian deviates ~ N(0,1)
%     [H,P,Stat,CV] = archtest(residuals , [1 2 4]' , 0.10)
%
% See also LBQTEST.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.6.2.1 $  $Date: 2003/05/08 21:45:14 $

%
% References:
%   Box, G.E.P., Jenkins, G.M., Reinsel, G.C., "Time Series Analysis: 
%     Forecasting and Control", 3rd edition, Prentice Hall, 1994.
%   Engle, Robert (1982), "Autoregressive Conditional Heteroskedasticity with Estimates of
%      the Variance of United Kingdom Inflation", Econometrica, vol. 50, pp. 987-1007.

%
% Ensure the sample data is a VECTOR.
%

[rows , columns]  =  size(residuals);

if (rows ~= 1) & (columns ~= 1) 
    error('GARCH:archtest:NonVectorInput' , ' Input ''Residuals'' must be a vector.');
end

residuals2  =  residuals(:).^2;     % Ensure a column vector
n           =  length(residuals2);  % Raw sample size.
defaultLags =  1;                   % First-order ARCH test.

%
% Ensure LAGS is a vector, that elements of LAGS are all positive 
% integers, and set default if necessary.
%

if (nargin >= 2) & ~isempty(Lags)
   if prod(size(Lags)) == length(Lags)    % Check for a vector.
      rowLags  =  size(Lags,1) == 1;
   else
      error('GARCH:archtest:NonVectorLags' , ' ''Lags'' must be a vector.');
   end
   Lags  =  Lags(:);
   if any(round(Lags) - Lags) | any(Lags <= 0)
      error('GARCH:archtest:NonPositiveInteger' , ' All elements of ''Lags'' must be positive integers.')
   end
   if any(Lags > (n - 2))
      error('GARCH:archtest:LagsTooLarge' , ' All elements of ''Lags'' must not exceed ''Residuals'' length - 2.');
   end
else
   Lags     =  defaultLags;
   rowLags  =  logical(0);                        
end

%
% Ensure the significance level, ALPHA, is a scalar 
% between 0 and 1, and set default if necessary.
%

if (nargin >= 3) & ~isempty(alpha)
   if prod(size(alpha)) ~= length(alpha)    % Check for a vector.
      error('GARCH:archtest:NonVectorAlpha' , ' ''Alpha'' must be a vector.');
   end
   alpha  =  alpha(:);
   if any(alpha <= 0 | alpha >= 1)
      error('GARCH:archtest:InvalidAlpha' , ' All significance levels ''Alpha'' must be between 0 and 1.'); 
   end
   if length(alpha) == 1
      alpha  =  alpha(ones(length(Lags),1));    % Scalar expansion.
   end
   if length(alpha) ~= length(Lags)
      error('GARCH:archtest:VectorLengthMismatch' , ' Sizes of ''Alpha'' and ''Lags'' must be the same');
   end
else
   alpha  =  0.05;
end

%
% Compute the requested regressions and store the R^2 statistics.
% 

nLags =  length(Lags);
R2    =  zeros (nLags,1);

for order = 1:nLags
    X         =  [ones(n,1)  lagmatrix(residuals2,[1:Lags(order)])];
    X         =  X(Lags(order)+1:end,:);                    % Explanatory regression matrix.
    y         =  residuals2(Lags(order)+1:end);             % Dependent variable.
    yHat      =  X * (X \ y);                               % Predicted responses at each point.
    T         =  n - Lags(order);                           % Effective sample size.
    yHat      =  yHat - sum(yHat)/T;                        % De-meaned predicted responses.
    y         =  y - sum(y)/T;                              % De-meaned observed responses.
    R2(order) =  (yHat'*yHat)/(y'*y);                       % Centered R-squared.
end

%
% Compute the ARCH effect test statistic and the corresponding 
% P-values (i.e., significance levels). Since the CHI2INV function
% is a slow, iterative procedure, compute the critical values ONLY
% if requested. Under the null hypothesis that the input 'residuals'
% are i.i.d. ~N(0,v) Gaussian variates of constant variance (i.e., 
% homoskedastic), the test statistic is asymptotically Chi-Square 
% distributed with degrees of freedom equal to the number of lags 
% uncluded in the regression.
%

testStatistic  =  R2 .* (n - Lags);                         % T*R^2 test statistic.
pValue         =  1 - chi2cdf(testStatistic , Lags);

if nargout >= 4
   criticalValue  =  chi2inv(1 - alpha , Lags);
else
   criticalValue  =  [];
end

%
% To maintain consistency with existing Statistics Toolbox hypothesis
% tests, returning 'H = 0' implies that we 'Do not reject the null 
% hypothesis at the significance level of alpha' and 'H = 1' implies 
% that we 'Reject the null hypothesis at significance level of alpha.'
%

H  =  (alpha >= pValue);

%
% Re-format outputs for compatibility with the LAGS input. When LAGS is
% input as a row vector, then pass the outputs as a row vectors. 
%

if rowLags
   H              =  H(:).';
   pValue         =  pValue(:).';
   testStatistic  =  testStatistic(:).';

   if ~isempty(criticalValue)
      criticalValue  =  criticalValue(:).';
   end
end
