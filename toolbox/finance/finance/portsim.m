function RetSeries = portsim(ERet, ECov, NumObs, RetIntervals, NumSim, Method)
%PORTSIM Monte Carlo simulation of correlated asset returns.
%   Simulate correlated returns of NASSETS assets over NUMOBS consecutive 
%   observation intervals. Asset returns are simulated as the proportional 
%   increments of constant drift, constant volatility stochastic processes, 
%   thereby approximating continuous-time geometric Brownian motion.
%
%   RetSeries = portsim(ExpReturn, ExpCovariance, NumObs)
%   RetSeries = portsim(ExpReturn, ExpCovariance, NumObs, RetIntervals, ...
%                       NumSim, Method)
%
% Optional Inputs: RetIntervals, NumSim, Method
%
% Inputs:
%   ExpReturn - 1 x NASSETS vector of expected (mean) returns of each asset. 
%
%   ExpCovariance - NASSETS x NASSETS matrix of asset return covariances. 
%     ExpCovariance must be symmetric and positive semi-definite (i.e., no 
%     negative eigenvalues). The standard deviations of the returns are given
%     by ExpSigma = sqrt(diag(ExpCovariance)).
%
%   NumObs - Number of consecutive observations in the return time series. If 
%     NumObs is entered as the empty matrix [], the length of RetIntervals
%     is used (see below). If not an empty matrix, NumObs must be a positive
%     scalar integer.
%
% Optional Inputs:
%   RetIntervals - Scalar or NUMOBS x 1 vector of interval times between
%     observations. If RetIntervals is not specified, all intervals are assumed
%     to have length 1.
%
%   NumSim - Number of simulated sample paths (i.e., realizations) of NUMOBS 
%     observations each. The default is 1 (i.e., a single realization of NUMOBS
%     correlated asset returns). When specified, NumSim must be a positive 
%     scalar integer.
%
%   Method - String indicating the type of Monte Carlo simulation performed:
%
%     'Exact' generates correlated asset returns whose sample mean and sample 
%     covariance (scaled by RetIntervals) match the input mean (ExpReturn) and 
%     covariance (ExpCovariance) specifications. Method is 'Exact' by default.
%     
%     'Expected' generates correlated asset returns whose sample mean and 
%     sample covariance (scaled by RetIntervals) are statistically equal to the
%     input mean and covariance specifications (i.e., the expected value of the 
%     sample mean and sample covariance are equal to the input mean (ExpReturn)
%     and covariance (ExpCovariance) specifications).
%
% Output:
%   RetSeries - NUMOBS x NASSETS x NUMSIM 3-D array of correlated, normally 
%     distributed, proportional asset returns. Asset returns over an interval 
%     of length "dt" are given by:
%
%     ExpReturn*dt + ExpSigma*sqrt(dt)*N(0,1)
%
%     where N(0,1) is a standard normal random draw. Each plane of RetSeries
%     is a single realization (i.e., sample path) of correlated asset returns.
%
% Notes:
% (1) When Method is 'Exact', the sample mean and covariance of all realizations
%     (appropriately scaled by RetIntervals) will match the input mean and 
%     covariance. When the returns are subsequently converted to asset prices, 
%     all terminal prices for a given asset will be in close agreement. In 
%     this case, although all realizations are drawn independently, they 
%     nevertheless produce very similar terminal asset prices. Set Method to
%     'Expected' to avoid this behavior. 
% (2) The returns realized from portfolios listed in PortWts are given by:
%     PortReturn = PortWts * RetSeries(:,:,1)', where PortWts is a matrix in
%     which each row contains the asset allocations of a portfolio. Each row
%     of PortReturn corresponds to one of the portfolios identified in PortWts,
%     and each column corresponds to one of the observations taken from the 
%     first realization (i.e., the first plane) of RetSeries. See PORTOPT and 
%     PORTSTATS for portfolio specification and optimization. 
% 
% See also EWSTATS, PORTOPT, PORTSTATS, RANDN, RET2TICK.

% Author(s): J. Akao 03/24/98
% Copyright 1995-2003 The MathWorks, Inc.  
% $Revision: 1.8.2.1 $   $Date: 2003/11/29 20:34:39 $

%-----------------------------------------------------------------
% Inputs
% ERet   [1 by NumAssets]
% ECov   [NumAssets by NumAssets]
% RetIntervals [NumObs by 1] intervals
% NumObs    [Scalar] : Number of return observations
% NumAssets [Scalar] : Number of assets in the time series
% NumSim    [Scalar] : Number of simulations of all NumObs observations
% Method    [String] : 'Exact' or 'Expected' matching of mean and cov
%-----------------------------------------------------------------

% Error check
if nargin < 3
    error('Finance:portsim:TooFewInputs', ...
          'Specify ExpReturn, ExpCovariance, and NumObs.');
end

[IsOne, NumAssets] = size(ERet);
if IsOne ~= 1
    error('Finance:portsim:ERetMustBeRowVector', ...
          'ExpReturn must be 1 by NASSETS instead of %d by %d.', IsOne, NumAssets)
end
if any(size(ECov) ~= NumAssets)
    error('Finance:portsim:NASSETSDimsOfEretAndEcovMustAgree', ...
          'Incompatible NASSETS dimensions in ExpReturn and ExpCovariance.');
end

