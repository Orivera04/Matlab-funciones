% EXAMPLE1.M
% -------------------------------------------------------------------
% MATLAB 5 ROUTINES FOR COMPUTATIONS IN CHAPTER 3
%--------------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

% student grades example (table 3.1)
% enter in dataset of form [binary_response sample_size covariate_matrix]
%
% here stat=[passing_indicator 1 1 sat_score]
% (alternatively, could `load stat.dat')

stat=[
     0     1     1   525
     0     1     1   533
     1     1     1   545
     0     1     1   582
     1     1     1   581
     1     1     1   576
     1     1     1   572
     1     1     1   609
     1     1     1   559
     1     1     1   543
     1     1     1   576
     1     1     1   525
     1     1     1   574
     1     1     1   582
     1     1     1   574
     0     1     1   471
     1     1     1   595
     0     1     1   557
     0     1     1   557
     1     1     1   584
     1     1     1   599
     0     1     1   517
     1     1     1   649
     1     1     1   584
     0     1     1   463
     1     1     1   591
     0     1     1   488
     1     1     1   563
     1     1     1   553
     1     1     1   549];
  
%---------------------------------------------------------------------
% logistic mle fit
% output is regression estimates, var_cov matrix, fitted probabilities,
% and three types of classical residuals

[beta,var,fitted_probs,dev_df,pearson_res,dev_res,adev_res]=breg_mle(stat,'l');  

%---------------------------------------------------------------------
% line plot of fitted probabilities against covariate SAT

figure(1)
[sorted_sat, i]=sort(stat(:,4));
plot(stat(i,4),fitted_probs(i))
xlabel('SAT'); ylabel('FITTED PROBABILITIES')
title('FITTED PROBABILITY PLOT')

%---------------------------------------------------------------------
% scatterplot of deviance residuals against fitted probabilities

figure(2)
plot(fitted_probs,dev_res,'o'); hold on; plot([0 1],[0 0],':');
xlabel('FITTED PROBABILITIES'); ylabel('DEVIANCE RESIDUAL')
title('CLASSICAL RESIDUAL PLOT')

%---------------------------------------------------------------------
% Bayesian logistic fit using Metropolis algorithm 
% output is Mb, matrix of simulated values, and acceptance rate of algorithm arate

[Mb,arate]=breg_bay(stat,5000,'l'); 

%---------------------------------------------------------------------
% plot parallel histograms of simulated values of beta0 and beta1

figure(3)
subplot(2,1,1), hist(Mb(:,1)), title('MARGINAL POSTERIOR DENSITY OF \beta_0')
subplot(2,1,2), hist(Mb(:,2)), title('MARGINAL POSTERIOR DENSITY OF \beta_1')

%---------------------------------------------------------------------
% displays scatterplot of posterior density of (beta0, beta1)

figure(4)
plot(Mb(:,1),Mb(:,2),'.'); xlabel('\beta_0'); ylabel('\beta_1');
title('SCATTERPLOT OF JOINT POSTERIOR OF (\beta_0, \beta_1)');

%---------------------------------------------------------------------
% computes summaries (5th, 50th, 95th percentiles) of the fitted probability 
% and Bayesian residual distributions

[fit_prob,residuals]=lfitted(Mb,stat,'l');

%---------------------------------------------------------------------
% plot fitted probability distributions against covariate sat using line graphs

figure(5)
plotfitted(stat(:,4),fit_prob,'SAT','Fitted Probability')
title('POSTERIOR DISTRIBUTIONS OF FITTED PROBABILITIES')

%---------------------------------------------------------------------
% plot residual distributions against posterior means of fitted probabilities using line graphs

figure(6)
plotfitted(fit_prob(:,2),residuals,'Fitted Probability','Bayesian Residual')
hold on; plot([0 1],[0 0],':'),axis([0 1 -1 1]),hold off
title('BAYESIAN RESIDUAL POSTERIOR DISTRIBUTIONS')

%---------------------------------------------------------------------
% computes posterior means of the ordered latent residuals
% produces logistic scores plot of the posterior means

figure(7)
[log_scores,sz]=llatent(Mb,stat);
%title('LOGISTIC SCORES PLOT OF LATENT RESIDUALS')

%---------------------------------------------------------------------
% Bayesian probit fit using Gibbs sampling and data augmentation

Mb_probit=b_probg(stat,5000);

%---------------------------------------------------------------------
% compute Bayes factors

% MODEL 1
prior1=[.7 1 1 500          % when sat=500, believe p=.7 -- info worth 1 observation
        .7 1 1 600];        % when sat=600, believe p=.7 -- info worth 1 observation
     
% MODEL 2
prior2=[.7 1000 1 500      % when sat=500, believe p=.7 -- info worth 1000 observations
        .7 1000 1 600];    % when sat=600, believe p=.7 -- info worth 1000 observations
     
[beta1,var1,lmarg1]=cmp(stat,prior1);   % compute marginal likelihood for MODEL 1
[beta2,var2,lmarg2]=cmp(stat,prior2);   % compute marginal likelihood for MODEL 2
BF_12=exp(lmarg1-lmarg2);               % compute Bayes factor in favor of MODEL 2 over MODEL 1

%---------------------------------------------------------------------
% Bayesian logistic fit using informative prior - Mb is matrix of simulated values

prior=[.3 5 1 500        % When sat=500, believe p=.3 -- info worth 5 observations
       .7 5 1 600];      % When sat=600, believe p=.7 -- info worth 5 observations

[Mb,arate]=breg_bay(stat,5000,'l',prior);

