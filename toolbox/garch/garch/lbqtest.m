function [H, pValue, Qstatistic, criticalValue] = lbqtest(Series , Lags , alpha , DoF)
%LBQTEST Ljung-Box Q-statistic lack-of-fit hypothesis test.
%   The Ljung-Box lack-of-fit hypothesis test for model misspecification is 
%   based on the Q-statistic:
%
%                   L    2
%        Q = N(N+2)Sum(r^(k)/(N-k))
%                  k=1
%
%   where N = sample size, L = number of autocorrelation lags included in the 
%   statistic, and r^2(k) is the squared sample autocorrelation at lag k. Once 
%   a univariate model is fit to an observed time series, the Q-statistic is 
%   used as a lack-of-fit test for a departure from randomness. Under the null 
%   hypothesis that the model fit is adequate, the test statistic is 
%   asymptotically Chi-square distributed.
%
%   [H, pValue, Qstat, CriticalValue] = lbqtest(Series)
%   [H, pValue, Qstat, CriticalValue] = lbqtest(Series , Lags , Alpha , DoF)
%
%   Optional Inputs: Lags, Alpha, DoF
%
% Input:
%   Series - Vector of observations of a univariate time series for which the
%     sample Q-statistic is computed. The last row of Series contains the most
%     recent observation of the stochastic sequence. Typically, Series is 
%     either the sample residuals derived from fitting a model to an observed
%     time series, or the standardized residuals obtained by dividing the 
%     sample residuals by the conditional standard deviations.
%
% Optional Inputs:
%   Lags - Vector of positive integers indicating the lags of the sample 
%     autocorrelation function included in the Q-statistic. If specified, each 
%     lag must be less than the length of Series. If empty or missing, the 
%     default is Lags = minimum[20 , length(Series)-1]. If the optional input 
%     DoF (see below) is unspecified, Lags also serves as the default degree(s) 
%     of freedom for the Chi-square distribution.
%
%   Alpha - Significance level(s). Alpha may be a scalar applied to all lags, 
%     or a vector the same length as Lags. If empty or missing, the default is 
%     0.05. All elements of Alpha must be greater than zero and less than one.
%
%   DoF - Degree(s) of freedom. DoF may be a scalar applied to all lags, or a 
%     vector the same length as Lags. If specified, all elements of DoF must be
%     positive integers less than the corresponding element of Lags. If empty 
%     or missing, the elements of Lags serve as the default degrees of freedom.
%
% Outputs:
%   H - Boolean decision vector. Elements of H = 0 indicate acceptance of the 
%     null hypothesis that the model fit is adequate (no serial correlation 
%     at the corresponding element of Lags); elements of H = 1 indicate 
%     rejection of the null hypothesis. H is the same size as Lags.
%
%   pValue - Vector of P-values (significance levels) at which the null 
%     hypothesis of no serial correlation at each lag in Lags is rejected.
%
%   Qstat - Vector of Q-statistics for each lag in Lags.
%
%   CriticalValue - Vector of critical values of the Chi-square distribution 
%     for comparison with the corresponding element of Qstat.
%
% Example:
%    Create a vector of 100 Gaussian random numbers, then compute Q-statistic
%    for autocorrelation lags 20 and 25 at the 10 percent significance level:
%
%      randn('state',100)               % Start from a known state.
%      Series         = randn(100,1);   % 100 Gaussian deviates ~ N(0,1)
%      [H,P,Qstat,CV] = lbqtest(Series , [20 25]' , 0.10)
%
% See also AUTOCORR, ARCHTEST.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.5.2.1 $  $Date: 2003/05/08 21:45:35 $

%
% Reference:
%   Box, G.E.P., Jenkins, G.M., Reinsel, G.C., "Time Series Analysis: 
%     Forecasting and Control", 3rd edition, Prentice Hall, 1994.

%
% Ensure the sample data SERIES is a VECTOR.
%

[rows , columns]  =  size(Series);

if (rows ~= 1) & (columns ~= 1) 
    error('GARCH:lbqtest:NonVectorSeries' , ' Input ''Series'' must be a vector.');
end

Series      =  Series(:);       % Ensure a column vector
n           =  length(Series);  % Sample size.
defaultLags =  20;              % BJR recommend about 20 lags for ACFs.

%
% Ensure the elements of LAGS are all positive 
% integers, and set default if necessary.
%

if (nargin >= 2) & ~isempty(Lags)
   if prod(size(Lags)) == length(Lags)    % Check for a vector.
      rowLags  =  size(Lags,1) == 1;
   else
      error('GARCH:lbqtest:NonVectorLags' , ' ''Lags'' must be a vector.');
   end
   Lags  =  Lags(:);
   if any(round(Lags) - Lags) | any(Lags <= 0)
      error('GARCH:lbqtest:NonPositiveIntegerLags' , ' All elements of ''Lags'' must be positive integers.')
   end
   if any(Lags > (n - 1))
      error('GARCH:lbqtest:LagsTooLarge' , ' All elements of ''Lags'' must not exceed ''Series'' length - 1.');
   end
else
   Lags     =  min(defaultLags , n - 1);
   rowLags  =  logical(0);
end

%
% Ensure the significance level, ALPHA, is a scalar 
% between 0 and 1, and set default if necessary.
%

if (nargin >= 3) & ~isempty(alpha)
   if prod(size(alpha)) ~= length(alpha)    % Check for a vector.
      error('GARCH:lbqtest:NonVectorAlpha' , ' ''Alpha'' must be a vector.');
   end
   alpha  =  alpha(:);
   if any(alpha <= 0 | alpha >= 1)
      error('GARCH:lbqtest:InvalidAlpha' , ' All significance levels ''Alpha'' must be between 0 and 1.'); 
   end
   if length(alpha) == 1
      alpha  =  alpha(ones(length(Lags),1));    % Scalar expansion.
   end
   if length(alpha) ~= length(Lags)
      error('GARCH:lbqtest:AlphaLagsLengthMismatch' , ' Sizes of ''Alpha'' and ''Lags'' must be the same.');
   end
else
   alpha  =  0.05;
end

%
% Ensure the Chi-square distribution degrees of freedom, DoF, is either
%   (1) a scalar, or
%   (2) a vector the same size as LAGS.
%
% In either case, ensure all elemnets of DoF are positive integers, and
% set default if necessary.
%

if (nargin >= 4) & ~isempty(DoF)
   if prod(size(DoF)) ~= length(DoF)    % Check for a vector.
      error('GARCH:lbqtest:NonVectorDoF' , ' ''DoF'' must be a vector.');
   end
   DoF  =  DoF(:);
   if any(round(DoF) - DoF) | any(DoF <= 0)
      error('GARCH:lbqtest:NonPositiveIntegerDoF' , ' All elements of ''DoF'' must be positive integers.')
   end
   if length(DoF) == 1
      DoF  =  DoF(ones(length(Lags),1));    % Scalar expansion.
   end
   if length(DoF) ~= length(Lags)
      error('GARCH:lbqtest:DoFLagsLengthMismatch' , ' Sizes of ''DoF'' and ''Lags'' must be the same.');
   end
   if any(DoF > Lags)
      error('GARCH:lbqtest:DoFTooLarge' , ' No element of ''DoF'' may exceed corresponding element of ''Lags''.');
   end
else
   DoF  =  Lags;
end

%
% Identify the largest auto-correlation lag and compute the sample ACF
% out to there. Note that, currently, the function ACFPLOT returns the
% ACF for lags 0,1,2 ... maxLag. Thus, ACF(1) = 1 = zeroth lag, and we 
% strip this off.
%

maxLag =  max(Lags);
N      =  [n - [1:maxLag]]';
ACF    =  autocorr(Series , maxLag);
ACF    =  ACF(2:end);

%
% Compute the Q-statistic for all lags, but keep only those requested. For
% those lags requested, also compute the level of significance (P-value) 
% at which the null hypothesis of no serial correlation is rejected.
%

Qstatistic  =  n * (n + 2) * cumsum((ACF.^2)./N);
Qstatistic  =  Qstatistic(Lags);                   % Retain only those lags we need.
pValue      =  1 - chi2cdf(Qstatistic , DoF);

%
% Since the CHI2INV function is a slow, iterative procedure, compute 
% the critical values ONLY if requested.
%

if nargout >= 4
   criticalValue =  chi2inv(1 - alpha , DoF);
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
   H           =  H(:).';
   pValue      =  pValue(:).';
   Qstatistic  =  Qstatistic(:).';

   if ~isempty(criticalValue)
      criticalValue  =  criticalValue(:).';
   end
end