if isempty(NumObs)
    if nargin < 4
        error('Finance:portsim:EnterNumObs', ...
              'The number of observations NumObs must be indicated.')
    else
        if isempty(RetIntervals)
           error('Finance:portsim:NoWayToDetermineNumObs', ...
                 'NumObs and RetIntervals cannot both be empty.')
        else
           NumObs = size(RetIntervals, 1);
        end
    end
end

% Set the intervals (dt)
if nargin < 4 || isempty(RetIntervals)
    % Default interval sizes
    RetIntervals = ones(NumObs, 1);
elseif numel(RetIntervals) == 1
    % Expand RetIntervals along the columns
    RetIntervals = RetIntervals(ones(NumObs, 1), :);
elseif all(size(RetIntervals) ~= 1)
    % Cannot be matrix
    error('Finance:portsim:RetIntervalsMustBeScalarorVector', ...
          'RetIntervals must be a Scalar or NumObs x 1 vector.');    
elseif size(RetIntervals, 1) ~= NumObs
    error('Finance:portsim:SizeOfRetIntervalsIncorrect', ...
          'RetIntervals must have NumObs rows instead of %d.', size(RetIntervals, 1));
end

% RetIntervals could be allowed to have 1 or NASSETS columns (JHA 03/23/98)

% Set the number of simulations

if nargin < 5
    NumSim = 1;
end

if  NumSim <= 0
    error('Finance:portsim:numSimMustBeAnInteger', ...
          'The number of simulations (NumSim) must be a positive integer.');   
end

% Set the Method
if nargin < 6
    Method = 'exact';
end

% Warn if ECov has negative eigenvalues:
%
% Set a zero tolerance for covariance matrix eigenvalues, dependent 
% on the size of the problem. Eigenvalues less than -tol are considered 
% negative, those between -tol and tol are considered zero, and those 
% greater than tol are considered positive.
%

eigenvalues = eig(ECov);
tol         = max(abs(eigenvalues)) .* NumAssets .* eps;

if any(eigenvalues < -tol)
   warning('Finance:portsim:NegativeEigenvalues', ...
           'Covariance matrix (ExpCovariance) is not positive semi-definite.');
end

%-----------------------------------------------------------------
% Generate correlated random shocks for the returns: 
% Shocks [NumObs by NumAssets by NumSim]
% 
% mean(Shocks) = [0, 0, ... 0]
%  cov(Shocks) = ECov
%-----------------------------------------------------------------
% Generate random shocks
Shocks = randn(NumObs, NumAssets, NumSim);

if strmatch(lower(Method), 'exact')
    % Generate EQ such that EQ'*EQ = ECov (if ECov is positive semidefinite)  
    % Use Singular value decomposition: U*Sing*U' = ECov
    [U, Sing, V] = svd(ECov); 
    EQ = sqrt(Sing) * U';
    
    % Adjust each simulation to mean zero and desired covariance ECov
    % Factors of (NumObs-1) and mean(S) are left out for clarity
    %                  S' * S                    = SCov = SQ'*SQ 
    %       inv(SQ)' * S' * S * inv(SQ)          = I
    % ( EQ'*inv(SQ)'*S' ) * ( S * inv(SQ) * EQ ) = EQ'*EQ = ECov
    %                             inv(SQ) * EQ   = FixQ
    %        ( S * FixQ)' * ( S * FixQ )         = ECov
    %
    for k = 1:NumSim
        SMean = mean(Shocks(:,:,k)); % should be approximately 0
        SCov  =  cov(Shocks(:,:,k)); % should be approximately Identity
        
        [SQ,SFlag] = chol(SCov); % SQ'*SQ = SCov
        if SFlag == 0 
            % the Cholesky factor from SCov is invertible
            FixQ = SQ \ EQ; % inv(SQ) * EQ = FixQ;  "help slash"
        else
            % Don't try to adjust the covariance, just use EQ
            FixQ = EQ;
        end
        
        Shocks(:,:,k) = (Shocks(:,:,k) - SMean(ones(NumObs, 1), :))*FixQ;
    end
elseif strmatch(lower(Method), 'expected')
    % Independent realizations
    for k = 1:NumSim
        % mu (ERet) is passed in as 0's in order to separate the
        % random portion out of the correlated returns. 
        % ret = randn * chol factor + mu;
        % Later we will use scale (randn * chol factor) and mu with dt.
        % (Using shocks as a pre allocated matrix only)
        Shocks(:,:,k) = mvnrnd(zeros(size(ERet)), ECov, NumObs);
    end
else
    error('Finance:portsim:MethodStringIncorrect', ...
          'Valid Methods are ''Exact'' or ''Expected''.');
end

%-----------------------------------------------------------------
% Scale the Shocks by DT and add the expected return
%-----------------------------------------------------------------
% MeanRets [NumObs by NumAssets] : mean return values
MeanRets = ERet(ones(NumObs, 1), :) .* RetIntervals(:, ones(1, NumAssets));

% SqDT [NumObs by NumAssets] : square root of time interval
SqDT = sqrt(RetIntervals);
SqDT = SqDT(:, ones(1, NumAssets));

% Pre allocate mem
RetSeries = Shocks;

for k = 1:NumSim
    RetSeries(:,:,k) = MeanRets + SqDT .* Shocks(:,:,k);
end


%-----------------------------------------------------------------
% end of function PORTSIM
%-----------------------------------------------------------------

% PORTSIM could be expanded to compute lognormal returns
% 1 + ri = exp( (r - 0.5*sig^2)*dt + sig*sqrt(dt) )

% [EOF]
