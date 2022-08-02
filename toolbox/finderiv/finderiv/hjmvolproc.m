function [Sigma, PropFlag, PropMax] = hjmvolproc(VolSpec, t, Tlist)
%HJMVOLPROC Compute values of an HJM volatility process.
% 
%   [SigmaList, PropList, PropMax] = hjmvolproc(VolSpec, t, Tlist)
%
% Inputs:
%   VolSpec - Structure specifying the volatility model for HJMTREE.
%   t       - SCALAR Observation time of the process.
%   Tlist   - NSTARTTIMES x 1 vector of starting times of the forward rates
%             for which the volatilities are being computed.
%
% Outputs:
%   SigmaList - NSTARTTIMES x NFACTORS 
%   PropList  - 1 x NFACTORS
%   PropMax   - 1 x NFACTORS
%

%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 16:38:19 $

% Find number of factors and number of times
NumFactors = VolSpec.NumFactors;
NumStartTimes = length(Tlist);

% Compute the volatility for each factor
Sigma = zeros(NumStartTimes, NumFactors);
PropFlag = logical(zeros(NumFactors,1));
PropMax = zeros(NumFactors,1);

for j=1:NumFactors,
  switch VolSpec.FactorModels{j}
   case 'Constant'
    Sigma0 = VolSpec.FactorArgs{j}{1};
    Sigma(:,j) = Sigma0;
    
   case 'Exponential'
    Sigma0 = VolSpec.FactorArgs{j}{1};
    Lambda = VolSpec.FactorArgs{j}{2};
    Sigma(:,j) = Sigma0*exp( -Lambda*( Tlist - t ) );
    
   case 'Stationary'
    F = VolSpec.FactorArgs{j}{1};
    X = VolSpec.FactorArgs{j}{2};
    
    % interpolate (or extrapolate) F( Tlist - t )
    % assume X is increasing
    XT = Tlist - t;

    I = ( XT<= X(end) );
    Sigma(I,j) = interp1(X, F, XT(I));
    
    I = ( XT > X(end) );
    Sigma(I,j) = F(end);
    
   case 'Spot'
    % Sigma(t,T) = F(t)
    F = VolSpec.FactorArgs{j}{1};
    X = VolSpec.FactorArgs{j}{2};
    
    % Set proportional to compare to BDT
    PropFlag(j) = logical(1);
    PropMax(j) = 1e6;
    
    % interpolate (or extrapolate) F( t )
    % assume X is increasing
    if t < X(1)
      Sigma(:,j) = F(1);
    elseif t<= X(end)
      Sigma(:,j) = interp1(X,F, t);
    else
      Sigma(:,j) = F(end);
    end
    
   case 'Vasicek'
    Sigma0 = VolSpec.FactorArgs{j}{1};
    F = VolSpec.FactorArgs{j}{2};
    X = VolSpec.FactorArgs{j}{3};

    Decay = zeros(NumStartTimes,1);
    % interpolate (or extrapolate) F( Tlist - t )
    % assume X is increasing
    XT = Tlist - t;

    I = ( XT<= X(end) );
    Decay(I) = interp1(X, F, XT(I));
    
    I = ( XT > X(end) );
    Decay(I) = F(end);
    
    % Sigma0*exp(-Decay)
    Sigma(:,j) = Sigma0*exp(-Decay);
    
   case 'Proportional'
    F = VolSpec.FactorArgs{j}{1};
    X = VolSpec.FactorArgs{j}{2};
    MaxSpot = VolSpec.FactorArgs{j}{3};
    
    % indicate proportional
    PropFlag(j) = logical(1);
    PropMax(j) = MaxSpot;
    
    % interpolate (or extrapolate) F( Tlist - t )
    % assume X is increasing
    XT = Tlist - t;

    I = ( XT<= X(end) );
    Sigma(I,j) = interp1(X,F, XT(I), [], 'extrap');
    
    I = ( XT > X(end) );
    Sigma(I,j) = F(end);
    
    
   otherwise
    error(['Volatility Spec ' VolSpec.FactorModels{j} ' not recognized']);
  end
end


