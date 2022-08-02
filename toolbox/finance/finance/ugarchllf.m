function LLF = ugarchllf(parameters , u , p , q)
%UGARCHLLF Log-likelihood objective function of univariate GARCH(P,Q)
%          processes with Gaussian innovations.
%
%   LogLikelihood = ugarchllf(Parameters , U , P , Q)
%
%   Inputs:
%     Parameters: (1 + P + Q) by 1 column vector of GARCH(P,Q) process 
%     parameters. The first element is the scalar constant term of the GARCH
%     process; the next P elements are coefficients associated with the P lags
%     of the conditional variance terms; the next Q elements are coefficients 
%     associated with the Q lags of the squared innovations terms.
%
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
%   Output:
%     LogLikelihood: Scalar value of the GARCH(P,Q) log-likelihood objective
%     function given the input arguments. This function is meant to be 
%     optimized via the FMINCON function of the MATLAB Optimization Toolbox. 
%     FMINCON is a minimization routine. To maximize the log-likelihood 
%     function, the likelihood output parameter is actually the negative 
%     of what is formally presented in most time series or econometrics 
%     references.
%
%   Notes:
%     The time-conditional variance, H(t), of a GARCH(P,Q) process is modeled 
%     as follows:
%
%     H(t) = Kappa + Alpha(1)*H(t-1) + Alpha(2)*H(t-2) +...+ Alpha(P)*H(t-P)
%                  + Beta(1)*U^2(t-1)+ Beta(2)*U^2(t-2)+...+ Beta(Q)*U^2(t-Q)
%
%     Note that U is vector of innovations representing a mean-zero, discrete 
%     time stochastic process. Although H is generated via the equation above, 
%     U and H are related as follows:
%    
%     U(t) = sqrt(H(t))*v(t), where {v(t)} is an i.i.d. sequence ~ N(0,1).
%
%   Also, since this function is really just a helper function, no argument 
%   checking is performed; thus, this function is NOT meant to be called 
%   directly from the command line.
%
%   See also UGARCHPRED, UGARCHSIM, UGARCHPLOT, UGARCH.

% Author(s): R.A. Baker, 04/29/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.9 $   $ Date: 1998/01/30 13:45:34 $

%
% Reference: James D. Hamilton, 'Time Series Analysis',
%            Princeton University Press, 1994. ISBN 0-691-04289-6.

%
% Over-write all parameters less than or equal to zero to 
% prevent the LLF from becoming minus infinity or complex.
%

parameters(find(parameters <= 0)) = realmin;

%
% GARCH(P,Q) processing requires pre-sample values for conditioning. That is, we 
% require P pre-sample values of h(t), the conditional variance of the residuals,
% or innovations, u(t), and Q pre-sample values of u(t) itself to 'jump-start' 
% the process. To be safe, create max(P,Q) pre-sample lags of both h(t) and u(t).
%
% NOTE: There appears to be (at least) 2 methods for 'jump-starting' the process:
%
%   (1) We can take u(t) as is, and allocate, say, the first M = max(P,Q) samples 
%       of u(t) for a preliminary estimate of the GARCH parameters. This is referred 
%       to as 'conditioning' on the first 'M' samples. The remaining samples are then
%       used for estimation via maximum likelihood (see Hamilton, bottom of page 660).
%
%   (2) We can create M = max(P,Q) samples and prepend them to u(t), thus increasing
%       the size of u(t) by M samples. Hamilton (top of page 667), suggests estimating
%       the unconditional variance of u(t) and assigning the estimate to the first M
%       samples of h(t) and u^2(t). This implies that the square root of this estimate
%       (the unconditional standard deviation) is assigned to the first M samples of
%       u(t). The original samples of u(t) are then used for estimation via maximum 
%       likelihood.
%
%   These are just 2 alternative methods for modeling the transient response of the 
%   GARCH process, and should have little effect on the steady-state characteristics
%   of the process. In the code below, I have chosen method (2).
%

m  =  max(p,q);   % # of pre-sample lags needed to 'jump-start' the process.

%
% Implement method 2 outlined above.
%

stdEstimate =  std(u,1);                      % Estimate the unconditional STD of u(t).
u           =  [stdEstimate(ones(m,1)) ; u];  % Prepend M samples to u(t).
T           =  size(u,1);                     % The total (original + M padded samples) length of u(t).

%
% Since M samples of the unconditional standard deviation of u(t) have been 
% assigned to the first M samples of u(t), assign u^2(1) to the first M
% samples to h(t) to 'jump-start' the process.
%

h  =  u(1).^2;
h  =  [h(ones(m,1)) ; zeros(T-m,1)];   % Pre-allocate the h(t) vector.

%
% Form the h(t) time series and evaluate the log-likelihood function.
% Note that LLF estimation is based on the original u(t) innovations 
% sequence, and ignores the M pre-pended samples.
%

for t = (m + 1):T
    h(t) = parameters' * [1 ; h(t-(1:p)) ; u(t-(1:q)).^2];
end

t    = (m + 1):T;
LLF  =  sum(log(h(t))) + sum((u(t).^2)./h(t));
LLF  =  0.5 * (LLF  +  (T - m)*log(2*pi));
