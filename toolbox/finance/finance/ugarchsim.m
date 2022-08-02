function [u,h] = ugarchsim(kappa , alpha , beta , nSamples)
%UGARCHSIM Simulate a univariate GARCH(P,Q) process with Gaussian innovations.
%
%   [U , H] = ugarchsim(Kappa , Alpha , Beta , NumSamples)
%
%   Inputs:
%     Kappa: Scalar constant term of the GARCH process. 
%
%     Alpha: P by 1 column vector of coefficients, where P is a model order that
%     determines the number of lags of the conditional variance included in 
%     the GARCH process. Alpha can be an empty matrix, in which case P is 
%     assumed zero; when P = 0, a GARCH(0,Q) process is actually an ARCH(Q) 
%     process.
%
%     Beta: Q by 1 column vector of coefficients, where Q is a model order that
%     determines the number of lags of the squared innovations included in 
%     the GARCH process.
%
%     NumSamples: Positive, scalar integer indicating the number of samples of
%     the innovations U and conditional variance H (see below) to simulate.
%
%   Outputs:
%     U: NUMSAMPLES by 1 column vector of innovations, representing a mean-zero,
%     discrete-time stochastic process. The innovations time series U is 
%     designed to follow the GARCH(P,Q) process specified by the inputs Kappa,
%     Alpha, and Beta. 
%
%     H: NUMSAMPLES by 1 column vector of the conditional variance corresponding 
%     to the innovations vector U. Note that U and H are the same length, and 
%     form a 'matching' pair of vectors. To model the GARCH(P,Q) process, the 
%     conditional variance time series, H(t), must be constructed (see notes 
%     below). Thus, H(t) represents the time series inferred from the 
%     innovations time series vector U. 
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
%     Note that U is vector of innovations representing a mean-zero, 
%     discrete-time stochastic process. Although H is generated via the 
%     equation above, U and H are related as follows:
%    
%     U(t) = sqrt(H(t))*v(t), where {v(t)} is an i.i.d. sequence ~ N(0,1).
%
%     The output vectors U and H are designed to be steady-state sequences,  
%     in that transients have arbitrarily small effect. The (arbitrary) metric 
%     used strips the first N samples of U and H such that the sum of the   
%     GARCH coefficients, excluding Kappa, raised to the Nth power will not 
%     exceed 0.01:
%
%     0.01 = (sum(Alpha) + sum(Beta))^N
%
%     Thus,
%
%     N = log(0.01)/log((sum(Alpha) + sum(Beta)))
%
%   See also UGARCHPRED, UGARCHPLOT, UGARCH.

% Author(s): R.A. Baker, 04/29/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.8 $   $ Date: 1998/01/30 13:45:34 $

%
% Error-checking on scalar/vector input parameter dimensions.
%

if (length(nSamples) > 1) | any(nSamples <= 0) 
   error(' Sample size NUMSAMPLES of the GARCH process must be a positive scalar.')
elseif isempty(nSamples)
   error(' Sample size NUMSAMPLES of the GARCH process is empty.')
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
   error(' All GARCH(P,Q) process coefficients must be non-negative.')
end

if sum([alpha ; beta]) >= 1
   error(' Sum of GARCH(P,Q) coefficients ''ALPHA(1,2,...P) + BETA(1,2,...Q)'' must be < 1.')
end

%
% Construct the parameter column vector of length (1 + P + Q).
%

parameters  =  [kappa ; alpha ; beta];  % GARCH(P,Q) parameter vector.

%
% Determine the GARCH(P,Q) lag orders.
%

p  =  size(alpha , 1);
q  =  size(beta  , 1);

%
% GARCH(P,Q) processing requires pre-sample values for conditioning. That is, we 
% require P pre-sample values of h(t), the conditional variance of the residuals
% (innovations) u(t), and Q pre-sample values of u(t) itself to 'jump-start' the
% process. To be safe, create max(P,Q) pre-sample lags of both h(t) and u(t).
%

m  =  max(p,q);   % # of pre-sample lags needed to 'jump-start' the process.

%
% Estimate the unconditional standard deviation, SIGMA, of the u(t) 
% process to 'jump-start' the simulation.
%

sigma  =  sqrt(kappa ./ (1 - sum([alpha ; beta])));

%
% Estimate the number of samples it takes for the transient effects of 'jump-starting'
% the GARCH(P,Q) process to die out. This is probably NOT a big deal, I just want to
% produce a 'clean' u(t) process in steady-state. The metric I use is, granted, rather
% arbitrary: I find the number of samples needed for the sum of the GARCH coefficients 
% to fall below 0.01 (one percent). Note that this excludes the constant term KAPPA.
%

T  =  nSamples  +  m  +  ceil(log(0.01)./log(sum(parameters(2:end))));

%
% Prepend M = max(P,Q) samples to u(t), thus increasing the size of u(t) by M samples. 
% Hamilton (top of page 667), suggests assigning the unconditional variance of u(t)
% to the first M samples of h(t) and u^2(t). This implies that the unconditional
% standard deviation, SIGMA, is assigned to the first M samples of u(t).
%

u  =  [sigma(ones(m,1)) ; zeros(T-m,1)];

%
% Since M samples of the unconditional standard deviation of u(t) have been 
% assigned to the first M samples of u(t), assign u^2(1) to the first M samples 
% to h(t) to 'jump-start' the process.
%

h  =  u(1).^2;
h  =  [h(ones(m,1)) ; zeros(T-m,1)];   % Pre-allocate the h(t) vector.

%
% Form the h(t) conditional variance and the u(t) innovations processes.
%
% NOTE: We draw the i.i.d. sequence from a Gaussian distribution, which
% should be considered in tandem with the Log-Likelihood function of the
% maximum likelihood estimation process (they should be consistent).
%

v  =  randn(T , 1);    % v(t) are Gaussian deviates ~ N(0,1) distributed.

for t = (m + 1):T
    h(t) = parameters' * [1 ; h(t-(1:p)) ; u(t-(1:q)).^2];
    u(t) = sqrt(h(t)) .* v(t);   % See Hamilton, equation 21.1.9, page 659.
end

%
% Since we have pre-pended M samples to u(t), and have also padded the length
% of u(t) and h(t) to compensate for transients, strip off the first few samples
% so as to retain only the last 'nSamples' samples.
%

u  =  u((T - nSamples + 1):T);
h  =  h((T - nSamples + 1):T);
