function [H, pValue, Ratio, criticalValue] = lratiotest(BaseLLF, NullLLF, DoF, alpha)
%LRATIOTEST Likelihood ratio hypothesis test.
%   Given the optimized log-likelihood function (LLF) value associated with 
%   an unrestricted maximum likelihood parameter estimate, and the LLF values 
%   associated with restricted parameter estimates, perform the likelihood ratio
%   hypothesis test. The unrestricted LLF is the baseline case used to fit 
%   conditional mean and variance specifications to an observed univariate 
%   return series. The restricted models determine the null hypotheses of each 
%   test, and the number of restrictions they impose determines the degrees of 
%   freedom of the resulting Chi-square distribution.
%
%   [H, pValue, Ratio, CriticalValue] = lratiotest(BaseLLF, NullLLF, DoF)
%   [H, pValue, Ratio, CriticalValue] = lratiotest(BaseLLF, NullLLF, DoF, Alpha)
%
%   Optional Inputs: Alpha
%
% Inputs:
%   BaseLLF - Scalar value of the optimized log-likelihood objective function
%     of the baseline, unrestricted estimate. BaseLLF is assumed to be obtained
%     from the estimation function GARCHFIT, or the inference function
%     GARCHINFER. Type "help garchfit" or "help garchinfer" for details.
%
%   NullLLF - Vector of optimized log-likelihood objective function values of
%     the restricted estimates. NullLLF values are also assumed to be obtained 
%     from GARCHFIT or GARCHINFER.
%
%   DoF - Degrees of freedom (i.e., the number of parameter restrictions)
%     associated with each value in NullLLF. DoF may be a scalar applied to
%     all values in NullLLF, or a vector the same length as NullLLF. All 
%     elements of DoF must be positive integers. 
%
% Optional Input:
%   Alpha - Significance levels of the hypothesis test. Alpha may be a scalar 
%     applied to all values in NullLLF, or a vector of significance levels the
%     same length as NullLLF. If empty or missing, the default is 0.05. All 
%     elements of Alpha must be greater than zero and less than one.
%
% Outputs:
%   H - Vector of Boolean decisions (sequence of 0's and 1's) the same size as 
%     NullLLF. Elements of H = 0 indicate acceptance of the restricted model 
%     under the null hypothesis; elements of H = 1 indicate rejection of the 
%     restricted, null hypothesis model relative to the unrestricted 
%     alternative associated with BaseLLF.
%
%   pValue - Vector of P-values (significance levels) at which the null 
%     hypothesis of each restricted model is rejected. pValue will be the same 
%     size as NullLLF.
%
%   Ratio - Vector of likelihood ratio test statistics the same size as NullLLF.
%     The test statistic is Ratio = 2(BaseLLF - NullLLF).
%
%   CriticalValue - Vector of critical values of the Chi-square distribution. 
%     CriticalValue will be the same size as NullLLF.
%
% Notes:
%   BaseLLF is usually the LLF of a larger estimated model and serves as the
%   alternative hypothesis. NullLLF are then the LLF's associated with smaller, 
%   restricted specifications. BaseLLF should exceed the values in NullLLF, 
%   and the asymptotic distribution of the test statistic is Chi-square 
%   distributed with degrees of freedom equal to the number of restrictions.
%
% See also GARCHFIT, GARCHINFER.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.7.4.1 $   $Date: 2003/05/08 21:45:36 $

%
% References:
%   Hamilton, J.D., "Time Series Analysis", Princeton University Press, 1994.
%

%
% Ensure sufficient inputs exist.
%

if (nargin < 3) | isempty(BaseLLF) | isempty(NullLLF) | isempty(DoF)
   error('GARCH:lratiotest:UnspecifiedInput' , ' ''BaseLLF'', ''NullLLF'', and ''DoF'' must all be specified.')
end

%
% Ensure BaseLLF is a scalar.
%

if prod(size(BaseLLF)) > 1
   error('GARCH:lratiotest:NonScalarBaseLLF' , ' Unrestricted LLF value ''BaseLLF'' must be a scalar.')
end

%
% Ensure NullLLF is a vector.
%

if prod(size(NullLLF)) == length(NullLLF)    % Check for a vector.
   rowLLF  =  size(NullLLF,1) == 1;          % Flag a row vector for outputs.
   NullLLF =  NullLLF(:);                    % Convert to a column vector.
else
   error('GARCH:lratiotest:NonVectorNullLLF' , ' ''NullLLF'' must be a vector.')
end

%
% Ensure the Chi-square distribution degrees of freedom, DoF, is either
%   (1) a scalar, or
%   (2) a vector the same size as NullLLF.
%
% In either case, ensure all elemnets of DoF are positive integers.
%

if prod(size(DoF)) ~= length(DoF)            % Check for a vector.
   error('GARCH:lratiotest:NonVectorDoF' , ' ''DoF'' must be a vector.');
end

DoF  =  DoF(:);

if any(round(DoF) - DoF) | any(DoF <= 0)
   error('GARCH:lratiotest:NonPositiveIntegerDoF' , ' All elements of ''DoF'' must be positive integers.')
end

if length(DoF) == 1
   DoF  =  DoF(ones(length(NullLLF),1));     % Scalar expansion.
end

if length(DoF) ~= length(NullLLF)
   error('GARCH:lratiotest:DoFNullLLFLengthMismatch' , ' Sizes of ''DoF'' and ''NullLLF'' must be the same.');
end

%
% Ensure the significance level, ALPHA, is between 
% 0 and 1, and set default if necessary.
%

if (nargin >= 4) & ~isempty(alpha)
   if prod(size(alpha)) ~= length(alpha)         % Check for a vector.
      error('GARCH:lratiotest:NonVectorAlpha' , ' ''Alpha'' must be a vector.');
   end
   alpha  =  alpha(:);
   if any(alpha <= 0 | alpha >= 1)
      error('GARCH:lratiotest:InvalidAlpha' , ' All significance levels ''Alpha'' must be between 0 and 1.'); 
   end
   if length(alpha) == 1
      alpha  =  alpha(ones(length(NullLLF),1));  % Scalar expansion.
   end
   if length(alpha) ~= length(NullLLF)
      error('GARCH:lratiotest:AlphaNullLLFLengthMismatch' , ' Sizes of ''Alpha'' and ''NullLLF'' must be the same.');
   end
else
   alpha  =  0.05;
   alpha  =  alpha(ones(length(NullLLF),1));     % Scalar expansion.
end

%
% Compute the Likelihood Ratio Test statistics and the corresponding 
% P-values (i.e., significance levels). Since the CHI2INV function
% is a slow, iterative procedure, compute the critical values ONLY
% if requested. Under the null hypothesis, the test statistic is 
% asymptotically Chi-Square distributed with degrees of freedom equal
% number of restrictions.
%

Ratio   =  2 * (BaseLLF - NullLLF);
pValue  =  1 - chi2cdf(Ratio , DoF);

if nargout >= 4
   criticalValue  =  chi2inv(1 - alpha , DoF);
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
% Re-format outputs for compatibility with the NullLLF input. When 
% NullLLF is input as a row vector, then pass the outputs as a row vectors. 
%

if rowLLF
   H              =  H(:).';
   pValue         =  pValue(:).';
   Ratio          =  Ratio(:).';
   criticalValue  =  criticalValue(:).';
end
