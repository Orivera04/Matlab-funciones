%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename FTGEX1.M
% Financial Toolbox Graphics Example 1:
% Plotting an Efficient Frontier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.6 $   $Date: 2002/04/14 21:42:59 $

%
% Specify the expected returns, standard deviations, and
% correlation matrix for a hypothetical 3-asset portfolio.
%

returns      = [0.1 0.15 0.12];
STDs         = [0.2 0.25 0.18];
correlations = [ 1   0.8  0.4
                0.8   1   0.3
                0.4  0.3   1 ];
%
% Convert the standard deviations and correlation 
% matrix into a variance-covariance matrix.
%

covariances = corr2cov(STDs , correlations);

%
% Compute and plot the efficient frontier for 
% 20 portfolios along the frontier.
%

portopt(returns , covariances , 20)

%
% Randomly generate the asset weights for 1000 
% portfolios starting from the MATLAB initial state.
%

rand('state' , 0)
weights = rand(1000 , 3);

%
% Normalize the weights of each portfolio so that the sum = 1.
%

total   =  sum(weights , 2);
total   =  total(:,ones(3,1));

weights =  weights./total;

%
% Compute the expected return and risk of each portfolio.
%

[portRisk , portReturn] = portstats(returns , covariances , weights);

%
% Now plot the returns and risks of each portfolio 
% on top of the existing efficient frontier for comparison.
%

hold on
plot (portRisk , portReturn , '.r')
title('Mean-Variance Efficient Frontier and Random Portfolios')
hold off